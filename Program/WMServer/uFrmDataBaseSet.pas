unit uFrmDataBaseSet;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TfrmDataBaseSet = class(TForm)
    lbl1: TLabel;
    lbl2: TLabel;
    lbl3: TLabel;
    edtAddr: TEdit;
    edtUser: TEdit;
    edtPassWord: TEdit;
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
  frmDataBaseSet: TfrmDataBaseSet;

implementation

uses IniFiles, WMFBData_Impl;

{$R *.dfm}

procedure TfrmDataBaseSet.LoadCfg;
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
    edtAddr.Text := aIni.ReadString('DataBase', 'ServerAddr', '127.0.0.1');
    edtPassWord.Text := aIni.ReadString('DataBase', 'Password', '123456');
    edtUser.Text := aIni.ReadString('DataBase', 'User', 'sa');
  finally
    aIni.Free;
  end;
end;

function TfrmDataBaseSet.SaveCfg: Boolean;
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
    aIni.WriteString('DataBase', 'ServerAddr', Trim(edtAddr.Text));
    aIni.WriteString('DataBase', 'Password', Trim(edtPassWord.Text));
    aIni.WriteString('DataBase', 'User', Trim(edtUser.Text));
    Result := True;
  finally
    aIni.Free;
  end;
end;

procedure TfrmDataBaseSet.btnOkClick(Sender: TObject);
begin
  if SaveCfg() then
    ModalResult := mrOk;
end;

procedure TfrmDataBaseSet.FormShow(Sender: TObject);
begin
  LoadCfg();
end;

end.
