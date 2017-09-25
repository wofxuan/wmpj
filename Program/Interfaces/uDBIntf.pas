unit uDBIntf;

interface

uses DBClient, uParamObject;

type
  IDBAccess = interface
    ['{E868E629-EA25-47F8-A3D9-445F4F77BC15}']
    procedure QuerySQL(const ASQLStr: string; AQueryData: TClientDataSet);
    function OpenSQL(const ASQLStr: AnsiString): Integer;
    function GetMoudleNoSQL(const AMoudleNo: Integer): string;

    // ִ��һ���洢����, ���������ݼ�
    function ExecuteProcByName(AProcName: string; AParamName: array of string; AParamValue: array of OleVariant; OutputParams: TParamObject = nil): Integer; overload;
    function ExecuteProcByName(AProcName: string; AInParam: TParamObject = nil; AOutParams: TParamObject = nil): Integer; overload;

    // ִ��һ���洢����, �����ݼ�
    function ExecuteProcBackData(AProcName: string; AInParam: TParamObject = nil; AOutParams: TParamObject = nil; ABackData: TClientDataSet = nil): Integer; overload;
    
    //��½�û�
    function Login(AUserName, AUserPSW: string; var AMsg: string): Integer;
  end;

implementation

end.

