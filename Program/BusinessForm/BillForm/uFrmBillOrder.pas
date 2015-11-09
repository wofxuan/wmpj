unit uFrmBillOrder;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uFrmMDIBill, ComCtrls, cxStyles, cxCustomData, cxGraphics,
  cxFilter, cxData, cxDataStorage, cxEdit, dxBar, dxBarExtItems, cxClasses,
  ImgList, ActnList, DB, DBClient, cxGridLevel, cxControls,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGrid,
  cxContainer, cxTreeView, ExtCtrls, cxDropDownEdit, cxCalendar,
  cxTextEdit, cxMaskEdit, cxButtonEdit, cxLabel, uBillData, uPackData;

type
  TfrmBillOrder = class(TfrmMDIBill)
    lblBtype: TcxLabel;
    edtBtype: TcxButtonEdit;
    lbl2: TcxLabel;
    edtEtype: TcxButtonEdit;
    lbl3: TcxLabel;
    edtDtype: TcxButtonEdit;
    lbl4: TcxLabel;
    deGatheringDate: TcxDateEdit;
    lblKtype: TcxLabel;
    edtKtype: TcxButtonEdit;
    lbl6: TcxLabel;
    edtSummary: TcxButtonEdit;
    lbl7: TcxLabel;
    edtComment: TcxButtonEdit;
  private
    { Private declarations }
    procedure BeforeFormShow; override;

    procedure InitMasterTitles(Sender: TObject); override;
    procedure InitGrids(Sender: TObject); override;

    function SaveToSettle: Boolean; override;
    function SaveMasterData(const ABillMasterData: TBillData): Integer; override;
    function SaveDetailData(const ABillDetailData: TPackData): Integer; override;
    function SaveDetailAccount(const ADetailAccountData: TPackData): integer; override; 
  public
    { Public declarations }
  end;

var
  frmBillOrder: TfrmBillOrder;

implementation

uses uSysSvc, uBaseFormPlugin, uMoudleNoDef, uParamObject, uModelControlIntf,
     uBaseInfoDef, uDefCom, uGridConfig, uFrmApp, uModelBillIntf, uVchTypeDef;

{$R *.dfm}

{ TfrmBillOrder }

procedure TfrmBillOrder.BeforeFormShow;
begin
  FModelBill := IModelBillOrder((SysService as IModelControl).GetModelIntf(IModelBillOrder));
  inherited;
end;

procedure TfrmBillOrder.InitGrids(Sender: TObject);
begin
  inherited;
  FGridItem.ClearField();
  FGridItem.AddFiled('PTypeId', 'PTypeId', -1);
  FGridItem.AddFiled('PFullname', '商品名称');
  FGridItem.AddFiled('PUsercode', '商品编码');
  FGridItem.AddFiled('Unit', '单位');
  FGridItem.AddFiled('Unit', '单位');
  FGridItem.InitGridData;
end;

procedure TfrmBillOrder.InitMasterTitles(Sender: TObject);
begin
  inherited;
  MoudleNo := FVchType;

  case FVchType of
    VchType_Order_Buy:
      begin
        BillTitle := '进货订单';
        lblBtype.Caption := '供货单位';
        lblKtype.Caption := '收货仓库';
      end;
    VchType_Order_Sale:
      begin
        BillTitle := '销售订单';
        lblBtype.Caption := '购买单位';
        lblKtype.Caption := '发货仓库';
      end;
  end;
end;

function TfrmBillOrder.SaveDetailAccount(
  const ADetailAccountData: TPackData): integer;
begin

end;

function TfrmBillOrder.SaveDetailData(
  const ABillDetailData: TPackData): Integer;
var
  aPackData: TParamObject;
