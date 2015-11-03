unit uFrmMDIBase;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, cxStyles, cxCustomData,
  cxGraphics, cxFilter, cxData, cxDataStorage, cxEdit, DB, cxDBData,
  cxGridLevel, cxClasses, cxControls, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid,
  uFrmParent, DBClient, ActnList, metelese, uGridConfig, uDBIntf, ComCtrls,
  cxContainer, cxTreeView;

type
  TfrmMDIBase = class(TfrmParent)
    pnlTop: TPanel;
    pnlBottom: TPanel;
    pnlTV: TPanel;
    gridDTVMainShow: TcxGridDBTableView;
    gridLVMainShow: TcxGridLevel;
    gridMainShow: TcxGrid;
    dsMainShow: TDataSource;
    cdsMainShow: TClientDataSet;
    tvClass: TcxTreeView;
    splOP: TSplitter;
  private
    procedure SetTVVisble(const Value: Boolean); //树表是否显示 调用此函数应该在IniGridData内
    function GetTVVisble: Boolean;
  protected
    { Private declarations }
    FGridItem: TGridItem;
    FDBAC: IDBAccess;

    procedure IniGridField; virtual;
    procedure LoadGridData(ATypeid: string = ''); virtual;

    procedure BeforeFormShow; override;
    procedure BeforeFormDestroy; override;
    procedure InitParamList; override;
  public
    { Public declarations }
    property TVVisble: boolean read GetTVVisble write SetTVVisble;
  end;

var
  frmMDIBase: TfrmMDIBase;

implementation

uses uSysSvc, uMoudleNoDef, uFrmApp;

{$R *.dfm}

{ TfrmMDIBase }

procedure TfrmMDIBase.BeforeFormDestroy;
begin
  inherited;
  FGridItem.Free;
end;

procedure TfrmMDIBase.BeforeFormShow;
begin
  inherited;
  FGridItem := TGridItem.Create(MoudleNo ,gridMainShow, gridDTVMainShow);
  FDBAC := SysService as IDBAccess;
end;

function TfrmMDIBase.GetTVVisble: Boolean;
begin
  Result := pnlTV.Visible;
end;

procedure TfrmMDIBase.IniGridField;
begin

end;

procedure TfrmMDIBase.InitParamList;
begin
  inherited;

end;

procedure TfrmMDIBase.LoadGridData(ATypeid: string);
begin

end;

procedure TfrmMDIBase.SetTVVisble(const Value: Boolean);
begin
  pnlTV.Visible := Value;
end;

end.
