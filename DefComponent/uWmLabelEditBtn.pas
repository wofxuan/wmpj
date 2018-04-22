unit uWmLabelEditBtn;

interface

uses Classes, Messages, StdCtrls, Controls, Graphics, Types, Windows, Forms,
  cxContainer, cxEdit, cxMaskEdit, cxButtonEdit, cxControls;

type
  TLabelPosition = (lpLeftTop, lpLeftCenter, lpLeftBottom, lpTopLeft,
    lpBottomLeft, lpLeftTopLeft, lpLeftCenterLeft, lpLeftBottomLeft,
    lpTopCenter, lpBottomCenter, lpRightTop, lpRightCenter, lpRighBottom,
    lpTopRight, lpBottomRight);

  TEditLabel = class(TLabel)
  private
    FAlwaysEnable: boolean;
    procedure CMEnabledChanged(var Msg: TMessage); message CM_ENABLEDCHANGED;
  published
    property AlwaysEnable: boolean read FAlwaysEnable write FAlwaysEnable;
  end;

  TWmLabelEditBtn = class(TcxButtonEdit)
  private
    FLabel: TEditLabel;
    FLabelFont: TFont;
    FLabelPosition: TLabelPosition;
    FLabelMargin: Integer;
    FLabelTransparent: boolean;
    FLabelAlwaysEnabled: boolean;
    FOnLabelClick: TNotifyEvent;
    FOnLabelDblClick: TNotifyEvent;
    FParentFnt: boolean;
    FShowError: boolean;
    FFocusLabel: boolean;
    FLoadedHeight: Integer;

    procedure SetLabelCaption(const value: string);
    function GetLabelCaption: string;
    procedure SetLabelPosition(const value: TLabelPosition);
    procedure SetLabelMargin(const value: Integer);
    procedure SetLabelTransparent(const value: boolean);
    procedure SetLabelAlwaysEnabled(const value: boolean);
    procedure SetLabelFont(const value: TFont);
    function GetHeightEx: Integer;
    procedure UpdateLabel;
    procedure UpdateLabelPos;
    procedure CMParentFontChanged(var Message: TMessage); message CM_PARENTFONTCHANGED;
    procedure SetHeightEx(const Value: Integer);
    procedure WMSetFocus(var Msg: TWMSetFocus); message WM_SETFOCUS;
    procedure WMKillFocus(var Msg: TWMKillFocus); message WM_KILLFOCUS;
  protected
    function CreateLabel: TEditLabel;
    procedure LabelClick(Sender: TObject);
    procedure LabelDblClick(Sender: TObject);
    procedure Loaded; override;
  public
    constructor Create(aOwner: TComponent); override;
    destructor Destroy; override;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
  published
    property Anchors;
    property AutoSize;
    property BeepOnEnter;
    property Constraints;
    property DragMode;
    property Enabled;
    property Height: Integer read GetHeightEx write SetHeightEx;
    property FocusLabel: boolean read FFocusLabel write FFocusLabel default false;
    property LabelCaption: string read GetLabelCaption write SetLabelCaption;
    property LabelPosition: TLabelPosition read FLabelPosition write SetLabelPosition default lpLeftCenter;
    property LabelMargin: Integer read FLabelMargin write SetLabelMargin default 4;
    property LabelTransparent: boolean read FLabelTransparent write SetLabelTransparent default false;
    property LabelAlwaysEnabled: boolean read FLabelAlwaysEnabled write SetLabelAlwaysEnabled default false;
    property LabelFont: TFont read FLabelFont write SetLabelFont;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property Properties;
    property ShowHint;
    property Style;
    property StyleDisabled;
    property StyleFocused;
    property StyleHot;
    property TabOrder;
    property TabStop;
    property Text;
    property Visible;
    property DragCursor;
    property DragKind;
    property ImeMode;
    property ImeName;
    property OnClick;
    property OnContextPopup;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEditing;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDrag;
    property OnEndDock;
    property OnStartDock;
    property OnLabelClick: TNotifyEvent read FOnLabelClick write FOnLabelClick;
    property OnLabelDblClick: TNotifyEvent read FOnLabelDblClick write FOnLabelDblClick;
    property ShowError: boolean read FShowError write FShowError default false;
  end;

implementation

{ TEditLabel }

procedure TEditLabel.CMEnabledChanged(var Msg: TMessage);
begin
  inherited;
  if AlwaysEnable and not Enabled then
    Enabled := true;
end;

{ TWmLabelEditBtn }

procedure TWmLabelEditBtn.CMParentFontChanged(var Message: TMessage);
begin
  inherited;
  if Assigned(FLabel) and not ShowError and ParentFont then
  begin
    FLabel.Font.Assign(Font);
    UpdateLabel;
  end;
end;

constructor TWmLabelEditBtn.Create(aOwner: TComponent);
begin
  inherited Create(aOwner);

  FLabelPosition := lpLeftCenter;
  FLabel := nil;
  FLabelMargin := 4;
  FLabelFont := TFont.Create;
  // FLabelFont.OnChange := LabelFontChange;
  FParentFnt := false;
