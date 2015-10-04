unit uFrmDialog;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uFrmParent, ActnList, Menus, cxLookAndFeelPainters, StdCtrls,
  cxButtons, ExtCtrls, cxControls, cxContainer, cxEdit, cxLabel;

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
  private
    { Private declarations }
    procedure SetTitle(const Value: string); override;
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

end.
