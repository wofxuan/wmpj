{------------------------------------
  ����˵����ʵ��IDBAccess�ӿ�
  �������ڣ�2014/08/04
  ���ߣ�mx
  ��Ȩ��mx
-------------------------------------}
unit uDBAccess;

interface

uses SysUtils, DB, DBClient, Dialogs, uDBIntf, uSvcInfoIntf, uParamObject, WMServer_Intf;

type
  TDBOperation = class(TInterfacedObject, IDBAccess, ISvcInfo)
  private
    FWMServer: IWMFBData;
  protected
  {IDBOperation}
    procedure QuerySQL(const ASQLStr: string; AQueryData: TClientDataSet);
    function GetMoudleNoSQL(const AMoudleNo: Integer): string;
    // ִ��һ���洢����, ���������ݼ�
    function ExecuteProcByName(AProcName: string; AParamName: array of string;
      AParamValue: array of OleVariant; OutputParams: TParamObject = nil): Integer; overload;
    function ExecuteProcByName(AProcName: string; AInParam: TParamObject = nil; AOutParams: TParamObject = nil): Integer; overload;

        // ִ��һ���洢����, �����ݼ�
    function ExecuteProcBackData(AProcName: string; AInParam: TParamObject = nil; AOutParams: TParamObject = nil; ABackData: TClientDataSet = nil): Integer; overload;
  {ISvcInfo}
    function GetModuleName: string;
    function GetTitle: string;
    function GetVersion: string;
    function GetComments: string;
  public
    constructor Create;
    destructor Destroy; override;
  end;

implementation

uses uSysSvc, uSysFactory, uRDM, uOtherIntf, uPubFun, variants;

{ TDBOperation }

function TDBOperation.GetComments: string;
begin
  Result := '�������ݿ����';
end;

function TDBOperation.GetModuleName: string;
begin
  Result := ExtractFileName(SysUtils.GetModuleName(HInstance));
end;

function TDBOperation.GetTitle: string;
begin
  Result := '���ݿ�����ӿ�(IDBAccess)';
end;

function TDBOperation.GetVersion: string;
begin
  Result := '20141203.001';
end;

procedure TDBOperation.QuerySQL(const ASQLStr: string; AQueryData: TClientDataSet);
var
  aBackDate: OleVariant;
begin
  if Trim(ASQLStr) = EmptyStr then Exit;

  try
    FWMServer.QuerySQL(ASQLStr, aBackDate);
    AQueryData.Data := aBackDate;
  except
    raise(SysService as IExManagement).CreateSysEx('ִ��SQL<' + Trim(ASQLStr) + '>����');
  end;
end;

constructor TDBOperation.Create;
var
  Obj: TObject;
begin
  DMWMServer := TDMWMServer.Create(nil);
  FWMServer := DMWMServer.RORemoteService as IWMFBData;
end;

destructor TDBOperation.Destroy;
begin
  DMWMServer.Free;
  inherited;
end;

procedure CreateDBOperation(out anInstance: IInterface);
begin
  anInstance := TDBOperation.Create;
end;

function TDBOperation.GetMoudleNoSQL(const AMoudleNo: Integer): string;
var
  aSQL: string;
begin
  Result := '';
end;

function TDBOperation.ExecuteProcByName(AProcName: string;
  AParamName: array of string; AParamValue: array of OleVariant;
  OutputParams: TParamObject): Integer;
begin

end;

function TDBOperation.ExecuteProcByName(AProcName: string; AInParam,
  AOutParams: TParamObject): Integer;
var
  aInParamJson, aOutParam: OleVariant;
  aBackParams: TParams;
  i: Integer;
  aWriteLogMsg: string;
begin
  try
    aInParamJson := StrToOleData(PackageToJson(AProcName, ParamObjectToJson(AInParam)).AsString);
    Result := FWMServer.ExecuteProc(aInParamJson, aOutParam);
    if Assigned(AOutParams) then
    begin
      aBackParams := TParams.Create;
      try
        UnpackParams(aOutParam, aBackParams);

        with aBackParams do
        begin
          for i := 0 to Count - 1 do
          begin
            AInParam.Add(Items[i].Name, Items[i].Value);
          end;
        end;
      finally
        FreeAndNil(aBackParams);
      end;
    end;
  except
    on E: Exception do
    begin
      aWriteLogMsg := StringFormat('�洢����[%s]������[%s]��������Ϣ[%s]', [AProcName, ParamObjectToString(AInParam), E.Message]);
      raise (SysService as IExManagement).CreateFunEx('ִ�д洢���̳���', aWriteLogMsg);
    end;
  end;
end;

function TDBOperation.ExecuteProcBackData(AProcName: string;
  AInParam: TParamObject; AOutParams: TParamObject; ABackData: TClientDataSet): Integer;
var
  aInParamJson, aBackDate: OleVariant;
  aBackParams: TParams;
  i: Integer;
var
  aWriteLogMsg: string;
begin
  try
    aInParamJson := StrToOleData(PackageToJson(AProcName, ParamObjectToJson(AInParam)).AsString);
    Result := FWMServer.ExecuteProcBackData(aInParamJson, aBackDate, aBackDate);
    ABackData.Data := aBackDate;
    if Assigned(AOutParams) then
    begin
      aBackParams := TParams.Create;
      try
        UnpackParams(aBackDate, aBackParams);

        with aBackParams do
        begin
          for i := 0 to Count - 1 do
          begin
            AOutParams.Add(Items[i].Name, Items[i].Value);
          end;
        end;
      finally
        FreeAndNil(aBackParams);
      end;
    end;
  except
    on E: Exception do
    begin
      aWriteLogMsg := StringFormat('�洢����[%s]������[%s]��������Ϣ[%s]', [AProcName, ParamObjectToString(AInParam), E.Message]);
      raise (SysService as IExManagement).CreateFunEx('ִ�д洢���̳���', aWriteLogMsg);
    end;
  end;
end;

initialization
  TSingletonFactory.Create(IDBAccess, @CreateDBOperation);

finalization

end.

