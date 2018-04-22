unit uFrmLogin;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, cxLookAndFeelPainters, StdCtrls, cxButtons, uMainFormIntf, uDBIntf, uOtherIntf,
  cxControls, cxContainer, cxEdit, cxTextEdit, cxMaskEdit, cxButtonEdit,
  uWmLabelEditBtn;

type
  TfrmLogin = class(TForm, ILogin)
    btnLogin: TcxButton;
    btnCancel: TcxButton;
    edtName: TWmLabelEditBtn;
    edtPW: TWmLabelEditBtn;
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

uses uSysSvc, uFactoryIntf, uSysFactory, uDefCom;

{$R *.dfm}

procedure TfrmLogin.btnLoginClick(Sender: TObject);
var
	aIDBAccess: IDBAccess;
	aUserName, aUserPSW, aMsg: string; 
	aMsgBox: IMsgBox;
begin
	aUserName := Trim(edtName.Text);
	aUserPSW := Trim(edtPW.Text);
	aMsg := '';
	
	aMsgBox := SysService as IMsgBox;
	if (Trim(aUserName) = EmptyStr) then
	begin
		aMsgBox.MsgBox('账户不能为空');
		Exit;
	end;
	if (Trim(aUserPSW) = EmptyStr) then
	begin
		aMsgBox.MsgBox('密码不能为空');
		Exit;
	end;
	
	aIDBAccess := SysService as IDBAccess;	
	if aIDBAccess.Login(aUserName, aUserPSW, aMsg) <> 0 then
	begin
    aMsgBox.MsgBox(aMsg);
		exit;
	end;
	OperatorID := aUserName;
  ModalResult := mrOk;
end;

procedure TfrmLogin.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmLogin.loading(AInfo: string);
begin

end;

function CheckDateTimeFormat(): Boolean;
var
  aBuf: pchar;
  i: Integer;
  aGPrevShortDate, aGPrevLongDate, aGPrevTimeFormat: string;
begin
	result := false;
  getmem(aBuf, 100);
  try
	  i := 100;
	  GetLocaleInfo(LOCALE_USER_DEFAULT, LOCALE_SSHORTDATE, aBuf, i);
	  aGPrevShortDate := string(aBuf);
	  if aGPrevShortDate <> 'yyyy-MM-dd' then
	  begin
	  	ShowMessage('系统日期格式应该设置为"yyyy-MM-dd"');
	  	exit;
	  end;
	  i := 100;
	  GetLocaleInfo(LOCALE_USER_DEFAULT, LOCALE_STIMEFORMAT, aBuf, i);
	  aGPrevTimeFormat := string(aBuf);
	  if aGPrevTimeFormat <> 'HH:mm:ss' then
	  begin
	  	ShowMessage('系统时间格式应该设置为"HH:mm:ss"');
	  	exit;
	  end;
	  result := true;
  finally
  	FreeMem(aBuf);
  end;
end;

function TfrmLogin.Login: Boolean;
begin
	result := false;
	if not CheckDateTimeFormat() then exit;
  
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
