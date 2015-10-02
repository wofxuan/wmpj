unit uRDM;

interface

uses
  SysUtils, Classes, uRORemoteService, uROClient, uROWinInetHttpChannel,
  uROBinMessage;

type
  TDMWMServer = class(TDataModule)
    ROMessage: TROBinMessage;
    ROChannel: TROWinInetHTTPChannel;
    RORemoteService: TRORemoteService;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DMWMServer: TDMWMServer;

implementation

{$R *.dfm}

end.
