unit uSysMenu;

interface

uses
  Menus, Forms, Windows, Classes, ShellAPI, DBClient, Dialogs, SysUtils, Controls, Messages,
  uParamObject, uFactoryFormIntf;

type
  TShowMDIEvent = procedure(Sender: TObject; ACaption: string; AFormIntf: IFormIntf) of object;

  //记录每个创建窗体的信息
  TFrmObj = class(TObject)
  private
    FFrmMDI: IFormIntf;
    FCreateTime: TDateTime;
  public
    constructor Create(AFrm: IFormIntf);
  published
    property FrmMDI: IFormIntf read FFrmMDI;

  end;

  TSysMenu = class(TObject)
  private
    FMainMenu: TMainMenu; //设置了ower时父类释放，子类也就释放了
    FOwner: TForm;
    FMDIClent: TWinControl; //MDI窗体显示的区域
    FMenus: TstringList;
    FOnShowMDI: TShowMDIEvent; //创建MDI窗体的时候回调此函数

    function FindParent(var ASubMenu: TMenuItem; const AParentMenuId: string): Boolean;
    procedure AddSeparators(const AParMenuId: string); {添加分割线}
    procedure AddMenu(const AMenuId: string; {定义唯一的个menuid,方便寻找}
      const Acaption: string; {acaption菜单标题}
      const AParMenuId: string; {父菜单的id}
      const AParamter: string; { 传入窗体的参数 多个参数以,(逗号)号隔开 1=a,2=b}
      AMdlNo: Integer; {对应模块号}
      AOnClick: TNotifyEvent; {FOnClick 对于特殊菜单的点击事件}
      AShortKey: string = ''); {快捷键 添加方式：'Ctrl+W' 'Ctrl+Shift+Alt+S'}
    procedure LoadMenu;
    procedure GetParamList(const AParam: string; AList: TParamObject);
    {菜单点击事件方法声明区}
    procedure DefaultMethod(Sender: TObject); //默认点击菜单发生的事件
    procedure TestIntfMethod(Sender: TObject); //测试接口，发布是可以删除
  public
    function GetMainMenu: TMainMenu;
    constructor Create(AOwner: TForm; AMDIClent: TWinControl);
    destructor Destroy; override;
  published
    property OnShowMDI: TShowMDIEvent read FOnShowMDI write FOnShowMDI;

  end;

implementation

uses uSysSvc, uOtherIntf, uTestdllInf, uMoudleNoDef, uDefCom;

{ TSysMenu }

procedure TSysMenu.AddMenu(const AMenuId, Acaption, AParMenuId,
  AParamter: string; AMdlNo: Integer; AOnClick: TNotifyEvent;
  AShortKey: string);
var
  tempMenu: TMenuItem;
begin
  //这里使用对象自定义的属性，而没有专门封装一些属性，是为了节省内存空间类的抽象复杂度
  tempMenu := TMenuItem.Create(FmainMenu);
  with tempMenu do
  begin
    Name := AmenuId; //不能重复
    Caption := Acaption;
    if AParamter <> '' then
      Hint := AParamter; //用Hint来记录Paramter
    HelpContext := AMdlNo; //用HelpContext记录模块号
    if Assigned(AOnClick) then
      OnClick := AOnClick
    else
    begin
      OnClick := DefaultMethod;
    end;

    if not FindParent(tempMenu, AParMenuId) then
    begin
      raise(SysService as IExManagement).CreateSysEx('对不起，加载菜单出错！');
    end;
    if AShortKey <> '' then
    begin
      ShortCut := TextToShortCut(AShortKey);
    end;
  end;
  FMenus.AddObject(AmenuId, tempMenu);
end;

procedure TSysMenu.AddSeparators(const AParMenuId: string);
begin

end;

constructor TSysMenu.Create(AOwner: TForm; AMDIClent: TWinControl);
begin
  FMainMenu := TMainMenu.Create(AOwner);
  FOwner := AOwner;
  FMDIClent := AMDIClent;
  FMainMenu.AutoHotkeys := maManual;
  FMenus := TStringList.Create;
  LoadMenu;
end;

procedure TSysMenu.DefaultMethod(Sender: TObject);
var
  aList: TParamObject;
  sHelpId, HelpItem: string;
  aFrm: IFormIntf;
begin
  //子菜单项
  if TMenuItem(Sender).Count = 0 then
  begin
    case TMenuItem(Sender).HelpContext of
      fnMdlHelp_Calc: //计算器
        ShellExecute(Application.Handle, '', 'Calc.exe', '', nil, SW_SHOW);
    else
      begin
        aList := TParamObject.Create;
        try
          GetParamList(TMenuItem(Sender).Hint, aList);
          aFrm := (SysService as IFromFactory).GetFormAsFromNo(TMenuItem(Sender).HelpContext, aList, FMDIClent);
          if aFrm.FrmShowStyle = fssShow then
          begin
            aFrm.FrmShow;
            if Assigned(OnShowMDI) then OnShowMDI(Self, TMenuItem(Sender).Caption, aFrm);
          end
          else if aFrm.FrmShowStyle = fssShow then
          begin
            try
              aFrm.FrmShowModal;
            finally
              aFrm.FrmFree();
            end;
          end
          else
          begin
            raise(SysService as IExManagement).CreateSysEx('没有找到<' + TMenuItem(Sender).Caption + '>窗体显示的方式！');
          end;
        finally
          aList.Free;
        end;
      end;
    end;
  end;
