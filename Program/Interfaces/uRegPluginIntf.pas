{------------------------------------
  功能说明：注册插件接口
  创建日期：2014/08/17
  作者：mx
  版权：mx
-------------------------------------}
unit uRegPluginIntf;

interface

uses uPluginBase;

type
  IRegPlugin = interface
    ['{B99EE19D-906E-4C58-B62A-C7D2DA0F28DA}']
    procedure RegisterPluginClass(PluginClass: TPluginClass);
  end;

implementation

end.

