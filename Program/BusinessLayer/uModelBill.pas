unit uModelBill;

interface

uses
  Classes, Windows, SysUtils, DBClient, uPubFun, uParamObject, uBusinessLayerPlugin,
  uBaseInfoDef, uModelParent, uModelBaseListIntf, uModelBillIntf;

type
  TModelBillOrder = class(TModelBill, IModelBillOrder) //单据-进货订单或者销售订单
    function BillCreate(AModi, ADraft, AVchType, AVchcode, AOldVchCode: Integer; AOutPutData: TParamObject): Integer; override; //单据过账
  end;

  TModelBillBuy = class(TModelBill, IModelBillBuy) //单据-进货单
    function BillCreate(AModi, ADraft, AVchType, AVchcode, AOldVchCode: Integer; AOutPutData: TParamObject): Integer; override; //单据过账
  end;

  TModelBillSale = class(TModelBill, IModelBillSale) //单据-销售单
    function BillCreate(AModi, ADraft, AVchType, AVchcode, AOldVchCode: Integer; AOutPutData: TParamObject): Integer; override; //单据过账
  end;
implementation

uses uModelFunCom, uOtherIntf;

{ TModelBillOrder }

function TModelBillOrder.BillCreate(AModi, ADraft, AVchType, AVchcode,
  AOldVchCode: Integer; AOutPutData: TParamObject): Integer;
var
  aList: TParamObject;
  aRet: Integer;
  aErrorMsg: string;
begin
  aList := TParamObject.Create;
  try
    aList.Add('@NewVchCode', AVchcode);
    aList.Add('@OldVchCode', AOldVchcode);
    aList.Add('@errorValue', '');
    aRet := gMFCom.ExecProcByName('pbx_Bill_Order_Create', aList);
    if aRet <> 0 then
    begin
      aErrorMsg := aList.AsString('@errorValue');
      gMFCom.ShowMsgBox(aErrorMsg, '错误', mbtError);
    end
    else
    begin
      gMFCom.ShowMsgBox('过账完成！', '提示', mbtError);
    end;
    Result := aRet;
  finally
    aList.Free;
  end;
end;

{ TModelBillBuy }

function TModelBillBuy.BillCreate(AModi, ADraft, AVchType, AVchcode,
  AOldVchCode: Integer; AOutPutData: TParamObject): Integer;
begin
  inherited BillCreate(AModi, ADraft, AVchType, AVchcode, AOldVchCode, AOutPutData);
end;

{ TModelBillSale }

function TModelBillSale.BillCreate(AModi, ADraft, AVchType, AVchcode,
  AOldVchCode: Integer; AOutPutData: TParamObject): Integer;
begin
  inherited BillCreate(AModi, ADraft, AVchType, AVchcode, AOldVchCode, AOutPutData);
end;

initialization
  gClassIntfManage.addClass(TModelBillOrder, IModelBillOrder);
  gClassIntfManage.addClass(TModelBillBuy, IModelBillBuy);
  gClassIntfManage.addClass(TModelBillSale, IModelBillSale);

end.
