unit uFrmInitOver;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uFrmDialog, Menus, cxLookAndFeelPainters, ActnList, cxControls,
  cxContainer, cxEdit, cxLabel, StdCtrls, cxButtons, ExtCtrls, uModelStockGoodsInf, uModelSysIntf;

type
  TfrmInitOver = class(TfrmDialog)
    btnBegin: TcxButton;
    btnEnd: TcxButton;
    pnlTip: TPanel;
    lblTip: TLabel;
    procedure btnBeginClick(Sender: TObject);
    procedure btnEndClick(Sender: TObject);
  private
    { Private declarations }
    FModelStockGoods: IModelStockGoods;

    procedure BeforeFormShow; override;
    procedure InitParamList; override;
    function InitOver(ADoType: Integer): Boolean;
  public
    { Public declarations }
  end;

var
  frmInitOver: TfrmInitOver;

implementation

uses uBaseFormPlugin, uSysSvc, uDBIntf, uGridConfig, uMoudleNoDef, uBaseInfoDef, uFactoryFormIntf,
  uModelControlIntf, uPubFun, uDefCom, uModelFunIntf, uParamObject;

{$R *.dfm}

{ TfrmInitOver }

procedure TfrmInitOver.BeforeFormShow;
begin
  inherited;
  Title := '期初建账..开账';
  FModelStockGoods := IModelStockGoods((SysService as IModelControl).GetModelIntf(IModelStockGoods));

  if IModelSys((SysService as IModelControl).GetModelIntf(IModelSys)).GetParam('InitOver') = '1' then
  begin
    btnBegin.Enabled := False;
    btnEnd.Enabled := True;
  end
  else
  begin
    btnBegin.Enabled := True;
    btnEnd.Enabled := False;
  end;
end;

function TfrmInitOver.InitOver(ADoType: Integer): Boolean;
var
  aParam: TParamObject;
  aRet: Integer;
begin
  Result := False;
  aParam := TParamObject.Create;
  try
    if ADoType = 1 then //开账
    begin
      aParam.Add('@DoType', 1);
    end
    else if ADoType = 0 then //反开账
    begin
      aParam.Add('@DoType', 0);
    end;
    
    aRet := FModelStockGoods.InitOver(aParam);
    if aRet <> 0 then Exit;

    Result := True;
  finally
    aParam.Free;
  end;
end;

procedure TfrmInitOver.InitParamList;
begin
  inherited;
  MoudleNo := fnMdlInitOver;
end;

procedure TfrmInitOver.btnBeginClick(Sender: TObject);
begin
  inherited;
  if InitOver(1) then FrmClose();
end;

procedure TfrmInitOver.btnEndClick(Sender: TObject);
begin
  inherited;
  if InitOver(0) then FrmClose();
end;

initialization
  gFormManage.RegForm(TfrmInitOver, fnMdlInitOver);

end.

