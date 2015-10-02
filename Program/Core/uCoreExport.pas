{------------------------------------
  功能说明：系统核心包控制单元
  创建日期：2014/07/08
  作者：mx
  版权：mx
-------------------------------------}
unit uCoreExport;

interface

uses Classes, SysUtils, Dialogs;

procedure Load(Intf: IInterface);//加载包后调用
procedure Init;//加载所有包后调用
procedure Final;//程序退出前调用


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
  //释放工厂管理的实例
  FactoryManager.ReleaseInstances;

  PluginMgr.Free;
end;

initialization

finalization

end.
