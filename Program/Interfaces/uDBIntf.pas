unit uDBIntf;

interface

uses DBClient, uParamObject;

type
  IDBAccess = interface
    ['{E868E629-EA25-47F8-A3D9-445F4F77BC15}']
    procedure QuerySQL(const ASQLStr: string; AQueryData: TClientDataSet);
    function GetMoudleNoSQL(const AMoudleNo: Integer): string;

    // 执行一个存储过程, 不返回数据集
    function ExecuteProcByName(AProcName: string; AParamName: array of string; AParamValue: array of OleVariant; OutputParams: TParamObject = nil): Integer; overload;
    function ExecuteProcByName(AProcName: string; AInParam: TParamObject = nil; AOutParams: TParamObject = nil): Integer; overload;

    // 执行一个存储过程, 回数据集
    function ExecuteProcBackData(AProcName: string; AInParam: TParamObject = nil; AOutParams: TParamObject = nil; ABackData: TClientDataSet = nil): Integer; overload;
  end;

implementation

end.

