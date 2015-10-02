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
    function GetBaseInputClass: TDlgInputBaseClass; override; //������Ϣ¼����ͼ
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
  FGridItem.AddFiled('BTypeId', 'PTypeId', -1);
  FGridItem.AddFiled('BFullname', '��λ����', 200);
  FGridItem.AddFiled('BUsercode', '��λ����', 200);
  FGridItem.AddFiled('RowIndex', '���', 50, gctInt);
  FGridItem.AddCheckBoxCol('IsStop', '�Ƿ�ͣ��', 1, 0);
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
