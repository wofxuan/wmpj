unit uFrmMDIReport;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uFrmMDI, cxStyles, cxCustomData, cxGraphics, cxFilter, cxData,
  cxDataStorage, cxEdit, dxBar, dxBarExtItems, cxClasses, ImgList,
  ActnList, DB, DBClient, cxGridLevel, cxControls, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGrid, ExtCtrls, uModelBaseIntf, uParamObject;

type
  TfrmMDIReport = class(TfrmMDI)
  private
    { Private declarations }
  protected
    FModelReport: IModelReport;

    procedure LoadGridData(ATypeid: string = ''); override;
    procedure BeforeFormShow; override;

    function GetQryParam(AParam: TParamObject): Boolean; virtual;//获取报表查询的参数
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

function TfrmMDIReport.GetQryParam(AParam: TParamObject): Boolean;
begin
  Result := True;
end;

procedure TfrmMDIReport.LoadGridData(ATypeid: string);
var
  aQryParam: TParamObject;
begin
  inherited;
  aQryParam := TParamObject.Create;
  try
    if GetQryParam(aQryParam) then
    begin
      FModelReport.LoadGridData(aQryParam, cdsMainShow);
      FGridItem.LoadData(cdsMainShow);
    end;
  finally
    aQryParam.Free;
  end;
end;

end.
