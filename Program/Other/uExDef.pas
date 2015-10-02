unit uExDef;

interface

uses SysUtils, Dialogs, Forms;

type
  EWMException = class(Exception)//�쳣����
  private
    FMsg: string;
  public
    constructor Create(const Msg: string);
    procedure DoEx; virtual; abstract; //�����쳣
  end;

  ESysException = class(EWMException)//ϵͳ���쳣
  public
    procedure DoEx; override;
  end;

  EFunException = class(EWMException)//�������쳣
  public
    procedure DoEx; override;
  end;

  TExMgr = class(TObject)
  private
    procedure DoException(Sender: TObject; E: Exception);
  public
    constructor Create;
    destructor Destroy; override;
    
  end;

var
  gExMgr :TExMgr;
  
implementation

uses uPubFun;

constructor TExMgr.Create;
begin
  Application.OnException := DoException;
  inherited;
end;

destructor TExMgr.Destroy;
begin

  inherited;
end;

procedure TExMgr.DoException(Sender: TObject; E: Exception);
var
  aExMsg: string;
begin
  if E is EWMException then
  begin
    EWMException(E).DoEx();
  end
  else
  begin
    if E is EAccessViolation  then
      aExMsg := '��Ч�ڴ洦������'
    else
      aExMsg := E.Message;

    ShowMessage('ϵͳ����' + aExMsg);
  end;
end;

{ EWMException }
constructor EWMException.Create(const Msg: string);
begin
  FMsg := Msg;
  inherited Create(Msg);
end;

{ ESysException }
procedure ESysException.DoEx;
begin
  inherited;
  ShowMessage('ESysException:' + FMsg);
end;

{ EFunException }

procedure EFunException.DoEx;
begin
  inherited;
  ShowMessage('EFunException:' + FMsg);
end;

initialization
  gExMgr := TExMgr.Create;

finalization
  gExMgr.Free;
  
end.
 