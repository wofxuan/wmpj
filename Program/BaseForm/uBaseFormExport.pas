{***************************
�����
mx 2014-11-28
****************************}
unit uBaseFormExport;

interface

uses Classes, SysUtils, uRegPluginIntf, uBaseFormPlugin;

procedure InstallPackage;//��װ��
procedure UnInstallPackage;//ж�ذ�
procedure RegisterPlugIn(Reg:IRegPlugin);//ע����

exports
  InstallPackage,
  UnInstallPackage,
  RegisterPlugIn;

implementation

procedure InstallPackage;
begin

end;

procedure UnInstallPackage;
begin

end;

procedure RegisterPlugIn(Reg:IRegPlugin);//ע����
begin
  Reg.RegisterPluginClass(TBaseFormPlugin);
end;

initialization

finalization

end.
 