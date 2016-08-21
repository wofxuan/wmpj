unit uModelReportIntf;

interface

uses DBClient, uParamObject, uBaseInfoDef, uModelBaseIntf, uOtherDefine;

type
  IModelReportStockGoods = interface(IModelReport) //����-����ѯ       
    ['{6BD77F05-402D-4B4F-81BC-80A034A2713D}']     
  end;
  IModelReportOrderBuy = interface(IModelReport) //����-��������ͳ��      
    ['{CBAC29EF-BEB1-46A7-A88A-6E2A128A9360}']
  end;
  IModelReportBuy = interface(IModelReport) //����-������ͳ��
    ['{0F0C852A-153C-4A70-8FB1-7770881D9329}']
  end;
  IModelReportOrderSale = interface(IModelReport) //����-���۶���ͳ��
    ['{97F150BC-2E3C-41F9-8E2E-04584AC65C82}']
  end;
  IModelReportSale = interface(IModelReport) //����-���۵�ͳ��     
    ['{2D626231-163D-4BBD-A202-AEA352D59407}']     
  end;

var
  TReport_Draft: TIDDisplayText;//�Ƿ����
  
implementation

initialization
  TReport_Draft := TIDDisplayText.Create;
  TReport_Draft.AddItem('0', 'δ����');
  TReport_Draft.AddItem('1', '�ݸ�');
  TReport_Draft.AddItem('2', '����');

finalization
  TReport_Draft.Free;
  
end.

