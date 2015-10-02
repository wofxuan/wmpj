unit uFrmMDIBase;

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
  TfrmMDIBase = class(TfrmParent)
    pnlTop: TPanel;
    pnlTV: TPanel;
    gridDTVMainShow: TcxGridDBTableView;
    gridLVMainShow: TcxGridLevel;
    gridMainShow: TcxGrid;
    dsMainShow: TDataSource;
    cdsMainShow: TClientDataSet;
    tvClass: TcxTreeView;
    splOP: TSplitter;
    imglstBtn: TcxImageList;
    actClose: TAction;
    actReturn: TAction;
    bmList: TdxBarManager;
    barTool: TdxBar;
    btnReturn: TdxBarLargeButton;
    btnClose: TdxBarLargeButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure actCloseExecute(Sender: TObject);
    procedure actReturnExecute(Sender: TObject);
  private
    procedure SetTVVisble(const Value: Boolean); //树表是否显示 调用此函数应该在IniGridData内
    function GetTVVisble: Boolean;
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
    property TVVisble: boolean read GetTVVisble write SetTVVisble;
  end;

var
  frmMDIBase: TfrmMDIBase;

implementation

uses uSysSvc, uMoudleNoDef, uBaseInfoDef, uFrmApp, uMainFormIntf;

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
  FGridItem := TGridItem.Create(MoudleNo, gridMainShow, gridDTVMainShow);
  FDBAC := SysService as IDBAccess;
  FModelFun := SysService as IModelFun;
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
//  if ATypeid <> ROOT_ID then
//    btnClose.Caption := '返回(&C)'
//  else
//    btnClose.Caption := '关闭(&C)';
end;

procedure TfrmMDIBase.SetTVVisble(const Value: Boolean);
begin
  pnlTV.Visible := Value;
end;

function TfrmMDIBase.LoadParGridData: Boolean;
begin
  Result := True;
end;

procedure TfrmMDIBase.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  Action := caFree;
end;

function TfrmMDIBase.FrmShowStyle: TShowStyle;
begin
  Result := fssShow;
end;

procedure TfrmMDIBase.actCloseExecute(Sender: TObject);
var
  aMainForm: IMainForm;
  aCanClose: Boolean;
begin
  inherited;
  aMainForm := SysService as IMainForm;
  OutputDebugString(PAnsiChar(Self.Caption));
  aMainForm.CloseFom(Self, aCanClose);
end;

procedure TfrmMDIBase.actReturnExecute(Sender: TObject);
begin
  inherited;
  if (not LoadParGridData()) then Close;
  gridMainShow.SetFocus;
end;

end.

