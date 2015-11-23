unit uFrmServerSet;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TfrmServerSet = class(TForm)
    lbl1: TLabel;
    edtPort: TEdit;
    btnOk: TButton;
    btnCancel: TButton;
    procedure btnOkClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    function SaveCfg: Boolean;
    procedure LoadCfg;
  public
    { Public declarations }
  end;

var
  frmServerSet: TfrmServerSet;

implementation

uses IniFiles, WMFBData_Impl;

{$R *.dfm}

procedure TfrmServerSet.LoadCfg;
var
  aFilePath: string;
  aIni: TIniFile;
begin
  aFilePath := ExtractFilePath(ParamStr(0)) + ServerCfgFile;
  if not FileExists(aFilePath) then
  begin
    FileCreate(aFilePath)
  end;
  aIni := TIniFile.Create(aFilePath);
  try
    edtPort.Text := IntToStr(aIni.ReadInteger('Server', 'Port', 8099));
  finally
    aIni.Free;
  end;
end;

function TfrmServerSet.SaveCfg: Boolean;
var
  aFilePath: string;
  aIni: TIniFile;
begin
  Result := False;
  aFilePath := ExtractFilePath(ParamStr(0)) + ServerCfgFile;
  if not FileExists(aFilePath) then
  begin
    FileCreate(aFilePath)
  end;
  aIni := TIniFile.Create(aFilePath);
  try
    aIni.WriteInteger('Server', 'Port', StrToIntDef(Trim(edtPort.Text), 8099));
    Result := True;
  finally
    aIni.Free;
  end;
end;

procedure TfrmServerSet.btnOkClick(Sender: TObject);
begin
  if SaveCfg() then
    ModalResult := mrOk;
end;

procedure TfrmServerSet.FormShow(Sender: TObject);
begin
  LoadCfg();
end;

end.
