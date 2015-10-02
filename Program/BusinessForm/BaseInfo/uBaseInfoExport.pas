unit uBaseInfoExport;

interface

uses Classes, SysUtils, uRegPluginIntf;

procedure InstallPackage;//安装包
procedure UnInstallPackage;//卸载包
procedure RegisterPlugIn(Reg:IRegPlugin);//注册插件

exports
  InstallPackage,
  UnInstallPackage,
  RegisterPlugIn;

implementation

uses uModuleList;

procedure InstallPackage;
begin

end;

procedure UnInstallPackage;
begin

end;

procedure RegisterPlugIn(Reg:IRegPlugin);//注册插件
begin

end;

initialization

finalization

end.
