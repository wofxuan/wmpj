unit uFrmBaseBtypeList;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uFrmMDIBaseType, Menus, cxLookAndFeelPainters, cxStyles,
  cxCustomData, cxGraphics, cxFilter, cxData, cxDataStorage, cxEdit, DB,
  cxDBData, ActnList, DBClient, cxGridLevel, cxClasses, cxControls,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGrid, StdCtrls, cxButtons, ExtCtrls, uFrmBaseInput,
  ComCtrls, cxContainer, cxTreeView, dxBar, dxBarExtItems, ImgList;

type
  TfrmBaseBtypeList = class(TfrmMDIBaseType)
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
  frmBaseBtypeList: TfrmBaseBtypeList;

implementation

uses uSysSvc, uBaseFormPlugin, uMoudleNoDef, uParamObject, uModelBaseListIntf, uFrmBaseBtypeInput,
     uModelControlIntf, uBaseInfoDef, uDefCom, uGridConfig, uFrmApp;

{$R *.dfm}

{ TfrmBaseList }

procedure TfrmBaseBtypeList.BeforeFormShow;
begin
  FModelBaseList := IModelBaseListPtype((SysService as IModelControl).GetModelIntf(IModelBaseListBtype));
  FModelBaseList.SetParamList(ParamList);
  FModelBaseList.SetBasicType(btBtype);
  TVVisble := True;
  inherited;
end;

function TfrmBaseBtypeList.GetBaseInputClass: TDlgInputBaseClass;
begin
  Result := TfrmBaseBtypeInput;
end;

procedure TfrmBaseBtypeList.IniGridField;
begin
  inherited;
  FGridItem.ClearField();
  FGridItem.AddFiled(btBtype);
  FGridItem.AddFiled('RowIndex', '序号', 50, cfInt);
  FGridItem.AddCheckBoxCol('IsStop', '是否停用', 1, 0);
  FGridItem.InitGridData;
end;

procedure TfrmBaseBtypeList.InitParamList;
begin
  inherited;
  MoudleNo := fnMdlBaseBtypeList;
end;

initialization
  gFormManage.RegForm(TfrmBaseBtypeList, fnMdlBaseBtypeList);

end.
