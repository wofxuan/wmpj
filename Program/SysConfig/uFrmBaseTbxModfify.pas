unit uFrmBaseTbxModfify;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uFrmDialog, Menus, cxLookAndFeelPainters, ActnList, cxControls,
  cxContainer, cxEdit, cxLabel, StdCtrls, cxButtons, ExtCtrls, cxGraphics,
  cxMemo, cxGroupBox, cxDropDownEdit, cxTextEdit, cxMaskEdit, cxButtonEdit, uModelSysIntf,
  DB, DBClient;

type
  TfrmBaseTbxModfify = class(TfrmDialog)
    edtTbxName: TcxButtonEdit;
    cbbTbxType: TcxComboBox;
    gbTbxComment: TcxGroupBox;
    mmoTbxComment: TcxMemo;
    lblName: TcxLabel;
    lblType: TcxLabel;
    cdsTbxInfo: TClientDataSet;
    edtTbxDefName: TcxButtonEdit;
    lblTbxDefName: TcxLabel;
    procedure actOKExecute(Sender: TObject);
  private
    { Private declarations }
    FTbxId: Integer;
    FModelTbxCfg: IModelTbxCfg;
    
    procedure BeforeFormShow; override;
    procedure SetFormData;
    function SaveData: Boolean;
  public
    { Public declarations }
  end;

function CallfrmBaseTbxModfify(ATbxId: Integer): Integer;

implementation

uses uParamObject, uBaseFormPlugin, uSysSvc, uDBIntf, uGridConfig, uMoudleNoDef, uBaseInfoDef,
    uModelControlIntf, uPubFun, uFrmApp;

{$R *.dfm}
function CallfrmBaseTbxModfify(ATbxId: Integer): Integer;
var
  aFrmBaseTbxModfify: TfrmBaseTbxModfify;
  aParam: TParamObject;
begin
  aParam := TParamObject.Create;
  aParam.Add('TbxId', ATbxId);
  aFrmBaseTbxModfify := TfrmBaseTbxModfify.CreateFrmParamList(nil, aParam);
  try
    Result := aFrmBaseTbxModfify.ShowModal;
  finally
    aFrmBaseTbxModfify.Free;
    aParam.Free;
  end;
end;

{ TfrmBaseTbxModfify }

procedure TfrmBaseTbxModfify.BeforeFormShow;
begin
  inherited;
  FTbxId := ParamList.AsInteger('TbxId');
  FModelTbxCfg := IModelTbxCfg((SysService as IModelControl).GetModelIntf(IModelTbxCfg));
  LoadCbbList(cbbTbxType, TSys_TbxType);
  SetFormData();
end;

procedure TfrmBaseTbxModfify.SetFormData;
begin
  FModelTbxCfg.GetTbxInfoRec(FTbxId, cdsTbxInfo);
  if not cdsTbxInfo.IsEmpty then
  begin
    edtTbxName.Text := cdsTbxInfo.FieldByName('TbxName').AsString;
    edtTbxDefName.Text := cdsTbxInfo.FieldByName('TbxDefName').AsString;
    mmoTbxComment.Text := cdsTbxInfo.FieldByName('TbxComment').AsString;
    SetCbbListID(cbbTbxType, TSys_TbxType, cdsTbxInfo.FieldByName('TbxType').AsString);
  end;
end;

procedure TfrmBaseTbxModfify.actOKExecute(Sender: TObject);
begin
  inherited;
  if  SaveData() then
  begin
    ModalResult := mrOk;
  end;
end;

function TfrmBaseTbxModfify.SaveData: Boolean;
var
  aParamData: TParamObject;
begin
  Result := False;
  aParamData := TParamObject.Create;
  try
    aParamData.Add('TbxDefName', Trim(edtTbxDefName.Text));
    aParamData.Add('TbxType', StringToInt(GetCbbListID(cbbTbxType, TSys_TbxType), -1));
    aParamData.Add('TbxComment', Trim(mmoTbxComment.Text));
    if FModelTbxCfg.ModfifyTbxInfoRec(FTbxId, aParamData) then
    begin
      Result := True;
    end;
  finally
    aParamData.Free;
  end;
end;

end.
