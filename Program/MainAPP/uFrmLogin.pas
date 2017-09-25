unit uFrmLogin;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, cxLookAndFeelPainters, StdCtrls, cxButtons, uMainFormIntf, uDBIntf, uOtherIntf;

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
var
	aIDBAccess: IDBAccess;
	aUserName, aUserPSW, aMsg: string; 
	aMsgBox: IMsgBox;
begin
	aUserName := Trim('00001');
	aUserPSW := Trim('00001');
	aMsg := '';
	
	aMsgBox := SysService as IMsgBox;
	if (Trim(aUserName) = EmptyStr) then
	begin
		aMsgBox.MsgBox('账号不能为空');
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
	  i := 100; // i必须在调用前赋值为buf缓冲区的长度。如果设为0或负值，将取不到设置的值
	  GetLocaleInfo(LOCALE_USER_DEFAULT, LOCALE_SSHORTDATE, aBuf, i);
	  // 取当前用户设置，短日期格式。
	  aGPrevShortDate := string(aBuf);
	  if aGPrevShortDate <> 'yyyy-MM-dd' then
	  begin
	  	ShowMessage('系统日期格式不正确，请设置为"yyyy-MM-dd"');
	  	exit;
	  end;
	  //i := 100;
	  //GetLocaleInfo(LOCALE_USER_DEFAULT, LOCALE_SLONGDATE, aBuf, i); // 取长日期格式
	  //aGPrevLongDate := string(aBuf);
	  i := 100;
	  GetLocaleInfo(LOCALE_USER_DEFAULT, LOCALE_STIMEFORMAT, aBuf, i); // 取时间格式
	  aGPrevTimeFormat := string(aBuf);
	  if aGPrevShortDate <> 'HH:mm:ss' then
	  begin
	  	ShowMessage('系统时间格式不正确，请设置为"HH:mm:ss"');
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
