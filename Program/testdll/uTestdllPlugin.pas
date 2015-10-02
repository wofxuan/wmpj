unit uTestdllPlugin;

interface

uses SysUtils, Classes, Windows, uPluginBase;

Type
  TTestdllPlugin = Class(TPlugin)
  private

  protected

  public
    Constructor Create(Intf: IInterface);override;
    Destructor Destroy;override;

    procedure Init; override;
    procedure final; override;
  end;

implementation

uses uOtherIntf, uFactoryIntf, uTestdllInf, uTestdll;

constructor TTestdllPlugin.Create(Intf: IInterface);
begin

end;

destructor TTestdllPlugin.Destroy;
begin

  inherited;
end;

procedure TTestdllPlugin.final;
begin
  inherited;

end;

procedure TTestdllPlugin.Init;
begin
  inherited;
  (Sys as IRegInf).RegObjFactory(ITestdll, gTestInf, False);
end;

end.
