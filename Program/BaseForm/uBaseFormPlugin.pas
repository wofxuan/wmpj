unit uBaseFormPlugin;

interface

uses SysUtils, Classes, Windows, Controls, Forms, uPluginBase, uParamObject, uFrmParent;

const
    Err_FrmExists = '����%s�Ѵ��ڣ������ظ�ע�ᣡ';
    Err_FrmNotSupport = '%s���岻���ڣ�����ע�ᣡ';
    Err_FrmNoNotSupport = '%sģ��Ų����ڣ�����ע�ᣡ';

Type
  TFormClass = class of TfrmParent;

  PFormItem = ^TFormItem;
  TFormItem = record
    FormNo: Integer;                     //ģ���
    FormName: string;                    //ģ����
    FormClass: TFormClass;               //ģ����
  end;

  TBaseFormPlugin = Class(TPlugin)
  private

  protected

  public
    Constructor Create(Intf: IInterface);override;
    Destructor Destroy;override;

    procedure Init; override;
    procedure final; override;
  end;

  TFormManage = Class(TObject)
  private
    FFormList: array of PFormItem;
    FBasicType: Integer;

    function GetItemByName(AFormName: string): PFormItem;
    function GetItemByNo(AFormNo: Integer): PFormItem;
  protected
    function CreateForm(AFormClass: TFormClass; AParam: TParamObject; AOwner: TComponent): IInterface;
  public
    Constructor Create;
    Destructor Destroy; override;

    procedure RegForm(AFormClass: TFormClass; AFormNo: Integer);

    function GetFormAsFromName(AFromName: string; AParam: TParamObject; AOwner: TComponent): IInterface;//��ȡҵ��ӿڵ�ʵ��
    function GetFormAsFromNo(AFromNo: Integer; AParam: TParamObject; AOwner: TComponent): IInterface;//��ȡҵ��ӿڵ�ʵ��

  end;

var
  gFormManage: TFormManage;


implementation

uses uSysSvc, uPubFun, uOtherIntf, uFactoryFormIntf, uDefCom, uMainFormIntf;

{ TBaseFormPlugin }

constructor TBaseFormPlugin.Create(Intf: IInterface);
begin
  inherited;

end;

destructor TBaseFormPlugin.Destroy;
begin

  inherited;
end;

procedure TBaseFormPlugin.final;
begin
  inherited;

end;

procedure TBaseFormPlugin.Init;
begin
  inherited;

end;

{ TFormManage }

procedure TFormManage.RegForm(AFormClass: TFormClass; AFormNo: Integer);
var
  aItemCount: Integer;
  aItem: PFormItem;
begin
  New(aItem);
  try
    aItem.FormNo := AFormNo;
    aItem.FormName := AFormClass.ClassName;
    aItem.FormClass := AFormClass;


    aItemCount := Length(FFormList) + 1;
    SetLength(FFormList, aItemCount);
    FFormList[aItemCount - 1] := aItem;
  except
    Dispose(aItem);
  end;
end;

constructor TFormManage.Create;
begin
  SetLength(FFormList, 0);
end;

destructor TFormManage.Destroy;
var
  i: Integer;
begin
  for i := 0 to Length(FFormList) - 1 do
  begin
    Dispose(FFormList[i]);
  end;
  SetLength(FFormList, 0);
  
  inherited;
end;

function TFormManage.GetFormAsFromName(AFromName: string; AParam: TParamObject; AOwner: TComponent): IInterface;
var
  aFormClass: PFormItem;
begin
  aFormClass := GetItemByName(AFromName);
  if not Assigned(aFormClass) then
  begin
    raise (SysService as IExManagement).CreateSysEx(StringFormat(Err_FrmNotSupport, [AFromName]));
  end;
  Result := CreateForm(aFormClass.FormClass, AParam, AOwner);
end;

function TFormManage.GetItemByName(AFormName: string): PFormItem;
var
  i: Integer;
begin
  Result := nil;
  for i := 0 to Length(FFormList) - 1 do
  begin
    if AnsiCompareStr(LowerCase(AFormName),
      LowerCase(FFormList[i].FormClass.ClassName)) = 0 then
    begin
      Result := FFormList[i];
      Exit;
    end;
  end;
end;

function TFormManage.GetFormAsFromNo(AFromNo: Integer; AParam: TParamObject;
  AOwner: TComponent): IInterface;
var
  aFormClass: PFormItem;
begin
  aFormClass := GetItemByNo(AFromNo);
  if not Assigned(aFormClass) then
  begin
    raise (SysService as IExManagement).CreateSysEx(StringFormat(Err_FrmNoNotSupport, [IntToStr(AFromNo)]));
  end;

  Result := CreateForm(aFormClass.FormClass, AParam, AOwner);
end;

function TFormManage.GetItemByNo(AFormNo: Integer): PFormItem;
var
  i: Integer;
begin
  Result := nil;
  for i := 0 to Length(FFormList) - 1 do
  begin
    if AFormNo = FFormList[i].FormNo then
    begin
      Result := FFormList[i];
      Exit;
    end;
  end;
end;

function TFormManage.CreateForm(AFormClass: TFormClass; AParam: TParamObject; AOwner: TComponent): IInterface;
var
  afrmParent: TfrmParent;
  aInstance: IInterface;
begin
  afrmParent := TfrmParent(AFormClass.NewInstance);
  afrmParent.CreateFrmParamList(AOwner, AParam);
//  if AOwner is TWinControl then
//  begin
//    afrmParent.Parent := TWinControl(AOwner);
//    afrmParent.BorderStyle := bsNone;
//    afrmParent.Align := alClient;
//  end;
  if afrmParent.FrmShowStyle = fssShow then
  begin
    afrmParent.Parent := (SysService as IMainForm).GetMDIShowClient;
    afrmParent.WindowState := wsMaximized; 
  end;
  afrmParent.GetInterface(IFormIntf, aInstance);
  Result := aInstance;
end;

initialization
  gFormManage := TFormManage.Create;
  
finalization
  gFormManage.Free;
  
end.






