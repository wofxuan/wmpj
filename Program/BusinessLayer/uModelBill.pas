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

  TModelBillAllot = class(TModelBill, IModelBillAllot) //单据-调拨单
    function GetBillCreateProcName: string; override;
  end;

  TModelBillPRMoney = class(TModelBill, IModelBillPRMoney) //单据-调拨单
    function GetBillCreateProcName: string; override;
    function QryBalance(AInParam: TParamObject; ACds: TClientDataSet): Integer; //查询需要结算点单据
    function SaveBalance(AParam: TParamObject): Integer; //保存，修改或删除结算的单据记录
  end;
implementation

uses uModelFunCom;

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

{ TModelBillPRMoney }

function TModelBillPRMoney.GetBillCreateProcName: string;
begin
  Result := 'pbx_Bill_Create';
end;

function TModelBillPRMoney.QryBalance(AInParam: TParamObject;
  ACds: TClientDataSet): Integer;
begin
  try
    Result := gMFCom.ExecProcBackData('pbx_A_Qry_Balance', AInParam, ACds);
  finally
  end;
end;

function TModelBillPRMoney.SaveBalance(AParam: TParamObject): Integer;
begin
  Result := gMFCom.ExecProcByName('pbx_A_Save_Gathering', AParam);
end;

initialization
  gClassIntfManage.addClass(TModelBillOrder, IModelBillOrder);
  gClassIntfManage.addClass(TModelBillBuy, IModelBillBuy);
  gClassIntfManage.addClass(TModelBillSale, IModelBillSale);
  gClassIntfManage.addClass(TModelBillAllot, IModelBillAllot);
  gClassIntfManage.addClass(TModelBillPRMoney, IModelBillPRMoney);

end.

