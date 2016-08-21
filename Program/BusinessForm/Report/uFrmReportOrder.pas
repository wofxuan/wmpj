unit uFrmReportOrder;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uFrmMDIReport, cxStyles, cxCustomData, cxGraphics, cxFilter,
  cxData, cxDataStorage, cxEdit, dxBar, dxBarExtItems, cxClasses, ImgList,
  ActnList, DB, DBClient, cxGridLevel, cxControls, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGrid, ExtCtrls, uParamObject;

type
  TfrmReportOrder = class(TfrmMDIReport)
    procedure gridTVMainShowCellDblClick(Sender: TcxCustomGridTableView;
      ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton;
      AShift: TShiftState; var AHandled: Boolean);
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
  frmReportOrder: TfrmReportOrder;

implementation

uses uSysSvc, uBaseFormPlugin, uMoudleNoDef, uModelReportIntf, uVchTypeDef, uFunApp,
     uModelControlIntf, uBaseInfoDef, uDefCom, uGridConfig, uFrmApp, uMainFormIntf;
{$R *.dfm}

{ TfrmReportStockGoods }

procedure TfrmReportOrder.BeforeFormShow;
begin
  if ParamList.AsString('Mode') = 'B' then
  begin
    Title := '����������ѯ';
    FVchType := VchType_Order_Buy;
    MoudleNo := fnMdlReportOrderBuy;
    FModelReport := IModelReportOrderBuy((SysService as IModelControl).GetModelIntf(IModelReportOrderBuy));
  end
  else if ParamList.AsString('Mode') = 'S' then
  begin
    Title := '���۶�����ѯ';
    FVchType := VchType_Order_Sale;
    MoudleNo := fnMdlReportOrderSale;
    FModelReport := IModelReportOrderSale((SysService as IModelControl).GetModelIntf(IModelReportOrderSale));
  end;
  inherited;
end;

procedure TfrmReportOrder.IniGridField;
begin
  inherited;
  FGridItem.ClearField();
  FGridItem.AddField(btVtype);
  FGridItem.AddField('VchCode', 'VchCode', -1);
  FGridItem.AddField('InputDate', '¼������', 100, cfDate);
  FGridItem.AddField('Savedate', '����ʱ��', 100, cfDatime);
  FGridItem.AddField('Number', '�������', 200, cfString);
  FGridItem.InitGridData;
end;

procedure TfrmReportOrder.InitParamList;
begin
  inherited;

end;

procedure TfrmReportOrder.gridTVMainShowCellDblClick(
  Sender: TcxCustomGridTableView;
  ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton;
  AShift: TShiftState; var AHandled: Boolean);
var
  aVchType, aVchCode: Integer;
  aRowIndex: Integer;
  aParam: TParamObject;
begin
  inherited;
  aRowIndex := FGridItem.RowIndex;
  if (aRowIndex < FGridItem.GetFirstRow) or (aRowIndex > FGridItem.GetLastRow) then
    Exit;

  aVchType := FGridItem.GetCellValue('VchType', aRowIndex);
  aVchCode := FGridItem.GetCellValue('VchCode', aRowIndex);

  OpenBillFrm(aVchType, aVchCode, bosEdit);
end;

function TfrmReportOrder.GetQryParam(AParam: TParamObject): Boolean;
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

initialization
  gFormManage.RegForm(TfrmReportOrder, fnMdlReportOrderBuy);
  gFormManage.RegForm(TfrmReportOrder, fnMdlReportOrderSale);
  
end.
