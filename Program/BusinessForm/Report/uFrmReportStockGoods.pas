unit uFrmReportStockGoods;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uFrmMDIReport, cxStyles, cxCustomData, cxGraphics, cxFilter,
  cxData, cxDataStorage, cxEdit, dxBar, dxBarExtItems, cxClasses, ImgList,
  ActnList, DB, DBClient, cxGridLevel, cxControls, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGrid, ExtCtrls;

type
  TfrmReportStockGoods = class(TfrmMDIRepor)
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
  inherited;
  FModelReport := IModelReportStockGoods((SysService as IModelControl).GetModelIntf(IModelReportStockGoods));
  IniGridField();
  LoadGridData(ROOT_ID);
end;

procedure TfrmReportStockGoods.IniGridField;
begin
  inherited;
  FGridItem.BasicType := btPtype;
  FGridItem.ClearField();
  FGridItem.AddFiled(btPtype);
  FGridItem.AddFiled('Qty', '数量', 50, cfQty);
  FGridItem.AddFiled('Price', '单价', 50, cfPrice);
  FGridItem.AddFiled('Total', '金额', 50, cfTotal);
  FGridItem.InitGridData;
end;

procedure TfrmReportStockGoods.InitParamList;
begin
  inherited;
  MoudleNo := fnMdlReportGoods;
end;

initialization
  gFormManage.RegForm(TfrmReportStockGoods, fnMdlReportGoods);
  
end.