end;

destructor TSysMenu.Destroy;
begin
  FMenus.Free;
  inherited;
end;

function TSysMenu.FindParent(var ASubMenu: TMenuItem;
  const AParentMenuId: string): Boolean;
var
  i: Integer;
begin
  Result := False;
  if not (AParentMenuId = '') then
  begin
    i := -1;
    i := FMenus.IndexOf(AParentMenuId);
    if i >= 0 then
    begin
      TMenuItem(FMenus.Objects[i]).Insert(TMenuItem(FMenus.Objects[i]).Count,
        ASubMenu);
      Result := True;
    end;
  end
  else
  begin
    FmainMenu.Items.Add(ASubMenu);
    Result := True;
  end;
end;

function TSysMenu.GetMainMenu: TMainMenu;
begin
  if Assigned(FMainMenu) then
    Result := FMainMenu
  else
    Result := nil;
end;

procedure TSysMenu.GetParamList(const AParam: string; AList: TParamObject);
var
  tempStrings: TStrings;
  i: Integer;
begin
  try
    if Aparam = '' then
    begin
      Exit;
    end
    else
    begin
      tempStrings := TStringList.Create;
      try
        tempStrings.CommaText := Aparam;
        Alist.Clear;
        //逗号分隔所产生的stringlist
        for i := 0 to tempStrings.Count - 1 do
        begin
          Alist.Add(tempStrings.Names[i],
            tempStrings.Values[tempStrings.Names[i]]); //参数名称定义
        end;
      finally
        tempStrings.Free;
      end;
    end;
  except
    raise(SysService as IExManagement).CreateSysEx('菜单参数定义错误！');
  end;
end;

procedure TSysMenu.LoadMenu;
  procedure LoadMenuMember;
  begin
    AddMenu('m1000', '系统维护', '', '', 0, nil);
    AddMenu('m10001000', '系统参数设置', 'm1000', '', 0, nil);
    AddMenu('m100010001000', '加载包设置', 'm10001000', '', fnMdlLoadItemSet, nil);
    AddMenu('m100010002000', '系统表格配置', 'm10001000', '', fnMdlBaseTbxCfg, nil);

    AddMenu('m100011111', '测试接口', 'm1000', '', 0, TestIntfMethod);


    AddMenu('m2000', '基本资料', '', '', 0, nil);
    AddMenu('m20001000', '商品信息', 'm2000', '', fnMdlBasePtypeList, nil);
    AddMenu('m20002000', '单位信息', 'm2000', '', fnMdlBaseBtypeList, nil);
    AddMenu('m20003000', '职员信息', 'm2000', '', fnMdlBaseEtypeList, nil);
    AddMenu('m20004000', '仓库信息', 'm2000', '', fnMdlBaseKtypeList, nil);
    AddMenu('m20005000', '-', 'm2000', '', 0, nil);
    AddMenu('m20006000', '部门信息', 'm2000', '', fnMdlBaseDtypeList, nil);

    AddMenu('m9000', '帮助', '', '', 0, nil);
    AddMenu('m90001000', '在线帮助', 'm9000', '', fnMdlHelp_Online, nil);
    AddMenu('m90002000', '计算器', 'm9000', '', fnMdlHelp_Calc, nil, 'F5');
  end;
begin
  //初始化顺序时一定要先定义了主菜单，然后再加次级菜单
  //强调: 顺序不能乱
  {Mid默认对应为模块编号对于没有模块的父级菜单采用如下的编码方式
   以字母m开头，
   每一级菜单以四位字符串表示
   子菜单的第一个mid从1000开始命名，然后递增 1000 2000 3000   }
  {使用tab控制符，美观界面，方便查找}

//  if gobjSys.CompilerOption.VerNoIndustry = cnVernoMember then
  begin
    //通用版菜单实现区
    LoadMenuMember();
  end;
end;

procedure TSysMenu.TestIntfMethod(Sender: TObject);
var
  aExInf: IExManagement;
  aMsgBox: IMsgBox;
  aTestdllInf: ITestdll;
  nIntfCount, I: Integer;
  pIntfTable: PInterfaceTable;
  aStr: string;
begin
//  aExInf := SysService as IExManagement;
//  raise aExInf.CreateSysEx('多岁的');

  aMsgBox := SysService as IMsgBox;
  aMsgBox.MsgBox('IMsgBox');

  aTestdllInf := SysService as ITestdll;
  aTestdllInf.TestAAA('ITestdll');

  pIntfTable := FOwner.GetInterfaceTable;
  nIntfCount := pintfTable.EntryCount;
  aStr := '';
  if nIntfCount > 0 then
  begin
    for I := 0 to nIntfCount - 1 do
    begin
      //如果不写GUID的话 默认的是零，打印出来一行0
      aStr := aStr + IntToStr(I) + ':' + GUIDToString(pIntfTable.Entries[I].IID);
    end;
  end;
  ShowMessage(aStr);
end;

{ TFrmObj }

constructor TFrmObj.Create(AFrm: IFormIntf);
begin
  FFrmMDI := AFrm;
  FCreateTime := Now;
end;

end.

 