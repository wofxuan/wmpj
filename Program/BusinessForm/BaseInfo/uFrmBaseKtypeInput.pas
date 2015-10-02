unit uFrmBaseKtypeInput;

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
  TfrmBaseKtypeInput = class(TfrmBaseInput)
    edtFullname: TcxButtonEdit;
    lbl1: TLabel;
    lbl2: TLabel;
    edtUsercode: TcxButtonEdit;
    Label1: TLabel;
    edtName: TcxButtonEdit;
    edtPYM: TcxButtonEdit;
    lbl3: TLabel;
    chkStop: TcxCheckBox;
    lbl4: TLabel;
    lbl5: TLabel;
    lbl6: TLabel;
    edtAddress: TcxButtonEdit;
    edtPerson: TcxButtonEdit;
    edtTel: TcxButtonEdit;
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
  frmBaseKtypeInput: TfrmBaseKtypeInput;

implementation

{$R *.dfm}

uses uSysSvc, uBaseFormPlugin, uBaseInfoDef, uModelBaseTypeIntf, uModelControlIntf, uOtherIntf, uDefCom;

{ TfrmBasePtypeInput }

procedure TfrmBaseKtypeInput.BeforeFormShow;
begin
  SetTitle('仓库信息');
  FModelBaseType := IModelBaseTypePtype((SysService as IModelControl).GetModelIntf(IModelBaseTypeKtype));
  FModelBaseType.SetParamList(ParamList);
  FModelBaseType.SetBasicType(btKtype);

  DBComItem.AddItem(edtFullname, 'Fullname', 'KFullname');
  DBComItem.AddItem(edtUsercode, 'Usercode', 'KUsercode');
  DBComItem.AddItem(edtName, 'Name', 'Name');
  DBComItem.AddItem(edtPYM, 'Namepy', 'Knamepy');
  DBComItem.AddItem(edtAddress, 'Address', 'Address');
  DBComItem.AddItem(edtPerson, 'Person', 'Person');
  DBComItem.AddItem(edtTel, 'Tel', 'Tel');
  DBComItem.AddItem(chkStop, 'IsStop', 'IsStop');
  DBComItem.AddItem(mmComment, 'Comment', 'KComment');
  inherited;
end;

procedure TfrmBaseKtypeInput.ClearFrmData;
begin
  inherited;
end;

procedure TfrmBaseKtypeInput.GetFrmData(ASender: TObject;
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

class function TfrmBaseKtypeInput.GetMdlDisName: string;
begin
  Result := '仓库信息';
end;

procedure TfrmBaseKtypeInput.SetFrmData(ASender: TObject;
  AList: TParamObject);
begin
  inherited;
  DBComItem.GetDataFormParam(AList);
end;

end.
