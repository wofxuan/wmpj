unit uFrmWMServer;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls,
  uROClient, uROPoweredByRemObjectsButton, uROClientIntf, uROServer,
  uROBinMessage, uROIndyHTTPServer, uROIndyTCPServer, Menus;

type
  TFrmWMServer = class(TForm)
    ROMessage: TROBinMessage;
    ROServer: TROIndyHTTPServer;
    mmServer: TMainMenu;
    mniSet: TMenuItem;
    mniDataBaseSet: TMenuItem;
    mniServerSet: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure mniDataBaseSetClick(Sender: TObject);
    procedure mniServerSetClick(Sender: TObject);
  private
    { Private declarations }
    FPort: Integer;
    
    procedure LoadCfg;
  public
    { Public declarations }
  end;

var
  FrmWMServer: TFrmWMServer;

implementation

uses IniFiles, WMFBData_Impl, uFrmDataBaseSet, uFrmServerSet;

{$R *.dfm}

procedure TFrmWMServer.FormCreate(Sender: TObject);
begin
  LoadCfg();
  ROServer.Port := FPort;
  ROServer.Active := true;
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
end.
