unit uFrmInputBox;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, uDefCom;

type
  TfrmInputBox = class(TForm)
    lblPrompt: TLabel;
    edtInput: TEdit;
    btnOK: TBitBtn;
    btnCancel: TBitBtn;
    procedure FormShow(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure edtInputKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    FPrompt: string;
    FCaptions: string;
    FInputValue: string;
    FMaxLen: Integer;
    FDataType: TColField;
  public
    { Public declarations }
    property Captions: string read FCaptions write FCaptions;
    property Prompt: string read FPrompt write FPrompt;
    property InputValue: string read FInputValue write FInputValue;
    property MaxLen: Integer read FMaxLen write FMaxLen;
    property DataType: TColField read FDataType write FDataType;
  end;

var
  frmInputBox: TfrmInputBox;

implementation

uses uOtherIntf;

{$R *.dfm}

procedure TfrmInputBox.FormShow(Sender: TObject);
begin
  Caption := Captions;
  lblPrompt.Caption := Prompt;
  edtInput.Text := InputValue;

  edtInput.SetFocus;
  edtInput.SelStart := Length(Trim(InputValue));
end;

procedure TfrmInputBox.btnOKClick(Sender: TObject);
begin
  ModalResult := mrOk;
end;

procedure TfrmInputBox.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmInputBox.edtInputKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then btnOK.SetFocus;
end;

end.
