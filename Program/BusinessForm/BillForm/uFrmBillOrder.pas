unit uFrmBillOrder;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uFrmMDIBill, ComCtrls, cxStyles, cxCustomData, cxGraphics,
  cxFilter, cxData, cxDataStorage, cxEdit, dxBar, dxBarExtItems, cxClasses,
  ImgList, ActnList, DB, DBClient, cxGridLevel, cxControls,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGrid,
  cxContainer, cxTreeView, ExtCtrls, cxDropDownEdit, cxCalendar,
  cxTextEdit, cxMaskEdit, cxButtonEdit, cxLabel;

type
  TfrmBillOrder = class(TfrmMDIBill)
  private
    { Private declarations }
    procedure InitMasterTitles(Sender: TObject); override;
    procedure InitGrids(Sender: TObject); override;
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

end;

initialization
  gFormManage.RegForm(TfrmBillOrder, fnMdlBillOrder);

end.
