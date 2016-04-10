unit uModelBill;

interface

uses
  Classes, Windows, SysUtils, DBClient, uPubFun, uParamObject, uBusinessLayerPlugin,
  uBaseInfoDef, uModelParent, uModelBaseListIntf, uModelBillIntf;

type
  TModelBillOrder = class(TModelBill, IModelBillOrder) //����-����
    function GetBillCreateProcName: string; override;
  end;

  TModelBillBuy = class(TModelBill, IModelBillBuy) //����-���۵�
    function GetBillCreateProcName: string; override;
  end;

  TModelBillSale = class(TModelBill, IModelBillSale) //����-������
  function GetBillCreateProcName: string; override;
  end;
  
  TModelBillAllot = class(TModelBill, IModelBillAllot) //����-������
  function GetBillCreateProcName: string; override;
  end;
implementation

{ TModelBillOrder }

function TModelBillOrder.GetBillCreateProcName: string;
begin
  Result := 'pbx_Bill_Order_Create';
end;

{ TModelBillSale }

function TModelBillSale.GetBillCreateProcName: string;
begin
  Result := 'pbx_Bill_Create';
end;

{ TModelBillBuy }

function TModelBillBuy.GetBillCreateProcName: string;
begin
  Result := 'pbx_Bill_Create';
end;

{ TModelBillAllot }

function TModelBillAllot.GetBillCreateProcName: string;
begin
  Result := 'pbx_Bill_Create';
end;

initialization
  gClassIntfManage.addClass(TModelBillOrder, IModelBillOrder);
  gClassIntfManage.addClass(TModelBillBuy, IModelBillBuy);
  gClassIntfManage.addClass(TModelBillSale, IModelBillSale);
  gClassIntfManage.addClass(TModelBillAllot, IModelBillAllot);

end.
