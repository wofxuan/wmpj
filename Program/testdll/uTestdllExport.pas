unit uTestdllExport;

interface

uses Classes, SysUtils, uRegPluginIntf, uTestdllPlugin;

procedure InstallPackage;                                   //安装包
procedure UnInstallPackage;                                 //卸载包
procedure RegisterPlugIn(Reg: IRegPlugin);                  //注册插件

implementation

procedure InstallPackage;
begin

end;

procedure UnInstallPackage;
begin

end;

procedure RegisterPlugIn(Reg: IRegPlugin);                  //注册插件
begin
  Reg.RegisterPluginClass(TTestdllPlugin);
end;

initialization

finalization

end.

