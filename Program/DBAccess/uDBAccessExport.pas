{***************************
���ݿ����
�˰���ר�Ŷ����ݿ�Ĳ�������ִ��SQL��䣬�洢���̵�
mx 2014-11-28
****************************}
unit uDBAccessExport;

interface

uses Classes, SysUtils, uRegPluginIntf, uDBAccess;

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

end;

initialization

finalization

end.