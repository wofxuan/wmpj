unit uFrmReportOrdeSale;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uFrmMDIReport, cxStyles, cxCustomData, cxGraphics, cxFilter,
  cxData, cxDataStorage, cxEdit, dxBar, dxBarExtItems, cxClasses, ImgList,
  ActnList, DB, DBClient, cxGridLevel, cxControls, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGrid, ExtCtrls;

type
  TfrmReportOrderSale = class(TfrmMDIReport)
  private
    { Private declarations }
    procedure BeforeFormShow; override;
  public
    { Public declarations }
    procedure IniGridField; override;
    procedure InitParamList; override;
  end;

var
  frmReportOrderSale: TfrmReportOrderSale;

implementation

uses uSysSvc, uBaseFormPlugin, uMoudleNoDef, uParamObject, uModelReportIntf,
     uModelControlIntf, uBaseInfoDef, uDefCom, uGridConfig, uFrmApp;
{$R *.dfm}

{ TfrmReportStockGoods }

procedure TfrmReportOrderSale.BeforeFormShow;
begin
  FModelReport := IModelReportOrderSale((SysService as IModelControl).GetModelIntf(IModelReportOrderSale));
  inherited;
end;

procedure TfrmReportOrderSale.IniGridField;
begin
  inherited;
  FGridItem.ClearField();
  FGridItem.AddFiled('VchType', '单据类型', 50, cfString);
  FGridItem.AddFiled('InputDate', '日期', 50, cfDate);
  FGridItem.AddFiled('Savedate', '存盘时间', 50, cfDatime);
  FGridItem.AddFiled('Number', '订单编号', 50, cfString);
  FGridItem.InitGridData;
end;

procedure TfrmReportOrderSale.InitParamList;
begin
  inherited;
  MoudleNo := fnMdlReportOrderSale;
end;

initialization
  gFormManage.RegForm(TfrmReportOrderSale, fnMdlReportOrderSale);
  
end.
