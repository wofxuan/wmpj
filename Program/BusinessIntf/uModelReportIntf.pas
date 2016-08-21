unit uModelReportIntf;

interface

uses DBClient, uParamObject, uBaseInfoDef, uModelBaseIntf, uOtherDefine;

type
  IModelReportStockGoods = interface(IModelReport) //报表-库存查询       
    ['{6BD77F05-402D-4B4F-81BC-80A034A2713D}']     
  end;
  IModelReportOrderBuy = interface(IModelReport) //报表-进货订单统计      
    ['{CBAC29EF-BEB1-46A7-A88A-6E2A128A9360}']
  end;
  IModelReportBuy = interface(IModelReport) //报表-进货单统计
    ['{0F0C852A-153C-4A70-8FB1-7770881D9329}']
  end;
  IModelReportOrderSale = interface(IModelReport) //报表-销售订单统计
    ['{97F150BC-2E3C-41F9-8E2E-04584AC65C82}']
  end;
  IModelReportSale = interface(IModelReport) //报表-销售单统计     
    ['{2D626231-163D-4BBD-A202-AEA352D59407}']     
  end;

var
  TReport_Draft: TIDDisplayText;//是否过账
  
implementation

initialization
  TReport_Draft := TIDDisplayText.Create;
  TReport_Draft.AddItem('0', '未定义');
  TReport_Draft.AddItem('1', '草稿');
  TReport_Draft.AddItem('2', '过账');

finalization
  TReport_Draft.Free;
  
end.

