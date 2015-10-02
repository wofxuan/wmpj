unit uFrmMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, StrUtils;

type
  TfrmMain = class(TForm)
    mmoSQLList: TMemo;
    btnDo: TButton;
    procedure btnDoClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

{-------------------------------------------------------------------------------
������:    MakeFileList �����ļ��м����ļ���
����:      SWGWEB
����:      2007.11.25
����:      Path,FileExt:string   1.��Ҫ������Ŀ¼ 2.Ҫ�������ļ���չ��
����ֵ:    TStringList

   Eg��ListBox1.Items:= MakeFileList( 'E:\��Ʒ�ɳ�','.exe') ;
       ListBox1.Items:= MakeFileList( 'E:\��Ʒ�ɳ�','.*') ;
-------------------------------------------------------------------------------}

function MakeFileList(Path, FileExt: string): TStringList;
var
  sch                         : TSearchrec;
begin
  Result := TStringlist.Create;

  if rightStr(trim(Path), 1) <> '\' then
    Path := trim(Path) + '\'
  else
    Path := trim(Path);

  if not DirectoryExists(Path) then
  begin
    Result.Clear;
    exit;
  end;

  if FindFirst(Path + '*', faAnyfile, sch) = 0 then
  begin
    repeat
      Application.ProcessMessages;
      if ((sch.Name = '.') or (sch.Name = '..')) then
        Continue;
      if DirectoryExists(Path + sch.Name) then
      begin
        Result.AddStrings(MakeFileList(Path + sch.Name, FileExt));
      end
      else
      begin
        if (UpperCase(extractfileext(Path + sch.Name)) = UpperCase(FileExt)) or
          (FileExt = '.*') then
          Result.Add(Path + sch.Name);
      end;
    until FindNext(sch) <> 0;
    SysUtils.FindClose(sch);
  end;
end;

procedure TfrmMain.btnDoClick(Sender: TObject);
var
  aFileList, aOneFile, aHBFile: TStringlist;
  aFile: TFileStream;
  aExePath, aFilePath: string;
  i: Integer;
begin
  aExePath := ExtractFilePath(ParamStr(0));
  aFileList := MakeFileList(aExePath + 'DBSQL\Procedure', '.*');
  aOneFile := TStringList.Create;
  aHBFile := TStringList.Create;
  try
    aHBFile.Clear;
    mmoSQLList.Clear;
    mmoSQLList.Lines.Add('��־��');
    for i := 0 to aFileList.Count - 1 do
    begin
      aFilePath := aFileList[i];
      aOneFile.LoadFromFile(aFilePath);
      aHBFile.AddStrings(aOneFile);
      aHBFile.Add('');
      aHBFile.Add('');
      aHBFile.Add('');
      mmoSQLList.Lines.Add(aFilePath + '�Ѻϲ�');
    end;
    aHBFile.SaveToFile(aExePath + 'xxSelf.Sql');
    Application.MessageBox('�ϲ����','��ʾ', mrNone);
    Close;
  finally
    aHBFile.Free;
    aOneFile.Free;
    aFileList.Free;
  end;
end;

end.
