unit uFrmBaseEtypeInput;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uFrmBaseInput, Menus, cxLookAndFeelPainters, ActnList, cxLabel,
  cxControls, cxContainer, cxEdit, cxCheckBox, StdCtrls, cxButtons,
  ExtCtrls, Mask, cxTextEdit, cxMaskEdit, cxButtonEdit, cxGraphics,
  cxDropDownEdit, uParamObject, ComCtrls, cxStyles, cxCustomData, cxFilter,
  cxData, cxDataStorage, DB, cxDBData, cxGridLevel, cxClasses,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGrid, uDBComConfig;

type
  TfrmBaseEtypeInput = class(TfrmBaseInput)
    edtFullname: TcxButtonEdit;
    lbl1: TLabel;
    lbl2: TLabel;
    edtUsercode: TcxButtonEdit;
    edtPYM: TcxButtonEdit;
    lbl3: TLabel;
    chkStop: TcxCheckBox;
    edtDType: TcxButtonEdit;
    lbl4: TLabel;
    lbl5: TLabel;
    lbl6: TLabel;
    edtTel: TcxButtonEdit;
    edtBirthday: TcxButtonEdit;
    edtAddress: TcxButtonEdit;
    lbl7: TLabel;
    lbl8: TLabel;
    lbl9: TLabel;
    edtJob: TcxButtonEdit;
    edtTopTotal: TcxButtonEdit;
    edtEMail: TcxButtonEdit;
    lbl10: TLabel;
    edtLowLimitDiscount: TcxButtonEdit;
    lbl11: TLabel;
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
  frmBaseEtypeInput: TfrmBaseEtypeInput;

implementation

{$R *.dfm}

uses uSysSvc, uBaseFormPlugin, uBaseInfoDef, uModelBaseTypeIntf, uModelControlIntf, uOtherIntf, uDefCom;

{ TfrmBasePtypeInput }

procedure TfrmBaseEtypeInput.BeforeFormShow;
begin
  SetTitle('职员信息');
  FModelBaseType := IModelBaseTypePtype((SysService as IModelControl).GetModelIntf(IModelBaseTypeEtype));
  FModelBaseType.SetParamList(ParamList);
  FModelBaseType.SetBasicType(btEtype);

  DBComItem.AddItem(edtFullname, 'Fullname', 'EFullname');
  DBComItem.AddItem(edtUsercode, 'Usercode', 'EUsercode');
  DBComItem.AddItem(edtPYM, 'Namepy', 'Enamepy');
  DBComItem.AddItem(chkStop, 'IsStop', 'IsStop');

  DBComItem.AddItem(edtDType, 'DTypeID', 'DTypeID');
  DBComItem.AddItem(edtTel, 'Tel', 'Tel');
  DBComItem.AddItem(edtBirthday, 'Birthday', 'Birthday');
  DBComItem.AddItem(edtEMail, 'EMail', 'EMail');
  DBComItem.AddItem(edtJob, 'Job', 'Job');
  DBComItem.AddItem(edtTopTotal, 'TopTotal', 'TopTotal');
  DBComItem.AddItem(edtLowLimitDiscount, 'LowLimitDiscount', 'LowLimitDiscount');
  DBComItem.AddItem(edtAddress, 'Address', 'Address');
  inherited;
end;

procedure TfrmBaseEtypeInput.ClearFrmData;
begin
  inherited;
end;

procedure TfrmBaseEtypeInput.GetFrmData(ASender: TObject;
  AList: TParamObject);
begin
  inherited;
  AList.Add('@Parid', ParamList.AsString('ParId'));
  DBComItem.SetDataToParam(AList);
  AList.Add('@Comment', '');
  if FModelBaseType.DataChangeType in [dctModif] then
  begin
    AList.Add('@typeId', ParamList.AsString('CurTypeid'));
  end;
end;

class function TfrmBaseEtypeInput.GetMdlDisName: string;
begin
  Result := '职员信息';
end;

procedure TfrmBaseEtypeInput.SetFrmData(ASender: TObject;
  AList: TParamObject);
begin
  inherited;
  DBComItem.GetDataFormParam(AList);
end;

end.
