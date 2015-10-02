unit uFrmMDIBaseType;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uFrmMDI, cxStyles, cxCustomData, cxGraphics, cxFilter,
  cxData, cxDataStorage, cxEdit, DB, cxDBData, cxGridLevel, cxClasses,
  cxControls, cxGridCustomView, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGrid, ExtCtrls, DBClient, Menus, uParamObject,
  cxLookAndFeelPainters, StdCtrls, cxButtons, ActnList, uFactoryFormIntf, uBaseInfoDef,
  uModelBaseIntf, uDefCom, uFrmBaseInput, ComCtrls, cxContainer, cxTreeView,
  dxBar, ImgList, dxBarExtItems;

type
  TfrmMDIBaseType = class(TfrmMDI)
    actAdd: TAction;
    actModify: TAction;
    actDelete: TAction;
    actClass: TAction;
    actCopyAdd: TAction;
    actList: TAction;
    actQuery: TAction;
    btnAdd: TdxBarLargeButton;
    btnModify: TdxBarLargeButton;
    btnCopyAdd: TdxBarLargeButton;
    btnDel: TdxBarLargeButton;
    btnClass: TdxBarLargeButton;
    btnList: TdxBarLargeButton;
    btnQuery: TdxBarLargeButton;
    btnStop: TdxBarLargeButton;
    actStop: TAction;
    procedure actAddExecute(Sender: TObject);
    procedure actModifyExecute(Sender: TObject);
    procedure actDeleteExecute(Sender: TObject);
    procedure actClassExecute(Sender: TObject);
    procedure actCopyAddExecute(Sender: TObject);
    procedure actListExecute(Sender: TObject);
    procedure actQueryExecute(Sender: TObject);
    procedure gridTVMainShowCellDblClick(Sender: TcxCustomGridTableView;
      ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton;
      AShift: TShiftState; var AHandled: Boolean);
    procedure tvClassChange(Sender: TObject; Node: TTreeNode);
  private
    { Private declarations }

  protected
    FModelBaseList: IModelBaseList;

    procedure AddNewRec; virtual;
    procedure ModifyRec; virtual;
    procedure DeleteRec; virtual;
    procedure ClssseRec; virtual;
    procedure CopyAddRec; virtual;
    procedure ListRec; virtual;
    procedure QueryRec; virtual;
    function GetBaseInputClass: TDlgInputBaseClass; virtual;            //基本信息录入视图
    function OpenInPutBase(AParam: TParamObject = nil): Boolean; virtual; //弹出窗口编辑纪录
    procedure BeforeFormShow; override;
    procedure BeforeFormDestroy; override;
    function GetCurTypeId: string; virtual;                 //获取当前表格选中行的ID
    procedure LoadGridData(ATypeid: string = ''); override;
    function LoadParGridData: Boolean; override;
    procedure InitParamList; override;
  public
    { Public declarations }
    property CurTypeId: string read GetCurTypeId;

  end;

var
  frmMDIBaseType: TfrmMDIBaseType;

implementation

uses TypInfo, uSysSvc, uPubFun, uFrmApp;

{$R *.dfm}

procedure TfrmMDIBaseType.actAddExecute(Sender: TObject);
begin
  inherited;
  AddNewRec();
end;

procedure TfrmMDIBaseType.actModifyExecute(Sender: TObject);
begin
  inherited;
  ModifyRec()
end;

procedure TfrmMDIBaseType.actDeleteExecute(Sender: TObject);
begin
  inherited;
  DeleteRec();
end;

procedure TfrmMDIBaseType.BeforeFormShow;
begin
  inherited;
  FGridItem.BasicType := FModelBaseList.GetBasicType;
  IniGridField();
  LoadGridData(ROOT_ID);

  if TVVisble then
  begin
    LoadBaseTVData(GetBaseTypeTable(FModelBaseList.GetBasicType), tvClass);
    tvClass.FullExpand;
  end;
end;

procedure TfrmMDIBaseType.AddNewRec;
var
  aParam: TParamObject;
  aParId_Cur: string;
begin
  aParam := TParamObject.Create;
  aParam.Add('cMode', dctAdd);
  aParId_Cur := Self.ParamList.AsString('ParId_Cur');
  if Trim(aParId_Cur) = EmptyStr then aParId_Cur := ROOT_ID;
  aParam.Add('ParId', aParId_Cur);
  try
    if OpenInPutBase(aParam) then
    begin
      LoadGridData(Self.ParamList.AsString('ParId_Cur'));
    end;
  finally
    aParam.Free;
  end;
end;

procedure TfrmMDIBaseType.ModifyRec;
var
  aParam: TParamObject;
  aParId_Cur: string;
  aOldRowIndex: Integer;
begin
  if StringEmpty(CurTypeId) then Exit;
  
  aOldRowIndex := gridTVMainShow.Controller.FocusedRowIndex;
  aParam := TParamObject.Create;
  try
    aParam.Add('cMode', GetEnumValue(TypeInfo(TDataChangeType), 'dctModif'));
    aParId_Cur := Self.ParamList.AsString('ParId_Cur');
    if Trim(aParId_Cur) = EmptyStr then aParId_Cur := ROOT_ID;
    aParam.Add('ParId', aParId_Cur);
    aParam.Add('CurTypeid', CurTypeId);
    if OpenInPutBase(aParam) then
    begin
      LoadGridData(Self.ParamList.AsString('ParId_Cur'));
      gridTVMainShow.Controller.FocusedRowIndex := aOldRowIndex;
    end;
  finally
    aParam.Free;
  end;
