unit uFrmLoadItemSet;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uFrmMDIBaseType, Menus, cxLookAndFeelPainters, cxStyles,
  cxCustomData, cxGraphics, cxFilter, cxData, cxDataStorage, cxEdit, DB,
  cxDBData, ActnList, DBClient, cxGridLevel, cxClasses, cxControls,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, uParamObject,
  cxGridDBTableView, cxGrid, StdCtrls, cxButtons, ExtCtrls, uFrmBaseInput,
  ComCtrls, cxContainer, cxTreeView, dxBar, dxBarExtItems, ImgList;

type
  TfrmLoadItemSet = class(TfrmMDIBaseType)
    procedure actDeleteExecute(Sender: TObject);
  private
    { Private declarations }
  protected

    procedure IniGridField; override;
    procedure InitParamList; override;
    function GetBaseInputClass: TDlgInputBaseClass; override; //������Ϣ¼����ͼ
  public
    { Public declarations }
    procedure BeforeFormShow; override;
    class function GetMdlDisName: string; override; //�õ�ģ����ʾ����
  end;

var
  frmLoadItemSet: TfrmLoadItemSet;

implementation

uses uBaseFormPlugin, uSysSvc, uDBIntf, uGridConfig, uMoudleNoDef, uBaseInfoDef,
     uModelBaseListIntf, uModelControlIntf, uFrmLoadItemSetInput, uDefCom;

{$R *.dfm}

{ TfrmLoadItemSet }
procedure TfrmLoadItemSet.BeforeFormShow;
begin
  FModelBaseList := IModelBaseListItype((SysService as IModelControl).GetModelIntf(IModelBaseListItype));
  FModelBaseList.SetParamList(ParamList);
  FModelBaseList.SetBasicType(btItype);
  inherited;
end;

function TfrmLoadItemSet.GetBaseInputClass: TDlgInputBaseClass;
begin
  Result := TfrmLoadItemSetInput;
end;

class function TfrmLoadItemSet.GetMdlDisName: string;
begin
  Result := '���ذ���Ϣ';
end;

procedure TfrmLoadItemSet.IniGridField;
var
  aCol: TcxGridDBColumn;
begin
  inherited;
  FGridItem.ClearField();
  FGridItem.AddFiled('ITypeId', 'ITypeId', -1);
  FGridItem.AddFiled('IFullname', '����', 200);
  FGridItem.AddFiled('IComment', '��ע', 200);
  FGridItem.AddFiled('RowIndex', '���', 50, cfInt);
  FGridItem.AddCheckBoxCol('ISystem', 'ϵͳ��', 1, 0);
  FGridItem.InitGridData;
end;

procedure TfrmLoadItemSet.InitParamList;
begin
  inherited;
  MoudleNo := fnMdlLoadItemSet;
end;

procedure TfrmLoadItemSet.actDeleteExecute(Sender: TObject);
begin
  inherited;
  ShowMessage(FGridItem.GetCellValue('IComment', 2));
end;

initialization
  gFormManage.RegForm(TfrmLoadItemSet, fnMdlLoadItemSet);

end.
