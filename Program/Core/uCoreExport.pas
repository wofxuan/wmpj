{------------------------------------
  ����˵����ϵͳ���İ����Ƶ�Ԫ
  �������ڣ�2014/07/08
  ���ߣ�mx
  ��Ȩ��mx
-------------------------------------}
unit uCoreExport;

interface

uses Classes, SysUtils, Dialogs;

procedure Load(Intf: IInterface);//���ذ������
procedure Init;//�������а������
procedure Final;//�����˳�ǰ����


exports
  Load,
  Init,
  final;
  
implementation

uses uSysFactoryMgr, uSysPluginMgr, uSysSvc;

procedure Load(Intf:IInterface);
begin
  PluginMgr := TPluginMgr.Create;
  PluginMgr.LoadPackage(Intf);
end;

procedure Init;
begin
  PluginMgr.Init;
end;

procedure Final;
begin
  PluginMgr.final;
  //�ͷŹ���������ʵ��
  FactoryManager.ReleaseInstances;

  PluginMgr.Free;
end;

initialization

finalization

end.