unit uFrmLimitSet;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uFrmDialog, Menus, cxLookAndFeelPainters, ActnList, cxControls,
  cxContainer, cxEdit, cxLabel, StdCtrls, cxButtons, ExtCtrls, uModelSysIntf,
  cxStyles, cxCustomData, cxGraphics, cxFilter, cxData, cxDataStorage,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, uDBIntf,
  cxGridBandedTableView, cxClasses, cxGridLevel, cxGrid, cxPC, uGridConfig, uModelFunIntf,
  DB, DBClient, uModelLimitIntf;

type
  TfrmLimitSet = class(TfrmDialog)
    pcLimit: TcxPageControl;
    tsBase: TcxTabSheet;
    tsBill: TcxTabSheet;
    tsReport: TcxTabSheet;
    tsData: TcxTabSheet;
    tsOther: TcxTabSheet;
    gridLVBase: TcxGridLevel;
    gridBase: TcxGrid;
    gridTVBase: TcxGridTableView;
    cdsBase: TClientDataSet;
  private
    { Private declarations }
    FGridBase: TGridItem;
    FDBAC: IDBAccess;
    FModelFun: IModelFun;

    FModelLimit: IModelLimit;
    
    procedure BeforeFormShow; override;
    procedure BeforeFormDestroy; override;
    procedure InitParamList; override;

    procedure IniGridField;
    procedure LoadGridData;
  public
    { Public declarations }
  end;

var
  frmLimitSet: TfrmLimitSet;

implementation

uses uBaseFormPlugin, uSysSvc, uMoudleNoDef, uBaseInfoDef, uFactoryFormIntf,
  uModelControlIntf, uPubFun, uDefCom, uParamObject, uOtherIntf;

{$R *.dfm}

{ TfrmInitOver }

procedure TfrmLimitSet.BeforeFormDestroy;
begin
  inherited;
  FGridBase.Free;
end;

procedure TfrmLimitSet.BeforeFormShow;
begin
  inherited;
  Title := '权限设置';
  FDBAC := SysService as IDBAccess;
  FModelFun := SysService as IModelFun;

  FModelLimit := IModelLimit((SysService as IModelControl).GetModelIntf(IModelLimit));
  
  FGridBase := TGridItem.Create(ClassName + gridBase.Name, gridBase, gridTVBase);
  FGridBase.SetGridCellSelect(True);
  FGridBase.ShowMaxRow := False;

  IniGridField();
  LoadGridData();
end;

procedure TfrmLimitSet.IniGridField;
var
  aColInfo: TColInfo;
begin
  FGridBase.ClearField();
  FGridBase.AddField('LAGUID', 'LAGUID', -1);
  aColInfo := FGridBase.AddField('LAName', '模块名称', 200);
  aColInfo.GridColumn.Options.Editing := False;
  FGridBase.AddCheckBoxCol('LView', '查看', 1, 0);
  FGridBase.AddCheckBoxCol('LAdd', '新增', 1, 0);
  FGridBase.AddCheckBoxCol('LClass', '分类', 1, 0);
  FGridBase.AddCheckBoxCol('LModify', '修改', 1, 0);
  FGridBase.AddCheckBoxCol('LDel', '删除', 1, 0);
  FGridBase.AddCheckBoxCol('LPrint', '打印', 1, 0);
  FGridBase.InitGridData;
end;

procedure TfrmLimitSet.InitParamList;
begin
  inherited;
  MoudleNo := fnDialogLimitSet;
end;

procedure TfrmLimitSet.LoadGridData;
begin
  FModelLimit.UserLimitData(Limit_Base, '00000', cdsBase);
  FGridBase.LoadData(cdsBase);
end;

initialization
  gFormManage.RegForm(TfrmLimitSet, fnDialogLimitSet);

end.

