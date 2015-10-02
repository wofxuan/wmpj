program WMPJ;

uses
  Forms,
  sysUtils,
  Windows,
  uPackageExport,
  uFrmWMPG in 'uFrmWMPG.pas' {FrmWMPG},
  uSysMenu in 'uSysMenu.pas';

{$R *.res}

var
  CorePackageFile: string[255]; //������������ɳ��ַ�����(string)FastMM���⵽���ڴ�й©
  DBPackageFile: string[255];
  ProLoad: TLoad;
  ProInit: TInit;
  ProFinal: TFinal;
  FCorePackageHandle: HMODULE;
  FDBPackageHandle: HMODULE;
begin
  Application.Initialize;
  Application.Title := 'WM������';
  Application.HintHidePause := 1000 * 10; //ָ����ʾ��������Ļ����ʾ��ʱ��
  //���غ��İ�
  CorePackageFile := ShortString(ExtractFilePath(Paramstr(0)) + 'Core.bpl');
  DBPackageFile := ShortString(ExtractFilePath(Paramstr(0)) + 'DBAccess.bpl');
  if FileExists(string(CorePackageFile)) then
  begin
    FCorePackageHandle := LoadPackage(string(CorePackageFile));
    FDBPackageHandle := LoadPackage(string(DBPackageFile));
    @ProLoad := GetProcAddress(FCorePackageHandle, 'Load');
    @ProInit := GetProcAddress(FCorePackageHandle, 'Init');

    Application.CreateForm(TFrmWMPG, FrmWMPG);//Ҫ�ڳ�ʼ��Core�󴴽�����Ȼ����ע��IMainForm
    
    if assigned(ProLoad) then
    begin
      try
        ProLoad(FrmWMPG);
      except
        on E: Exception do
        begin
          application.ShowException(E);
          Exit;
        end;
      end;
    end;

    if assigned(ProInit) then
    begin
      try
        ProInit;
      except
        on E: Exception do
          application.ShowException(E);
      end;
    end;

    Application.Run;
//    �������
    @ProFinal := GetProcAddress(FCorePackageHandle, 'Final');
    if assigned(ProFinal) then
    begin
      try
        ProFinal;
      except
        on E: Exception do
          application.ShowException(E);
      end;
    end;
//    �ͷŰ�
    UnLoadPackage(FCorePackageHandle);
  end
  else Application.MessageBox(pchar('�Ҳ�����ܺ��İ�[' + string(CorePackageFile)
      + ']�������޷�������'), '��������', MB_OK + MB_ICONERROR);
end.

