program Testmxpj;

uses
  Forms,
  SysUtils,
  Windows,
  uFrmTest in 'uFrmTest.pas' {FrmTest};

{$R *.res}

var
  CorePackageFile:String[255];//这里如果声明成长字符串型(string)FastMM会检测到有内存泄漏
  ProLoad:TLoad;
  ProInit:TInit;
  ProFinal:TFinal;
  FCorePackageHandle: HMODULE;
begin
  Application.Initialize;
  Application.Title := '框架主程序';
  Application.HintHidePause:=1000*30;
  Application.CreateForm(TFrmTest, FrmTest);
  //加载核心包
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
    //程序结束
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
    //释放包
    UnLoadPackage(FCorePackageHandle);
  end
  else Application.MessageBox(pchar('找不到框架核心包['+String(CorePackageFile)
     +']，程序无法启动！'),'启动错误',MB_OK+MB_ICONERROR);
end.
