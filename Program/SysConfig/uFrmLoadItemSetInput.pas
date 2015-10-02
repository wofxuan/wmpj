unit uFrmLoadItemSetInput;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uFrmBaseInput, Menus, cxLookAndFeelPainters, ActnList, cxLabel,
  cxControls, cxContainer, cxEdit, cxCheckBox, StdCtrls, cxButtons,
  ExtCtrls, cxMemo, cxTextEdit, cxMaskEdit, cxButtonEdit, DBClient, uParamObject;

type
  TfrmLoadItemSetInput = class(TfrmBaseInput)
    edtLIName: TcxButtonEdit;
    chkIsSytem: TcxCheckBox;
    lbl1: TLabel;
    grp1: TGroupBox;
    mmRemark: TcxMemo;
  protected
    { Private declarations }
    procedure SetFrmData(ASender: TObject; AList: TParamObject); override;  
    procedure GetFrmData(ASender: TObject; AList: TParamObject); override;
    procedure ClearFrmData; override;
  public
    { Public declarations }
    procedure BeforeFormShow; override;
    class function GetMdlDisName: string; override; //得到模块显示名称

  end;

var
  frmLoadItemSetInput: TfrmLoadItemSetInput;

implementation

uses uSysSvc, uBaseFormPlugin, uBaseInfoDef, uModelBaseTypeIntf, uModelControlIntf;

{$R *.dfm}

{ TfrmLoadItemSetInput }

procedure TfrmLoadItemSetInput.BeforeFormShow;
begin
  FModelBaseType := IModelBaseTypeItype((SysService as IModelControl).GetModelIntf(IModelBaseTypeItype));
  FModelBaseType.SetParamList(ParamList);
  FModelBaseType.SetBasicType(btItype);

  DBComItem.AddItem(edtLIName, 'IFullname');
  DBComItem.AddItem(chkIsSytem, 'ISystem');
  DBComItem.AddItem(mmRemark, 'IComment');
  inherited;
end;

procedure TfrmLoadItemSetInput.ClearFrmData;
begin
  inherited;
  edtLIName.Text := '';
  chkIsSytem.Checked := False;
  mmRemark.Text := '';
end;

procedure TfrmLoadItemSetInput.GetFrmData(ASender: TObject;
  AList: TParamObject);
begin
  inherited;
  DBComItem.SetDataToParam(AList);
end;

class function TfrmLoadItemSetInput.GetMdlDisName: string;
begin
  Result := '加载包信息';
end;

procedure TfrmLoadItemSetInput.SetFrmData(ASender: TObject;
   AList: TParamObject);
begin
  inherited;
  DBComItem.GetDataFormParam(AList);
end;

end.
