unit uFrmBaseDtypeList;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uFrmMDIBaseType, Menus, cxLookAndFeelPainters, cxStyles,
  cxCustomData, cxGraphics, cxFilter, cxData, cxDataStorage, cxEdit, DB,
  cxDBData, ActnList, DBClient, cxGridLevel, cxClasses, cxControls,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGrid, StdCtrls, cxButtons, ExtCtrls, uFrmBaseInput,
  ComCtrls, cxContainer, cxTreeView;

type
  TfrmBaseDtypeList = class(TfrmMDIBaseType)
  private
    { Private declarations }
  protected
    function GetBaseInputClass: TDlgInputBaseClass; override; //基本信息录入视图
    procedure BeforeFormShow; override;
  public
    { Public declarations }
    procedure IniGridField; override;
    procedure InitParamList; override;

  end;

var
  frmBaseDtypeList: TfrmBaseDtypeList;

implementation

uses uSysSvc, uBaseFormPlugin, uMoudleNoDef, uParamObject, uModelBaseListIntf, uFrmBaseDtypeInput,
     uModelControlIntf, uBaseInfoDef, uDefCom, uGridConfig, uFrmApp;

{$R *.dfm}

{ TfrmBaseList }

procedure TfrmBaseDtypeList.BeforeFormShow;
begin
  FModelBaseList := IModelBaseListPtype((SysService as IModelControl).GetModelIntf(IModelBaseListDtype));
  FModelBaseList.SetParamList(ParamList);
  FModelBaseList.SetBasicType(btDtype);
  TVVisble := True;
  inherited;
end;

function TfrmBaseDtypeList.GetBaseInputClass: TDlgInputBaseClass;
begin
  Result := TfrmBaseDtypeInput;
end;

procedure TfrmBaseDtypeList.IniGridField;
begin
  inherited;
  FGridItem.ClearField();
  FGridItem.AddFiled('DTypeId', 'DTypeId', -1);
  FGridItem.AddFiled('DFullname', '部门名称', 200);
  FGridItem.AddFiled('DUsercode', '部门编码', 200);
  FGridItem.AddFiled('RowIndex', '序号', 50, gctInt);
  FGridItem.AddCheckBoxCol('IsStop', '是否停用', 1, 0);
  FGridItem.InitGridData;
end;

procedure TfrmBaseDtypeList.InitParamList;
begin
  inherited;
  MoudleNo := fnMdlBaseDtypeList;
end;

initialization
  gFormManage.RegForm(TfrmBaseDtypeList, fnMdlBaseDtypeList);

end.
