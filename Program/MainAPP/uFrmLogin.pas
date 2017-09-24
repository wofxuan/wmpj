unit uFrmLogin;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, cxLookAndFeelPainters, StdCtrls, cxButtons, uMainFormIntf;

type
  TfrmLogin = class(TForm, ILogin)
    btnLogin: TcxButton;
    btnCancel: TcxButton;
    procedure btnLoginClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    function Login: Boolean; //登录窗口
    procedure loading(AInfo: string); //正在加载的内容
  public
    { Public declarations }
    procedure CreateLogin(out anInstance: IInterface);
  end;

var
  frmLogin: TfrmLogin;

implementation

uses uSysSvc, uFactoryIntf, uSysFactory;

{$R *.dfm}

procedure TfrmLogin.btnLoginClick(Sender: TObject);
begin
  ModalResult := mrOk;
end;

procedure TfrmLogin.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmLogin.loading(AInfo: string);
begin

end;

function TfrmLogin.Login: Boolean;
begin
//  frmLogin := TfrmLogin.Create(nil);
  try
    Result := frmLogin.ShowModal = mrOk;
  finally
//    frmLogin.Free;
  end;
end;

procedure TfrmLogin.FormCreate(Sender: TObject);
var
  aRegInf: IRegInf;
begin
  aRegInf := SysService as IRegInf;
  aRegInf.RegObjFactory(ILogin, Self);

//  TIntfFactory.Create(ILogin, CreateLogin);
end;

procedure TfrmLogin.CreateLogin(out anInstance: IInterface);
begin
//  anInstance := TfrmLogin.Create;
end;

initialization


end.
