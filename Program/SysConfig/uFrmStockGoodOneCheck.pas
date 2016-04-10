unit uFrmStockGoodOneCheck;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uFrmDialog, Menus, cxLookAndFeelPainters, ActnList, cxControls,
  cxContainer, cxEdit, cxLabel, StdCtrls, cxButtons, ExtCtrls, cxTextEdit,
  cxMaskEdit, cxDropDownEdit, cxCalendar, cxButtonEdit, uModelFunIntf, uBaseInfoDef,
  uModelStockGoodsInf, uParamObject;

type
  TfrmStockGoodOneCheck = class(TfrmDialog)
    deCheckDate: TcxDateEdit;
    lbl1: TLabel;
    edtKType: TcxButtonEdit;
    lbl2: TLabel;
    btnNew: TcxButton;
    procedure actOKExecute(Sender: TObject);
  private
    { Private declarations }
    FModelStockGoods: IModelStockGoods;
    
    procedure BeforeFormShow; override;
    function OneCheck(AKTypeId, ACheckDate: string): Boolean;
  public
    { Public declarations }
    procedure DoSelectBasic(Sender: TObject; ABasicType: TBasicType;
      ASelectBasicParam: TSelectBasicParam;
      ASelectOptions: TSelectBasicOptions; var ABasicDatas: TSelectBasicDatas;
      var AReturnCount: Integer); override;
  end;

var
  frmStockGoodOneCheck: TfrmStockGoodOneCheck;

implementation

uses uBaseFormPlugin, uSysSvc, uDBIntf, uGridConfig, uMoudleNoDef, uFactoryFormIntf,
     uModelControlIntf, uFrmBaseTbxCheckDef, uPubFun, uDefCom, uOtherIntf;
     
{$R *.dfm}

procedure TfrmStockGoodOneCheck.actOKExecute(Sender: TObject);
begin
  inherited;
  if StringEmpty(DBComItem.GetItemValue(edtKType)) then
  begin
    (SysService as IMsgBox).MsgBox('请先选择一个仓库！');
    Exit;
  end;
  if OneCheck(DBComItem.GetItemValue(edtKType), DBComItem.GetItemValue(deCheckDate)) then
    ModalResult := mrOk;
end;

procedure TfrmStockGoodOneCheck.BeforeFormShow;
begin
  inherited;
  Title := '盘点选项';

  DBComItem.AddItem(deCheckDate, 'CheckDate');
  DBComItem.AddItem(edtKType, 'KTypeId', 'KTypeId', 'KUsercode', btKtype);
  DBComItem.ClearItemData();

  btnNew.Enabled := False;
  
  FModelStockGoods := IModelStockGoods((SysService as IModelControl).GetModelIntf(IModelStockGoods));
end;

procedure TfrmStockGoodOneCheck.DoSelectBasic(Sender: TObject;
  ABasicType: TBasicType; ASelectBasicParam: TSelectBasicParam;
  ASelectOptions: TSelectBasicOptions; var ABasicDatas: TSelectBasicDatas;
  var AReturnCount: Integer);
begin
  inherited;
  if  Sender = edtKType then
  begin
    if AReturnCount >= 1 then
    begin
      if ABasicType = btKtype then
      begin
        OneCheck(ABasicDatas[0].TypeId, '');
      end
    end;
  end;
end;

function TfrmStockGoodOneCheck.OneCheck(AKTypeId, ACheckDate: string): Boolean;
var
  aList: TParamObject;
begin
  inherited;
  Result := False;
  aList := TParamObject.Create;
  try
    aList.Add('@KTypeId', AKTypeId);
    aList.Add('@ETypeid', OperatorID);
    aList.Add('@CheckDate', ACheckDate);
    aList.Add('@Updatetag', 0); 

    if FModelStockGoods.P_OneCheck(aList) = 0 then
    begin
      if StringEmpty(ACheckDate) then
      begin
        if aList.AsString('@CheckDate') <> EmptyStr then
        begin
          deCheckDate.Text := aList.AsString('@CheckDate');
          deCheckDate.Enabled := False;
          btnNew.Enabled := True;
        end
        else
        begin
          deCheckDate.Date := Trunc(Now);
          deCheckDate.Enabled := True;
          btnNew.Enabled := False;
        end;
      end;
      ParamList.Add('Updatetag', aList.AsInteger('@Updatetag'));
      ParamList.Add('CheckDate', aList.AsString('@CheckDate'));
      ParamList.Add('KTypeId', aList.AsString('@KTypeId'));

      Result := True;
    end;
  finally
    aList.Free;
  end;
end;

end.
