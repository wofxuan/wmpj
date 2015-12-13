unit uSysMenu;

interface

uses
  Menus, Forms, Windows, Classes, ShellAPI, DBClient, Dialogs, SysUtils, Controls, Messages,
  uParamObject, uFactoryFormIntf;

type
  TShowMDIEvent = procedure(Sender: TObject; ACaption: string; AFormIntf: IFormIntf) of object;

  //��¼ÿ�������������Ϣ
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
    FMainMenu: TMainMenu; //������owerʱ�����ͷţ�����Ҳ���ͷ���
    FOwner: TForm;
    FMDIClent: TWinControl; //MDI������ʾ������
    FMenus: TstringList;
    FOnShowMDI: TShowMDIEvent; //����MDI�����ʱ��ص��˺���

    function FindParent(var ASubMenu: TMenuItem; const AParentMenuId: string): Boolean;
    procedure AddSeparators(const AParMenuId: string); {��ӷָ���}
    procedure AddMenu(const AMenuId: string; {����Ψһ�ĸ�menuid,����Ѱ��}
      const Acaption: string; {acaption�˵�����}
      const AParMenuId: string; {���˵���id}
      const AParamter: string; { ���봰��Ĳ��� ���������,(����)�Ÿ��� 1=a,2=b}
      AMdlNo: Integer; {��Ӧģ���}
      AOnClick: TNotifyEvent; {FOnClick ��������˵��ĵ���¼�}
      AShortKey: string = ''); {��ݼ� ��ӷ�ʽ��'Ctrl+W' 'Ctrl+Shift+Alt+S'}
    procedure LoadMenu;
    procedure GetParamList(const AParam: string; AList: TParamObject);
    {�˵�����¼�����������}
    procedure DefaultMethod(Sender: TObject); //Ĭ�ϵ���˵��������¼�
    procedure TestIntfMethod(Sender: TObject); //���Խӿڣ������ǿ���ɾ��
  public
    function GetMainMenu: TMainMenu;
    constructor Create(AOwner: TForm; AMDIClent: TWinControl);
    destructor Destroy; override;
  published
    property OnShowMDI: TShowMDIEvent read FOnShowMDI write FOnShowMDI;

  end;

implementation

uses uSysSvc, uOtherIntf, uTestdllInf, uMoudleNoDef, uDefCom, uVchTypeDef;

{ TSysMenu }

procedure TSysMenu.AddMenu(const AMenuId, Acaption, AParMenuId,
  AParamter: string; AMdlNo: Integer; AOnClick: TNotifyEvent;
  AShortKey: string);
var
  tempMenu: TMenuItem;
begin
  //����ʹ�ö����Զ�������ԣ���û��ר�ŷ�װһЩ���ԣ���Ϊ�˽�ʡ�ڴ�ռ���ĳ����Ӷ�
  tempMenu := TMenuItem.Create(FmainMenu);
  with tempMenu do
  begin
    Name := AmenuId; //�����ظ�
    Caption := Acaption;
    if AParamter <> '' then
      Hint := AParamter; //��Hint����¼Paramter
    HelpContext := AMdlNo; //��HelpContext��¼ģ���
    if Assigned(AOnClick) then
      OnClick := AOnClick
    else
    begin
      OnClick := DefaultMethod;
    end;

    if not FindParent(tempMenu, AParMenuId) then
    begin
      raise(SysService as IExManagement).CreateSysEx('�Բ��𣬼��ز˵�����');
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
  //�Ӳ˵���
  if TMenuItem(Sender).Count = 0 then
  begin
    case TMenuItem(Sender).HelpContext of
      fnMdlHelp_Calc: //������
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
            raise(SysService as IExManagement).CreateSysEx('û���ҵ�<' + TMenuItem(Sender).Caption + '>������ʾ�ķ�ʽ��');
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
        //���ŷָ���������stringlist
        for i := 0 to tempStrings.Count - 1 do
        begin
          Alist.Add(tempStrings.Names[i],
            tempStrings.Values[tempStrings.Names[i]]); //�������ƶ���
        end;
      finally
        tempStrings.Free;
      end;
    end;
  except
    raise(SysService as IExManagement).CreateSysEx('�˵������������');
  end;
