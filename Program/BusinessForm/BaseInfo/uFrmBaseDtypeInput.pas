unit uFrmBaseDtypeInput;

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
  TfrmBaseDtypeInput = class(TfrmBaseInput)
    edtFullname: TcxButtonEdit;
    lbl1: TLabel;
    lbl2: TLabel;
    edtUsercode: TcxButtonEdit;
    Label1: TLabel;
    edtName: TcxButtonEdit;
    edtPYM: TcxButtonEdit;
    lbl3: TLabel;
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
  frmBaseDtypeInput: TfrmBaseDtypeInput;

implementation

{$R *.dfm}

uses uSysSvc, uBaseFormPlugin, uBaseInfoDef, uModelBaseTypeIntf, uModelControlIntf, uOtherIntf, uDefCom;

{ TfrmBasePtypeInput }

procedure TfrmBaseDtypeInput.BeforeFormShow;
begin
  SetTitle('部门信息');
  FModelBaseType := IModelBaseTypePtype((SysService as IModelControl).GetModelIntf(IModelBaseTypeDtype));
  FModelBaseType.SetParamList(ParamList);
  FModelBaseType.SetBasicType(btDtype);

  DBComItem.AddItem(edtFullname, 'Fullname', 'DFullname');
  DBComItem.AddItem(edtUsercode, 'Usercode', 'DUsercode');
  DBComItem.AddItem(edtName, 'Name', 'Name');
  DBComItem.AddItem(edtPYM, 'Namepy', 'Dnamepy');
  DBComItem.AddItem(chkStop, 'IsStop', 'IsStop');
  DBComItem.AddItem(mmComment, 'Comment', 'DComment');
  inherited;
end;

procedure TfrmBaseDtypeInput.ClearFrmData;
begin
  inherited;
end;

procedure TfrmBaseDtypeInput.GetFrmData(ASender: TObject;
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

class function TfrmBaseDtypeInput.GetMdlDisName: string;
begin
  Result := '部门信息';
end;

procedure TfrmBaseDtypeInput.SetFrmData(ASender: TObject;
  AList: TParamObject);
begin
  inherited;
  DBComItem.GetDataFormParam(AList);
end;

end.