end;

function TWmLabelEditBtn.CreateLabel: TEditLabel;
begin
  Result := TEditLabel.Create(self);
  Result.Parent := Parent;
  Result.FocusControl := self;
  Result.Font.Assign(LabelFont);
  Result.OnClick := LabelClick;
  Result.OnDblClick := LabelDblClick;
  Result.ParentFont := ParentFont;
end;

destructor TWmLabelEditBtn.Destroy;
begin
  if (FLabel <> nil) then
  begin
    FLabel.Parent := nil;
    FLabel.Free;
    FLabel := nil;
  end;

  FLabelFont.Free;

  inherited Destroy;
end;

function TWmLabelEditBtn.GetHeightEx: Integer;
begin
  Result := inherited Height;
end;

function TWmLabelEditBtn.GetLabelCaption: string;
begin
  if FLabel <> nil then
    Result := FLabel.Caption
  else
    Result := '';
end;

procedure TWmLabelEditBtn.LabelClick(Sender: TObject);
begin
  if Assigned(FOnLabelClick) then
    FOnLabelClick(self);
end;

procedure TWmLabelEditBtn.LabelDblClick(Sender: TObject);
begin
  if Assigned(FOnLabelDblClick) then
    FOnLabelDblClick(self);
end;

procedure TWmLabelEditBtn.Loaded;
begin
  inherited Loaded;

  if not (csDesigning in ComponentState) then
    if FLabel <> nil then UpdateLabel;

  Height := FLoadedHeight;
  SetBounds(Left, Top, Width, Height);

  if not LabelAlwaysEnabled and Assigned(FLabel) then
  begin
    FLabel.Enabled := Enabled;
    FLabel.AlwaysEnable := LabelAlwaysEnabled;
  end;

  if (FLabel <> nil) then
    UpdateLabel;

  if ParentFont and not ShowError and Assigned(FLabel) then
  begin
    FLabel.Font.Assign(Font);
  end;

  FParentFnt := ParentFont;

  if (FLabel <> nil) then
    UpdateLabel;
end;

procedure TWmLabelEditBtn.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
begin
  if Assigned(FLabel) then
  begin
    case LabelPosition of
      lpLeftTop, lpLeftCenter, lpLeftBottom:
        begin
          if (Align in [alTop, alClient, alBottom]) then
          begin
            AWidth := AWidth - (FLabel.Width + LabelMargin);
            ALeft := ALeft + (FLabel.Width + LabelMargin);
          end;
        end;
      lpRightTop, lpRightCenter, lpRighBottom:
        begin
          if (Align in [alTop, alClient, alBottom]) then
            AWidth := AWidth - (FLabel.Width + LabelMargin);
        end;
      lpTopLeft, lpTopCenter, lpTopRight:
        begin
          if (Align in [alTop, alClient, alRight, alLeft]) then
            ATop := ATop + FLabel.Height;
        end;
    end;
  end;

  inherited SetBounds(ALeft, ATop, AWidth, AHeight);

  if (FLabel <> nil) then
  begin
    if (FLabel.Parent <> nil) then
      UpdateLabel;
  end;
end;

procedure TWmLabelEditBtn.SetHeightEx(const Value: Integer);
begin
  if (csLoading in ComponentState) then
    FLoadedHeight := Value;
  inherited Height := Value;
end;

procedure TWmLabelEditBtn.SetLabelAlwaysEnabled(const value: boolean);
begin
  FLabelAlwaysEnabled := value;
  if Assigned(FLabel) then
  begin
    if value then
      FLabel.Enabled := true;
    FLabel.AlwaysEnable := value;
  end;
  Invalidate;
end;

procedure TWmLabelEditBtn.SetLabelCaption(const value: string);
begin
  if FLabel = nil then
    FLabel := CreateLabel;
  FLabel.Caption := value;
  UpdateLabel;
end;

procedure TWmLabelEditBtn.SetLabelFont(const value: TFont);

begin
  FLabelFont := value;
end;

procedure TWmLabelEditBtn.SetLabelMargin(const value: Integer);
begin
  FLabelMargin := Value;
  if FLabel <> nil then UpdateLabel;
end;

procedure TWmLabelEditBtn.SetLabelPosition(const value: TLabelPosition);
begin
  FLabelPosition := Value;
  if FLabel <> nil then UpdateLabel;
end;

procedure TWmLabelEditBtn.SetLabelTransparent(const value: boolean);
begin
  FLabelTransparent := Value;
  if FLabel <> nil then UpdateLabel;
end;

procedure TWmLabelEditBtn.UpdateLabel;
begin
  if Assigned(FLabel.Parent) then
  begin
    FLabel.Transparent := FLabelTransparent;

    if not FParentFnt or ShowError then
    begin
      FLabel.Font.Assign(FLabelFont);
    end
    else
      FLabel.Font.Assign(Font);

    if FocusLabel then
    begin
      if Focused then
        FLabel.Font.Style := FLabel.Font.Style + [fsBold]
      else
        FLabel.Font.Style := FLabel.Font.Style - [fsBold];
    end;

    if FLabel.Parent.HandleAllocated then
      UpdateLabelPos;
  end;
