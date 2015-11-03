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
  private
    { Private declarations }
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
     uBaseInfoDef, uDefCom, uGridConfig, uFrmApp;

{$R *.dfm}

{ TfrmBillOrder }

procedure TfrmBillOrder.InitGrids(Sender: TObject);
begin
  inherited;
  FGridItem.ClearField();
  FGridItem.AddFiled('PTypeId', 'PTypeId', -1);
  FGridItem.AddFiled('PFullname', '商品名称', 200);
  FGridItem.AddFiled('PUsercode', '商品编码', 200);
  FGridItem.AddFiled('uni', '单位', 200);
  FGridItem.InitGridData;
end;

procedure TfrmBillOrder.InitMasterTitles(Sender: TObject);
begin
  inherited;
  FVchcode := 0;
  FVchtype := 7;
end;

function TfrmBillOrder.SaveDetailAccount(
  const ADetailAccountData: TPackData): integer;
begin

end;

function TfrmBillOrder.SaveDetailData(
  const ABillDetailData: TPackData): Integer;
begin

end;

function TfrmBillOrder.SaveMasterData(
  const ABillMasterData: TBillData): Integer;
begin

end;

function TfrmBillOrder.SaveToSettle: Boolean;
var
  aBillData: TBillData;
  aOutPutData: TPackData;
begin
  Result := False;
  aBillData := TBillData.Create;
  aOutPutData := TPackData.Create;
  try
    aBillData.PRODUCT_TRADE := 0;
    aBillData.Draft := Ord(soSettle);
    aBillData.isModi := false;
    aBillData.vchCode := FVchcode;
    aBillData.vchType := FVchtype;

    SaveMasterData(aBillData);
    SaveDetailData(aBillData.DetailData);
    SaveDetailAccount(aBillData.AccountData);

  finally
    aOutPutData.Free;
    aBillData.Free;
  end;
end;

initialization
  gFormManage.RegForm(TfrmBillOrder, fnMdlBillOrder);

end.
