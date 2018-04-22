{ ------------------------------------
  ����˵����ƽ̨BPL�������
  �������ڣ�2014/07/08
  ���ߣ�mx
  ��Ȩ��mx
  ------------------------------------- }
unit uSysPluginMgr;

interface

uses SysUtils, Classes, Windows, Contnrs, Forms, uRegPluginIntf, uPluginBase,
      uSysSvc, uOtherIntf, uMainFormIntf;

const
  BPLTYPE = 1;
  DLLTYPE = 2;

type
  TRegisterPlugInPro = procedure(Reg: IRegPlugin);

  TPluginLoader = class(TInterfacedObject, IRegPlugin) //����ÿ��BPL��DLL�������Ϣ
  private
    FIntf: IInterface;
    FPackageHandle: HMODULE;
    FPackageFile: string;
    FPlugin: TPlugin;
    FFileType: Integer;
    function GetContainPlugin: Boolean;
  protected
    {IRegPlugin}
    procedure RegisterPluginClass(APluginClass: TPluginClass);
  public
    constructor Create(const PackageFile: string; Intf: IInterface);
    destructor Destroy; override;

    property ContainPlugin: Boolean read GetContainPlugin;
    property Plugin: TPlugin read FPlugin;
    property PackageFile: string read FPackageFile;
  end;

  TPluginMgr = class(TObject) //����ÿ��BPL��������
  private
    procedure WriteErrFmt(const AErr: string; const AArgs: array of const);
  protected
    FPluginList: TObjectList;

    procedure GetPackageList(APackageList: TStrings);
    procedure LoadPackageFromFile(const PackageFile: string; Intf: IInterface);
  public
    constructor Create;
    destructor Destroy; override;

    procedure LoadPackage(Intf: IInterface);
    procedure Init;
    procedure final;
  end;

var
  PluginMgr: TPluginMgr;

implementation

uses DBClient, Dialogs, uPubFun;

{ TPluginMgr }

constructor TPluginMgr.Create;
begin
  FPluginList := TObjectList.Create(True);
end;

destructor TPluginMgr.Destroy;
begin
  FPluginList.Free;
  inherited;
end;

procedure TPluginMgr.Init;
var
  i: Integer;
  PluginLoader: TPluginLoader;
  aLogin: ILogin;
begin
  PluginLoader := nil;
  aLogin := SysService as ILogin;
  if Assigned(aLogin) then
  begin
    if not aLogin.Login() then
    begin
      (SysService as IMainForm).SetWindowState(wsMinimized);
      Application.Terminate;
      Exit;
    end;
  end;
  
  try
    for i := 0 to FpluginList.Count - 1 do
    begin
        PluginLoader := TPluginLoader(FpluginList.Items[i]);
        if not PluginLoader.ContainPlugin then Continue;

        if Assigned(aLogin) then
          aLogin.loading(Format('���ڳ�ʼ����[%s]', [ExtractFileName(PluginLoader.PackageFile)]));
  //      if Assigned(SplashForm) then
  //        SplashForm.loading(Format('���ڳ�ʼ����[%s]',
  //            [ExtractFileName(PluginLoader.PackageFile)]));

        PluginLoader.Plugin.Init;
    end;
  except
    on E: Exception do
    begin
      WriteErrFmt('������Init��������([%s])������%s', [ExtractFileName(PluginLoader.PackageFile), E.Message]);

      raise Exception.CreateFmt('������Init��������([%s])����鿴LogĿ¼�µĴ�����־��', [ExtractFileName(PluginLoader.PackageFile)]);
    end;
  end;
end;

procedure TPluginMgr.LoadPackage(Intf: IInterface);
var
  aList: TStrings;
  i: Integer;
  PackageFile: string;
begin
  // ����������
  aList := TStringList.Create;
  try
    GetPackageList(aList);
    for i := 0 to aList.Count - 1 do
    begin
      PackageFile := aList[i];
      // ���ذ�
      if FileExists(PackageFile) then
        LoadPackageFromFile(PackageFile, Intf)
      else
      begin
        WriteErrFmt('�Ҳ�����[%s]���޷����أ�', [PackageFile]);
        raise Exception.CreateFmt('�Ҳ�����[%s]���޷����أ���鿴LogĿ¼�µĴ�����־��', [PackageFile]);
      end;
    end;
  finally
    aList.Free;
  end;
end;

