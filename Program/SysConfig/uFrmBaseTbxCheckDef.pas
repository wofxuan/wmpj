unit uFrmBaseTbxCheckDef;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uFrmDialog, Menus, cxLookAndFeelPainters, ActnList, cxControls,
  cxContainer, cxEdit, cxLabel, StdCtrls, cxButtons, ExtCtrls,
  cxCheckListBox, uModelSysIntf, cxGroupBox, cxSplitter, cxListBox;

type
  TfrmBaseTbxCheckDef = class(TfrmDialog)
    lblTip: TcxLabel;
    gbUnDef: TcxGroupBox;
    gbDel: TcxGroupBox;
    slLeft: TcxSplitter;
    lbUnDef: TcxListBox;
    lbDel: TcxListBox;
    procedure actOKExecute(Sender: TObject);
    procedure actCancelExecute(Sender: TObject);
  private
    { Private declarations }
    FModelTbxCfg: IModelTbxCfg;
    procedure IniData;
  public
    { Public declarations }
    procedure BeforeFormShow; override;
    procedure BeforeFormDestroy; override;
  end;

function CallTfrmBaseTbxCheckDef(AModelTbxCfg: IModelTbxCfg; AOwner: TComponent): Integer;

implementation

uses DBClient;

{$R *.dfm}

function CallTfrmBaseTbxCheckDef(AModelTbxCfg: IModelTbxCfg; AOwner: TComponent): Integer;
var
  afrmBaseTbxCheckDef: TfrmBaseTbxCheckDef;
begin
  afrmBaseTbxCheckDef := TfrmBaseTbxCheckDef.CreateFrmParamList(AOwner, nil);
  try
    with afrmBaseTbxCheckDef do
    begin
      FModelTbxCfg := AModelTbxCfg;
      IniData();
      Result := ShowModal;
    end;
  finally
    afrmBaseTbxCheckDef.Free;
  end;
end;
{ TfrmBaseTbxUnDef }

procedure TfrmBaseTbxCheckDef.BeforeFormDestroy;
begin
  inherited;
end;

procedure TfrmBaseTbxCheckDef.BeforeFormShow;
begin
  inherited;
  Self.Title := '≈‰÷√ºÏ≤È';
end;

procedure TfrmBaseTbxCheckDef.IniData;
var
  aCdsTmp: TClientDataSet;
  i: Integer;
begin
  aCdsTmp := TClientDataSet.Create(nil);
  try
    FModelTbxCfg.LoadGridData('U', aCdsTmp);
    aCdsTmp.First;
    while not aCdsTmp.Eof do
    begin
      lbUnDef.Items.Add(Trim(aCdsTmp.FieldByName('tbxName').AsString));
      aCdsTmp.Next;
    end;

    FModelTbxCfg.LoadGridData('D', aCdsTmp);
    aCdsTmp.First;
    while not aCdsTmp.Eof do
    begin
      lbDel.Items.Add(Trim(aCdsTmp.FieldByName('tbxName').AsString));
      aCdsTmp.Next;
    end;
  finally
    aCdsTmp.Free;
  end;
end;

procedure TfrmBaseTbxCheckDef.actOKExecute(Sender: TObject);
begin
  inherited;
  if FModelTbxCfg.CheckTbxCfg(tctInsert) and FModelTbxCfg.CheckTbxCfg(tctDel)  then
    ModalResult := mrOk;
end;

procedure TfrmBaseTbxCheckDef.actCancelExecute(Sender: TObject);
begin
  inherited;
  ModalResult := mrCancel;
end;

end.

