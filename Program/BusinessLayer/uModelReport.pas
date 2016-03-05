unit uModelReport;

interface

uses
  Classes, Windows, SysUtils, DBClient, uPubFun, uParamObject, uBusinessLayerPlugin,
  uBaseInfoDef, uModelParent, uModelBaseListIntf, uModelReportIntf, uModelFunCom;

type
  TModelReportStockGoods = class(TModelReport, IModelReportStockGoods) //报表-库存信息
     procedure LoadGridData(AParam: TParamObject; ACdsBaseList: TClientDataSet); override;
  end;

  TModelReportOrderBuy = class(TModelReport, IModelReportOrderBuy) //报表-进货订单统计
     procedure LoadGridData(AParam: TParamObject; ACdsBaseList: TClientDataSet); override;
  end;

  TModelReportBuy = class(TModelReport, IModelReportBuy) //报表-进货单统计
     procedure LoadGridData(AParam: TParamObject; ACdsBaseList: TClientDataSet); override;
  end;

  TModelReportOrderSale = class(TModelReport, IModelReportOrderSale) //报表-销售订单统计
     procedure LoadGridData(AParam: TParamObject; ACdsBaseList: TClientDataSet); override;
  end;

  TModelReportSale = class(TModelReport, IModelReportSale) //报表-销售单统计
     procedure LoadGridData(AParam: TParamObject; ACdsBaseList: TClientDataSet); override;
  end;
implementation

uses uVchTypeDef;

{ TModelReportStockGoods }

procedure TModelReportStockGoods.LoadGridData(AParam: TParamObject;
  ACdsBaseList: TClientDataSet);
begin
  inherited;
  gMFCom.QuerySQL('SELECT * FROM dbo.tbx_Stock_Goods a LEFT JOIN dbo.tbx_Base_Ptype b ON a.PTypeId = b.PTypeId', ACdsBaseList);
end;

{ TModelReportOrderBuy }

procedure TModelReportOrderBuy.LoadGridData(AParam: TParamObject;
  ACdsBaseList: TClientDataSet);
begin
  inherited;
  gMFCom.QuerySQL('SELECT * FROM dbo.tbx_Bill_Order_M WHERE VchType =' + IntToString(VchType_Order_Buy), ACdsBaseList);
end;

{ TModelReportBuy }

procedure TModelReportBuy.LoadGridData(AParam: TParamObject;
  ACdsBaseList: TClientDataSet);
begin
  inherited;
  gMFCom.QuerySQL('SELECT * FROM dbo.tbx_Bill_M WHERE VchType =' + IntToString(VchType_Buy), ACdsBaseList);
end;

{ TModelReportOrderSale }

procedure TModelReportOrderSale.LoadGridData(AParam: TParamObject;
  ACdsBaseList: TClientDataSet);
begin
  inherited;
  gMFCom.QuerySQL('SELECT * FROM dbo.tbx_Bill_Order_M WHERE VchType =' + IntToString(VchType_Order_Sale), ACdsBaseList);
end;

{ TModelReportSale }

procedure TModelReportSale.LoadGridData(AParam: TParamObject;
  ACdsBaseList: TClientDataSet);
begin
  inherited;
  gMFCom.QuerySQL('SELECT * FROM dbo.tbx_Bill_M WHERE VchType =' + IntToString(VchType_Sale), ACdsBaseList);
end;

initialization
  gClassIntfManage.addClass(TModelReportStockGoods, IModelReportStockGoods);
  gClassIntfManage.addClass(TModelReportOrderBuy, IModelReportOrderBuy);
  gClassIntfManage.addClass(TModelReportBuy, IModelReportBuy);
  gClassIntfManage.addClass(TModelReportOrderSale, IModelReportOrderSale);
  gClassIntfManage.addClass(TModelReportSale, IModelReportSale);

end.
