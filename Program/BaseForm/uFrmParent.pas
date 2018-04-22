unit uFrmParent;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, uFactoryFormIntf, uParamObject, ExtCtrls, 
  ActnList, uBaseInfoDef, uGridConfig, uDBComConfig, uDefCom, uModelFunIntf,
  cxGridLevel, cxClasses, cxControls, cxGridCustomView, dxBar, uWmLabelEditBtn,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid, cxGroupBox;

type
  TfrmParent = class(TForm, IFormIntf)
    actlstEvent: TActionList;
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }

    FMoudleNo: Integer; //ģ��ı�ź�uMoudleNoDef��Ԫ�ĳ�����Ӧ
    FParamList: TParamObject; //��ʼ���Ǵ���Ĳ���
    FTitle: string; //���幤������ʾ������
    FDBComItem: TFormDBComItem; //���ý���ؼ��������ֶ�
  protected
    { IInterface }
    function QueryInterface(const IID: TGUID; out Obj): HResult; stdcall;
    function _AddRef: Integer; stdcall;
    function _Release: Integer; stdcall;

    { IFormIntf }
    procedure CreateParamList(AOwner: TComponent; AParam: TParamObject);
    procedure FrmShow;
    function FrmShowModal: Integer;
    procedure FrmFree;
    procedure FrmClose;
    procedure ResizeFrm(AParentForm: TWinControl);
    function GetForm: TForm;

    procedure DoSelectBasic(Sender: TObject; ABasicType: TBasicType;
      ASelectBasicParam: TSelectBasicParam;
      ASelectOptions: TSelectBasicOptions; var ABasicDatas: TSelectBasicDatas;
      var AReturnCount: Integer); virtual;
    procedure BeforeFormShow; virtual;
    procedure InitParamList; virtual; //��Ʒ�����ڴ��ڴ���֮ǰ�ȶԲ������д�����Ҫ�Խ���Ŀؼ����д���
    procedure BeforeFormDestroy; virtual;
    procedure SetTitle(const Value: string); virtual;
    procedure IniView; virtual; //��ʼ����ͼ
    procedure IniData; virtual;

    procedure InitialAllComponent; virtual;
    procedure InitcxGridClass(AComp: TComponent);
    procedure InitPanel(AComp: TComponent);
    procedure InitdxBar(AComp: TComponent);
    procedure InitWmLabelEditBtn(AComp: TComponent);
    procedure InitcxGroupBox(AComp: TComponent);
  public
    { Public declarations }
    constructor CreateFrmParamList(AOwner: TComponent; AParam: TParamObject); virtual; //�������Ĵ���
    property MoudleNo: Integer read FMoudleNo write FMoudleNo;
    property ParamList: TParamObject read FParamList write FParamList;
    class function GetMdlDisName: string; virtual; //�õ�ģ����ʾ����
    property Title: string read FTitle write SetTitle; //�����������lbltitle.caption
    property DBComItem: TFormDBComItem read FDBComItem write FDBComItem;
    function FrmShowStyle: TShowStyle; virtual; abstract; //������ʾ�����ͣ��Ƿ�modal
  end;

var
  frmParent: TfrmParent;

implementation

uses uSysSvc, uDBIntf, uMainFormIntf, uMoudleNoDef, uFrmBaseSelect;

{$R *.dfm}

{ TParentForm }

procedure TfrmParent.BeforeFormDestroy;
begin
  ParamList.Free;
end;

procedure TfrmParent.BeforeFormShow;
begin
  if Self.GetMdlDisName <> '' then
    Title := Self.GetMdlDisName;

  IniView;
end;

procedure TfrmParent.CreateParamList(AOwner: TComponent;
  AParam: TParamObject);
begin
  CreateFrmParamList(AOwner, AParam);
end;

procedure TfrmParent.FormShow(Sender: TObject);
begin
  Color := clWhite;
  FDBComItem := TFormDBComItem.Create(Self);
  FDBComItem.OnSelectBasic := DoSelectBasic;

  BeforeFormShow();
end;

procedure TfrmParent.InitParamList;
begin

end;

procedure TfrmParent.FormDestroy(Sender: TObject);
begin
  BeforeFormDestroy();
  FDBComItem.Free;
end;

constructor TfrmParent.CreateFrmParamList(AOwner: TComponent;
  AParam: TParamObject);
