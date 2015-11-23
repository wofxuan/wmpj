{***************************
弹出的TC类，用于表格或者输入框等选择信息
mx 2015-10-11
****************************}
unit uFrmBaseSelect;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uFrmDialog, Menus, cxLookAndFeelPainters, ActnList, cxControls,
  cxContainer, cxEdit, cxLabel, StdCtrls, cxButtons, ExtCtrls, cxStyles,
  cxCustomData, cxGraphics, cxFilter, cxData, cxDataStorage, DB, cxDBData,
  cxButtonEdit, cxTextEdit, cxMaskEdit, cxDropDownEdit, cxGridLevel,
  cxClasses, cxGridCustomView, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGrid, uGridConfig, uDBIntf, uModelFunIntf, uBaseInfoDef,
  DBClient, uModelBaseIntf;

type
  TfrmBaseSelect = class(TfrmDialog)
    gridLVMainShow: TcxGridLevel;
    gridMainShow: TcxGrid;
    cbbQueryType: TcxComboBox;
    edtFilter: TcxButtonEdit;
    btnQuery: TcxButton;
    actQuery: TAction;
    btnSelect: TcxButton;
    actSelect: TAction;
    gridTVMainShow: TcxGridTableView;
    procedure actSelectExecute(Sender: TObject);
    procedure gridTVMainShowKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure gridTVMainShowCellDblClick(Sender: TcxCustomGridTableView;
      ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton;
      AShift: TShiftState; var AHandled: Boolean);
  private
    { Private declarations }
    FGridItem: TGridItem;
    FDBAC: IDBAccess;
    FModelFun: IModelFun;
    FModelBaseList: IModelBaseList;
    FBasicType: TBasicType;
    FSelectBasicParam: TSelectBasicParam;
    FSelectOptions: TSelectBasicOptions;
    FBasicDatas: TSelectBasicDatas;
    FReturnArray: TSelectBasicDatas; //返回选择的内容

    procedure IniGridField;
    procedure LoadGridData(ATypeid: string = '');

    procedure BeforeFormShow; override;
    procedure BeforeFormDestroy; override;
    procedure InitParamList; override;

    procedure IniView; override; 
  public
    { Public declarations }
  end;

function SelectBasicData(ABasicType: TBasicType;
  ASelectParam: TSelectBasicParam; ASelectOptions: TSelectBasicOptions;
  var AReturnArray: TSelectBasicDatas): Integer;

implementation

uses uSysSvc, uMoudleNoDef, uFrmApp, uDefCom, uMainFormIntf, uModelControlIntf,
      uModelBaseListIntf, uOtherIntf;

{$R *.dfm}

function SelectBasicData(ABasicType: TBasicType;
  ASelectParam: TSelectBasicParam; ASelectOptions: TSelectBasicOptions;
  var AReturnArray: TSelectBasicDatas): Integer;
var
  aFrm: TfrmBaseSelect;
begin
  aFrm := TfrmBaseSelect.CreateFrmParamList(Application, nil);
  try
    with aFrm do
    begin
      FBasicType := ABasicType;
      FSelectBasicParam := ASelectParam;
      FSelectOptions := ASelectOptions;
      FrmShowModal;
      AReturnArray := FReturnArray;
      Result := Length(FReturnArray);
    end;
  finally
    aFrm.Free;
  end;
end;
{ TfrmBaseSelect }

procedure TfrmBaseSelect.BeforeFormDestroy;
begin
  inherited;

end;

procedure TfrmBaseSelect.BeforeFormShow;
begin
  inherited;
  FGridItem := TGridItem.Create(MoudleNo, gridMainShow, gridTVMainShow);
  FGridItem.SetGoToNextCellOnEnter(False);
  FDBAC := SysService as IDBAccess;
  FModelFun := SysService as IModelFun;

  IniGridField();
  LoadGridData(ROOT_ID);
  SetLength(FReturnArray, 0);
  gridMainShow.SetFocus;
end;

procedure TfrmBaseSelect.IniGridField;
var
  aColInfo: TColInfo;
