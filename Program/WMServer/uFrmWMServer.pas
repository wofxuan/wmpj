unit uFrmWMServer;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls,
  uROClient, uROPoweredByRemObjectsButton, uROClientIntf, uROServer,
  uROBinMessage, uROIndyHTTPServer, uROIndyTCPServer, Menus, ShellAPI;

{自定义消息，当小图标捕捉到鼠标事件时Windows向回调函数发送此消息}
const MY_MESSAGE = WM_USER + 100;

type
  TFrmState = (fsIni, fsClose);

  TFrmWMServer = class(TForm)
    ROMessage: TROBinMessage;
    ROServer: TROIndyHTTPServer;
    mmServer: TMainMenu;
    mniSet: TMenuItem;
    mniDataBaseSet: TMenuItem;
    mniServerSet: TMenuItem;
    pmList: TPopupMenu;
    mniClose: TMenuItem;
    mniShowFrm: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure mniDataBaseSetClick(Sender: TObject);
    procedure mniServerSetClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure mniCloseClick(Sender: TObject);
    procedure mniShowFrmClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    FPort: Integer;
    FFrmState: TFrmState;

    procedure LoadCfg;
    procedure SetIcon;
    procedure OnIconNotify(var Message: TMessage); message MY_MESSAGE;
    procedure OnSYSCOMMAND(var Message: TMessage); message WM_SYSCOMMAND;
  public
    { Public declarations }
  end;

var
  FrmWMServer: TFrmWMServer;
  FNotifyIcon: TNotifyIconData;

implementation

uses IniFiles, WMFBData_Impl, uFrmDataBaseSet, uFrmServerSet;

{$R *.dfm}

procedure TFrmWMServer.FormCreate(Sender: TObject);
begin
  LoadCfg();
  SetIcon();
  ROServer.Port := FPort;
  ROServer.Active := true;
  FFrmState := fsIni;
end;

procedure TFrmWMServer.LoadCfg;
var
  aFilePath: string;
  aIni: TIniFile;
begin
  aFilePath := ExtractFilePath(ParamStr(0)) + ServerCfgFile;
  aIni := TIniFile.Create(aFilePath);
  try
    FPort := aIni.ReadInteger('Server', 'Port', 8099);
  finally
    aIni.Free;
  end;
end;


procedure TFrmWMServer.mniDataBaseSetClick(Sender: TObject);
var
  aFrm: TfrmDataBaseSet;
begin
  aFrm := TfrmDataBaseSet.Create(Self);
  try
    aFrm.ShowModal;
  finally
    aFrm.Free;
  end;
end;

procedure TFrmWMServer.mniServerSetClick(Sender: TObject);
var
  aFrm: TfrmServerSet;
begin
  aFrm := TfrmServerSet.Create(Self);
  try
    aFrm.ShowModal;
  finally
    aFrm.Free;
  end;
end;

procedure TFrmWMServer.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if FFrmState <> fsClose then
  begin
    Action := caNone;
    Hide;
  end;
end;

procedure TFrmWMServer.OnIconNotify(var Message: TMessage);
var
  aPt: TPoint;
begin
  case Message.LParam of
    WM_RBUTTONUP:
      begin
        GetCursorPos(aPt);
        pmList.Popup(aPt.X, aPt.Y);
      end;
    WM_LBUTTONDBLCLK:
    begin
      mniShowFrmClick(mniShowFrm);
    end;
  end;
end;

procedure TFrmWMServer.SetIcon;
begin
  FNotifyIcon.cbSize := sizeof(FNotifyIcon); // nid变量的字节数
  FNotifyIcon.Wnd := Handle; // 主窗口句柄
  FNotifyIcon.uID := 0; // 内部标识，可设为任意数
  FNotifyIcon.hIcon := Application.Icon.Handle; // 要加入的图标句柄，可任意指定
  FNotifyIcon.szTip := 'WM服务端'; // 提示字符串
  FNotifyIcon.uCallbackMessage := MY_MESSAGE; // 回调函数消息

  FNotifyIcon.uFlags := NIF_ICON or NIF_TIP or NIF_MESSAGE; // 指明哪些字段有效
  if not Shell_NotifyIcon(NIM_ADD, @FNotifyIcon) then
  begin
    ShowMessage('加载系统函数失败！');
    Application.Terminate;
  end;
end;

procedure TFrmWMServer.mniCloseClick(Sender: TObject);
begin
  if MessageBox(Handle, '是否确定关闭服务端？', '提示', MB_ICONINFORMATION + MB_YESNO) = idYes  then
  begin
    FFrmState := fsClose;
    Close;
  end;
end;

procedure TFrmWMServer.mniShowFrmClick(Sender: TObject);
begin
  Show;
end;

procedure TFrmWMServer.FormDestroy(Sender: TObject);
begin
  Shell_NotifyIcon(NIM_DELETE, @FNotifyIcon);
end;

procedure TFrmWMServer.OnSYSCOMMAND(var Message: TMessage);
begin
  inherited;
  if Message.WParam = SC_MINIMIZE then
    Close;
end;

end.

