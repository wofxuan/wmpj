unit uFrmSelectBill;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uFrmDialog, Menus, cxLookAndFeelPainters, ActnList, cxControls,
  cxContainer, cxEdit, cxLabel, StdCtrls, cxButtons, ExtCtrls, cxStyles,
  cxCustomData, cxGraphics, cxFilter, cxData, cxDataStorage, cxGridLevel,
  cxClasses, cxGridCustomView, cxGridCustomTableView, cxGridTableView,
  cxGrid, uGridConfig, uDBIntf, uModelFunIntf, uBaseInfoDef,
  DBClient, uModelBaseIntf, uParamObject, DB;

type
  TfrmSelectBill = class(TfrmDialog)
    pnlMaster: TPanel;
    gridMaster: TcxGrid;
    gridTVMaster: TcxGridTableView;
    gridLVMaster: TcxGridLevel;
    pnlDetail: TPanel;
    gridDetail: TcxGrid;
    gridTVDetail: TcxGridTableView;
    gridLVDetail: TcxGridLevel;
    cdsMaster: TClientDataSet;
    cdsDetail: TClientDataSet;
    procedure gridTVMasterCellClick(Sender: TcxCustomGridTableView;
      ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton;
      AShift: TShiftState; var AHandled: Boolean);
    procedure actOKExecute(Sender: TObject);
  private
    { Private declarations }
    FGridMaster, FGridDetail: TGridItem;
    FDBAC: IDBAccess;
    FModelFun: IModelFun;
    FType: Integer;

    FBillMaster: TParamObject;
    FBillDetail: TClientDataSet;
    
    procedure BeforeFormShow; override;
    procedure BeforeFormDestroy; override;
    procedure InitParamList; override;

    procedure IniView; override;
    procedure IniGridField;
    procedure LoadGridData;
    procedure LoadGridFieldDetail;
  public
    { Public declarations }
  published
    property BillMaster: TParamObject read FBillMaster write FBillMaster;
    property BillDetail: TClientDataSet read FBillDetail write FBillDetail;
    
  end;

function SelectBill(AInParam: TParamObject; ABillMaster: TParamObject; ABillDetail: TClientDataSet): Boolean;

implementation

uses uSysSvc, uMoudleNoDef, uFrmApp, uDefCom, uMainFormIntf, uModelControlIntf,
      uModelBaseListIntf, uOtherIntf, uPubFun, uVchTypeDef, uModelReportIntf, uModelBillIntf;
      
{$R *.dfm}

function SelectBill(AInParam: TParamObject; ABillMaster: TParamObject; ABillDetail: TClientDataSet): Boolean;
var
  afrmSelectBill: TfrmSelectBill;
begin
  afrmSelectBill := TfrmSelectBill.CreateFrmParamList(nil, AInParam);
  try
    afrmSelectBill.BillMaster := ABillMaster;
    afrmSelectBill.BillDetail := ABillDetail;
     
    Result := afrmSelectBill.ShowModal = mrOk;
  finally
    afrmSelectBill.Free;
  end;
end;
{ TfrmSelectBill }

procedure TfrmSelectBill.BeforeFormDestroy;
begin
  inherited;
  FGridMaster.Free;
  FGridDetail.Free;
end;

procedure TfrmSelectBill.BeforeFormShow;
var
  aMoudleNoM, aMoudleNoD: Integer;
begin
  inherited;
  aMoudleNoM := 0;
  aMoudleNoD := 0;
  
  FGridMaster := TGridItem.Create(aMoudleNoM, gridMaster, gridTVMaster);
  FGridMaster.SetGoToNextCellOnEnter(False);

  FGridDetail := TGridItem.Create(aMoudleNoD, gridDetail, gridTVDetail);
  FGridDetail.SetGoToNextCellOnEnter(False);
  FGridDetail.SetGridCellSelect(True);
  FGridDetail.ShowMaxRow := False;

  FDBAC := SysService as IDBAccess;
  FModelFun := SysService as IModelFun;

  IniGridField();
  LoadGridData();
end;

procedure TfrmSelectBill.IniGridField;
begin
  FGridDetail.ClearField();
  FGridMaster.ClearField();
  if FType = VchType_Buy then
  begin
    FGridMaster.AddField(btVtype);
    FGridMaster.AddField('VchCode', 'VchCode', -1);
    FGridMaster.AddField('InputDate', '录单日期', 100, cfDate);
    FGridMaster.AddField('Savedate', '存盘时间', 100, cfDatime);
    FGridMaster.AddField('Number', '订单编号', 200, cfString);

    FGridDetail.MultiSelect(True);
    FGridDetail.AddCheckBoxCol('IsCheck', '选择', 1, 0);
    FGridDetail.AddField(btPtype, True);
    FGridDetail.AddField('Qty', '数量', 100, cfQty, True);
    FGridDetail.AddField('Price', '单价', 100, cfPrice, True);
    FGridDetail.AddField('Total', '金额', 100, cfTotal, True);
    FGridDetail.AddField('Comment', '备注', 100, cfString, True);
  end;
  FGridMaster.InitGridData;
  FGridDetail.InitGridData;
end;

procedure TfrmSelectBill.LoadGridFieldDetail;
var
  aDetailParam: TParamObject;
begin
  aDetailParam := TParamObject.Create;
  try
    if FType = VchType_Buy then
    begin
      aDetailParam.Add('VchCode', FGridMaster.GetCellValue('VchCode', FGridMaster.RowIndex));
      aDetailParam.Add('VchType', VchType_Order_Buy);
      aDetailParam.Add('BillState', Ord(bosView));
      IModelBillOrder((SysService as IModelControl).GetModelIntf(IModelBillOrder)).LoadBillDataDetail(aDetailParam, cdsDetail);
      FGridDetail.LoadData(cdsDetail);
    end;
  finally
    aDetailParam.Free;
  end;
end;

procedure TfrmSelectBill.InitParamList;
begin
  inherited;
  FType := ParamList.AsInteger('Type');
end;

procedure TfrmSelectBill.IniView;
begin
  inherited;
  if FType = VchType_Buy then
  begin
    Title := '选择进货订单';
  end;
end;

procedure TfrmSelectBill.LoadGridData;
var
  aQryParam: TParamObject;
begin
  aQryParam := TParamObject.Create;
  try
    if FType = VchType_Buy then
    begin
      aQryParam.Add('@VchType', VchType_Order_Buy);
      aQryParam.Add('@CMode', 'L');
      aQryParam.Add('@BeginDate', '');
      aQryParam.Add('@EndDate', '');
      aQryParam.Add('@TypeID', '');
      aQryParam.Add('@PTypeId', '');
      aQryParam.Add('@BTypeId', '');
      aQryParam.Add('@ETypeId', '');
      aQryParam.Add('@KTypeId', '');
      aQryParam.Add('@OperatorID', OperatorID);

      IModelReportOrderBuy((SysService as IModelControl).GetModelIntf(IModelReportOrderBuy)).LoadGridData(aQryParam, cdsMaster);
      FGridMaster.LoadData(cdsMaster);
      LoadGridFieldDetail();
    end;
  finally
    aQryParam.Free;
  end;
end;

procedure TfrmSelectBill.gridTVMasterCellClick(
  Sender: TcxCustomGridTableView;
  ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton;
  AShift: TShiftState; var AHandled: Boolean);
begin
  inherited;
  LoadGridFieldDetail();
end;

procedure TfrmSelectBill.actOKExecute(Sender: TObject);
var
  aRow: Integer;
begin
  inherited;
  if FType = VchType_Buy then
  begin

  end;
end;

end.
