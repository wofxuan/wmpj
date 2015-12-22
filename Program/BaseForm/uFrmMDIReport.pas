unit uFrmMDIReport;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uFrmMDI, cxStyles, cxCustomData, cxGraphics, cxFilter, cxData,
  cxDataStorage, cxEdit, dxBar, dxBarExtItems, cxClasses, ImgList,
  ActnList, DB, DBClient, cxGridLevel, cxControls, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGrid, ExtCtrls, uModelBaseIntf;

type
  TfrmMDIRepor = class(TfrmMDI)
  private
    { Private declarations }
  protected
    FModelReport: IModelReport;

    procedure LoadGridData(ATypeid: string = ''); override;
  public
    { Public declarations }
  end;

var
  frmMDIRepor: TfrmMDIRepor;

implementation

{$R *.dfm}

{ TfrmMDIRepor }

procedure TfrmMDIRepor.LoadGridData(ATypeid: string);
begin
  inherited;
  FModelReport.LoadGridData(nil, cdsMainShow);
  FGridItem.LoadData(cdsMainShow);
end;

end.
