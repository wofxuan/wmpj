unit uFrmBaseEtypeList;

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
  TfrmBaseEtypeList = class(TfrmMDIBaseType)
  private
    { Private declarations }
  protected
    function GetBaseInputClass: TDlgInputBaseClass; override; //������Ϣ¼����ͼ
    procedure BeforeFormShow; override;
  public
    { Public declarations }
    procedure IniGridField; override;
    procedure InitParamList; override;

  end;

var
  frmBaseEtypeList: TfrmBaseEtypeList;

implementation

uses uSysSvc, uBaseFormPlugin, uMoudleNoDef, uParamObject, uModelBaseListIntf, uFrmBaseEtypeInput,
     uModelControlIntf, uBaseInfoDef, uDefCom, uGridConfig, uFrmApp;

{$R *.dfm}

{ TfrmBaseList }

procedure TfrmBaseEtypeList.BeforeFormShow;
begin
  FModelBaseList := IModelBaseListPtype((SysService as IModelControl).GetModelIntf(IModelBaseListEtype));
  FModelBaseList.SetParamList(ParamList);
  FModelBaseList.SetBasicType(btEtype);
  TVVisble := True;
  inherited;
end;

function TfrmBaseEtypeList.GetBaseInputClass: TDlgInputBaseClass;
begin
  Result := TfrmBaseEtypeInput;
end;

procedure TfrmBaseEtypeList.IniGridField;
begin
  inherited;
  FGridItem.ClearField();
  FGridItem.AddFiled(btEtype);
  FGridItem.AddFiled('RowIndex', '���', 50, cfInt);
  FGridItem.AddCheckBoxCol('IsStop', '�Ƿ�ͣ��', 1, 0);
  FGridItem.InitGridData;
end;

procedure TfrmBaseEtypeList.InitParamList;
begin
  inherited;
  MoudleNo := fnMdlBaseEtypeList;
end;

initialization
  gFormManage.RegForm(TfrmBaseEtypeList, fnMdlBaseEtypeList);

end.
