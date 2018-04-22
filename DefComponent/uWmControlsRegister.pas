unit uWmControlsRegister;

interface

uses
  Classes;

procedure Register;
{ * 控件、组件编辑器、属性编辑器注册过程 }

implementation

uses
  uWmLabelEditBtn;

procedure Register;
begin
  RegisterComponents('wmControls', [TWmLabelEditBtn]);
end;

end.

