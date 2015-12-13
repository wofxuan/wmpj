unit uModelBillIntf;

interface

uses DBClient, uParamObject, uBaseInfoDef, uModelBaseIntf;

type
  IModelBillOrder = interface(IModelBill) //单据-订单
    ['{2F34D9A2-B1C1-4DB8-99C9-7CE7D5D69AFC}']      
  end;

  IModelBillBuy = interface(IModelBill) //单据-进货单
    ['{C2586F34-A232-4C40-A3C9-547C8BC66F12}']
  end;

  IModelBillSale = interface(IModelBill) //单据-销售单
    ['{8BE32B7F-DFA3-48B7-9687-51CE83C1BBBB}']
  end;

implementation

end.

