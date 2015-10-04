unit uFrmBaseTbxCfg;  //定义基本信息表格的相关数据

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
    actCheckDefTbx: TAction;
    procedure actCheckDefTbxExecute(Sender: TObject);
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
     uModelBaseListIntf, uModelControlIntf, uFrmBaseTbxCheckDef;
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
  Result := '系统表格配置';
end;

procedure TfrmBaseTbxCfg.IniGridField;
var
  aCol: TColInfo;
begin
  inherited;
  FGridItem.ClearField();
  FGridItem.AddFiled('tbxId', 'ITypeId', -1);
  FGridItem.AddFiled('tbxName', '表格名称', 200);
  aCol := FGridItem.AddFiled('tbxType', '表格类型', 200);
  aCol.SetDisplayText('-1', '未定义');
  FGridItem.AddFiled('tbxComment', '备注', 200);
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
  FModelTbxCfg.LoadGridData('L', cdsMainShow);
  FGridItem.LoadData(cdsMainShow);
end;

procedure TfrmBaseTbxCfg.actCheckDefTbxExecute(Sender: TObject);
begin
  inherited;
  if CallTfrmBaseTbxCheckDef(FModelTbxCfg, Self) = MROK then
    LoadGridData('');
end;

initialization
  gFormManage.RegForm(TfrmBaseTbxCfg, fnMdlBaseTbxCfg);

end.
