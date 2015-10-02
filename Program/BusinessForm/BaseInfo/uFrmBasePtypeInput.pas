unit uFrmBasePtypeInput;

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
  TfrmBasePtypeInput = class(TfrmBaseInput)
    edtFullname: TcxButtonEdit;
    lbl1: TLabel;
    lbl2: TLabel;
    edtUsercode: TcxButtonEdit;
    Label1: TLabel;
    edtName: TcxButtonEdit;
    edtPYM: TcxButtonEdit;
    lbl3: TLabel;
    lbl4: TLabel;
    Label2: TLabel;
    lbl5: TLabel;
    edtStandard: TcxButtonEdit;
    edtModel: TcxButtonEdit;
    edtArea: TcxButtonEdit;
    cbbCostMode: TcxComboBox;
    lbl6: TLabel;
    edtUsefulLifeday: TcxButtonEdit;
    lbl7: TLabel;
    chkStop: TcxCheckBox;
    pgcView: TPageControl;
    tsJG: TTabSheet;
    gridDTVPtypeUnit: TcxGridDBTableView;
    gridLVPtypeUnit: TcxGridLevel;
    gridPtypeUnit: TcxGrid;
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
  frmBasePtypeInput: TfrmBasePtypeInput;

implementation

{$R *.dfm}

uses uSysSvc, uBaseFormPlugin, uBaseInfoDef, uModelBaseTypeIntf, uModelControlIntf, uOtherIntf, uDefCom;

{ TfrmBasePtypeInput }

procedure TfrmBasePtypeInput.BeforeFormShow;
begin
  SetTitle('商品信息');
  FModelBaseType := IModelBaseTypePtype((SysService as IModelControl).GetModelIntf(IModelBaseTypePtype));
  FModelBaseType.SetParamList(ParamList);
  FModelBaseType.SetBasicType(btPtype);

  DBComItem.AddItem(edtFullname, 'Fullname', 'PFullname');
  DBComItem.AddItem(edtUsercode, 'Usercode', 'PUsercode');
  DBComItem.AddItem(edtName, 'Name', 'Name');
  DBComItem.AddItem(edtPYM, 'Namepy', 'Pnamepy');
  DBComItem.AddItem(edtStandard, 'Standard', 'Standard');
  DBComItem.AddItem(edtModel, 'Model', 'Model');
  DBComItem.AddItem(edtArea, 'Area', 'Area');
  DBComItem.AddItem(cbbCostMode, 'CostMode', 'CostMode');
  DBComItem.AddItem(edtUsefulLifeday, 'UsefulLifeday', 'UsefulLifeday');
  DBComItem.AddItem(chkStop, 'IsStop', 'IsStop');
  inherited;
end;

procedure TfrmBasePtypeInput.ClearFrmData;
begin
  inherited;
end;

procedure TfrmBasePtypeInput.GetFrmData(ASender: TObject;
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

class function TfrmBasePtypeInput.GetMdlDisName: string;
begin
  Result := '商品信息';
end;

procedure TfrmBasePtypeInput.SetFrmData(ASender: TObject;
  AList: TParamObject);
begin
  inherited;
  DBComItem.GetDataFormParam(AList);
end;

end.