end;

procedure TSysMenu.LoadMenu;
  procedure LoadMenuMember;
  begin
    AddMenu('m1000', 'ϵͳά��', '', '', 0, nil);
    AddMenu('m10001000', 'ϵͳ��������', 'm1000', '', 0, nil);
    AddMenu('m100010001000', '���ذ�����', 'm10001000', '', fnMdlLoadItemSet, nil);
    AddMenu('m100010002000', 'ϵͳ�������', 'm10001000', '', fnMdlBaseTbxCfg, nil);

    AddMenu('m100011111', '���Խӿ�', 'm1000', '', 0, TestIntfMethod);


    AddMenu('m2000', '��������', '', '', 0, nil);
    AddMenu('m20001000', '��Ʒ��Ϣ', 'm2000', '', fnMdlBasePtypeList, nil);
    AddMenu('m20002000', '��λ��Ϣ', 'm2000', '', fnMdlBaseBtypeList, nil);
    AddMenu('m20003000', 'ְԱ��Ϣ', 'm2000', '', fnMdlBaseEtypeList, nil);
    AddMenu('m20004000', '�ֿ���Ϣ', 'm2000', '', fnMdlBaseKtypeList, nil);
    AddMenu('m20005000', '-', 'm2000', '', 0, nil);
    AddMenu('m20006000', '������Ϣ', 'm2000', '', fnMdlBaseDtypeList, nil);

    AddMenu('m3000', 'ҵ��¼��', '', '', 0, nil);
    AddMenu('m30001000', '��������', 'm3000', 'Vchtype=' + IntToStr(VchType_Order_Buy), fnMdlBillOrderBuy, nil);
    AddMenu('m30002000', '������', 'm3000', 'Vchtype=' + IntToStr(VchType_Buy), fnMdlBillBuy, nil);
    AddMenu('m30003000', '���۶���', 'm3000', 'Vchtype=' + IntToStr(VchType_Order_Sale), fnMdlBillOrderSale, nil);
    AddMenu('m30004000', '���۵�', 'm3000', 'Vchtype=' + IntToStr(VchType_Sale), fnMdlBillSale, nil);

    AddMenu('m4000', '���ݲ�ѯ', '', '', 0, nil);
    AddMenu('m40001000', '���״��', 'm4000', '', fnMdlReportGoods, nil);
    AddMenu('m40002000', '��������ͳ��', 'm4000', '', fnMdlReportOrderBuy, nil);
    AddMenu('m40003000', '������ͳ��', 'm4000', '', fnMdlReportBuy, nil);
    
    AddMenu('m9000', '����', '', '', 0, nil);
    AddMenu('m90001000', '���߰���', 'm9000', '', fnMdlHelp_Online, nil);
    AddMenu('m90002000', '������', 'm9000', '', fnMdlHelp_Calc, nil, 'F5');
  end;
begin
  //��ʼ��˳��ʱһ��Ҫ�ȶ��������˵���Ȼ���ټӴμ��˵�
  //ǿ��: ˳������
  {MidĬ�϶�ӦΪģ���Ŷ���û��ģ��ĸ����˵��������µı��뷽ʽ
   ����ĸm��ͷ��
   ÿһ���˵�����λ�ַ�����ʾ
   �Ӳ˵��ĵ�һ��mid��1000��ʼ������Ȼ����� 1000 2000 3000   }
  {ʹ��tab���Ʒ������۽��棬�������}

//  if gobjSys.CompilerOption.VerNoIndustry = cnVernoMember then
  begin
    //ͨ�ð�˵�ʵ����
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
//  raise aExInf.CreateSysEx('�����');

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
      //�����дGUID�Ļ� Ĭ�ϵ����㣬��ӡ����һ��0
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

 