unit uFrmBasePtypeInput;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uFrmBaseInput, Menus, cxLookAndFeelPainters, ActnList, cxLabel,
  cxControls, cxContainer, cxEdit, cxCheckBox, StdCtrls, cxButtons,
  ExtCtrls, Mask, cxTextEdit, cxMaskEdit, cxButtonEdit, cxGraphics,
  cxDropDownEdit, uParamObject, ComCtrls, cxStyles, cxCustomData, cxFilter,
  cxData, cxDataStorage, DB, cxDBData, cxGridLevel, cxClasses,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGrid, uDBComConfig, uGridConfig;

type
  TfrmBasePtypeInput = class(TfrmBaseInput)
    edtFullname: TcxButtonEdit;
    lbl1: TLabel;
    lbl2: TLabel;
    edtUsercode: TcxButtonEdit;
    Label1: TLabel;
    edtName: TcxButtonEdit;
    edtPYM: TcxButtonEdit;
    lbl3: TLabel;
    lbl4: TLabel;
    Label2: TLabel;
    lbl5: TLabel;
    edtStandard: TcxButtonEdit;
    edtModel: TcxButtonEdit;
    edtArea: TcxButtonEdit;
    cbbCostMode: TcxComboBox;
    lbl6: TLabel;
    edtUsefulLifeday: TcxButtonEdit;
    lbl7: TLabel;
    chkStop: TcxCheckBox;
    pgcView: TPageControl;
    tsJG: TTabSheet;
    gridLVPtypeUnit: TcxGridLevel;
    gridPtypeUnit: TcxGrid;
    gridTVPtypeUnit: TcxGridTableView;
    procedure gridTVPtypeUnitEditing(Sender: TcxCustomGridTableView;
      AItem: TcxCustomGridTableItem; var AAllow: Boolean);
  protected
    { Private declarations }
    procedure SetFrmData(ASender: TObject; AList: TParamObject); override;  
    procedure GetFrmData(ASender: TObject; AList: TParamObject); override;
    procedure ClearFrmData; override;
    function SaveData: Boolean; override;
  private
    FGridItem: TGridItem;

    procedure IniUnitGridField;
  public
    { Public declarations }
    procedure InitParamList; override;
    procedure BeforeFormShow; override;
    procedure BeforeFormDestroy; override;
    class function GetMdlDisName: string; override; //得到模块显示名称

  end;

var
  frmBasePtypeInput: TfrmBasePtypeInput;

implementation

{$R *.dfm}

uses uSysSvc, uBaseFormPlugin, uBaseInfoDef, uModelBaseTypeIntf, uModelControlIntf, uOtherIntf,
     uDefCom, uMoudleNoDef, uPubFun, DBClient;

{ TfrmBasePtypeInput }

procedure TfrmBasePtypeInput.BeforeFormDestroy;
begin
  inherited;
  FGridItem.Free;
end;

procedure TfrmBasePtypeInput.BeforeFormShow;
begin
  Title := '商品信息';
  FModelBaseType := IModelBaseTypePtype((SysService as IModelControl).GetModelIntf(IModelBaseTypePtype));
  FModelBaseType.SetParamList(ParamList);
  FModelBaseType.SetBasicType(btPtype);

  DBComItem.AddItem(edtFullname, 'Fullname', 'PFullname');
  DBComItem.AddItem(edtUsercode, 'Usercode', 'PUsercode');
  DBComItem.AddItem(edtName, 'Name', 'Name');
  DBComItem.AddItem(edtPYM, 'Namepy', 'Pnamepy');
  DBComItem.AddItem(edtStandard, 'Standard', 'Standard');
  DBComItem.AddItem(edtModel, 'Model', 'Model');
  DBComItem.AddItem(edtArea, 'Area', 'Area');
  DBComItem.AddItem(cbbCostMode, 'CostMode', 'CostMode');
  DBComItem.AddItem(edtUsefulLifeday, 'UsefulLifeday', 'UsefulLifeday');
  DBComItem.AddItem(chkStop, 'IsStop', 'IsStop');

  FGridItem := TGridItem.Create(MoudleNo, gridPtypeUnit, gridTVPtypeUnit);
  FGridItem.SetGridCellSelect(True);

  IniUnitGridField();
  inherited;
end;

procedure TfrmBasePtypeInput.ClearFrmData;
begin
  inherited;
  edtUsefulLifeday.Text := '0';
end;

procedure TfrmBasePtypeInput.GetFrmData(ASender: TObject;
  AList: TParamObject);
begin
  inherited;
  AList.Add('@Parid', ParamList.AsString('ParId'));
  DBComItem.SetDataToParam(AList);
  AList.Add('@Comment', '');
  if FModelBaseType.DataChangeType in [dctModif] then
  begin
    AList.Add('@typeId', ParamList.AsString('CurTypeid'));
  end;
end;

class function TfrmBasePtypeInput.GetMdlDisName: string;
begin
  Result := '商品信息';
end;

procedure TfrmBasePtypeInput.InitParamList;
begin
  inherited;
  MoudleNo := fnMdlBasePtypeList;
end;

