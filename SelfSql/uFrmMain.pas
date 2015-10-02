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
过程名:    MakeFileList 遍历文件夹及子文件夹
作者:      SWGWEB
日期:      2007.11.25
参数:      Path,FileExt:string   1.需要遍历的目录 2.要遍历的文件扩展名
返回值:    TStringList

   Eg：ListBox1.Items:= MakeFileList( 'E:\极品飞车','.exe') ;
       ListBox1.Items:= MakeFileList( 'E:\极品飞车','.*') ;
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
    mmoSQLList.Lines.Add('日志：');
    for i := 0 to aFileList.Count - 1 do
    begin
      aFilePath := aFileList[i];
      aOneFile.LoadFromFile(aFilePath);
      aHBFile.AddStrings(aOneFile);
      aHBFile.Add('');
      aHBFile.Add('');
      aHBFile.Add('');
      mmoSQLList.Lines.Add(aFilePath + '已合并');
    end;
    aHBFile.SaveToFile(aExePath + 'xxSelf.Sql');
    Application.MessageBox('合并完成','提示', mrNone);
    Close;
  finally
    aHBFile.Free;
    aOneFile.Free;
    aFileList.Free;
  end;
end;

end.
