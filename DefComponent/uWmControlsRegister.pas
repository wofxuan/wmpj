unit uWmControlsRegister;

interface

uses
  Classes;

procedure Register;
{ * �ؼ�������༭�������Ա༭��ע����� }

implementation

uses
  uWmLabelEditBtn;

procedure Register;
begin
  RegisterComponents('wmControls', [TWmLabelEditBtn]);
end;

end.

