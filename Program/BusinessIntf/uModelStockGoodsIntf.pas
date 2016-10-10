{***************************
�����صĽӿ�
mx 2016-03-27
****************************}

unit uModelStockGoodsIntf;

interface

uses DBClient, Classes, uParamObject, uBaseInfoDef, uModelBaseIntf, uOtherDefine;

type
  IModelStockGoods = interface(IModelBase)
    ['{C97276EC-94AA-46EF-A6C4-3EC66F97D0BF}']
    function LoadStockGoodsIni(AParam: TParamObject; ACdsIniData: TClientDataSet): Integer; //��ѯ�ڳ������Ϣ
    function ModifyOneRec(AParam: TParamObject): Integer; //�޸�һ���ڳ���¼
    function InitOver(AParam: TParamObject): Integer; //ϵͳ���˺ͷ�����
    function P_OneCheck(AParam: TParamObject): Integer; //��ȡ���߲��������һ���ֿ��̵���Ϣ���
    function QryCheck(AParam: TParamObject; ACdsCheckData: TClientDataSet): Integer; //��ѯ�̵�ļ�¼
    function SaveOneCheck(AParam: TParamObject): Integer; //�����̵�ļ�¼
  end;

implementation

end.

