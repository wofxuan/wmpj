unit uFrmFlowItem;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uFrmDialog, Menus, cxLookAndFeelPainters, ActnList, cxControls,
  cxContainer, cxEdit, cxLabel, StdCtrls, cxButtons, ExtCtrls, uParamObject,
  cxTextEdit, cxMaskEdit, cxButtonEdit, uWmLabelEditBtn, cxGraphics,
  cxDropDownEdit;

type
  TfrmFlowItem = class(TfrmDialog)
    edtProcesseName: TWmLabelEditBtn;
    cbbType: TcxComboBox;
    lbl1: TLabel;
    edtProceOrder: TWmLabelEditBtn;
    edtEtype: TWmLabelEditBtn;
    procedure actOKExecute(Sender: TObject);
  private
    { Private declarations }
    procedure BeforeFormShow; override;
    procedure BeforeFormDestroy; override;
  public
    { Public declarations }
  end;

var
  frmFlowItem: TfrmFlowItem;

function ShowFlowItem(AParam: TParamObject): Integer;

implementation

{$R *.dfm}
uses uBaseFormPlugin, uSysSvc, uDBIntf, uMoudleNoDef, uBaseInfoDef, uFactoryFormIntf,
     uModelControlIntf, uPubFun, uDefCom, uModelFunIntf, uOtherIntf;

function ShowFlowItem(AParam: TParamObject): Integer;
var
  aFrm: TfrmFlowItem;
begin
  aFrm := TfrmFlowItem.CreateFrmParamList(nil, AParam);
  try
    Result := aFrm.ShowModal;
    AParam.Assign(aFrm.ParamList);
  finally
    aFrm.Free;
  end;
end;

{ TfrmFlowItem }

procedure TfrmFlowItem.BeforeFormDestroy;
begin
  inherited;

end;

procedure TfrmFlowItem.BeforeFormShow;
begin
  inherited;
  Title := '流程作业具体项目';

  DBComItem.AddItem(edtEtype, 'ETypeId', 'ETypeId', 'EUsercode', btEtype);
end;

procedure TfrmFlowItem.actOKExecute(Sender: TObject);
begin
  inherited;
  ParamList.Add('ProcesseName', Trim(edtProcesseName.Text));
  ParamList.Add('OperType', cbbType.ItemIndex);
  ParamList.Add('ProceOrder', Trim(edtProceOrder.Text));
  ParamList.Add('OperId', DBComItem.GetItemValue(edtEtype));

  ModalResult := mrOk;
end;

end.
