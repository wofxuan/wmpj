unit uFrmBaseInput;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uFrmParent, ActnList, ExtCtrls, Menus, cxLookAndFeelPainters, DBClient,
  StdCtrls, cxButtons, cxControls, cxContainer, cxEdit, cxLabel, cxCheckBox, uParamObject,
  uBaseInfoDef, uDefCom, uModelBaseIntf, Mask, cxTextEdit, cxMaskEdit, cxButtonEdit, cxGraphics,
  cxDropDownEdit, cxMemo;

type
  TDlgInputBaseClass = class of TfrmBaseInput;

  TfrmBaseInput = class(TfrmParent)
    pnlBottom: TPanel;
    pnlClient: TPanel;
    btnOK: TcxButton;
    btnCannel: TcxButton;
    actOK: TAction;
    actCannel: TAction;
    pnlTop: TPanel;
    lblTitle: TcxLabel;
    chkAutoAdd: TcxCheckBox;
    procedure actOKExecute(Sender: TObject);
    procedure actCannelExecute(Sender: TObject);
  private
    { Private declarations }
    FViewRoot: TObject; //保存调用此窗体的对象，如TfrmBaseList
    
    procedure SelfClose;
  protected
    FModelBaseType: IModelBaseType;
    
    function SaveData: Boolean; virtual;                    //保存数据

    procedure SetReadOnly(AReadOnly: Boolean); virtual;     //设置界面只读
    procedure SetFrmData(ASender: TObject; AList: TParamObject); virtual; abstract; //把数据库中的显示到界面
    procedure GetFrmData(ASender: TObject; AList: TParamObject); virtual; abstract; //把界面的数据写到参数表中
    procedure ClearFrmData; virtual;                        //清空界面数据
    procedure SetTitle(const Value: string); override;
  public
    { Public declarations }
    constructor CreateFrmParamList(AOwner: TComponent; AParam: TParamObject); override;

    class function InputBase(AViewR: TObject = nil; AParam: TParamObject = nil): Boolean;
    procedure SetViewRoot(AViewR: TObject);
    procedure IniView; override;                             //初始化视图
    procedure IniData; override;

    procedure BeforeFormShow; override;
    procedure BeforeFormDestroy; override;
    function CurTypeId: string;
    
  end;
var
  frmBaseInput: TfrmBaseInput;

implementation

uses uSysSvc;
{$R *.dfm}

{ TfrmBaseInput }

procedure TfrmBaseInput.BeforeFormDestroy;
begin
  inherited;

end;

procedure TfrmBaseInput.BeforeFormShow;
begin
  FModelBaseType.OnSetDataEvent(SetFrmData);
  FModelBaseType.OnGetDataEvent(GetFrmData);
  inherited;
end;

procedure TfrmBaseInput.ClearFrmData;
begin
  inherited;
  DBComItem.ClearItemData();
end;

constructor TfrmBaseInput.CreateFrmParamList(AOwner: TComponent;
  AParam: TParamObject);
begin
  inherited;
  SetViewRoot(AOwner);
end;

procedure TfrmBaseInput.IniData;
begin
  ClearFrmData();
  FModelBaseType.IniData(CurTypeId);
end;

procedure TfrmBaseInput.IniView;
  function GetSetANullAdd: Boolean;
  begin
    if (FModelBaseType.DataChangeType = dctAdd)        //空白新增
    or ((FModelBaseType.DataChangeType = dctAddCopy) and (CurTypeId = '')) then
      //复制新增
      Result := True
    else
      Result := False;
  end;
var
  cdsTemp           : TClientDataSet;
begin
  if FModelBaseType.DataChangeType in [dctNo, dctModif, dctDis] then
  begin
    chkAutoAdd.Visible := False;
  end;
  if chkAutoAdd.Visible then
  begin
//    chkAutoAdd.Checked := gFuncom.GetConfig('BASIC', 'AUTOADD', '1') = '1';
  end;
  cdsTemp := TClientDataSet.Create(nil);
  try
    if GetSetANullAdd() then
    begin
      ClearFrmData;                     //清空界面数据
    end
    else //if () then  //获取数据
    begin
      IniData;
    end;
  finally
    cdsTemp.Free;
  end;
  //设置只读
  if FModelBaseType.DataChangeType = dctDis then
  begin
    SetReadOnly(True);
  end;
  Title := Caption; //默认title和caption是一样的。如果要设置为不一样的，可以在子类重写SetTitle方法
end;

function TfrmBaseInput.SaveData: Boolean;
begin
  Result := FModelBaseType.SaveData();
end;

procedure TfrmBaseInput.SelfClose;
begin
  Self.ModalResult := mrCancel;
end;

procedure TfrmBaseInput.SetReadOnly(AReadOnly: Boolean);
begin

end;

procedure TfrmBaseInput.SetTitle(const Value: string);
begin
  inherited;
  lblTitle.Caption := Value;
end;

procedure TfrmBaseInput.SetViewRoot(AViewR: TObject);
begin
  FViewRoot := AViewR;
end;

procedure TfrmBaseInput.actOKExecute(Sender: TObject);
begin
  inherited;
  if SaveData() then
  begin
    ModalResult := mrOk;
  end;
end;

procedure TfrmBaseInput.actCannelExecute(Sender: TObject);
begin
  inherited;
  SelfClose();
end;

function TfrmBaseInput.CurTypeId: string;
begin
  Result := FModelBaseType.CurTypeId;
end;

class function TfrmBaseInput.InputBase(AViewR: TObject;
  AParam: TParamObject): Boolean;
var
  fDlgInputBase     : TfrmBaseInput;
begin
  Result := False;
  fDlgInputBase := Self.CreateFrmParamList(TComponent(AViewR), AParam);
  try
    if fDlgInputBase.ShowModal = mrOk then
    begin
      Result := True;
    end;
  finally
    fDlgInputBase.Free;
  end;
end;
end.

