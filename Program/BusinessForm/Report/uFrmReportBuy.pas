unit uFrmReportBuy;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uFrmMDIReport, cxStyles, cxCustomData, cxGraphics, cxFilter,
  cxData, cxDataStorage, cxEdit, dxBar, dxBarExtItems, cxClasses, ImgList,
  ActnList, DB, DBClient, cxGridLevel, cxControls, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGrid, ExtCtrls;

type
  TfrmReportBuy = class(TfrmMDIReport)
  private
    { Private declarations }
    procedure BeforeFormShow; override;
  public
    { Public declarations }
    procedure IniGridField; override;
    procedure InitParamList; override;
  end;

var
  frmReportBuy: TfrmReportBuy;

implementation

uses uSysSvc, uBaseFormPlugin, uMoudleNoDef, uParamObject, uModelReportIntf,
     uModelControlIntf, uBaseInfoDef, uDefCom, uGridConfig, uFrmApp;
{$R *.dfm}

{ TfrmReportStockGoods }

procedure TfrmReportBuy.BeforeFormShow;
begin
  FModelReport := IModelReportBuy((SysService as IModelControl).GetModelIntf(IModelReportBuy));
  Title := '进货单统计';
  inherited;
end;

procedure TfrmReportBuy.IniGridField;
begin
  inherited;
  FGridItem.ClearField();
  FGridItem.AddField('VchType', '单据类型', 50, cfString);
  FGridItem.AddField('InputDate', '日期', 50, cfDate);
  FGridItem.AddField('Savedate', '存盘时间', 50, cfDatime);
  FGridItem.AddField('Number', '订单编号', 50, cfString);
  FGridItem.InitGridData;
end;

procedure TfrmReportBuy.InitParamList;
begin
  inherited;
  MoudleNo := fnMdlReportBuy;
end;

initialization
  gFormManage.RegForm(TfrmReportBuy, fnMdlReportBuy);
  
end.
