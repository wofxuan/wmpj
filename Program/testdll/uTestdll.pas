unit uTestdll;

interface

uses SysUtils, Dialogs, uPluginBase, uSvcInfoIntf, uTestdllInf;

type
  TTestdll = class(TPlugin, ISvcInfo, ITestdll)
  private

  protected
  {ISvcInfo}
    function GetModuleName: string;
    function GetTitle: string;
    function GetVersion: string;
    function GetComments: string;
  {ITestdll}
    function TestAAA(AMsg: string): string;
  public
    constructor Create;
    destructor Destroy; override;
  end;

var
  gTestInf: TTestdll;
  
implementation

{ TTestdll }

constructor TTestdll.Create;
begin

end;

destructor TTestdll.Destroy;
begin

  inherited;
end;

function TTestdll.GetComments: string;
begin

end;

function TTestdll.GetModuleName: string;
begin

end;

function TTestdll.GetTitle: string;
begin

end;

function TTestdll.GetVersion: string;
begin

end;

function TTestdll.TestAAA(AMsg: string): string;
begin
  ShowMessage(AMsg);
end;

initialization
  gTestInf := TTestdll.Create;

finalization
  if Assigned(gTestInf) then
  begin
    FreeAndNil(gTestInf);
  end;
end.