procedure TPluginMgr.final;
var
  i: Integer;
  PluginLoader: TPluginLoader;
begin
  for i := 0 to FpluginList.Count - 1 do
  begin
    PluginLoader := TPluginLoader(FpluginList.Items[i]);
    if PluginLoader.ContainPlugin then
      PluginLoader.Plugin.final;
  end;
end;

procedure TPluginMgr.GetPackageList(APackageList: TStrings);
var
  aCdsBpl: TClientDataSet;
  aExePath: string;
begin
  aExePath := ExtractFilePath(ParamStr(0)); // E:\code\delphi\wmpj\Bin\
  aCdsBpl := TClientDataSet.Create(nil);
  try
//    aDBAC.QuerySQL('SELECT * FROM tbx_Base_PackageInfo where ITypeId <> ''00000'' ORDER BY RowIndex', aCdsBpl);
//    aCdsBpl.First;
//    while not aCdsBpl.Eof do
//    begin
//      APackageList.Add(aExePath + Trim(aCdsBpl.fieldByName('IFullname').AsString));
//      aCdsBpl.Next;
//    end;
    APackageList.Add(aExePath + 'Other.bpl');
    APackageList.Add(aExePath + 'DBAccess.bpl');
    APackageList.Add(aExePath + 'BusinessIntf.bpl');
    APackageList.Add(aExePath + 'BusinessLayer.bpl');
    APackageList.Add(aExePath + 'BaseForm.bpl');
    APackageList.Add(aExePath + 'SysConfig.bpl');
    APackageList.Add(aExePath + 'BaseInfo.bpl');
    APackageList.Add(aExePath + 'BillForm.bpl');
    APackageList.Add(aExePath + 'Report.bpl');  
    APackageList.Add(aExePath + 'Testdll.dll');
    APackageList.Add(aExePath + 'TestBpl.bpl');
  finally
    aCdsBpl.Free;
  end;
end;

procedure TPluginMgr.LoadPackageFromFile(const PackageFile: string;
  Intf: IInterface);
var
  aObj: TObject;
begin
  try
    aObj := TPluginLoader.Create(PackageFile, Intf);
    if Assigned(aObj) then
      FPluginList.Add(aObj);
  except
    on E: Exception do
    begin
      WriteErrFmt('���ذ�[%s]��������%s', [ExtractFileName(PackageFile), E.Message]);

      raise Exception.CreateFmt('���ذ�[%s]������鿴LogĿ¼�µĴ�����־��', [ExtractFileName(PackageFile)]);
    end;
  end;
end;

procedure TPluginMgr.WriteErrFmt(const AErr: string;
  const AArgs: array of const);
var
  aLog: ILog;
begin
  aLog := SysService as ILog;
  aLog.WriteLogTxt(ltErrSys, StringFormat(AErr, AArgs));
end;

{ TPluginLoader }

constructor TPluginLoader.Create(const PackageFile: string;
  Intf: IInterface);
var
  RegisterPlugIn: TRegisterPlugInPro;
  aExt: string;
begin
  FPlugin := nil;
  FPackageHandle := 0;
  FIntf := Intf;
  FPackageFile := PackageFile;
  aExt := UpperCase(ExtractFileExt(PackageFile));
  if aExt = '.BPL' then
  begin
    FFileType := BPLTYPE;
    FPackageHandle := SysUtils.LoadPackage(PackageFile)
  end
  else if aExt = '.DLL' then
  begin
    FFileType := DLLTYPE;
    FPackageHandle := LoadLibrary(PAnsiChar(PackageFile));
  end;

  if FPackageHandle <> 0 then
  begin
    @RegisterPlugIn := GetProcAddress(FPackageHandle, 'RegisterPlugIn');
    RegisterPlugIn(Self);
  end;
end;

destructor TPluginLoader.Destroy;
begin
  if Assigned(FPlugin) then
    FPlugin.Free;

  case FFileType of
    BPLTYPE: SysUtils.UnloadPackage(FPackageHandle);
    DLLTYPE: FreeLibrary(FPackageHandle);
  else

  end;

  inherited;
end;

function TPluginLoader.GetContainPlugin: Boolean;
begin
  Result := self.FPlugin <> nil;
end;

procedure TPluginLoader.RegisterPluginClass(APluginClass: TPluginClass);
begin
  if APluginClass <> nil then
    FPlugin := APluginClass.Create(FIntf);
  FPlugin.Sys := SysService;
end;

end.

