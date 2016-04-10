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
  Title := '������ͳ��';
  inherited;
end;

procedure TfrmReportBuy.IniGridField;
begin
  inherited;
  FGridItem.ClearField();
  FGridItem.AddField('VchType', '��������', 50, cfString);
  FGridItem.AddField('InputDate', '����', 50, cfDate);
  FGridItem.AddField('Savedate', '����ʱ��', 50, cfDatime);
  FGridItem.AddField('Number', '�������', 50, cfString);
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
