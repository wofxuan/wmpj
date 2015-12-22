unit uModelReport;

interface

uses
  Classes, Windows, SysUtils, DBClient, uPubFun, uParamObject, uBusinessLayerPlugin,
  uBaseInfoDef, uModelParent, uModelBaseListIntf, uModelReportIntf, uModelFunCom;

type
  TModelReportStockGoods = class(TModelReport, IModelReportStockGoods) //报表-库存信息
     procedure LoadGridData(AParam: TParamObject; ACdsBaseList: TClientDataSet); override;
  end;


implementation


{ TModelReportStockGoods }

procedure TModelReportStockGoods.LoadGridData(AParam: TParamObject;
  ACdsBaseList: TClientDataSet);
begin
  inherited;
  gMFCom.QuerySQL('SELECT * FROM dbo.tbx_Stock_Goods a LEFT JOIN dbo.tbx_Base_Ptype b ON a.PTypeId = b.PTypeId', ACdsBaseList);
end;

initialization
  gClassIntfManage.addClass(TModelReportStockGoods, IModelReportStockGoods);

end.
