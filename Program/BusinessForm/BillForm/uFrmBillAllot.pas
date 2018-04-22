unit uFrmBillAllot;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uFrmMDIBill, ComCtrls, cxStyles, cxCustomData, cxGraphics,
  cxFilter, cxData, cxDataStorage, cxEdit, dxBar, dxBarExtItems, cxClasses,
  ImgList, ActnList, DB, DBClient, cxGridLevel, cxControls,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGrid,
  cxContainer, cxTreeView, ExtCtrls, cxDropDownEdit, cxCalendar,
  cxTextEdit, cxMaskEdit, cxButtonEdit, cxLabel, uBillData, uPackData, uBaseInfoDef,
  uModelFunIntf;

type
  TfrmBillAllot = class(TfrmMDIBill)
    lblKtype: TcxLabel;
    edtKtype: TcxButtonEdit;
    lbl2: TcxLabel;
    edtEtype: TcxButtonEdit;
    lbl3: TcxLabel;
    edtDtype: TcxButtonEdit;
    lblKtype2: TcxLabel;
    edtKtype2: TcxButtonEdit;
    lbl6: TcxLabel;
    edtSummary: TcxButtonEdit;
    lbl7: TcxLabel;
    edtComment: TcxButtonEdit;
  private
    { Private declarations }
    procedure BeforeFormShow; override;
    procedure InitParamList; override;

    procedure InitMasterTitles(Sender: TObject); override;
    procedure InitGrids(Sender: TObject); override;

    function LoadBillDataGrid: Boolean; override;

    function SaveMasterData(const ABillMasterData: TBillData): Integer; override;
    function SaveDetailData(const ABillDetailData: TPackData): Integer; override;
    function SaveDetailAccount(const ADetailAccountData: TPackData): integer; override;
    function LoadPtype(ABasicDatas: TSelectBasicDatas): Boolean;
    function LoadOnePtype(ARow: Integer; AData: TSelectBasicData; IsImport: Boolean = False): Boolean; override;
  protected
    procedure DoSelectBasic(Sender: TObject; ABasicType: TBasicType;
      ASelectBasicParam: TSelectBasicParam;
      ASelectOptions: TSelectBasicOptions; var ABasicDatas: TSelectBasicDatas;
      var AReturnCount: Integer); override;
  public
    { Public declarations }
  end;

var
  frmBillAllot: TfrmBillAllot;

implementation

uses uSysSvc, uBaseFormPlugin, uMoudleNoDef, uParamObject, uModelControlIntf,
     uDefCom, uGridConfig, uFrmApp, uModelBillIntf, uVchTypeDef, uPubFun;

{$R *.dfm}

{ TfrmBillOrder }

procedure TfrmBillAllot.BeforeFormShow;
begin
  FModelBill := IModelBillAllot((SysService as IModelControl).GetModelIntf(IModelBillAllot));
  inherited;
end;

procedure TfrmBillAllot.DoSelectBasic(Sender: TObject;
  ABasicType: TBasicType; ASelectBasicParam: TSelectBasicParam;
  ASelectOptions: TSelectBasicOptions; var ABasicDatas: TSelectBasicDatas;
  var AReturnCount: Integer);
begin
  if  Sender = gridMainShow then
  begin
    ASelectOptions := ASelectOptions + [opMultiSelect]
  end;
  inherited;
  if  Sender = gridMainShow then
  begin
    if AReturnCount >= 1 then
    begin
      if ABasicType = btPtype then
      begin
        LoadPtype(ABasicDatas);
      end
    end;
  end;
end;

procedure TfrmBillAllot.InitGrids(Sender: TObject);
begin
  inherited;
  FGridItem.ClearField();
  FGridItem.AddField(btPtype);

  FGridItem.AddField('Qty', '数量', 100, cfQty);
  FGridItem.AddField('Price', '单价', 100, cfPrice);
  FGridItem.AddField('Total', '金额', 100, cfTotal);
  FGridItem.AddField('Comment', '备注');

  SetQtyPriceTotal('Total', 'Qty', 'Price');
  FGridItem.InitGridData;
end;

procedure TfrmBillAllot.InitMasterTitles(Sender: TObject);
begin
  inherited;
  Title := '调拨单';

  DBComItem.AddItem(deBillDate, 'InputDate');
  DBComItem.AddItem(edtBillNumber, 'Number');

  DBComItem.AddItem(edtKtype, 'KTypeId', 'KTypeId', 'KUsercode', btKtype);
  DBComItem.AddItem(edtEtype, 'ETypeId', 'ETypeId', 'EUsercode', btEtype);
  DBComItem.AddItem(edtDtype, 'DTypeId', 'DTypeId', 'DUsercode', btDtype);
  DBComItem.AddItem(edtKtype2, 'KTypeId2', 'KTypeId2', 'KUsercode', btKtype);

  DBComItem.AddItem(edtSummary, 'Summary');
  DBComItem.AddItem(edtComment, 'Comment');
end;

procedure TfrmBillAllot.InitParamList;
begin
  inherited;
  MoudleNo := fnMdlBillAllot;
end;

function TfrmBillAllot.LoadBillDataGrid: Boolean;
var
  szSql, szTemp: string;
begin
  inherited LoadBillDataGrid;
end;

function TfrmBillAllot.LoadOnePtype(ARow: Integer; AData: TSelectBasicData;
  IsImport: Boolean): Boolean;
begin
  FGridItem.SetCellValue(GetBaseTypeid(btPtype), ARow, AData.TypeId);
  FGridItem.SetCellValue(GetBaseTypeFullName(btPtype), ARow, AData.FullName);
  FGridItem.SetCellValue(GetBaseTypeUsercode(btPtype), ARow, AData.Usercode);
