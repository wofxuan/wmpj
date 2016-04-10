unit uFrmDialog;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uFrmParent, ActnList, Menus, cxLookAndFeelPainters, StdCtrls,
  cxButtons, ExtCtrls, cxControls, cxContainer, cxEdit, cxLabel, uDefCom;

type
  TfrmDialog = class(TfrmParent)
    pnlBottom: TPanel;
    btnOK: TcxButton;
    btnCannel: TcxButton;
    actOK: TAction;
    actCancel: TAction;
    pnlTop: TPanel;
    lblTitle: TcxLabel;
    pnlClient: TPanel;
    procedure actCancelExecute(Sender: TObject);
  private
    { Private declarations }
    procedure SetTitle(const Value: string); override;
    function FrmShowStyle: TShowStyle; override;
  public
    { Public declarations }
  end;

var
  frmDialog: TfrmDialog;

implementation

{$R *.dfm}

{ TfrmDialog }

procedure TfrmDialog.SetTitle(const Value: string);
begin
  inherited;
  lblTitle.Caption := Value;
  Caption := Value;
end;

procedure TfrmDialog.actCancelExecute(Sender: TObject);
begin
  inherited;
  ModalResult := mrCancel;
end;

function TfrmDialog.FrmShowStyle: TShowStyle;
begin
  Result := fssShowModal;
end;

end.
