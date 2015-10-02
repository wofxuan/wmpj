unit uTestPlugin;

interface

uses SysUtils, Classes, Windows, uPluginBase;

Type
  TTestPlugin = Class(TPlugin)
  private

  protected

  public
    Constructor Create(Intf: IInterface);override;
    Destructor Destroy;override;

    procedure Init; override;
    procedure final; override;
  end;

implementation

constructor TTestPlugin.Create(Intf: IInterface);
begin

end;

destructor TTestPlugin.Destroy;
begin

  inherited;
end;

procedure TTestPlugin.final;
begin
  inherited;

end;

procedure TTestPlugin.Init;
begin
  inherited;

end;

end.
