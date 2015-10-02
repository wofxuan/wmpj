unit uFrmWMServer;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls,
  uROClient, uROPoweredByRemObjectsButton, uROClientIntf, uROServer,
  uROBinMessage, uROIndyHTTPServer, uROIndyTCPServer;

type
  TFrmWMServer = class(TForm)
    ROMessage: TROBinMessage;
    ROServer: TROIndyHTTPServer;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmWMServer: TFrmWMServer;

implementation


{$R *.dfm}

procedure TFrmWMServer.FormCreate(Sender: TObject);
begin
  ROServer.Active := true;
end;

end.
