unit uFrmStockGoodsModifyIni;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uFrmDialog, Menus, cxLookAndFeelPainters, ActnList, cxControls,
  cxContainer, cxEdit, cxLabel, StdCtrls, cxButtons, ExtCtrls, cxTextEdit,
  cxMaskEdit, cxButtonEdit, uModelStockGoodsIntf, uParamObject;

type
  TfrmStockGoodsModifyIni = class(TfrmDialog)
    lbl1: TcxLabel;
    lbl3: TcxLabel;
    lbl2: TcxLabel;
    edtQty: TcxButtonEdit;
    edtPrice: TcxButtonEdit;
    edtTotal: TcxButtonEdit;
    procedure actOKExecute(Sender: TObject);
  private
    { Private declarations }
    FModelStockGoods: IModelStockGoods;
    
    procedure BeforeFormShow; override;
    procedure IniData; override;
  public
    { Public declarations }
  end;

var
  frmStockGoodsModifyIni: TfrmStockGoodsModifyIni;

implementation

uses uBaseFormPlugin, uSysSvc, uDBIntf, uGridConfig, uMoudleNoDef, uBaseInfoDef, uFactoryFormIntf,
     uModelControlIntf, uFrmBaseTbxCheckDef, uPubFun, uDefCom;
     
{$R *.dfm}

{ TfrmDialog1 }

procedure TfrmStockGoodsModifyIni.BeforeFormShow;
begin
  inherited;
  Title := '期初库存商品录入';
  FModelStockGoods := IModelStockGoods((SysService as IModelControl).GetModelIntf(IModelStockGoods));
  IniData();
end;

procedure TfrmStockGoodsModifyIni.IniData;
begin
  inherited;
  edtQty.Text := ParamList.AsString('Qty');
  edtPrice.Text := ParamList.AsString('Price');
  edtTotal.Text := ParamList.AsString('Total');
end;

procedure TfrmStockGoodsModifyIni.actOKExecute(Sender: TObject);
var
  aList: TParamObject;
begin
  inherited;
  aList := TParamObject.Create;
  try
    aList.Add('@PTypeId', ParamList.AsString('PTypeId'));
    aList.Add('@KTypeId', ParamList.AsString('KTypeId'));
    aList.Add('@Qty', edtQty.Text);
    aList.Add('@Total', edtTotal.Text);
    aList.Add('@Memo', '');
    aList.Add('@JobNumber', '');

    if FModelStockGoods.ModifyOneRec(aList) = 0 then
    begin
      ModalResult := mrOk;
    end;
  finally
    aList.Free;
  end;
end;

end.
