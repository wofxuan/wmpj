unit uFrmStockGoodCheck;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uFrmMDI, cxStyles, cxCustomData, cxGraphics, cxFilter, cxData,
  cxDataStorage, cxEdit, dxBar, dxBarExtItems, cxClasses, ImgList,
  ActnList, DB, DBClient, cxGridLevel, cxControls, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGrid, ExtCtrls, uModelStockGoodsIntf,
  uModelFunIntf, uBaseInfoDef, StdCtrls;

type
  TfrmStockGoodCheck = class(TfrmMDI)
    lblKType: TLabel;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Private declarations }
    FModelStockGoods: IModelStockGoods;
    
    procedure InitParamList; override;
    procedure BeforeFormShow; override;
    procedure IniGridField; override;
    procedure LoadGridData(ATypeid: string); override;
    function LoadPtype(ABasicDatas: TSelectBasicDatas): Boolean;
    function LoadOnePtype(ARow: Integer; AData: TSelectBasicData; IsImport: Boolean = False): Boolean;
    function SaveCheck: Boolean;
  protected
    procedure DoSelectBasic(Sender: TObject; ABasicType: TBasicType;
      ASelectBasicParam: TSelectBasicParam;
      ASelectOptions: TSelectBasicOptions; var ABasicDatas: TSelectBasicDatas;
      var AReturnCount: Integer); override;
  public
    { Public declarations }
  end;

var
  frmStockGoodCheck: TfrmStockGoodCheck;

implementation

uses uBaseFormPlugin, uSysSvc, uDBIntf, uGridConfig, uMoudleNoDef, uFactoryFormIntf,
     uModelControlIntf, uPubFun, uDefCom, uFrmStockGoodOneCheck, uParamObject, uOtherIntf;
     
{$R *.dfm}

{ TfrmStockGoodCheck }

procedure TfrmStockGoodCheck.BeforeFormShow;
var
  aFrm: TfrmStockGoodOneCheck;
begin
  inherited;
  Title := '仓库盘点';
  FGridItem.SetGridCellSelect(True);
  FModelStockGoods := IModelStockGoods((SysService as IModelControl).GetModelIntf(IModelStockGoods));
  
  aFrm := TfrmStockGoodOneCheck.CreateFrmParamList(nil, nil);
  try
    if aFrm.ShowModal <> mrok then FrmClose;

    ParamList.Assign(aFrm.ParamList);
    lblKType.Caption := '仓库：' + FModelFun.GetLocalValue(btKtype, GetBaseTypeFullName(btKtype), ParamList.AsString('KTypeId'));
    IniGridField();
    LoadGridData('');
  finally
    aFrm.Free;
  end;
end;

procedure TfrmStockGoodCheck.DoSelectBasic(Sender: TObject;
  ABasicType: TBasicType; ASelectBasicParam: TSelectBasicParam;
  ASelectOptions: TSelectBasicOptions; var ABasicDatas: TSelectBasicDatas;
  var AReturnCount: Integer);
begin
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

procedure TfrmStockGoodCheck.IniGridField;
begin
  inherited;
  FGridItem.BasicType := btPtype;
  FGridItem.ClearField;
  FGridItem.AddField('SCId', 'SCId', -1, cfInt);
  FGridItem.AddField('GoodsOrder', 'GoodsOrder', -1, cfInt); 
  FGridItem.AddField(btPtype);
  FGridItem.AddField('StockQty', '库存量', 100, cfQty);
  FGridItem.AddField('Price', '单价', 100, cfPrice);
  FGridItem.AddField('Total', '金额', 100, cfTotal);
  FGridItem.AddField('CheckedQty', '盘点数量', 100, cfQty);
  FGridItem.AddField('DiffQty', '盈亏数量', 100, cfQty);
  FGridItem.AddField('JobNumber', '批号');
  FGridItem.AddField('OutFactoryDate', '生产日期');
  FGridItem.InitGridData;
end;

procedure TfrmStockGoodCheck.InitParamList;
begin
  inherited;
  MoudleNo := fnMdlCheckGoods;
end;

procedure TfrmStockGoodCheck.LoadGridData(ATypeid: string);
var
  aList: TParamObject;
  aKTypeId, aCheckDate: string;
  aUpdatetag: Integer;
begin
  inherited;
  aList := TParamObject.Create;
  try
    aUpdatetag := ParamList.AsInteger('Updatetag');

    aList.Add('@KTypeId', AKTypeId);
    aList.Add('@ETypeid', OperatorID);
    aList.Add('@CheckDate', ACheckDate);
    aList.Add('@Updatetag', aUpdatetag); 

    FModelStockGoods.QryCheck(aList, cdsMainShow);
    FGridItem.LoadData(cdsMainShow);
  finally
    aList.Free;
  end;
end;

function TfrmStockGoodCheck.LoadOnePtype(ARow: Integer;
  AData: TSelectBasicData; IsImport: Boolean): Boolean;
begin
  FGridItem.SetCellValue(GetBaseTypeid(btPtype), ARow, AData.TypeId);
  FGridItem.SetCellValue(GetBaseTypeFullName(btPtype), ARow, AData.FullName);
  FGridItem.SetCellValue(GetBaseTypeUsercode(btPtype), ARow, AData.Usercode);
end;

function TfrmStockGoodCheck.LoadPtype(
  ABasicDatas: TSelectBasicDatas): Boolean;
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

procedure TfrmStockGoodCheck.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  inherited;
  if (SysService as IMsgBox).MsgBox('是否保存当前仓库的盘点数据？', '提示', mbtConfirmation, mbbYesNoCancel) = mrYes then
  begin
    if not SaveCheck() then
    begin
      CanClose := False; 
    end;
  end;
end;

function TfrmStockGoodCheck.SaveCheck: Boolean;
var
  aRow: Integer;
  aParam: TParamObject;
  aPtypeId: string;
begin
  Result := False;
  aParam := TParamObject.Create;
  try
    for aRow := FGridItem.GetFirstRow to FGridItem.GetLastRow do
    begin
      aPtypeId := FGridItem.GetCellValue(GetBaseTypeid(btPtype), aRow);
      if StringEmpty(aPtypeId) then Continue;

      aParam.Clear;
      aParam.Add('@KTypeId', ParamList.AsString('KTypeId'));
      aParam.Add('@PTypeId', aPtypeId);
      aParam.Add('@GoodsOrder', FGridItem.GetCellValue('GoodsOrder', aRow));
      aParam.Add('@CheckedQty', FGridItem.GetCellValue('CheckedQty', aRow));
      aParam.Add('@UpdateTag', ParamList.AsInteger('Updatetag'));
      aParam.Add('@CheckDate', ParamList.AsString('CheckDate'));
      aParam.Add('@SCId', FGridItem.GetCellValue('SCId', aRow));
      aParam.Add('@JobNumber', FGridItem.GetCellValue('JobNumber', aRow));
      aParam.Add('@OutFactoryDate', FGridItem.GetCellValue('OutFactoryDate', aRow));
      aParam.Add('@Total', FGridItem.GetCellValue('Total', aRow));
      aParam.Add('@ETypeId', OperatorID);

      if FModelStockGoods.SaveOneCheck(aParam) <> 0 then
      begin
        Exit;
      end;
    end;
    FGridItem.ClearData;
    Result := True;
  finally
    aParam.Free;
  end;
end;

initialization
  gFormManage.RegForm(TfrmStockGoodCheck, fnMdlCheckGoods);
  
end.
