unit uFrmBaseTbxCfg;  //���������Ϣ�����������

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uFrmMDI, ComCtrls, cxStyles, cxCustomData, cxGraphics, cxFilter,
  cxData, cxDataStorage, cxEdit, dxBar, dxBarExtItems, cxClasses, ImgList,
  ActnList, DB, DBClient, cxGridLevel, cxControls, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGrid, cxContainer, cxTreeView,
  ExtCtrls, uModelSysIntf;

type
  TfrmBaseTbxCfg = class(TfrmMDI)
    btnUnDefTbx: TdxBarLargeButton;
    actUnDefTbx: TAction;
    procedure actUnDefTbxExecute(Sender: TObject);
  private
    FModelTbxCfg: IModelTbxCfg;
    { Private declarations }
    procedure InitParamList; override;
    procedure BeforeFormShow; override;
    procedure IniGridField; override;
    procedure LoadGridData(ATypeid: string); override;
  public
    { Public declarations }
    class function GetMdlDisName: string; override; 
  end;

var
  frmBaseTbxCfg: TfrmBaseTbxCfg;

implementation

uses uBaseFormPlugin, uSysSvc, uDBIntf, uGridConfig, uMoudleNoDef, uBaseInfoDef,
     uModelBaseListIntf, uModelControlIntf, uFrmBaseTbxUnDef;
{$R *.dfm}

{ TfrmMDI1 }

procedure TfrmBaseTbxCfg.BeforeFormShow;
begin
  inherited;
  FModelTbxCfg := IModelTbxCfg((SysService as IModelControl).GetModelIntf(IModelTbxCfg));
  IniGridField();
  LoadGridData('');
end;

class function TfrmBaseTbxCfg.GetMdlDisName: string;
begin
  Result := 'ϵͳ�������';
end;

procedure TfrmBaseTbxCfg.IniGridField;
begin
  inherited;
  FGridItem.ClearField();
  FGridItem.AddFiled('tbxId', 'ITypeId', -1);
  FGridItem.AddFiled('tbxName', '�������', 200);
  FGridItem.AddFiled('tbxType', '�������', 200);
  FGridItem.AddFiled('tbxComment', '��ע', 200);
  FGridItem.InitGridData;
end;

procedure TfrmBaseTbxCfg.InitParamList;
begin
  inherited;
  MoudleNo := fnMdlBaseTbxCfg;
end;

procedure TfrmBaseTbxCfg.LoadGridData(ATypeid: string);
begin
  inherited;
  FModelTbxCfg.LoadGridData('D', cdsMainShow);
  FGridItem.LoadData(cdsMainShow);
end;

procedure TfrmBaseTbxCfg.actUnDefTbxExecute(Sender: TObject);
begin
  inherited;
  if CallTfrmBaseTbxUnDef(FModelTbxCfg, Self) = MROK then
    LoadGridData('');
end;

initialization
  gFormManage.RegForm(TfrmBaseTbxCfg, fnMdlBaseTbxCfg);

end.
