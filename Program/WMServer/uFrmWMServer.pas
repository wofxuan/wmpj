unit uFrmWMServer;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls,
  uROClient, uROPoweredByRemObjectsButton, uROClientIntf, uROServer,
  uROBinMessage, uROIndyHTTPServer, uROIndyTCPServer, Menus, ShellAPI;

{�Զ�����Ϣ����Сͼ�겶׽������¼�ʱWindows��ص��������ʹ���Ϣ}
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
  FNotifyIcon.cbSize := sizeof(FNotifyIcon); // nid�������ֽ���
  FNotifyIcon.Wnd := Handle; // �����ھ��
  FNotifyIcon.uID := 0; // �ڲ���ʶ������Ϊ������
  FNotifyIcon.hIcon := Application.Icon.Handle; // Ҫ�����ͼ������������ָ��
  FNotifyIcon.szTip := 'WM�����'; // ��ʾ�ַ���
  FNotifyIcon.uCallbackMessage := MY_MESSAGE; // �ص�������Ϣ

  FNotifyIcon.uFlags := NIF_ICON or NIF_TIP or NIF_MESSAGE; // ָ����Щ�ֶ���Ч
  if not Shell_NotifyIcon(NIM_ADD, @FNotifyIcon) then
  begin
    ShowMessage('����ϵͳ����ʧ�ܣ�');
    Application.Terminate;
  end;
end;

procedure TFrmWMServer.mniCloseClick(Sender: TObject);
begin
  if MessageBox(Handle, '�Ƿ�ȷ���رշ���ˣ�', '��ʾ', MB_ICONINFORMATION + MB_YESNO) = idYes  then
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

