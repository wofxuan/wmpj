unit uFrmBasePtypeList;

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
  TfrmBasePtypeList = class(TfrmMDIBaseType)
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
  frmBasePtypeList: TfrmBasePtypeList;

implementation

uses uSysSvc, uBaseFormPlugin, uMoudleNoDef, uParamObject, uModelBaseListIntf, uFrmBasePtypeInput,
     uModelControlIntf, uBaseInfoDef, uDefCom, uGridConfig, uFrmApp;

{$R *.dfm}

{ TfrmBaseList }

procedure TfrmBasePtypeList.BeforeFormShow;
begin
  FModelBaseList := IModelBaseListPtype((SysService as IModelControl).GetModelIntf(IModelBaseListPtype));
  FModelBaseList.SetParamList(ParamList);
  FModelBaseList.SetBasicType(btPtype);
  TVVisble := True;
  inherited;
end;

function TfrmBasePtypeList.GetBaseInputClass: TDlgInputBaseClass;
begin
  Result := TfrmBasePtypeInput;
end;

procedure TfrmBasePtypeList.IniGridField;
begin
  inherited;
  FGridItem.ClearField();
  FGridItem.AddFiled(btPtype);
  FGridItem.AddFiled('PUsercode', '商品编码', 200);
  FGridItem.AddFiled('RowIndex', '序号', 50, cfInt);
  FGridItem.AddCheckBoxCol('IsStop', '是否停用', 1, 0);
  FGridItem.InitGridData;
end;

procedure TfrmBasePtypeList.InitParamList;
begin
  inherited;
  MoudleNo := fnMdlBasePtypeList;
end;

initialization
  gFormManage.RegForm(TfrmBasePtypeList, fnMdlBasePtypeList);

end.
