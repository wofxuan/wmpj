{***************************
业务层公共操作数据库的函数和全局的变量
如系统设置等
mx 2015-03-27
****************************}
unit uModelFunCom;

interface

uses
  Classes, SysUtils, StdCtrls, Forms, Windows, DateUtils, Graphics, Controls, DB, DBClient,
  ActnList, Menus, ShellAPI, ShlObj, IniFiles, Variants, uDefCom, uParamObject,
  uOtherIntf, uDBIntf, uModelFunIntf, uBaseInfoDef;

type
  TModelFunCom = class(TObject, IModelFun)
  private
    FDBAC: IDBAccess;
    FExInf: IExManagement;
    FMsgBox: IMsgBox;
    FLog: ILog;

    FOperatorID: string; //当前登录的操作员ID
  protected
    { IInterface }
    function QueryInterface(const IID: TGUID; out Obj): HResult; stdcall;
    function _AddRef: Integer; stdcall;
    function _Release: Integer; stdcall;

    function GetLocalValue(ABasicType: TBasicType; ADbName, ATypeid: string): string; 
  public
    constructor Create;
    destructor Destroy; override;

    //显示错误信息提示
    function ShowErrorMessage(ARet: Integer): Boolean; //通用的错误信息提示
    function DbErrorStr(ARet: Integer): string; //后台错误信息

    //数据库操作
    function ExecProcByName(AProcName: string; AInParam: TParamObject): Integer;
    function ExecProcBackData(AProcName: string; AInParam: TParamObject = nil; ABackData: TClientDataSet = nil): Integer;
    procedure QuerySQL(const ASQLStr: string; AQueryData: TClientDataSet);
    //显示提示消息
    function ShowMsgBox(AMsg: string; ACaption: string = ''; AMsgType: TMessageBoxType = mbtInformation; AButtons: TMessageBoxButtons = [mbbOk]): Integer;

    property OperatorID: string read FOperatorID write FOperatorID;
  end;

var
  gMFCom: TModelFunCom;
  
implementation

uses uSysSvc, uSysFactory, uBasicDataLocalClass;

{ TFunCom }

constructor TModelFunCom.Create;
begin
  FDBAC := SysService as IDBAccess;
  FExInf := SysService as IExManagement;
  FMsgBox := SysService as IMsgBox;
  FLog := SysService as ILog;
end;

function TModelFunCom.DbErrorStr(ARet: Integer): string;
begin
  Result := 'DbErrorStr未知错误';
end;

destructor TModelFunCom.Destroy;
begin

  inherited;
end;

function TModelFunCom.ExecProcByName(AProcName: string;
  AInParam: TParamObject): Integer;
begin
  Result := FDBAC.ExecuteProcByName(AProcName, AInParam, AInParam);
end;

function TModelFunCom.ExecProcBackData(AProcName: string;
  AInParam: TParamObject; ABackData: TClientDataSet): Integer;
begin
  Result := FDBAC.ExecuteProcBackData(AProcName, AInParam, AInParam, ABackData);
end;

function TModelFunCom.ShowErrorMessage(ARet: Integer): Boolean;
var
  AErrStr: string;
begin
  Result := ARet = 0;
  if Result then
  begin
    AErrStr := '';
    Exit;
  end;
  AErrStr := DbErrorStr(ARet);
  if AErrStr <> '' then
  begin
    FMsgBox.MsgBox(AErrStr, '', mbtError);
  end;
end;

function TModelFunCom.ShowMsgBox(AMsg, ACaption: string;
  AMsgType: TMessageBoxType; AButtons: TMessageBoxButtons): Integer;
begin
  Result := FMsgBox.MsgBox(AMsg, ACaption, AMsgType, AButtons);
end;

function TModelFunCom.GetLocalValue(ABasicType: TBasicType; ADbName,
  ATypeid: string): string;
begin
  Result := gBasicDataLocal.GetLocalValue(ABasicType, ADbName, ATypeid);
end;

function TModelFunCom._AddRef: Integer;
begin
  Result := -1;
end;

function TModelFunCom._Release: Integer;
begin
  Result := -1;
end;

function TModelFunCom.QueryInterface(const IID: TGUID; out Obj): HResult;
begin
  if GetInterface(IID, Obj) then
    Result := 0
  else
    Result := E_NOINTERFACE;
end;

procedure TModelFunCom.QuerySQL(const ASQLStr: string;
  AQueryData: TClientDataSet);
begin
  FDBAC.QuerySQL(ASQLStr, AQueryData);
end;

initialization
  gMFCom := TModelFunCom.Create;
  TObjFactory.Create(IModelFun, gMFCom);
  
finalization
  if Assigned(gMFCom) then  gMFCom.Free;
  
end.

