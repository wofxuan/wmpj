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
  CorePackageFile: string[255]; //这里如果声明成长字符串型(string)FastMM会检测到有内存泄漏
  DBPackageFile: string[255];
  ProLoad: TLoad;
  ProInit: TInit;
  ProFinal: TFinal;
  FCorePackageHandle: HMODULE;
  FDBPackageHandle: HMODULE;
begin
  Application.Initialize;
  Application.Title := 'WM主程序';
  Application.HintHidePause := 1000 * 10; //指定提示窗口在屏幕上显示的时间
  //加载核心包
  CorePackageFile := ShortString(ExtractFilePath(Paramstr(0)) + 'Core.bpl');
  DBPackageFile := ShortString(ExtractFilePath(Paramstr(0)) + 'DBAccess.bpl');
  if FileExists(string(CorePackageFile)) then
  begin
    FCorePackageHandle := LoadPackage(string(CorePackageFile));
    FDBPackageHandle := LoadPackage(string(DBPackageFile));
    @ProLoad := GetProcAddress(FCorePackageHandle, 'Load');
    @ProInit := GetProcAddress(FCorePackageHandle, 'Init');

    Application.CreateForm(TFrmWMPG, FrmWMPG);//要在初始化Core后创建，不然不能注册IMainForm
    
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
//    程序结束
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
//    释放包
    UnLoadPackage(FCorePackageHandle);
  end
  else Application.MessageBox(pchar('找不到框架核心包[' + string(CorePackageFile)
      + ']，程序无法启动！'), '启动错误', MB_OK + MB_ICONERROR);
end.