end;

function TfrmBillAllot.LoadPtype(ABasicDatas: TSelectBasicDatas): Boolean;
var
  i, j: Integer;
  s: string;
begin
  for i := 0 to Length(ABasicDatas) - 1 do
  begin
    if i = 0 then
    begin
      LoadOnePtype(FGridItem.RowIndex, ABasicDatas[i]);
    end
    else
    begin
      for j := FGridItem.RowIndex + 1 to FGridItem.GetLastRow - 1 do
      begin
        if StringEmpty(FGridItem.GetCellValue(GetBaseTypeid(btPtype), j)) then Break;
      end;
      if j >= FGridItem.GetLastRow then exit;
      LoadOnePtype(j, ABasicDatas[i])
    end;
  end;
end;

function TfrmBillAllot.SaveDetailAccount(
  const ADetailAccountData: TPackData): integer;
begin

end;

function TfrmBillAllot.SaveDetailData(
  const ABillDetailData: TPackData): Integer;
var
  aPackData: TParamObject;
  aRow: Integer;
  aPrice, aTotal, aQty: Extended;
begin
  ABillDetailData.ProcName := 'pbx_Bill_Is_Allot_D';
  for aRow := FGridItem.GetFirstRow to FGridItem.GetLastRow do
  begin
    if StringEmpty(FGridItem.GetCellValue(GetBaseTypeid(btPtype), aRow)) then Continue;

    aQty := FGridItem.GetCellValue('Qty', aRow);
    aPrice := FGridItem.GetCellValue('Price', aRow);
    aTotal := FGridItem.GetCellValue('Total', aRow);
    
    aPackData := ABillDetailData.AddChild();
    aPackData.Add('@ColRowNo', IntToStr(aRow + 1));
    aPackData.Add('@AtypeId', '0000100001');
    aPackData.Add('@BtypeId', '');
    aPackData.Add('@EtypeId', DBComItem.GetItemValue(edtEtype));
    aPackData.Add('@DtypeId', DBComItem.GetItemValue(edtDtype));
    aPackData.Add('@KtypeId', DBComItem.GetItemValue(edtKtype));
    aPackData.Add('@KtypeId2', DBComItem.GetItemValue(edtKtype2));
    aPackData.Add('@PtypeId', FGridItem.GetCellValue(GetBaseTypeid(btPtype), aRow));
    aPackData.Add('@CostMode', 0);
    aPackData.Add('@UnitRate', 1);
    aPackData.Add('@Unit', 0);
    aPackData.Add('@Blockno', '');
    aPackData.Add('@Prodate', '');
    aPackData.Add('@UsefulEndDate', '');
    aPackData.Add('@Jhdate', '');
    aPackData.Add('@GoodsNo', 0);
    aPackData.Add('@Qty', aQty);
    aPackData.Add('@Price', aPrice);
    aPackData.Add('@Total', aTotal);
    aPackData.Add('@Discount', 1);
    aPackData.Add('@DiscountPrice', aPrice);
    aPackData.Add('@DiscountTotal', aTotal);
    aPackData.Add('@TaxRate', 1);
    aPackData.Add('@TaxPrice', aPrice);
    aPackData.Add('@TaxTotal', aTotal);
    aPackData.Add('@AssQty', aQty);
    aPackData.Add('@AssPrice', aPrice);
    aPackData.Add('@AssDiscountPrice', aPrice);
    aPackData.Add('@AssTaxPrice', aPrice);
    aPackData.Add('@CostTotal', aTotal);
    aPackData.Add('@CostPrice', aPrice);
    aPackData.Add('@OrderCode', 0);
    aPackData.Add('@OrderDlyCode', 0);
    aPackData.Add('@OrderVchType', 0);
    aPackData.Add('@Comment', FGridItem.GetCellValue('Comment', aRow));   
    aPackData.Add('@InputDate', FormatDateTime('YYYY-MM-DD', deBillDate.Date));
    aPackData.Add('@Usedtype', '1');
    aPackData.Add('@Period', 1);
    aPackData.Add('@PStatus', 0);
    aPackData.Add('@YearPeriod', 1);
  end;
end;

function TfrmBillAllot.SaveMasterData(
  const ABillMasterData: TBillData): Integer;
begin
  ABillMasterData.ProcName := 'pbx_Bill_Is_Allot_M';
  ABillMasterData.Add('@InputDate', FormatDateTime('YYYY-MM-DD', deBillDate.Date));
  ABillMasterData.Add('@Number', DBComItem.GetItemValue(edtBillNumber));
  ABillMasterData.Add('@VchType', FVchType);
  ABillMasterData.Add('@Summary', DBComItem.GetItemValue(edtSummary));
  ABillMasterData.Add('@Comment', DBComItem.GetItemValue(edtComment));
  ABillMasterData.Add('@Btypeid', '');
  ABillMasterData.Add('@Etypeid', DBComItem.GetItemValue(edtEtype));
  ABillMasterData.Add('@Dtypeid', DBComItem.GetItemValue(edtDtype));
  ABillMasterData.Add('@Ktypeid', DBComItem.GetItemValue(edtKtype));
  ABillMasterData.Add('@Ktypeid2', DBComItem.GetItemValue(edtKtype2));
  ABillMasterData.Add('@Period', 1);
  ABillMasterData.Add('@YearPeriod', 1);
  ABillMasterData.Add('@Total', 0);
  ABillMasterData.Add('@RedWord', 'F');
  ABillMasterData.Add('@Defdiscount', 1);
  ABillMasterData.Add('@GatheringDate', '');
end;

initialization
  gFormManage.RegForm(TfrmBillAllot, fnMdlBillAllot);

end.
