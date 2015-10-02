{***************************
其它操作
异常处理，信息提示,跟业务和数据库不相关的操作
mx 2014-12-28
****************************}
unit uOtherExport;

interface

uses Classes, SysUtils, uRegPluginIntf, uOther;

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

