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
    actCheckDefTbx: TAction;
    procedure actCheckDefTbxExecute(Sender: TObject);
    procedure gridTVMainShowCellDblClick(Sender: TcxCustomGridTableView;
      ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton;
      AShift: TShiftState; var AHandled: Boolean);
  private
    FModelTbxCfg: IModelTbxCfg;
    { Private declarations }
    procedure InitParamList; override;
    procedure BeforeFormShow; override;
    procedure IniGridField; override;
    procedure LoadGridData(ATypeid: string); override;
    function GetCurTypeId: string;          //��ȡ��ǰ���ѡ���е�ID
    function ModifyRecTbxCfg(ATbxId: Integer): Boolean;
  public
    { Public declarations }
    class function GetMdlDisName: string; override; 
  end;

var
  frmBaseTbxCfg: TfrmBaseTbxCfg;

implementation

uses uBaseFormPlugin, uSysSvc, uDBIntf, uGridConfig, uMoudleNoDef, uBaseInfoDef,
     uModelControlIntf, uFrmBaseTbxCheckDef, uPubFun, uFrmBaseTbxModfify;
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
var
  aCol: TColInfo;
begin
  inherited;
  FGridItem.ClearField();
  FGridItem.AddField('tbxId', 'tbxId', -1);
  FGridItem.AddField('tbxName', '�������', 200);
  FGridItem.AddField('tbxDefName', '������', 200);             
  aCol := FGridItem.AddField('tbxType', '�������', 200);
  aCol.SetDisplayText(TSys_TbxType);

  FGridItem.AddField('tbxComment', '��ע', 200);
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

function TfrmBaseTbxCfg.GetCurTypeId: string;
var
  aRowIndex: Integer;
begin
  Result := '';
  aRowIndex := FGridItem.RowIndex;
  if (aRowIndex < FGridItem.GetFirstRow) or (aRowIndex > FGridItem.GetLastRow) then
    Exit;

  Result := FGridItem.GetCellValue('tbxId', aRowIndex);
end;

procedure TfrmBaseTbxCfg.gridTVMainShowCellDblClick(
  Sender: TcxCustomGridTableView;
  ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton;
  AShift: TShiftState; var AHandled: Boolean);
var
  aTbxId: string;
begin
  inherited;
  aTbxId := GetCurTypeId();
  if not StringEmpty(aTbxId)  then
  begin
    if ModifyRecTbxCfg(StringToInt(aTbxId)) then
    begin
      LoadGridData('');
    end;
  end
end;

function TfrmBaseTbxCfg.ModifyRecTbxCfg(ATbxId: Integer): Boolean;
begin
  Result := CallfrmBaseTbxModfify(ATbxId) = mrOk;
end;

initialization
  gFormManage.RegForm(TfrmBaseTbxCfg, fnMdlBaseTbxCfg);

end.
