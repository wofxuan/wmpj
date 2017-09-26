unit uFrmReportStockGoods;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uFrmMDIReport, cxStyles, cxCustomData, cxGraphics, cxFilter,
  cxData, cxDataStorage, cxEdit, dxBar, dxBarExtItems, cxClasses, ImgList,
  ActnList, DB, DBClient, cxGridLevel, cxControls, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGrid, ExtCtrls;

type
  TfrmReportStockGoods = class(TfrmMDIReport)
  private
    { Private declarations }
    procedure BeforeFormShow; override;
  public
    { Public declarations }
    procedure IniGridField; override;
    procedure InitParamList; override;
  end;

var
  frmReportStockGoods: TfrmReportStockGoods;

implementation

uses uSysSvc, uBaseFormPlugin, uMoudleNoDef, uParamObject, uModelReportIntf,
     uModelControlIntf, uBaseInfoDef, uDefCom, uGridConfig, uFrmApp;
{$R *.dfm}

{ TfrmReportStockGoods }

procedure TfrmReportStockGoods.BeforeFormShow;
begin
  FModelReport := IModelReportStockGoods((SysService as IModelControl).GetModelIntf(IModelReportStockGoods));
  inherited;
end;

procedure TfrmReportStockGoods.IniGridField;
var
  aCol: TColInfo;
begin
  inherited;
  FGridItem.BasicType := btPtype;
  FGridItem.ClearField();
  FGridItem.AddField(btPtype);
  FGridItem.AddField('Qty', '数量', 50, cfQty);
  FGridItem.AddField('Price', '单价', 50, cfPrice);
  aCol := FGridItem.AddField('Total', '金额', 50, cfTotal);
  FGridItem.AddFooterSummary(aCol, skSum);
  FGridItem.InitGridData;
end;

procedure TfrmReportStockGoods.InitParamList;
begin
  MoudleNo := fnMdlReportGoods;
  inherited;
end;

initialization
  gFormManage.RegForm(TfrmReportStockGoods, fnMdlReportGoods);
  
end.
