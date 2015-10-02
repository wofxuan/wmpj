program Testmxpj;

uses
  Forms,
  SysUtils,
  Windows,
  uFrmTest in 'uFrmTest.pas' {FrmTest};

{$R *.res}

var
  CorePackageFile:String[255];//������������ɳ��ַ�����(string)FastMM���⵽���ڴ�й©
  ProLoad:TLoad;
  ProInit:TInit;
  ProFinal:TFinal;
  FCorePackageHandle: HMODULE;
begin
  Application.Initialize;
  Application.Title := '���������';
  Application.HintHidePause:=1000*30;
  Application.CreateForm(TFrmTest, FrmTest);
  //���غ��İ�
  CorePackageFile:=ShortString(ExtractFilePath(Paramstr(0))+'Core.bpl');
  if FileExists(String(CorePackageFile)) then
  begin
    FCorePackageHandle:=LoadPackage(String(CorePackageFile));
    @ProLoad:=GetProcAddress(FCorePackageHandle,'Load');
    @ProInit:=GetProcAddress(FCorePackageHandle,'Init');

    if assigned(ProLoad) then
    begin
      Try
        ProLoad(FrmTest);
      Except
        on E:Exception do
          application.ShowException(E);
      End;
    end;

    if assigned(ProInit) then
    begin
      try
        ProInit;
      Except
        on E:Exception do
          application.ShowException(E);
      end;
    end;

    Application.Run;
    //�������
    @ProFinal:=GetProcAddress(FCorePackageHandle,'Final');
    if assigned(ProFinal) then
    begin
      try
        ProFinal;
      Except
        on E:Exception do
          application.ShowException(E);
      end;
    end;
    //�ͷŰ�
    UnLoadPackage(FCorePackageHandle);
  end
  else Application.MessageBox(pchar('�Ҳ�����ܺ��İ�['+String(CorePackageFile)
     +']�������޷�������'),'��������',MB_OK+MB_ICONERROR);
end.
