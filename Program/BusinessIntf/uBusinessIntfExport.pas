{***************************
业务接口包
保存所有的业务接口，没有任何的逻辑，和其它代码
mx 2014-12-28
****************************}
unit uBusinessIntfExport;

interface

uses Classes, SysUtils, uRegPluginIntf;

procedure InstallPackage;                                   //安装包
procedure UnInstallPackage;                                 //卸载包
procedure RegisterPlugIn(Reg: IRegPlugin);                  //注册插件

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

procedure RegisterPlugIn(Reg: IRegPlugin);                  //注册插件
begin

end;

initialization

finalization

end.

