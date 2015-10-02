unit uFrmBaseBtypeInput;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uFrmBaseInput, Menus, cxLookAndFeelPainters, ActnList, cxLabel,
  cxControls, cxContainer, cxEdit, cxCheckBox, StdCtrls, cxButtons,
  ExtCtrls, Mask, cxTextEdit, cxMaskEdit, cxButtonEdit, cxGraphics,
  cxDropDownEdit, uParamObject, ComCtrls, cxStyles, cxCustomData, cxFilter,
  cxData, cxDataStorage, DB, cxDBData, cxGridLevel, cxClasses,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGrid, uDBComConfig, cxMemo;

type
  TfrmBaseBtypeInput = class(TfrmBaseInput)
    edtFullname: TcxButtonEdit;
    edtUsercode: TcxButtonEdit;
    edtName: TcxButtonEdit;
    edtPYM: TcxButtonEdit;
    lbl2: TLabel;
    lbl1: TLabel;
    Label1: TLabel;
    lbl3: TLabel;
    edtAddress: TcxButtonEdit;
    lbl4: TLabel;
    edtTel: TcxButtonEdit;
    lbl5: TLabel;
    edtEMail: TcxButtonEdit;
    edtContact1: TcxButtonEdit;
    edtLinkerTel1: TcxButtonEdit;
    lbl6: TLabel;
    lbl7: TLabel;
    lbl8: TLabel;
    lbl15: TLabel;
    lbl16: TLabel;
    lbl17: TLabel;
    edtContact2: TcxButtonEdit;
    edtLinkerTel2: TcxButtonEdit;
    edtDefEtype: TcxButtonEdit;
    lbl18: TLabel;
    lbl19: TLabel;
    lbl20: TLabel;
    edtBankOfDeposit: TcxButtonEdit;
    edtBankAccounts: TcxButtonEdit;
    edtPostCode: TcxButtonEdit;
    lbl24: TLabel;
    lbl25: TLabel;
    lbl26: TLabel;
    edtFax: TcxButtonEdit;
    edtTaxNumber: TcxButtonEdit;
    edtRtypeid: TcxButtonEdit;
    chkStop: TcxCheckBox;
    grpComment: TGroupBox;
    mmComment: TcxMemo;
  protected
    { Private declarations }
    procedure SetFrmData(ASender: TObject; AList: TParamObject); override;  
    procedure GetFrmData(ASender: TObject; AList: TParamObject); override;
    procedure ClearFrmData; override;
  public
    { Public declarations }
    procedure BeforeFormShow; override;
    class function GetMdlDisName: string; override; //得到模块显示名称

  end;

var
  frmBaseBtypeInput: TfrmBaseBtypeInput;

implementation

{$R *.dfm}

uses uSysSvc, uBaseFormPlugin, uBaseInfoDef, uModelBaseTypeIntf, uModelControlIntf, uOtherIntf, uDefCom;

{ TfrmBasePtypeInput }

procedure TfrmBaseBtypeInput.BeforeFormShow;
begin
  SetTitle('单位信息');
  FModelBaseType := IModelBaseTypePtype((SysService as IModelControl).GetModelIntf(IModelBaseTypeBtype));
  FModelBaseType.SetParamList(ParamList);
  FModelBaseType.SetBasicType(btBtype);

  DBComItem.AddItem(edtFullname, 'Fullname', 'BFullname');
  DBComItem.AddItem(edtUsercode, 'Usercode', 'BUsercode');
  DBComItem.AddItem(edtName, 'Name', 'Name');
  DBComItem.AddItem(edtPYM, 'Namepy', 'Bnamepy');
  DBComItem.AddItem(mmComment, 'Comment', 'BComment');

  DBComItem.AddItem(edtAddress, 'Address', 'Address');
  DBComItem.AddItem(edtTel, 'Tel', 'Tel');
  DBComItem.AddItem(edtEMail, 'EMail', 'EMail');
  DBComItem.AddItem(edtContact1, 'Contact1', 'Contact1');
  DBComItem.AddItem(edtContact2, 'Contact2', 'Contact2');
  DBComItem.AddItem(edtLinkerTel1, 'LinkerTel1', 'LinkerTel1');
  DBComItem.AddItem(edtLinkerTel2, 'LinkerTel2', 'LinkerTel2');
  DBComItem.AddItem(edtDefEtype, 'DefEtype', 'DefEtype');
  DBComItem.AddItem(edtBankOfDeposit, 'BankOfDeposit', 'BankOfDeposit');
  DBComItem.AddItem(edtBankAccounts, 'BankAccounts', 'BankAccounts');
  DBComItem.AddItem(edtPostCode, 'PostCode', 'PostCode');
  DBComItem.AddItem(edtFax, 'Fax', 'Fax');
  DBComItem.AddItem(edtTaxNumber, 'TaxNumber', 'TaxNumber');
  DBComItem.AddItem(edtRtypeid, 'Rtypeid', 'Rtypeid');
  DBComItem.AddItem(chkStop, 'IsStop', 'IsStop');
  inherited;
end;

procedure TfrmBaseBtypeInput.ClearFrmData;
begin
  inherited;
end;

procedure TfrmBaseBtypeInput.GetFrmData(ASender: TObject;
  AList: TParamObject);
begin
  inherited;
  AList.Add('@Parid', ParamList.AsString('ParId'));
  DBComItem.SetDataToParam(AList);
  if FModelBaseType.DataChangeType in [dctModif] then
  begin
    AList.Add('@typeId', ParamList.AsString('CurTypeid'));
  end;
end;

class function TfrmBaseBtypeInput.GetMdlDisName: string;
begin
  Result := '单位信息';
end;

procedure TfrmBaseBtypeInput.SetFrmData(ASender: TObject;
  AList: TParamObject);
begin
  inherited;
  DBComItem.GetDataFormParam(AList);
end;

end.
