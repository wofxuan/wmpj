{***************************
ҵ���߼��ӿڿ���
ע��ͻ�ȡҵ���߼�ģ�͵Ľӿ�
mx 2015-05-08
****************************}
unit uModelControlIntf;

interface

uses SysUtils, uDefCom;

type

  //ҵ����ƽӿ�                                
  IModelControl = interface
    ['{079684DF-C6E6-4B7A-82AC-5EC93A95262E}']
    procedure RegModelIntf(AModelIntf: IInterface);
    function GetModelIntf(AModelIntf: TGUID): IInterface;
end;


implementation

end.

