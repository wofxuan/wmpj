unit uFrmReportBill;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uFrmMDIReport, cxStyles, cxCustomData, cxGraphics, cxFilter,
  cxData, cxDataStorage, cxEdit, dxBar, dxBarExtItems, cxClasses, ImgList,
  ActnList, DB, DBClient, cxGridLevel, cxControls, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGrid, ExtCtrls, uParamObject;

type
  TfrmReportBill = class(TfrmMDIReport)
  private
    { Private declarations }
    FVchType: Integer;
    
    procedure BeforeFormShow; override;
    function GetQryParam(AParam: TParamObject): Boolean; override;
  public
    { Public declarations }
    procedure IniGridField; override;
    procedure InitParamList; override;
  end;

var
  frmReportBill: TfrmReportBill;

implementation

uses uSysSvc, uBaseFormPlugin, uMoudleNoDef, uModelReportIntf, uVchTypeDef,
     uModelControlIntf, uBaseInfoDef, uDefCom, uGridConfig, uFrmApp;
{$R *.dfm}

{ TfrmReportStockGoods }

procedure TfrmReportBill.BeforeFormShow;
begin
  if ParamList.AsString('Mode') = 'B' then
  begin
    Title := '进货单查询';
    FVchType := VchType_Buy;
    MoudleNo := fnMdlBillBuy;
    FModelReport := IModelReportBuy((SysService as IModelControl).GetModelIntf(IModelReportBuy));
  end
  else if ParamList.AsString('Mode') = 'S' then
  begin
    Title := '销售单查询';
    FVchType := VchType_Sale;
    MoudleNo := fnMdlBillSale;
    FModelReport := IModelReportSale((SysService as IModelControl).GetModelIntf(IModelReportSale));
  end;
  inherited;
end;

function TfrmReportBill.GetQryParam(AParam: TParamObject): Boolean;
begin
  Result := False;
  AParam.Add('@VchType', FVchType);
  AParam.Add('@CMode', 'L');
  AParam.Add('@BeginDate', '');
  AParam.Add('@EndDate', '');
  AParam.Add('@TypeID', '');
  AParam.Add('@PTypeId', '');
  AParam.Add('@BTypeId', '');
  AParam.Add('@ETypeId', '');
  AParam.Add('@KTypeId', '');
  AParam.Add('@OperatorID', OperatorID);
  Result := True;
end;

procedure TfrmReportBill.IniGridField;
begin
  inherited;
  FGridItem.ClearField();
  FGridItem.AddField(btVtype);
  FGridItem.AddField('VchCode', 'VchCode', -1);
  FGridItem.AddField('InputDate', '录单日期', 100, cfDate);
  FGridItem.AddField('Savedate', '存盘时间', 100, cfDatime);
  FGridItem.AddField('Number', '单据编号', 200, cfString);
  FGridItem.InitGridData;
end;

procedure TfrmReportBill.InitParamList;
begin
  inherited;

end;

initialization
  gFormManage.RegForm(TfrmReportBill, fnMdlReportBuy);
  gFormManage.RegForm(TfrmReportBill, fnMdlReportSale);
  
end.
