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
    FViewRoot: TObject; //������ô˴���Ķ�����TfrmBaseList
    
    procedure SelfClose;
  protected
    FModelBaseType: IModelBaseType;
    
    function SaveData: Boolean; virtual;                    //��������

    procedure SetReadOnly(AReadOnly: Boolean); virtual;     //���ý���ֻ��
    procedure SetFrmData(ASender: TObject; AList: TParamObject); virtual; abstract; //�����ݿ��е���ʾ������
    procedure GetFrmData(ASender: TObject; AList: TParamObject); virtual; abstract; //�ѽ��������д����������
    procedure ClearFrmData; virtual;                        //��ս�������
    procedure SetTitle(const Value: string); override;
  public
    { Public declarations }
    constructor CreateFrmParamList(AOwner: TComponent; AParam: TParamObject); override;

    class function InputBase(AViewR: TObject = nil; AParam: TParamObject = nil): Boolean;
    procedure SetViewRoot(AViewR: TObject);
    procedure IniView; override;                             //��ʼ����ͼ
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
    if (FModelBaseType.DataChangeType = dctAdd)        //�հ�����
    or ((FModelBaseType.DataChangeType = dctAddCopy) and (CurTypeId = '')) then
      //��������
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
      ClearFrmData;                     //��ս�������
    end
    else //if () then  //��ȡ����
    begin
      IniData;
    end;
  finally
    cdsTemp.Free;
  end;
  //����ֻ��
  if FModelBaseType.DataChangeType = dctDis then
  begin
    SetReadOnly(True);
  end;
  Self.Title := Self.Caption; //Ĭ��title��caption��һ���ġ����Ҫ����Ϊ��һ���ģ�������������дSetTitle����
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
    Self.ModalResult := mrOk;
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

