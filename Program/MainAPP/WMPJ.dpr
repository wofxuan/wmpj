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
  CorePackageHandle: HMODULE;
begin
  Application.Initialize;
  Application.Title := 'WM������';
  Application.HintHidePause := 1000 * 10; //ָ����ʾ��������Ļ����ʾ��ʱ��
  //���غ��İ�
  CorePackageFile := ShortString(ExtractFilePath(Paramstr(0)) + 'Core.bpl');
  if FileExists(string(CorePackageFile)) then
  begin
    CorePackageHandle := LoadPackage(string(CorePackageFile));
    @ProLoad := GetProcAddress(CorePackageHandle, 'Load');
    @ProInit := GetProcAddress(CorePackageHandle, 'Init');

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
    @ProFinal := GetProcAddress(CorePackageHandle, 'Final');
    if Assigned(ProFinal) then
    begin
      try
        ProFinal;
      except
        on E: Exception do
          application.ShowException(E);
      end;
    end;
//    �ͷŰ�
    UnLoadPackage(CorePackageHandle);
  end
  else Application.MessageBox(pchar('�Ҳ�����ܺ��İ�[' + string(CorePackageFile)
      + ']�������޷�������'), '��������', MB_OK + MB_ICONERROR);
end.