begin
  //Ҫ���ô��ڵ�VisableΪfalse,��Ȼ�ڵ���create������Parent�Ժ�ͻ�ִ��show�¼�
  ParamList := TParamObject.Create;
  if Assigned(AParam) then ParamList.Params := AParam.Params;
  InitParamList();
  Create(AOwner);
//  ���������
  if Self.GetMdlDisName <> EmptyStr then
    Self.Caption := Self.GetMdlDisName;
end;

procedure TfrmParent.FrmShow;
begin
  Self.Show;
end;

procedure TfrmParent.FrmFree;
begin
  Self.Free;
end;

procedure TfrmParent.FrmClose;
begin
  Self.Close;
end;

function TfrmParent.FrmShowModal: Integer;
begin
  Result := Self.ShowModal;
end;

class function TfrmParent.GetMdlDisName: string;
begin
  Result := '';
end;

procedure TfrmParent.SetTitle(const Value: string);
begin
  FTitle := Value;
  Caption := Value;
end;

procedure TfrmParent.IniData;
begin

end;

procedure TfrmParent.IniView;
begin

end;

function TfrmParent._AddRef: Integer;
begin
  Result := -1;
end;

function TfrmParent._Release: Integer;
begin
  Result := -1;
end;

function TfrmParent.QueryInterface(const IID: TGUID; out Obj): HResult;
begin
  if GetInterface(IID, Obj) then
    Result := 0
  else
    Result := E_NOINTERFACE;
end;

procedure TfrmParent.DoSelectBasic(Sender: TObject; ABasicType: TBasicType;
  ASelectBasicParam: TSelectBasicParam;
  ASelectOptions: TSelectBasicOptions; var ABasicDatas: TSelectBasicDatas;
  var AReturnCount: Integer);
begin
  //������Ϣѡ��
  //˫������ťΪȫ�����س�֧��ģ����ѯ
  if ASelectBasicParam.SelectBasicMode <> sbtKeydown then
    ASelectBasicParam.SearchString := '';
  AReturnCount := SelectBasicData(ABasicType, ASelectBasicParam,
    ASelectOptions, ABasicDatas);
end;

procedure TfrmParent.InitialAllComponent;
var i: Integer;
begin
  Font.Name := '����';
  Font.Size := 10;
  for i := 0 to ComponentCount - 1 do
  begin
    if (Components[i] is TcxGridTableView) then InitcxGridClass(Components[i])
    else if (Components[i] is TdxBar) then InitdxBar(Components[i])
    else if (Components[i] is TPanel) then InitPanel(Components[i])
    else if (Components[i] is TWmLabelEditBtn) then InitWmLabelEditBtn(Components[i])
    else if (Components[i] is TcxGroupBox) then InitcxGroupBox(Components[i]);
  end;
end;

procedure TfrmParent.FormCreate(Sender: TObject);
begin
  InitialAllComponent();
end;

procedure TfrmParent.InitcxGridClass(AComp: TComponent);
var
  aCxGrid: TcxGridTableView;
begin
  aCxGrid := TcxGridTableView(AComp);
  aCxGrid.OptionsView.DataRowHeight := 25;
end;

procedure TfrmParent.ResizeFrm(AParentForm: TWinControl);
begin
  Width := AParentForm.Width;
  Height := AParentForm.Height;
end;

function TfrmParent.GetForm: TForm;
begin
  Result := Self;
end;

procedure TfrmParent.InitPanel(AComp: TComponent);
begin
  TPanel(AComp).Color := clWhite;
end;

procedure TfrmParent.InitdxBar(AComp: TComponent);
begin
  TdxBar(AComp).Color := clWhite;
end;

procedure TfrmParent.InitWmLabelEditBtn(AComp: TComponent);
begin
//  TWmLabelEditBtn(AComp).LabelFont.Name := '����';
//  TWmLabelEditBtn(AComp).LabelFont.Size := 9;
//
//  TWmLabelEditBtn(AComp).Style.Font.Name := '����';
//  TWmLabelEditBtn(AComp).Style.Font.Size := 9;
end;

procedure TfrmParent.InitcxGroupBox(AComp: TComponent);
begin
//  TcxGroupBox(AComp).Font.Name := '����';
//  TcxGroupBox(AComp).Font.Size := 9;
//
//  TcxGroupBox(AComp).Style.Font.Name := '����';
//  TcxGroupBox(AComp).Style.Font.Size := 9;
end;

initialization

end.

