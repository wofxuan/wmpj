{***************************
��������
�쳣��������Ϣ��ʾ,��ҵ������ݿⲻ��صĲ���
mx 2014-12-28
****************************}
unit uOtherExport;

interface

uses Classes, SysUtils, uRegPluginIntf, uOther;

procedure InstallPackage;                                   //��װ��
procedure UnInstallPackage;                                 //ж�ذ�
procedure RegisterPlugIn(Reg: IRegPlugin);                  //ע����

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

procedure RegisterPlugIn(Reg: IRegPlugin);                  //ע����
begin

end;

initialization

finalization

end.
