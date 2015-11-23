unit uFrmTest;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, cxStyles, cxCustomData,
  cxGraphics, cxFilter, cxData, cxDataStorage, cxEdit, DB, cxDBData,
  cxGridLevel, cxClasses, cxControls, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid,
  uFrmMDI, ActnList, DBClient, dxBar, dxBarExtItems, ImgList;

type
  TFrmTest = class(TfrmMDI)
    procedure btn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmTest: TFrmTest;

implementation

uses uBaseFormPlugin, uParamObject, uMoudleNoDef;

{$R *.dfm}

procedure TFrmTest.btn1Click(Sender: TObject);
begin
  inherited;
  ShowMessage('asd');
end;


initialization
  gFormManage.RegForm(TFrmTest, fnMdlTTest);

end.
