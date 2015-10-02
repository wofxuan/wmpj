{------------------------------------
  功能说明：服务信息接口
  创建日期：2014/08/04
  作者：mx
  版权：mx
-------------------------------------}
unit uSvcInfoIntf;

interface

type
  ISvcInfo = interface
    ['{A4AC764B-1306-4FC3-9A0F-524B25C56992}']
    function GetModuleName: string;
    function GetTitle: string;
    function GetVersion: string;
    function GetComments: string;
  end;

implementation

end.

 