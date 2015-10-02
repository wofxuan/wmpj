{***************************
数据库操作
此包是专门对数据库的操作，如执行SQL语句，存储过程等
mx 2014-11-28
****************************}
unit uDBAccessExport;

interface

uses Classes, SysUtils, uRegPluginIntf, uDBAccess;

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

end;

initialization

finalization

end.
