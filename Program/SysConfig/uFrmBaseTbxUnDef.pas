unit uFrmBaseTbxUnDef;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uFrmDialog, Menus, cxLookAndFeelPainters, ActnList, cxControls,
  cxContainer, cxEdit, cxLabel, StdCtrls, cxButtons, ExtCtrls,
  cxCheckListBox, uModelSysIntf;

type
  TfrmBaseTbxUnDef = class(TfrmDialog)
    lstbUnDef: TcxCheckListBox;
    lblTip: TcxLabel;
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

function CallTfrmBaseTbxUnDef(AModelTbxCfg: IModelTbxCfg; AOwner: TComponent): Integer;

implementation

uses DBClient;

{$R *.dfm}

function CallTfrmBaseTbxUnDef(AModelTbxCfg: IModelTbxCfg; AOwner: TComponent): Integer;
var
  afrmBaseTbxUnDef: TfrmBaseTbxUnDef;
begin
  afrmBaseTbxUnDef := TfrmBaseTbxUnDef.CreateFrmParamList(AOwner, nil);
  try
    with afrmBaseTbxUnDef do
    begin
      FModelTbxCfg := AModelTbxCfg;
      IniData();
      Result := ShowModal;
    end;
  finally
    afrmBaseTbxUnDef.Free;
  end;
end;
{ TfrmBaseTbxUnDef }

procedure TfrmBaseTbxUnDef.BeforeFormDestroy;
begin
  inherited;
end;

procedure TfrmBaseTbxUnDef.BeforeFormShow;
begin
  inherited;
  Self.Title := '未配置对应信息的表格';
end;

procedure TfrmBaseTbxUnDef.IniData;
var
  aCdsTmp: TClientDataSet;
  aItem: TcxCheckListBoxItem;
  i: Integer;
begin
  aCdsTmp := TClientDataSet.Create(nil);
  try
    FModelTbxCfg.LoadGridData('U', aCdsTmp);
    aCdsTmp.First;
    while not aCdsTmp.Eof do
    begin
      aItem := lstbUnDef.Items.Add;
      aItem.Text := Trim(aCdsTmp.FieldByName('tbxName').AsString);
      aItem.Checked := True;
      aCdsTmp.Next;
    end;
  finally
    aCdsTmp.Free;
  end;
end;

procedure TfrmBaseTbxUnDef.actOKExecute(Sender: TObject);
begin
  inherited;
  ModalResult := mrOk;
end;

procedure TfrmBaseTbxUnDef.actCancelExecute(Sender: TObject);
begin
  inherited;
  ModalResult := mrCancel;
end;

end.

