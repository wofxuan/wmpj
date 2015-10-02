unit uFrmMsgBox;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, uDefCom, uOtherIntf;

type
  TfrmMsgBox = class(TForm)
    pnlClient: TPanel;
    pnlBottom: TPanel;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    FIcons: Pchar;
    FMessages: string;
    FCaptions: string;
    FButtons: TMessageBoxButtons;
    FMsgType: TMessageBoxType;
    procedure SetButtons(const Value: TMessageBoxButtons);
    procedure SetCaptions(const Value: string);
    procedure SetMessages(const Value: string);
    procedure SetMsgType(const Value: TMessageBoxType);
    procedure IniAllComp;
  public
    { Public declarations }
    property Messages: string read FMessages write SetMessages;
    property Captions: string read FCaptions write SetCaptions;
    property MsgType: TMessageBoxType read FMsgType write SetMsgType default mbtInformation;
    property Buttons: TMessageBoxButtons read FButtons write SetButtons;

  end;

const
  ButtonNames: array[TMessageBoxButton] of string = (
    'btnSett', 'btnDraft', 'btnClose', 'btnYes', 'btnNo', 'btnOk', 'btnCancel');
  BtnCaptions: array[TMessageBoxButton] of string = (
    '保存单据(&S)', '存入草稿(&D)', '废弃退出(&X)', '是(&Y)', '否(&N)',
    '确定(&O)', '取消(&C)');
  ModalResults: array[TMessageBoxButton] of Integer = (
    mrSett, mrDraft, mrClose, mrYes, mrNo, mrOk, mrCancel);
  IconIDs: array[TMessageBoxType] of PChar =
  (IDI_EXCLAMATION, IDI_HAND, IDI_ASTERISK, IDI_QUESTION, nil);

var
  frmMsgBox: TfrmMsgBox;

implementation

uses Math, Buttons, StdCtrls;

{$R *.dfm}

{ TfrmMsgBox }

procedure TfrmMsgBox.IniAllComp;
var
  I: Integer;
begin
  for I := 0 to ComponentCount - 1 do
  begin
    if Components[I] is TPanel then
    begin
      TPanel(Components[I]).Color := clWhite;
    end;
  end;
end;

procedure TfrmMsgBox.FormCreate(Sender: TObject);
begin
  IniAllComp();
end;

procedure TfrmMsgBox.SetButtons(const Value: TMessageBoxButtons);
var
  ButtonWidths: array[TMessageBoxButton] of Integer;
  B, DefaultBtn, CancelBtn: TMessageBoxButton;
  TextRect: TRect;
  X, BtnCount, BtnGroupWidth: Integer;
  BtnWidth, BtnHeight, BtnSpace: Integer;
begin
  FButtons := Value;
  BtnCount := 0;
  BtnWidth := 80;                                           //默认BtnWidth
  BtnHeight := 23;                                          //默认BtnHeight
  BtnSpace := 8;                                            //默认BtnSpace
  BtnGroupWidth := 0;
  for B := Low(TMessageBoxButton) to High(TMessageBoxButton) do
  begin
    ButtonWidths[B] := 0;
    if B in FButtons then
    begin
      Inc(BtnCount);
      TextRect := Rect(0, 0, 0, 0);

      Windows.DrawText(pnlBottom.Handle, PChar(BtnCaptions[B]), -1,
        TextRect, DT_CALCRECT or DT_LEFT or DT_SINGLELINE or
        DrawTextBiDiModeFlagsReadingOnly);
      with TextRect do
        ButtonWidths[B] := Right - Left + 16;
      BtnWidth := Max(BtnWidth, ButtonWidths[B]);
    end;
  end;
  if mbbSett in FButtons then
    DefaultBtn := mbbSett
  else if mbbOk in FButtons then
    DefaultBtn := mbbOk
  else if mbbYes in FButtons then
    DefaultBtn := mbbYes;

  if mbbCancel in FButtons then
    CancelBtn := mbbCancel
  else if mbbClose in FButtons then
    CancelBtn := mbbClose
  else if mbbNo in FButtons then
    CancelBtn := mbbNo;
  if BtnCount <> 0 then
    BtnGroupWidth := BtnWidth * BtnCount + BtnSpace * (BtnCount - 1);
  X := (ClientWidth - BtnGroupWidth) div 2;
  for B := Low(TMessageBoxButton) to High(TMessageBoxButton) do
  begin
    if B in FButtons then
      with TBitBtn.Create(Self) do
      begin
        Name := ButtonNames[B];
        Parent := pnlBottom;
        Caption := BtnCaptions[B];
        ModalResult := ModalResults[B];
        if B = DefaultBtn then
          Default := True;
        if B = CancelBtn then
          Cancel := True;
        SetBounds(X, (pnlBottom.ClientHeight - BtnHeight) div 2,
          BtnWidth, BtnHeight);
        Inc(X, BtnWidth + BtnSpace);
      end;
  end;
end;

procedure TfrmMsgBox.SetCaptions(const Value: string);
begin
  if Value = EmptyStr then
    FCaptions := '提示'
  else
    FCaptions := Value;
  Caption := FCaptions;
end;

procedure TfrmMsgBox.SetMessages(const Value: string);
var
  TextRect: TRect;
  MsgHeight, MsgWidth: Integer;
begin
  FMessages := Value;
  with TMemo.Create(Self) do
  begin
    Name := 'Message';
    Parent := pnlClient;
    WordWrap := True;
    Text := FMessages;
    BorderStyle := bsNone;
    Color := pnlClient.Color;
    ReadOnly := True;
    TextRect := Rect(0, 0, pnlClient.Width - 80, pnlClient.Height);
    BiDiMode := pnlClient.BiDiMode;
    Windows.DrawText(pnlClient.Handle, PChar(FMessages),
      Length(FMessages),
      TextRect, DT_EXPANDTABS or DT_CALCRECT or DT_WORDBREAK or
      DrawTextBiDiModeFlagsReadingOnly);
    with TextRect do
    begin
      MsgHeight := Bottom - Top;
      MsgWidth := Right - Left;
    end;
    if MsgHeight > 30 then
      Self.ClientHeight := Self.ClientHeight + MsgHeight - 30;
    if MsgWidth < 100 then
      Self.ClientWidth := Self.ClientWidth + MsgWidth - 260
    else if MsgWidth < 200 then
      Self.ClientWidth := Self.ClientWidth + MsgWidth - 260;
    SetBounds(64, (pnlClient.ClientHeight - MsgHeight) div 2,
      pnlClient.Width - 80, MsgHeight);
  end;
end;

procedure TfrmMsgBox.SetMsgType(const Value: TMessageBoxType);
begin
  FMsgType := Value;
  FIcons := IconIDs[FMsgType];
  if FIcons <> nil then
    with TImage.Create(Self) do
    begin
      Name := 'Image';
      Parent := pnlClient;
      Picture.Icon.Handle := LoadIcon(0, FIcons);
      SetBounds(16, 16, 32, 32);
    end;
end;

end.



