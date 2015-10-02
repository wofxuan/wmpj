{***************************
窗体包
mx 2014-11-28
****************************}
unit uBaseFormExport;

interface

uses Classes, SysUtils, uRegPluginIntf, uBaseFormPlugin;

procedure InstallPackage;//安装包
procedure UnInstallPackage;//卸载包
procedure RegisterPlugIn(Reg:IRegPlugin);//注册插件

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

procedure RegisterPlugIn(Reg:IRegPlugin);//注册插件
begin
  Reg.RegisterPluginClass(TBaseFormPlugin);
end;

initialization

finalization

end.
 