procedure TfrmBasePtypeInput.IniUnitGridField;
var
  i: Integer;
  aColInfo: TColInfo;
begin
  FGridItem.ClearField();
  FGridItem.AddField('IsBase', 'IsBase', -1, cfInt);
  FGridItem.AddField('UnitId', 'UnitId', -1, cfInt);
  aColInfo := FGridItem.AddField('UnitType', '项目', 100, cfString);
  aColInfo.GridColumn.Options.Editing := False;
  FGridItem.AddField('UnitName', '单位名称', 100, cfString);
  FGridItem.AddField('UnitRates', '单位关系', 100, cfQty);
  FGridItem.AddField('Barcode', '条码', 100, cfString);
  FGridItem.AddField('RetailPrice', '零售价', 100, cfPrice);
  FGridItem.InitGridData;

  gridTVPtypeUnit.DataController.RecordCount := 3;
  FGridItem.SetCellValue('UnitId', 0, 0);
  FGridItem.SetCellValue('UnitType', 0, '基本单位');
  FGridItem.SetCellValue('UnitRates', 0, 1);
  FGridItem.SetCellValue('IsBase', 0, 1);

  FGridItem.SetCellValue('UnitId', 1, 1);
  FGridItem.SetCellValue('UnitType', 1, '辅助单位1');
  FGridItem.SetCellValue('IsBase', 1, 0);

  FGridItem.SetCellValue('UnitId', 2, 2);
  FGridItem.SetCellValue('UnitType', 2, '辅助单位2');
  FGridItem.SetCellValue('IsBase', 1, 0);
end;

function TfrmBasePtypeInput.SaveData: Boolean;
var
  aUnitInfo: TParamObject;
  aRow: Integer;
  aUnitName, aBarcode: string;
  aURate: Double;
begin
  Result := inherited SaveData;
  if not Result then Exit;
  
  aUnitInfo := TParamObject.Create;
  try
    for aRow := FGridItem.GetFirstRow to FGridItem.GetLastRow do
    begin
      aUnitName := FGridItem.GetCellValue('UnitName', aRow);
      aURate := FGridItem.GetCellValue('UnitRates', aRow);
      if (StringEmpty(aUnitName) or (aURate = 0)) and (aRow <> 0) then Continue;
      
      aUnitInfo.Clear;
      aUnitInfo.Add('@PTypeId', FModelBaseType.CurTypeId);
      aUnitInfo.Add('@UnitName', aUnitName);
      aUnitInfo.Add('@URate', aURate);
      aUnitInfo.Add('@IsBase', FGridItem.GetCellValue('IsBase', aRow));
      aUnitInfo.Add('@BarCode', FGridItem.GetCellValue('Barcode', aRow));
      aUnitInfo.Add('@Comment', '');
      aUnitInfo.Add('@OrdId', FGridItem.GetCellValue('UnitId', aRow));
      IModelBaseTypePtype(FModelBaseType).SaveOneUnitInfo(aUnitInfo);
    end;
  finally
    aUnitInfo.Free;
  end;
end;

procedure TfrmBasePtypeInput.SetFrmData(ASender: TObject;
  AList: TParamObject);
var
  aCdsTmp: TClientDataSet;
  aUnitId: Integer;
begin
  inherited;
  DBComItem.GetDataFormParam(AList);

  aCdsTmp := TClientDataSet.Create(nil);
  try
    IModelBaseTypePtype(FModelBaseType).GetUnitInfo(FModelBaseType.CurTypeId, aCdsTmp);
    aCdsTmp.First;
    while not aCdsTmp.Eof do
    begin
      aUnitId := aCdsTmp.FieldByName('OrdId').AsInteger;
      FGridItem.SetCellValue('UnitName', aUnitId,  aCdsTmp.FieldByName('UnitName').AsString);
      FGridItem.SetCellValue('UnitRates', aUnitId, aCdsTmp.FieldByName('URate').AsFloat);
      FGridItem.SetCellValue('BarCode', aUnitId, aCdsTmp.FieldByName('BarCode').AsString);
      aCdsTmp.Next;
    end;
  finally
    aCdsTmp.Free;
  end;
end;

procedure TfrmBasePtypeInput.gridTVPtypeUnitEditing(
  Sender: TcxCustomGridTableView; AItem: TcxCustomGridTableItem;
  var AAllow: Boolean);
var
  aUnitName, aBarcode: string;
  aURate: Double;
begin
  inherited;
  if FGridItem.RowIndex = 0 then
  begin
    if FGridItem.FindColByFieldName('UnitRates').GridColumn = AItem then
      AAllow := False;
  end
  else if FGridItem.RowIndex = 1 then
  begin
    aUnitName := FGridItem.GetCellValue('UnitName', 0);
    aURate := FGridItem.GetCellValue('UnitRates', 0);

    if (StringEmpty(aUnitName) or (aURate = 0)) then AAllow := False;
  end
  else if FGridItem.RowIndex = 2 then
  begin
    aUnitName := FGridItem.GetCellValue('UnitName', 1);
    aURate := FGridItem.GetCellValue('UnitRates', 1);

    if (StringEmpty(aUnitName) or (aURate = 0)) then AAllow := False;
  end;
end;

end.
