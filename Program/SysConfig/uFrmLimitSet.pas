unit uFrmLimitSet;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uFrmDialog, Menus, cxLookAndFeelPainters, ActnList, cxControls,
  cxContainer, cxEdit, cxLabel, StdCtrls, cxButtons, ExtCtrls, uModelSysIntf;

type
  TfrmLimitSet = class(TfrmDialog)
  private
    { Private declarations }

    procedure BeforeFormShow; override;
    procedure InitParamList; override;
  public
    { Public declarations }
  end;

var
  frmLimitSet: TfrmLimitSet;

implementation

uses uBaseFormPlugin, uSysSvc, uDBIntf, uGridConfig, uMoudleNoDef, uBaseInfoDef, uFactoryFormIntf,
  uModelControlIntf, uPubFun, uDefCom, uModelFunIntf, uParamObject, uOtherIntf;

{$R *.dfm}

{ TfrmInitOver }

procedure TfrmLimitSet.BeforeFormShow;
begin
  inherited;
  Title := '»®œﬁ…Ë÷√';
end;

procedure TfrmLimitSet.InitParamList;
begin
  inherited;
  MoudleNo := fnDialogLimitSet;
end;

initialization
  gFormManage.RegForm(TfrmLimitSet, fnMdlReBuild);

end.

