unit uBusinessLayerExport;

interface

uses Classes, SysUtils, uRegPluginIntf;

procedure InstallPackage;//��װ��
procedure UnInstallPackage;//ж�ذ�
procedure RegisterPlugIn(Reg:IRegPlugin);//ע����

exports
  InstallPackage,
  UnInstallPackage,
  RegisterPlugIn;

implementation

uses uBusinessLayerPlugin;

procedure InstallPackage;
begin

end;

procedure UnInstallPackage;
begin

end;

procedure RegisterPlugIn(Reg: IRegPlugin);//ע����
begin
  Reg.RegisterPluginClass(TBusinessLayerPlugin);
end;

initialization

finalization

end.
