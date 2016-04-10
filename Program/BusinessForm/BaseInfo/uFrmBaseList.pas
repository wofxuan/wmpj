unit uFrmBaseList;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uFrmMDIBaseType, Menus, cxLookAndFeelPainters, cxStyles,
  cxCustomData, cxGraphics, cxFilter, cxData, cxDataStorage, cxEdit, DB,
  cxDBData, ActnList, DBClient, cxGridLevel, cxClasses, cxControls,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGrid, StdCtrls, cxButtons, ExtCtrls, uFrmBaseInput,
  ComCtrls, cxContainer, cxTreeView, dxBar, dxBarExtItems, ImgList, uBaseInfoDef;

type
  TfrmBaseList = class(TfrmMDIBaseType)
  private
    { Private declarations }
    FBasicType: TBasicType;
    
  protected
    function GetBaseInputClass: TDlgInputBaseClass; override; //基本信息录入视图
    procedure BeforeFormShow; override;
  public
    { Public declarations }
    procedure IniGridField; override;
    procedure InitParamList; override;

  end;

var
  frmBaseList: TfrmBaseList;

implementation

uses uSysSvc, uBaseFormPlugin, uMoudleNoDef, uParamObject, uModelBaseListIntf,
     uModelControlIntf, uDefCom, uGridConfig, uFrmApp, uModelBaseIntf, uFrmBasePtypeInput,
     uFrmBaseBtypeInput, uFrmBaseDtypeInput, uFrmBaseEtypeInput, uFrmBaseKtypeInput;

{$R *.dfm}

{ TfrmBaseList }

procedure TfrmBaseList.BeforeFormShow;
begin
  if ParamList.AsString('Mode') = 'P' then
  begin
    MoudleNo := fnMdlBasePtypeList;
    FBasicType := btPtype;
    FModelBaseList := IModelBaseList((SysService as IModelControl).GetModelIntf(IModelBaseListPtype));
  end
  else if ParamList.AsString('Mode') = 'B' then
  begin
    MoudleNo := fnMdlBaseBtypeList;
    FBasicType := btBtype;
    FModelBaseList := IModelBaseList((SysService as IModelControl).GetModelIntf(IModelBaseListBtype));
  end
  else if ParamList.AsString('Mode') = 'D' then
  begin
    MoudleNo := fnMdlBaseDtypeList;
    FBasicType := btDtype;
    FModelBaseList := IModelBaseList((SysService as IModelControl).GetModelIntf(IModelBaseListDtype));
  end
  else if ParamList.AsString('Mode') = 'E' then
  begin
    MoudleNo := fnMdlBaseEtypeList;
    FBasicType := btEtype;
    FModelBaseList := IModelBaseList((SysService as IModelControl).GetModelIntf(IModelBaseListEtype));
  end
  else if ParamList.AsString('Mode') = 'K' then
  begin
    MoudleNo := fnMdlBaseKtypeList;
    FBasicType := btKtype;
    FModelBaseList := IModelBaseList((SysService as IModelControl).GetModelIntf(IModelBaseListKtype));
  end;

  FModelBaseList.SetParamList(ParamList);
  FModelBaseList.SetBasicType(FBasicType);
  TVVisble := True;
  Title := GetBasicTypeCaption(FBasicType) + '信息';
  inherited;
end;

function TfrmBaseList.GetBaseInputClass: TDlgInputBaseClass;
begin
  case FBasicType of
    btBtype: Result := TfrmBaseBtypeInput;
    btEtype: Result := TfrmBaseEtypeInput;
    btKtype: Result := TfrmBaseKtypeInput;
    btPtype: Result := TfrmBasePtypeInput;
    btDtype: Result := TfrmBaseDtypeInput;
  else

  end;
end;

procedure TfrmBaseList.IniGridField;
begin
  inherited;
  FGridItem.ClearField();
  FGridItem.AddField(FBasicType);
  FGridItem.AddField('RowIndex', '序号', 50, cfInt);
  FGridItem.AddCheckBoxCol('IsStop', '是否停用', 1, 0);
  FGridItem.InitGridData;
end;

procedure TfrmBaseList.InitParamList;
begin
  inherited;
  
end;

initialization
  gFormManage.RegForm(TfrmBaseList, fnMdlBasePtypeList);
  gFormManage.RegForm(TfrmBaseList, fnMdlBaseBtypeList);
  gFormManage.RegForm(TfrmBaseList, fnMdlBaseDtypeList);
  gFormManage.RegForm(TfrmBaseList, fnMdlBaseEtypeList);
  gFormManage.RegForm(TfrmBaseList, fnMdlBaseKtypeList);

end.
