{***************************
����ȫ�ֵ�һЩͼƬ����Դ
mx 2016-10-10
****************************}
unit uDM;

interface

uses
  SysUtils, Classes, ImgList, Controls, Graphics, cxGraphics;

type
  //ͼƬ������
  TImgName = (imDelRow);

  TDMApp = class(TDataModule)
    imglstApp: TcxImageList;
  private
    { Private declarations }
  public
    { Public declarations }
    function GetBitmap(AImgName: TImgName; ABit: TBitmap): Boolean;
  end;

var
  DMApp: TDMApp;

implementation

{$R *.dfm}

{ TDMApp }

function TDMApp.GetBitmap(AImgName: TImgName; ABit: TBitmap): Boolean;
begin
  Result := False;
  case AImgName of
    imDelRow: Result := imglstApp.GetBitmap(0, ABit);
  else

  end;

end;

initialization
  dmApp := TDMApp.Create(nil);

finalization
  dmApp.Free;

end.

