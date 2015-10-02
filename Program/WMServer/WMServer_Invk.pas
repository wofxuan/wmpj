unit WMServer_Invk;

{----------------------------------------------------------------------------}
{ This unit was automatically generated by the RemObjects SDK after reading  }
{ the RODL file associated with this project .                               }
{                                                                            }
{ Do not modify this unit manually, or your changes will be lost when this   }
{ unit is regenerated the next time you compile the project.                 }
{----------------------------------------------------------------------------}

{$I RemObjects.inc}

interface

uses
  {vcl:} Classes,
  {RemObjects:} uROXMLIntf, uROServer, uROServerIntf, uROTypes, uROClientIntf,
  {Generated:} WMServer_Intf;

type
  TWMFBData_Invoker = class(TROInvoker)
  private
  protected
  public
    constructor Create; override;
  published
    procedure Invoke_Sum(const __Instance:IInterface; const __Message:IROMessage; const __Transport:IROTransport; out __oResponseOptions:TROResponseOptions);
    procedure Invoke_GetServerTime(const __Instance:IInterface; const __Message:IROMessage; const __Transport:IROTransport; out __oResponseOptions:TROResponseOptions);
    procedure Invoke_QuerySQL(const __Instance:IInterface; const __Message:IROMessage; const __Transport:IROTransport; out __oResponseOptions:TROResponseOptions);
    procedure Invoke_ExecuteProc(const __Instance:IInterface; const __Message:IROMessage; const __Transport:IROTransport; out __oResponseOptions:TROResponseOptions);
    procedure Invoke_ExecuteProcBackData(const __Instance:IInterface; const __Message:IROMessage; const __Transport:IROTransport; out __oResponseOptions:TROResponseOptions);
  end;

implementation

uses
  {RemObjects:} uRORes, uROClient;

{ TWMFBData_Invoker }

constructor TWMFBData_Invoker.Create;
begin
  inherited Create;
  FAbstract := False;
end;

procedure TWMFBData_Invoker.Invoke_Sum(const __Instance:IInterface; const __Message:IROMessage; const __Transport:IROTransport; out __oResponseOptions:TROResponseOptions);
{ function Sum(const A: Integer; const B: Integer): Integer; }
var
  A: Integer;
  B: Integer;
  lResult: Integer;
begin
  try
    __Message.Read('A', TypeInfo(Integer), A, []);
    __Message.Read('B', TypeInfo(Integer), B, []);

    lResult := (__Instance as IWMFBData).Sum(A, B);

    __Message.InitializeResponseMessage(__Transport, 'WMServer', 'WMFBData', 'SumResponse');
    __Message.Write('Result', TypeInfo(Integer), lResult, []);
    __Message.Finalize;
    __Message.UnsetAttributes(__Transport);

  finally
  end;
end;

procedure TWMFBData_Invoker.Invoke_GetServerTime(const __Instance:IInterface; const __Message:IROMessage; const __Transport:IROTransport; out __oResponseOptions:TROResponseOptions);
{ function GetServerTime: DateTime; }
var
  lResult: DateTime;
begin
  try
    lResult := (__Instance as IWMFBData).GetServerTime;

    __Message.InitializeResponseMessage(__Transport, 'WMServer', 'WMFBData', 'GetServerTimeResponse');
    __Message.Write('Result', TypeInfo(DateTime), lResult, [paIsDateTime]);
    __Message.Finalize;
    __Message.UnsetAttributes(__Transport);

  finally
  end;
end;

procedure TWMFBData_Invoker.Invoke_QuerySQL(const __Instance:IInterface; const __Message:IROMessage; const __Transport:IROTransport; out __oResponseOptions:TROResponseOptions);
{ function QuerySQL(const ASQL: AnsiString; var ABackData: OleVariant): Integer; }
var
  ASQL: AnsiString;
  ABackData: OleVariant;
  lResult: Integer;
begin
  try
    __Message.Read('ASQL', TypeInfo(AnsiString), ASQL, []);
    __Message.Read('ABackData', TypeInfo(OleVariant), ABackData, []);

    lResult := (__Instance as IWMFBData).QuerySQL(ASQL, ABackData);

    __Message.InitializeResponseMessage(__Transport, 'WMServer', 'WMFBData', 'QuerySQLResponse');
    __Message.Write('Result', TypeInfo(Integer), lResult, []);
    __Message.Write('ABackData', TypeInfo(OleVariant), ABackData, []);
    __Message.Finalize;
    __Message.UnsetAttributes(__Transport);

  finally
  end;
end;

procedure TWMFBData_Invoker.Invoke_ExecuteProc(const __Instance:IInterface; const __Message:IROMessage; const __Transport:IROTransport; out __oResponseOptions:TROResponseOptions);
{ function ExecuteProc(const AInputParams: OleVariant; out AOutParams: OleVariant): Integer; }
var
  AInputParams: OleVariant;
  AOutParams: OleVariant;
  lResult: Integer;
begin
  try
    __Message.Read('AInputParams', TypeInfo(OleVariant), AInputParams, []);

    lResult := (__Instance as IWMFBData).ExecuteProc(AInputParams, AOutParams);

    __Message.InitializeResponseMessage(__Transport, 'WMServer', 'WMFBData', 'ExecuteProcResponse');
    __Message.Write('Result', TypeInfo(Integer), lResult, []);
    __Message.Write('AOutParams', TypeInfo(OleVariant), AOutParams, []);
    __Message.Finalize;
    __Message.UnsetAttributes(__Transport);

  finally
  end;
end;

procedure TWMFBData_Invoker.Invoke_ExecuteProcBackData(const __Instance:IInterface; const __Message:IROMessage; const __Transport:IROTransport; out __oResponseOptions:TROResponseOptions);
{ function ExecuteProcBackData(const AInputParams: OleVariant; out AOutParams: OleVariant; var ABackData: OleVariant): Integer; }
var
  AInputParams: OleVariant;
  AOutParams: OleVariant;
  ABackData: OleVariant;
  lResult: Integer;
begin
  try
    __Message.Read('AInputParams', TypeInfo(OleVariant), AInputParams, []);
    __Message.Read('ABackData', TypeInfo(OleVariant), ABackData, []);

    lResult := (__Instance as IWMFBData).ExecuteProcBackData(AInputParams, AOutParams, ABackData);

    __Message.InitializeResponseMessage(__Transport, 'WMServer', 'WMFBData', 'ExecuteProcBackDataResponse');
    __Message.Write('Result', TypeInfo(Integer), lResult, []);
    __Message.Write('AOutParams', TypeInfo(OleVariant), AOutParams, []);
    __Message.Write('ABackData', TypeInfo(OleVariant), ABackData, []);
    __Message.Finalize;
    __Message.UnsetAttributes(__Transport);

  finally
  end;
end;

initialization
end.