end;

procedure TfrmMDIBaseType.DeleteRec;
begin
  if FModelBaseList.DeleteRec(CurTypeId) then
  begin
    LoadGridData(Self.ParamList.AsString('ParId_Cur'));
  end;
end;

procedure TfrmMDIBaseType.ClssseRec;
var
  aParam: TParamObject;
  aCur: string;
begin
  aParam := TParamObject.Create;
  aParam.Add('cMode', dctClass);
  aCur := CurTypeId;
  if Trim(aCur) = EmptyStr then Exit;
  aParam.Add('ParId', aCur);
  aParam.Add('CurTypeid', aCur);
  try
    if OpenInPutBase(aParam) then
    begin
      LoadGridData(aCur);
    end;
  finally
    aParam.Free;
  end;
end;

procedure TfrmMDIBaseType.CopyAddRec;
begin

end;

procedure TfrmMDIBaseType.ListRec;
begin

end;

procedure TfrmMDIBaseType.QueryRec;
begin

end;

function TfrmMDIBaseType.GetBaseInputClass: TDlgInputBaseClass;
begin
  Result := TfrmBaseInput;
end;

function TfrmMDIBaseType.OpenInPutBase(AParam: TParamObject): Boolean;
var
  aInfFrmBaseInput: IFormIntf;
  aFrmBaseInput: TDlgInputBaseClass;
begin
  Result := False;
  aFrmBaseInput := GetBaseInputClass;
  if not Assigned(aFrmBaseInput) then
    Exit;

  if Assigned(AParam) then
  begin
    Result := aFrmBaseInput.InputBase(Self, AParam);
  end
  else
  begin
    Result := aFrmBaseInput.InputBase(Self, ParamList);
  end;
end;

function TfrmMDIBaseType.GetCurTypeId: string;
var
  aRowIndex: Integer;
begin
  Result := '';
  aRowIndex := gridTVMainShow.Controller.FocusedRowIndex;
  if (aRowIndex < FGridItem.GetFirstRow) or (aRowIndex > FGridItem.GetLastRow) then
    Exit;
  if FModelBaseList.GetBasicType <> btNo then
  begin
    Result := FGridItem.GetCellValue(GetBaseTypeid(FModelBaseList.GetBasicType), aRowIndex);
  end;
end;

procedure TfrmMDIBaseType.LoadGridData(ATypeid: string);
begin
  inherited;
  Self.ParamList.Add('ParId_Cur', ATypeid);
  FModelBaseList.LoadGridData(ATypeid, '', cdsMainShow);
  FGridItem.LoadData(cdsMainShow);
end;

procedure TfrmMDIBaseType.InitParamList;
begin
  inherited;
  ParamList.Add(ReportMode, ReportMode_Node);
  Self.ParamList.Add('ParId', ROOT_ID);
end;

procedure TfrmMDIBaseType.actClassExecute(Sender: TObject);
begin
  inherited;
  ClssseRec();
end;

procedure TfrmMDIBaseType.actCopyAddExecute(Sender: TObject);
begin
  inherited;
  CopyAddRec()
end;

procedure TfrmMDIBaseType.actListExecute(Sender: TObject);
begin
  inherited;
  ListRec()
end;

procedure TfrmMDIBaseType.actQueryExecute(Sender: TObject);
begin
  inherited;
  QueryRec();
end;

function TfrmMDIBaseType.LoadParGridData: Boolean;
var
  aParId: string;
begin
  Result := False;
  aParId := FModelFun.GetLocalValue(FModelBaseList.GetBasicType, 'Parid', Self.ParamList.AsString('ParId_Cur'));
  if Length(aParId) >= Length(ROOT_ID) then
  begin
    LoadGridData(aParId);
  end;
  if Length(aParId) <= Length(ROOT_ID) then
  begin
    actReturn.Enabled := False;
  end;
  Result := True;
end;

procedure TfrmMDIBaseType.gridTVMainShowCellDblClick(
  Sender: TcxCustomGridTableView;
  ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton;
  AShift: TShiftState; var AHandled: Boolean);
var
  aSonnum: string;
begin
  inherited;
  aSonnum := FModelFun.GetLocalValue(FModelBaseList.GetBasicType, GetBaseTypeSonnumStr(FModelBaseList.GetBasicType), CurTypeId);
  if StrToIntDef(aSonnum, 0) > 0 then
  begin
    LoadGridData(CurTypeId);
    actReturn.Enabled := True;
  end
  else
  begin
    ModifyRec();
  end;
end;

procedure TfrmMDIBaseType.BeforeFormDestroy;
begin
  if TVVisble then
    FreeBaseTVData(tvClass);
  inherited;
end;

procedure TfrmMDIBaseType.tvClassChange(Sender: TObject; Node: TTreeNode);
var
  aNodeData: PNodeData;
begin
  inherited;
  aNodeData := Node.Data;
  if Assigned(aNodeData) then
  begin
    LoadGridData(aNodeData.Typeid);
  end;
end;

end.

