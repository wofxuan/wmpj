unit uFrmStockGoodsIni;  //定义基本信息表格的相关数据

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uFrmMDI, ComCtrls, cxStyles, cxCustomData, cxGraphics, cxFilter,
  cxData, cxDataStorage, cxEdit, dxBar, dxBarExtItems, cxClasses, ImgList,
  ActnList, DB, DBClient, cxGridLevel, cxControls, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGrid, cxContainer, cxTreeView,
  ExtCtrls, uModelStockGoodsInf, uParamObject, StdCtrls;

type
  TfrmStockGoodsIni = class(TfrmMDI)
    btnModifyIni: TdxBarLargeButton;
    actModify: TAction;
    actSelectKType: TAction;
    btnSelectKType: TdxBarLargeButton;
    lblKType: TLabel;
    procedure actModifyExecute(Sender: TObject);
    procedure gridTVMainShowCellDblClick(Sender: TcxCustomGridTableView;
      ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton;
      AShift: TShiftState; var AHandled: Boolean);
    procedure actSelectKTypeExecute(Sender: TObject);
  private
    FModelStockGoods: IModelStockGoods;
    { Private declarations }
    procedure InitParamList; override;
    procedure BeforeFormShow; override;
    procedure IniGridField; override;
    procedure LoadGridData(ATypeid: string); override;
    function GetCurTypeId: string;          //获取当前表格选中行的ID
    function ModifyRecPTypeIni: Boolean;
  public
    { Public declarations }
    class function GetMdlDisName: string; override; 
  end;

var
  frmStockGoodsIni: TfrmStockGoodsIni;

implementation

uses uBaseFormPlugin, uSysSvc, uDBIntf, uGridConfig, uMoudleNoDef, uBaseInfoDef, uFactoryFormIntf,
     uModelControlIntf, uPubFun, uDefCom, uFrmStockGoodsModifyIni, uModelFunIntf;
{$R *.dfm}

{ TfrmMDI1 }

procedure TfrmStockGoodsIni.BeforeFormShow;
begin
  inherited;
  Title := '期初库存商品';
  FModelStockGoods := IModelStockGoods((SysService as IModelControl).GetModelIntf(IModelStockGoods));
  IniGridField();
  LoadGridData('');
end;

class function TfrmStockGoodsIni.GetMdlDisName: string;
begin
  Result := '期初库存商品';
end;

procedure TfrmStockGoodsIni.IniGridField;
var
  aCol: TColInfo;
begin
  inherited;
  FGridItem.ClearField();
  FGridItem.AddField(btPtype);
  FGridItem.AddField('Qty', '库存数量', 200, cfQty);
  FGridItem.AddField('Price', '成本均价', 200, cfPrice);
  FGridItem.AddField('Total', '库存金额', 200, cfTotal);
  FGridItem.InitGridData;
  FGridItem.BasicType := btPtype;
end;

procedure TfrmStockGoodsIni.InitParamList;
begin
  inherited;
  MoudleNo := fnMdlStockGoodsIni;
end;

procedure TfrmStockGoodsIni.LoadGridData(ATypeid: string);
var
  aList: TParamObject;
begin
  inherited;
  aList := TParamObject.Create;
  try
    aList.Add('@ParPTypeId', ATypeid);
    aList.Add('@KTypeId', '');
    aList.Add('@Operator', OperatorID);
    FModelStockGoods.LoadStockGoodsIni(aList, cdsMainShow);
    FGridItem.LoadData(cdsMainShow);
  finally
    aList.Free;
  end;
end;

function TfrmStockGoodsIni.GetCurTypeId: string;
var
  aRowIndex: Integer;
begin
  Result := '';
  aRowIndex := FGridItem.RowIndex;
  if (aRowIndex < FGridItem.GetFirstRow) or (aRowIndex > FGridItem.GetLastRow) then
    Exit;

  Result := FGridItem.GetCellValue(GetBaseTypeid(btPtype), aRowIndex);
end;

function TfrmStockGoodsIni.ModifyRecPTypeIni: Boolean;
var
  aParam: TParamObject;
  aFrm: IFormIntf;
  aRowIndex: Integer;
  aKTypeId: string;
begin
  Result := False;
  aKTypeId := Trim(ParamList.AsString('KTypeId'));
  if StringEmpty(aKTypeId) or (aKTypeId = ROOT_ID)  then
  begin
    FModelFun.ShowMsgBox('现在为所有仓库合计值,请先选择某一仓库！','提示');
    Exit;
  end;
  
  aParam := TParamObject.Create;
  try
    aRowIndex := FGridItem.RowIndex;
    if (aRowIndex < FGridItem.GetFirstRow) or (aRowIndex > FGridItem.GetLastRow) then
      Exit;

    aParam.Add('PTypeId', FGridItem.GetCellValue(GetBaseTypeid(btPtype), aRowIndex));
    aParam.Add('KTypeId', aKTypeId);
    aParam.Add('Qty', FGridItem.GetCellValue('Qty', aRowIndex));
    aParam.Add('Price', FGridItem.GetCellValue('Price', aRowIndex));
    aParam.Add('Total', FGridItem.GetCellValue('Total', aRowIndex));

    TfrmStockGoodsModifyIni.CreateFrmParamList(Self, aParam).GetInterface(IFormIntf, aFrm);
    if aFrm.FrmShowModal = mrOk then
    begin
      Result := True;
      LoadGridData('');
    end;
  finally
    aParam.Free;
  end;
end;

procedure TfrmStockGoodsIni.actModifyExecute(Sender: TObject);
begin
  inherited;
  ModifyRecPTypeIni();
end;

procedure TfrmStockGoodsIni.gridTVMainShowCellDblClick(
  Sender: TcxCustomGridTableView;
  ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton;
  AShift: TShiftState; var AHandled: Boolean);
begin
  inherited;
  ModifyRecPTypeIni();
end;

procedure TfrmStockGoodsIni.actSelectKTypeExecute(Sender: TObject);
var
  aSelectParam: TSelectBasicParam;
  aSelectOptions: TSelectBasicOptions;
  aReturnArray: TSelectBasicDatas;
  aReturnCount: Integer;
begin
  inherited;
  DoSelectBasic(Self, btKtype, aSelectParam, aSelectOptions, aReturnArray, aReturnCount);
  if aReturnCount >= 1 then
  begin
    ParamList.Add('KTypeId', aReturnArray[0].TypeId);
    lblKType.Caption := '仓库：' + aReturnArray[0].FullName;
  end;
end;

initialization
  gFormManage.RegForm(TfrmStockGoodsIni, fnMdlStockGoodsIni);

end.
