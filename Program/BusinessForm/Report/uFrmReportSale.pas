unit uFrmReportSale;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uFrmMDIReport, cxStyles, cxCustomData, cxGraphics, cxFilter,
  cxData, cxDataStorage, cxEdit, dxBar, dxBarExtItems, cxClasses, ImgList,
  ActnList, DB, DBClient, cxGridLevel, cxControls, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGrid, ExtCtrls;

type
  TfrmReportSale = class(TfrmMDIReport)
  private
    { Private declarations }
    procedure BeforeFormShow; override;
  public
    { Public declarations }
    procedure IniGridField; override;
    procedure InitParamList; override;
  end;

var
  frmReportSale: TfrmReportSale;

implementation

uses uSysSvc, uBaseFormPlugin, uMoudleNoDef, uParamObject, uModelReportIntf,
     uModelControlIntf, uBaseInfoDef, uDefCom, uGridConfig, uFrmApp;
{$R *.dfm}

{ TfrmReportStockGoods }

procedure TfrmReportSale.BeforeFormShow;
begin
  FModelReport := IModelReportSale((SysService as IModelControl).GetModelIntf(IModelReportSale));
  inherited;
end;

procedure TfrmReportSale.IniGridField;
begin
  inherited;
  FGridItem.ClearField();
  FGridItem.AddField('VchType', '��������', 50, cfString);
  FGridItem.AddField('InputDate', '����', 50, cfDate);
  FGridItem.AddField('Savedate', '����ʱ��', 50, cfDatime);
  FGridItem.AddField('Number', '�������', 50, cfString);
  FGridItem.InitGridData;
end;

procedure TfrmReportSale.InitParamList;
begin
  inherited;
  MoudleNo := fnMdlReportOrderSale;
end;

initialization
  gFormManage.RegForm(TfrmReportSale, fnMdlReportSale);
  
end.
