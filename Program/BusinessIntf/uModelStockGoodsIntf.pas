{***************************
库存相关的接口
mx 2016-03-27
****************************}

unit uModelStockGoodsIntf;

interface

uses DBClient, Classes, uParamObject, uBaseInfoDef, uModelBaseIntf, uOtherDefine;

type
  IModelStockGoods = interface(IModelBase)
    ['{C97276EC-94AA-46EF-A6C4-3EC66F97D0BF}']
    function LoadStockGoodsIni(AParam: TParamObject; ACdsIniData: TClientDataSet): Integer; //查询期初库存信息
    function ModifyOneRec(AParam: TParamObject): Integer; //修改一条期初记录
    function InitOver(AParam: TParamObject): Integer; //系统开账和反开账
    function P_OneCheck(AParam: TParamObject): Integer; //获取或者插入最近的一个仓库盘点信息标记
    function QryCheck(AParam: TParamObject; ACdsCheckData: TClientDataSet): Integer; //查询盘点的记录
    function SaveOneCheck(AParam: TParamObject): Integer; //保存盘点的记录
  end;

implementation

end.

