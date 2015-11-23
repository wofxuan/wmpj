unit uRDM;

interface

uses
  SysUtils, Classes, uRORemoteService, uROClient, uROWinInetHttpChannel,
  uROBinMessage;

const
  ClientCfgFile = 'WMPJ.Cfg';

type
  TDMWMServer = class(TDataModule)
    ROMessage: TROBinMessage;
    ROChannel: TROWinInetHTTPChannel;
    RORemoteService: TRORemoteService;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DMWMServer: TDMWMServer;

implementation

uses IniFiles;

{$R *.dfm}

procedure TDMWMServer.DataModuleCreate(Sender: TObject);
var
  aFilePath, aServerAddr: string;
  aIni: TIniFile;
  aPort: Integer;
begin
  aFilePath := ExtractFilePath(ParamStr(0)) + ClientCfgFile;
  if not FileExists(aFilePath) then
  begin
    FileCreate(aFilePath)
  end;
  aIni := TIniFile.Create(aFilePath);
  try
    aServerAddr := aIni.ReadString('Server', 'ServerAddr', '127.0.0.1');
    aIni.WriteString('Server', 'ServerAddr', aServerAddr);

    aPort := aIni.ReadInteger('Server', 'Port', 8099);
    aIni.WriteInteger('Server', 'Port', aPort);

//    ROChannel.TargetURL := 'http://localhost:8098/BIN';
    ROChannel.TargetURL := 'http://' + Trim(aServerAddr) + ':' + IntToStr(aPort) + '/BIN';
  finally
    aIni.Free;
  end;
end;

end.
