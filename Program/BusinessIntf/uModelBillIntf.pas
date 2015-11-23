unit uModelBillIntf;

interface

uses DBClient, uParamObject, uBaseInfoDef, uModelBaseIntf;

type
  IModelBillOrder = interface(IModelBill) //单据-进货订单或者销售订单
    ['{2F34D9A2-B1C1-4DB8-99C9-7CE7D5D69AFC}']      
  end;

  IModelBillBuy = interface(IModelBill) //单据-进货单
    ['{8F4CEB98-D36F-412B-939A-5F547F6339CB}']    
  end;

  IModelBillSale = interface(IModelBill) //单据-销售单
    ['{F2F823F6-8666-4C26-BB74-74B1A6D39871}']           
  end;
implementation

end.

