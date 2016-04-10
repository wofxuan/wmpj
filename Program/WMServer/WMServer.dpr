program WMServer;

{#ROGEN:WMServer.rodl} // RemObjects: Careful, do not remove!

uses
  uROComInit,
  Forms,
  uFrmWMServer in 'uFrmWMServer.pas' {FrmWMServer},
  WMServer_Intf in 'WMServer_Intf.pas',
  WMServer_Invk in 'WMServer_Invk.pas',
  WMFBData_Impl in 'WMFBData_Impl.pas',
  uPubFun in '..\Pub\uPubFun.pas';

{$R *.res}
{$R RODLFile.res}

begin
  Application.Initialize;
  Application.Title := 'WM·þÎñ¶Ë';
  Application.CreateForm(TFrmWMServer, FrmWMServer);
  Application.Run;
end.