begin
  FGridItem.ClearField();
  if opMultiSelect in FSelectOptions then
  begin
    FGridItem.MultiSelect(True);
  end;

  if FBasicType = btPtype then
  begin
    FGridItem.AddFiled(btPtype);
    FGridItem.AddCheckBoxCol('IsStop', '是否停用', 1, 0);
  end
  else if FBasicType = btDtype then
  begin
    FGridItem.AddFiled(btDtype);
  end
  else if FBasicType = btEtype then
  begin
    FGridItem.AddFiled(btEtype);
  end
  else if FBasicType = btBtype then
  begin
    FGridItem.AddFiled(btBtype);
  end
  else if FBasicType = btKtype then
  begin
    FGridItem.AddFiled(btKtype);
  end;
  FGridItem.InitGridData;
end;

procedure TfrmBaseSelect.InitParamList;
begin
  inherited;

end;

procedure TfrmBaseSelect.LoadGridData(ATypeid: string);
var
  aCdsTmp: TClientDataSet;
begin
  ParamList.Add(ReportMode, ReportMode_Node);
  FModelBaseList.SetParamList(ParamList);
  aCdsTmp := TClientDataSet.Create(nil);
  try
    FModelBaseList.LoadGridData(ATypeid, '', aCdsTmp);
    FGridItem.LoadData(aCdsTmp);
  finally
    aCdsTmp.Free;
  end;
end;

procedure TfrmBaseSelect.actSelectExecute(Sender: TObject);
var
  aRowIndex, i: Integer;
begin
  inherited;
//   aRowIndex := FGridItem.RowIndex;
//  if (aRowIndex < FGridItem.GetFirstRow) or (aRowIndex > FGridItem.GetLastRow) then Exit;
  if gridTVMainShow.DataController.GetSelectedCount <= 0 then Exit;
  
  if FBasicType <> btNo then
  begin
    SetLength(FReturnArray, gridTVMainShow.DataController.GetSelectedCount);
    for i := 0 to gridTVMainShow.DataController.GetSelectedCount - 1 do
    begin
      aRowIndex := gridTVMainShow.DataController.GetSelectedRowIndex(i);
      FReturnArray[i].TypeId := FGridItem.GetCellValue(GetBaseTypeid(FBasicType), aRowIndex);
      FReturnArray[i].FullName := FGridItem.GetCellValue(GetBaseTypeFullName(FBasicType), aRowIndex);
      FReturnArray[i].Usercode := FGridItem.GetCellValue(GetBaseTypeUsercode(FBasicType), aRowIndex);
    end;
  end;
  ModalResult := mrOk;
end;

procedure TfrmBaseSelect.gridTVMainShowKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  inherited;
  if Key = VK_RETURN then
  begin
    if FGridItem.SelectedRowCount > 0 then
      actSelectExecute(actSelect);
  end;
end;

procedure TfrmBaseSelect.IniView;
begin
  inherited;
  if FBasicType = btPtype then
  begin
    FModelBaseList := IModelBaseListPtype((SysService as IModelControl).GetModelIntf(IModelBaseListPtype));
    FModelBaseList.SetBasicType(btPtype);
  end
  else if FBasicType = btDtype then
  begin
    FModelBaseList := IModelBaseListPtype((SysService as IModelControl).GetModelIntf(IModelBaseListDtype));
    FModelBaseList.SetBasicType(btDtype);
  end
  else if FBasicType = btBtype then
  begin
    FModelBaseList := IModelBaseListPtype((SysService as IModelControl).GetModelIntf(IModelBaseListBtype));
    FModelBaseList.SetBasicType(btBtype);
  end
  else if FBasicType = btKtype then
  begin
    FModelBaseList := IModelBaseListPtype((SysService as IModelControl).GetModelIntf(IModelBaseListKtype));
    FModelBaseList.SetBasicType(btKtype);
  end
  else if FBasicType = btEtype then
  begin
    FModelBaseList := IModelBaseListPtype((SysService as IModelControl).GetModelIntf(IModelBaseListEtype));
    FModelBaseList.SetBasicType(btEtype);
  end
  else
  begin
    raise(SysService as IExManagement).CreateSysEx('没有设置基本信息的类型！');
  end;
end;

procedure TfrmBaseSelect.gridTVMainShowCellDblClick(
  Sender: TcxCustomGridTableView;
  ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton;
  AShift: TShiftState; var AHandled: Boolean);
begin
  inherited;
  if FGridItem.SelectedRowCount > 0 then
    actSelectExecute(actSelect);
end;

end.


