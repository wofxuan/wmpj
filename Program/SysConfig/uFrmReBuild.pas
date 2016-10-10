unit uFrmReBuild;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uFrmDialog, Menus, cxLookAndFeelPainters, ActnList, cxControls,
  cxContainer, cxEdit, cxLabel, StdCtrls, cxButtons, ExtCtrls, uModelSysIntf;

type
  TfrmReBuild = class(TfrmDialog)
    pnlTip: TPanel;
    lblTip: TLabel;
    procedure actOKExecute(Sender: TObject);
  private
    { Private declarations }

    procedure BeforeFormShow; override;
    procedure InitParamList; override;
    function ReBuild: Boolean;
  public
    { Public declarations }
  end;

var
  frmReBuild: TfrmReBuild;

implementation

uses uBaseFormPlugin, uSysSvc, uDBIntf, uGridConfig, uMoudleNoDef, uBaseInfoDef, uFactoryFormIntf,
  uModelControlIntf, uPubFun, uDefCom, uModelFunIntf, uParamObject, uOtherIntf;

{$R *.dfm}

{ TfrmInitOver }

procedure TfrmReBuild.BeforeFormShow;
begin
  inherited;
  Title := '系统重建';
end;

function TfrmReBuild.ReBuild: Boolean;
var
  aParam: TParamObject;
  aRet: Integer;
begin
  Result := False;
  if (SysService as IMsgBox).MsgBox('是否进行重建操作？', '提示', mbtConfirmation, mbbOkCancel) <> mrOk then Exit;
  
  aParam := TParamObject.Create;
  try
    aParam.Add('@ClearStock', 1);
    aParam.Add('@ClearBak', 1);
    aRet := IModelSys((SysService as IModelControl).GetModelIntf(IModelSys)).ReBuild(aParam);
    if aRet <> 0 then Exit;
    
    (SysService as IMsgBox).MsgBox('系统重建完成，请退出系统重新进入！', '提示');
    Result := True;
  finally
    aParam.Free;
  end;
end;

procedure TfrmReBuild.InitParamList;
begin
  inherited;
  MoudleNo := fnDialogReBuild;
end;

procedure TfrmReBuild.actOKExecute(Sender: TObject);
begin
  inherited;
  if ReBuild() then FrmClose;
end;

initialization
  gFormManage.RegForm(TfrmReBuild, fnDialogReBuild);

end.