end;

procedure TWmLabelEditBtn.UpdateLabelPos;
var
  tw, brdr: Integer;
  r: TRect;
begin
  r := Rect(0, 0, 1000, 255);
  DrawText(FLabel.Canvas.Handle, PChar(FLabel.Caption), Length(FLabel.Caption),
    r, DT_HIDEPREFIX or DT_CALCRECT);
  tw := r.Right;

  brdr := 0;
  if BorderStyle = cxcbsNone then
    brdr := 2;

  case FLabelPosition of
    lpLeftTop:
      begin
        FLabel.Top := self.Top;
        FLabel.Left := self.Left - tw - FLabelMargin;
      end;
    lpLeftCenter:
      begin
        if self.Height > FLabel.Height then
          FLabel.Top := Top + ((Height - brdr - FLabel.Height) div 2)
        else
          FLabel.Top := Top - ((FLabel.Height - Height + brdr) div 2);

        FLabel.Left := Left - tw - FLabelMargin;
      end;
    lpLeftBottom:
      begin
        FLabel.Top := self.Top + self.Height - FLabel.Height;
        FLabel.Left := self.Left - tw - FLabelMargin;
      end;
    lpTopLeft:
      begin
        FLabel.Top := self.Top - FLabel.Height - FLabelMargin;
        FLabel.Left := self.Left;
      end;
    lpTopRight:
      begin
        FLabel.Top := self.Top - FLabel.Height - FLabelMargin;
        FLabel.Left := self.Left + self.Width - FLabel.Width;
      end;
    lpTopCenter:
      begin
        FLabel.Top := self.Top - FLabel.Height - FLabelMargin;
        if self.Width - FLabel.Width > 0 then
          FLabel.Left := self.Left + ((self.Width - FLabel.Width) div 2)
        else
          FLabel.Left := self.Left - ((FLabel.Width - self.Width) div 2)
      end;
    lpBottomLeft:
      begin
        FLabel.Top := self.Top + self.Height + FLabelMargin;
        FLabel.Left := self.Left;
      end;
    lpBottomCenter:
      begin
        FLabel.Top := self.Top + self.Height + FLabelMargin;
        if self.Width - FLabel.Width > 0 then
          FLabel.Left := self.Left + ((self.Width - FLabel.Width) div 2)
        else
          FLabel.Left := self.Left - ((FLabel.Width - self.Width) div 2)
      end;
    lpBottomRight:
      begin
        FLabel.Top := self.Top + self.Height + FLabelMargin;
        FLabel.Left := self.Left + self.Width - FLabel.Width;
      end;
    lpLeftTopLeft:
      begin
        FLabel.Top := self.Top;
        FLabel.Left := self.Left - FLabelMargin;
      end;
    lpLeftCenterLeft:
      begin
        if self.Height > FLabel.Height then
          FLabel.Top := self.Top + ((Height - brdr - FLabel.Height) div 2)
        else
          FLabel.Top := self.Top - ((FLabel.Height - Height + brdr) div 2);
        FLabel.Left := self.Left - FLabelMargin;
      end;
    lpLeftBottomLeft:
      begin
        FLabel.Top := self.Top + self.Height - FLabel.Height;
        FLabel.Left := self.Left - FLabelMargin;
      end;
    lpRightTop:
      begin
        FLabel.Top := self.Top;
        FLabel.Left := self.Left + self.Width + FLabelMargin;
      end;
    lpRightCenter:
      begin
        if self.Height > FLabel.Height then
          FLabel.Top := Top + ((Height - brdr - FLabel.Height) div 2)
        else
          FLabel.Top := Top - ((FLabel.Height - Height + brdr) div 2);

        FLabel.Left := self.Left + self.Width + FLabelMargin;
      end;
    lpRighBottom:
      begin
        FLabel.Top := self.Top + self.Height - FLabel.Height;
        FLabel.Left := self.Left + self.Width + FLabelMargin;
      end;
  end;

  FLabel.Visible := Visible;
end;

procedure TWmLabelEditBtn.WMKillFocus(var Msg: TWMKillFocus);
begin
  if (csLoading in ComponentState) then
    Exit;

  if FFocusLabel and (FLabel <> nil) then
  begin
    FLabel.Font.Style := FLabel.Font.Style - [fsBold];
    UpdateLabelPos;
  end;

  inherited;
end;

procedure TWmLabelEditBtn.WMSetFocus(var Msg: TWMSetFocus);
begin
  if csLoading in ComponentState then
    Exit;

  inherited;

  if FFocusLabel and (FLabel <> nil) then
  begin
    FLabel.Font.Style := FLabel.Font.Style + [fsBold];
    UpdateLabelPos;
  end;
end;

end.
