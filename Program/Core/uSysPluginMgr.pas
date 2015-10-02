{ ------------------------------------
  功能说明：平台BPL插件管理
  创建日期：2014/07/08
  作者：mx
  版权：mx
  ------------------------------------- }
unit uSysPluginMgr;

interface

uses SysUtils, Classes, Windows, Contnrs, uRegPluginIntf, uPluginBase, uDBIntf, uSysSvc;

const
  BPLTYPE = 1;
  DLLTYPE = 2;

type
  TRegisterPlugInPro = procedure(Reg: IRegPlugin);

  TPluginLoader = class(TInterfacedObject, IRegPlugin) //关联每个BPL或DLL的相关信息
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

  TPluginMgr = class(TObject) //管理每个BPL包的数据
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

uses DBClient, Dialogs, uPubFun, uOtherIntf;

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
begin
  PluginLoader := nil;
  for i := 0 to FpluginList.Count - 1 do
  begin
    try
      PluginLoader := TPluginLoader(FpluginList.Items[i]);
      if not PluginLoader.ContainPlugin then Continue;

//      if Assigned(SplashForm) then
//        SplashForm.loading(Format('正在初始化包[%s]',
//            [ExtractFileName(PluginLoader.PackageFile)]));

      PluginLoader.Plugin.Init;
    except
      on E: Exception do
      begin
        WriteErrFmt('处理插件Init方法出错([%s])，错误：%s', [ExtractFileName(PluginLoader.PackageFile), E.Message]);

        raise Exception.CreateFmt('处理插件Init方法出错([%s])，请查看Log目录下的错误日志！', [ExtractFileName(PluginLoader.PackageFile)]);
      end;
    end;
  end;
end;

procedure TPluginMgr.LoadPackage(Intf: IInterface);
var
  aList: TStrings;
  i: Integer;
  PackageFile: string;
begin
  // 加载其他包
  aList := TStringList.Create;
  try
    GetPackageList(aList);
    for i := 0 to aList.Count - 1 do
    begin
      PackageFile := aList[i];
      // 加载包
      if FileExists(PackageFile) then
        LoadPackageFromFile(PackageFile, Intf)
      else
      begin
        WriteErrFmt('找不到包[%s]，无法加载！', [PackageFile]);
        raise Exception.CreateFmt('找不到包[%s]，无法加载，请查看Log目录下的错误日志！', [PackageFile]);
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
  aDBAC: IDBAccess;
  aCdsBpl: TClientDataSet;
  aExePath: string;
begin
  aDBAC := SysService as IDBAccess;
  aExePath := ExtractFilePath(ParamStr(0)); // E:\code\delphi\wmpj\Bin\
  aCdsBpl := TClientDataSet.Create(nil);
  try
    aDBAC.QuerySQL('SELECT * FROM tbx_Base_PackageInfo where ITypeId <> ''00000'' ORDER BY RowIndex', aCdsBpl);
    aCdsBpl.First;
    while not aCdsBpl.Eof do
    begin
      APackageList.Add(aExePath + Trim(aCdsBpl.fieldByName('IFullname').AsString));
      aCdsBpl.Next;
    end;
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
      WriteErrFmt('加载包[%s]出错，错误：%s', [ExtractFileName(PackageFile), E.Message]);

      raise Exception.CreateFmt('加载包[%s]出错，请查看Log目录下的错误日志！', [ExtractFileName(PackageFile)]);
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

