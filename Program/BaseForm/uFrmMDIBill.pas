unit uFrmMDIBill;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uFrmMDI, ComCtrls, cxStyles, cxCustomData, cxGraphics,
  cxFilter, cxData, cxDataStorage, cxEdit, dxBar, dxBarExtItems, cxClasses,
  ImgList, ActnList, DB, DBClient, cxGridLevel, cxControls,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGrid,
  cxContainer, cxTreeView, ExtCtrls, cxLabel, cxDropDownEdit, cxCalendar,
  cxTextEdit, cxMaskEdit, cxButtonEdit;

type
  TfrmMDIBill = class(TfrmMDI)
    pnlBillTitle: TPanel;
    pnlBillMaster: TPanel;
    lblBillTitle: TcxLabel;
    edtBillNumber: TcxButtonEdit;
    deBillDate: TcxDateEdit;
    lblBillDate: TcxLabel;
    lblBillNumber: TcxLabel;
    btnNewBill: TdxBarLargeButton;
    actNewBill: TAction;
  private
    { Private declarations }
  protected
    procedure BeforeFormShow; override;
    procedure BeforeFormDestroy; override;
    
    procedure InitParamList; override;

    function LoadBillDataMaster: Boolean; virtual;
    function LoadBillDataGrid: Boolean; virtual;

    procedure InitMasterTitles(Sender: TObject); virtual; //初始化表头
    procedure InitGrids(Sender: TObject); virtual; //初始化表体
    procedure InitMenuItem(Sender: TObject); virtual; //初始化右建菜单
    procedure InitOthers(Sender: TObject); virtual; ////初始化其它
  public
    { Public declarations }
  end;

var
  frmMDIBill: TfrmMDIBill;

implementation

uses uSysSvc, uBaseFormPlugin, uMoudleNoDef, uParamObject, uModelControlIntf,
     uBaseInfoDef, uDefCom, uGridConfig, uFrmApp;

{$R *.dfm}

{ TfrmMDIBill }

procedure TfrmMDIBill.BeforeFormDestroy;
begin
  inherited;

end;

procedure TfrmMDIBill.BeforeFormShow;
begin
  inherited;
  FGridItem.OnSelectBasic := DoSelectBasic;
  FGridItem.SetGridCellSelect(True);
  
  InitMasterTitles(Self);
  InitGrids(self);
  InitMenuItem(self);
  InitOthers(self);
end;

procedure TfrmMDIBill.InitGrids(Sender: TObject);
begin

end;

procedure TfrmMDIBill.InitMasterTitles(Sender: TObject);
begin

end;

procedure TfrmMDIBill.InitMenuItem(Sender: TObject);
begin

end;

procedure TfrmMDIBill.InitOthers(Sender: TObject);
begin

end;

procedure TfrmMDIBill.InitParamList;
begin
  inherited;

end;

function TfrmMDIBill.LoadBillDataGrid: Boolean;
begin

end;

function TfrmMDIBill.LoadBillDataMaster: Boolean;
begin

end;

end.
