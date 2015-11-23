unit uFrmBaseKtypeList;

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
  TfrmBaseKtypeList = class(TfrmMDIBaseType)
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
  frmBaseKtypeList: TfrmBaseKtypeList;

implementation

uses uSysSvc, uBaseFormPlugin, uMoudleNoDef, uParamObject, uModelBaseListIntf, uFrmBaseKtypeInput,
     uModelControlIntf, uBaseInfoDef, uDefCom, uGridConfig, uFrmApp;

{$R *.dfm}

{ TfrmBaseList }

procedure TfrmBaseKtypeList.BeforeFormShow;
begin
  FModelBaseList := IModelBaseListPtype((SysService as IModelControl).GetModelIntf(IModelBaseListKtype));
  FModelBaseList.SetParamList(ParamList);
  FModelBaseList.SetBasicType(btKtype);
  TVVisble := True;
  inherited;
end;

function TfrmBaseKtypeList.GetBaseInputClass: TDlgInputBaseClass;
begin
  Result := TfrmBaseKtypeInput;
end;

procedure TfrmBaseKtypeList.IniGridField;
begin
  inherited;
  FGridItem.ClearField();
  FGridItem.AddFiled(btKtype);
  FGridItem.AddFiled('RowIndex', '序号', 50, cfInt);
  FGridItem.AddCheckBoxCol('IsStop', '是否停用', 1, 0);
  FGridItem.InitGridData;
end;

procedure TfrmBaseKtypeList.InitParamList;
begin
  inherited;
  MoudleNo := fnMdlBaseKtypeList;
end;

initialization
  gFormManage.RegForm(TfrmBaseKtypeList, fnMdlBaseKtypeList);

end.