begin
  ABillDetailData.ProcName := 'pbx_Bill_Is_Order_D';
  aPackData := ABillDetailData.AddChild();
  aPackData.Add('@ColRowNo', '1');
  aPackData.Add('@AtypeId', '0000100001');
  aPackData.Add('@BtypeId', '00000');
  aPackData.Add('@EtypeId', '00000');
  aPackData.Add('@DtypeId', '00000');
  aPackData.Add('@KtypeId', '00000');
  aPackData.Add('@KtypeId2', '00000');
  aPackData.Add('@PtypeId', '00000' );
  aPackData.Add('@CostMode', 1);
  aPackData.Add('@UnitRate', 1);
  aPackData.Add('@Unit', 1);
  aPackData.Add('@Blockno', '');
  aPackData.Add('@Prodate', '');
  aPackData.Add('@UsefulEndDate', '');
  aPackData.Add('@Jhdate', '');
  aPackData.Add('@GoodsNo', '1');
  aPackData.Add('@Qty', 5);
  aPackData.Add('@Price', 6);
  aPackData.Add('@Total', 30);
  aPackData.Add('@Discount', 1);
  aPackData.Add('@DiscountPrice', 2);
  aPackData.Add('@DiscountTotal', 3);
  aPackData.Add('@TaxRate', 1);
  aPackData.Add('@TaxPrice', 1);
  aPackData.Add('@TaxTotal', 2);
  aPackData.Add('@AssQty', 2);
  aPackData.Add('@AssPrice', 3);
  aPackData.Add('@AssDiscountPrice', 2);
  aPackData.Add('@AssTaxPrice', 1);
  aPackData.Add('@CostTotal', 2);
  aPackData.Add('@CostPrice', 3);
  aPackData.Add('@OrderCode', 4);
  aPackData.Add('@OrderDlyCode', 1);
  aPackData.Add('@OrderVchType', 3);
  aPackData.Add('@Comment', 'ssss');
  aPackData.Add('@InputDate', FormatDateTime('YYYY-MM-DD', deBillDate.Date));
  aPackData.Add('@Usedtype', '1');
  aPackData.Add('@Period', 0);
  aPackData.Add('@PStatus', 1);
  aPackData.Add('@YearPeriod', 1);
//  with gridTVMainShow do
//  begin
//    for I := 0 to DataRowCount - 1 do
//    begin
//      if (TypeId[btPtype, I] = '') then Continue;
//      aPackData := DlyPackData.addChild;
//    end
//  end;
end;

function TfrmBillOrder.SaveMasterData(
  const ABillMasterData: TBillData): Integer;
begin
  ABillMasterData.ProcName := 'pbx_Bill_Is_Order_M';
  ABillMasterData.Add('@InputDate', FormatDateTime('YYYY-MM-DD', deBillDate.Date));
  ABillMasterData.Add('@Number', edtBillNumber.Text);
  ABillMasterData.Add('@VchType', FVchType);
  ABillMasterData.Add('@Summary', 'sss');
  ABillMasterData.Add('@Comment', 'wwww');
  ABillMasterData.Add('@Btypeid', '00000');
  ABillMasterData.Add('@Etypeid', '00000');
  ABillMasterData.Add('@Dtypeid', '00000');
  ABillMasterData.Add('@Ktypeid', '00000');
  ABillMasterData.Add('@Ktypeid2', '00000');
  ABillMasterData.Add('@Period', 1);
  ABillMasterData.Add('@YearPeriod', 1);
  ABillMasterData.Add('@Total', 11);
  ABillMasterData.Add('@RedWord', 'F');
  ABillMasterData.Add('@Defdiscount', 1);
  ABillMasterData.Add('@GatheringDate', '5015-09-08');
end;

function TfrmBillOrder.SaveToSettle: Boolean;
var
  aBillData: TBillData;
  aOutPutData: TParamObject;
  aNewVchcode: Integer;
begin
  Result := False;
  aBillData := TBillData.Create;
  aOutPutData := TParamObject.Create;
  try
    aBillData.PRODUCT_TRADE := 0;
    aBillData.Draft := Ord(soSettle);
    aBillData.IsModi := false;
    aBillData.VchCode := FVchcode;
    aBillData.VchType := FVchtype;

    SaveMasterData(aBillData);
    SaveDetailData(aBillData.DetailData);
    SaveDetailAccount(aBillData.AccountData);
    aNewVchcode := FModelBill.SaveBill(aBillData, aOutPutData);
    if aNewVchcode >= 0 then
    begin
      FModelBill.BillCreate(0, aBillData.Draft, FVchType, aNewVchcode, aBillData.VchCode, aOutPutData);
    end;
  finally
    aOutPutData.Free;
    aBillData.Free;
  end;
end;

initialization
  gFormManage.RegForm(TfrmBillOrder, fnMdlBillOrderBuy);
  gFormManage.RegForm(TfrmBillOrder, fnMdlBillOrderSale);

end.
