unit uFrmMDI;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, cxStyles, cxCustomData,
  cxGraphics, cxFilter, cxData, cxDataStorage, cxEdit, DB, cxDBData,
  cxGridLevel, cxClasses, cxControls, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid,
  uFrmParent, DBClient, ActnList, metelese, uGridConfig, uDBIntf, ComCtrls,
  cxContainer, cxTreeView, uModelBaseIntf, Menus, cxLookAndFeelPainters,
  cxButtons, uDefCom, dxBar, ImgList, dxBarExtItems, uModelFunIntf;

type
  TfrmMDI = class(TfrmParent)
    pnlTop: TPanel;
    gridLVMainShow: TcxGridLevel;
    gridMainShow: TcxGrid;
    dsMainShow: TDataSource;
    cdsMainShow: TClientDataSet;
    splOP: TSplitter;
    imglstBtn: TcxImageList;
    actClose: TAction;
    bmList: TdxBarManager;
    barTool: TdxBar;
    btnClose: TdxBarLargeButton;
    gridTVMainShow: TcxGridTableView;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure actCloseExecute(Sender: TObject);
  private
    function FrmShowStyle: TShowStyle; override;
  protected
    { Private declarations }
    FGridItem: TGridItem;
    FDBAC: IDBAccess;
    FModelFun: IModelFun;

    procedure IniGridField; virtual;
    procedure LoadGridData(ATypeid: string = ''); virtual;
    function LoadParGridData: Boolean; virtual;//加载当前行父类的父类数据

    procedure BeforeFormShow; override;
    procedure BeforeFormDestroy; override;
    procedure InitParamList; override;
  public
    { Public declarations }
    
  end;

var
  frmMDI: TfrmMDI;

implementation

uses uSysSvc, uMoudleNoDef, uBaseInfoDef, uFrmApp, uMainFormIntf;

{$R *.dfm}

{ TfrmMDIBase }

procedure TfrmMDI.BeforeFormDestroy;
begin
  inherited;

  FGridItem.Free;
end;

procedure TfrmMDI.BeforeFormShow;
begin
  inherited;
  FGridItem := TGridItem.Create(MoudleNo, gridMainShow, gridTVMainShow);
  FGridItem.OnSelectBasic := DoSelectBasic;
  FDBAC := SysService as IDBAccess;
  FModelFun := SysService as IModelFun;
end;

procedure TfrmMDI.IniGridField;
begin

end;

procedure TfrmMDI.InitParamList;
begin
  inherited;

end;

procedure TfrmMDI.LoadGridData(ATypeid: string);
begin

end;

function TfrmMDI.LoadParGridData: Boolean;
begin
  Result := True;
end;

procedure TfrmMDI.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  Action := caFree;
end;

function TfrmMDI.FrmShowStyle: TShowStyle;
begin
  Result := fssShow;
end;

procedure TfrmMDI.actCloseExecute(Sender: TObject);
var
  aMainForm: IMainForm;
  aCanClose: Boolean;
begin
  inherited;
  aMainForm := SysService as IMainForm;
  OutputDebugString(PAnsiChar(Self.Caption));
  aMainForm.CloseFom(Self, aCanClose);
end;

end.

