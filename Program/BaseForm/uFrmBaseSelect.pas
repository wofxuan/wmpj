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
  cxGridDBTableView, cxGrid, uGridConfig, uDBIntf, uModelFunIntf, uBaseInfoDef;

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
  private
    { Private declarations }
    FGridItem: TGridItem;
    FDBAC: IDBAccess;
    FModelFun: IModelFun;

    procedure IniGridField;
    procedure LoadGridData(ATypeid: string = '');

    procedure BeforeFormShow; override;
    procedure BeforeFormDestroy; override;
    procedure InitParamList; override;
  public
    { Public declarations }
  end;

function SelectBasicData(ABasicType: TBasicType;
  ASelectParam: TSelectBasicParam; ASelectOptions: TSelectBasicOptions;
  var AReturnArray: TSelectBasicDatas): Integer;

implementation

uses uSysSvc, uMoudleNoDef, uFrmApp, uDefCom, uMainFormIntf;

{$R *.dfm}

function SelectBasicData(ABasicType: TBasicType;
  ASelectParam: TSelectBasicParam; ASelectOptions: TSelectBasicOptions;
  var AReturnArray: TSelectBasicDatas): Integer;
var
  aFrm: TfrmBaseSelect;
begin
  aFrm := TfrmBaseSelect.Create(Application);
  try
    with aFrm do
    begin
      FrmShowModal;
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
  FDBAC := SysService as IDBAccess;
  FModelFun := SysService as IModelFun;

  IniGridField();
  LoadGridData(ROOT_ID);
end;

procedure TfrmBaseSelect.IniGridField;
begin
  FGridItem.ClearField();
  FGridItem.AddFiled('DTypeId', 'DTypeId', -1);
  FGridItem.AddFiled('DFullname', '部门名称', 200);
  FGridItem.AddFiled('DUsercode', '部门编码', 200);
  FGridItem.AddFiled('RowIndex', '序号', 50, gctInt);
  FGridItem.AddCheckBoxCol('IsStop', '是否停用', 1, 0);
  FGridItem.InitGridData;
end;

procedure TfrmBaseSelect.InitParamList;
begin
  inherited;

end;

procedure TfrmBaseSelect.LoadGridData(ATypeid: string);
begin

end;

end.

