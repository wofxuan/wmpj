unit uFrmMDIReport;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uFrmMDI, cxStyles, cxCustomData, cxGraphics, cxFilter, cxData,
  cxDataStorage, cxEdit, dxBar, dxBarExtItems, cxClasses, ImgList,
  ActnList, DB, DBClient, cxGridLevel, cxControls, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGrid, ExtCtrls, uModelBaseIntf;

type
  TfrmMDIReport = class(TfrmMDI)
  private
    { Private declarations }
  protected
    FModelReport: IModelReport;

    procedure LoadGridData(ATypeid: string = ''); override;
    procedure BeforeFormShow; override;
  public
    { Public declarations }

  end;

var
  frmMDIReport: TfrmMDIReport;

implementation

uses uDefCom;

{$R *.dfm}

{ TfrmMDIRepor }

procedure TfrmMDIReport.BeforeFormShow;
begin
  inherited;
  IniGridField();
  LoadGridData(ROOT_ID);
end;

procedure TfrmMDIReport.LoadGridData(ATypeid: string);
begin
  inherited;
  FModelReport.LoadGridData(nil, cdsMainShow);
  FGridItem.LoadData(cdsMainShow);
end;

end.
