unit uFrmTest;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TLoad=procedure (Intf:IInterface);//���ذ������
  TInit=procedure ;//��ʼ����(�������а�����ã�
  TFinal=procedure;//�����˳�ǰ����

  TFrmTest = class(TForm)
    btnLoad: TButton;
    procedure btnLoadClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmTest: TFrmTest;

implementation

{$R *.dfm}

procedure TFrmTest.btnLoadClick(Sender: TObject);
var
  aCoreHandle: THandle;
  aCorePath: string;
  ProLoad:TLoad;
  ProInit:TInit;
begin
  aCorePath := ExtractFilePath(Paramstr(0))+'Core.bpl';
  aCoreHandle := LoadPackage(aCorePath);
  try
    @ProLoad:=GetProcAddress(aCoreHandle,'Load');
    @ProInit:=GetProcAddress(aCoreHandle,'Init');
    ProLoad(nil);
    ProInit;
  finally
    UnLoadPackage(aCoreHandle);
  end;
end;

end.
