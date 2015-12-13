unit uModelBill;

interface

uses
  Classes, Windows, SysUtils, DBClient, uPubFun, uParamObject, uBusinessLayerPlugin,
  uBaseInfoDef, uModelParent, uModelBaseListIntf, uModelBillIntf;

type
  TModelBillOrder = class(TModelBill, IModelBillOrder) //单据-订单
    function GetBillCreateProcName: string; override;
  end;

  TModelBillBuy = class(TModelBill, IModelBillBuy) //单据-销售单
    function GetBillCreateProcName: string; override;
  end;

  TModelBillSale = class(TModelBill, IModelBillSale) //单据-进货单
  function GetBillCreateProcName: string; override;
  end;

implementation

{ TModelBillSale }

function TModelBillSale.GetBillCreateProcName: string;
begin
  Result := 'pbx_Bill_Create';
end;

{ TModelBillOrder }

function TModelBillOrder.GetBillCreateProcName: string;
begin
  Result := 'pbx_Bill_Order_Create';
end;

{ TModelBillBuy }

function TModelBillBuy.GetBillCreateProcName: string;
begin
  Result := 'pbx_Bill_Create';
end;

initialization
  gClassIntfManage.addClass(TModelBillOrder, IModelBillOrder);
  gClassIntfManage.addClass(TModelBillBuy, IModelBillBuy);
  gClassIntfManage.addClass(TModelBillSale, IModelBillSale);

end.
