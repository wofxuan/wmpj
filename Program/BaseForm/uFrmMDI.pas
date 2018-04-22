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
    imglstBtn: TcxImageList;
    actClose: TAction;
    bmList: TdxBarManager;
    barTool: TdxBar;
    btnClose: TdxBarLargeButton;
    gridTVMainShow: TcxGridTableView;
    actReturn: TAction;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure actCloseExecute(Sender: TObject);
    procedure actReturnExecute(Sender: TObject);
  private
    FShowStyle: TShowStyle;

    function FrmShowStyle: TShowStyle; override;
  protected
    { Private declarations }
    FGridItem: TGridItem;
    FDBAC: IDBAccess;
    FModelFun: IModelFun;

    procedure IniGridField; virtual;
    procedure LoadGridData(ATypeid: string = ''); virtual;
    procedure DoLoadUpDownData(Sender: TObject; ATypeid: string); virtual; ///双击表格时回调的函数

    procedure BeforeFormShow; override;
    procedure BeforeFormDestroy; override;
    procedure InitParamList; override; //设置MoudleNo等于界面无关点操作
  public
    { Public declarations }
    property ShowStyle: TShowStyle read FShowStyle write FShowStyle default fssShow;
  end;

var
  frmMDI: TfrmMDI;

implementation

uses uSysSvc, uMoudleNoDef, uBaseInfoDef, uFrmApp, uPubFun, uMainFormIntf;

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
  FGridItem := TGridItem.Create(ClassName + IntToString(MoudleNo) + gridMainShow.Name, gridMainShow, gridTVMainShow);
  FGridItem.OnSelectBasic := DoSelectBasic;
  FGridItem.OnLoadUpDownData := DoLoadUpDownData;
  FDBAC := SysService as IDBAccess;
  FModelFun := SysService as IModelFun;
end;

procedure TfrmMDI.IniGridField;
begin

end;

procedure TfrmMDI.InitParamList;
begin
  inherited;
  FShowStyle := fssShow;
end;

procedure TfrmMDI.LoadGridData(ATypeid: string);
begin

end;

procedure TfrmMDI.FormClose(Sender: TObject; var Action: TCloseAction);
var
  aCanClose: Boolean;
begin
  inherited;
  aCanClose := False;
  (SysService as IMainForm).CloseFom(Self, aCanClose);
  Action := caFree;
end;

function TfrmMDI.FrmShowStyle: TShowStyle;
begin
  Result := FShowStyle;
end;

procedure TfrmMDI.actCloseExecute(Sender: TObject);
begin
  inherited;
  FrmClose();
end;

procedure TfrmMDI.DoLoadUpDownData(Sender: TObject; ATypeid: string);
begin
  LoadGridData(ATypeid);
  bmList.BeginUpdate;
  try
    if ATypeid > ROOT_ID then
    begin
      btnClose.Action := actReturn;
      btnClose.LargeImageIndex := 0;
      btnClose.ImageIndex := 0;
    end
    else
    begin
      btnClose.Action := actClose;
      btnClose.LargeImageIndex := 1;
      btnClose.ImageIndex := 1;
    end;
  finally
    bmList.EndUpdate;
  end;
end;

procedure TfrmMDI.actReturnExecute(Sender: TObject);
begin
  inherited;
  FGridItem.LoadUpDownData(True);
end;

end.

