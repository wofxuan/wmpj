{------------------------------------
  ����˵����������Ϣ�ӿ�
  �������ڣ�2014/08/04
  ���ߣ�mx
  ��Ȩ��mx
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

 