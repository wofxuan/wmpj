{***************************
界面控件与存储过程参数字段配置
为了减少对界面控件的值的获取和赋值
mx 2015-04-28
****************************}
unit uDBComConfig;

interface

uses
  Windows, Classes, Db, DBClient, SysUtils, Controls, cxGrid, cxGridCustomView, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGraphics, uParamObject, cxButtons, ExtCtrls, Mask, cxTextEdit, cxMaskEdit, cxButtonEdit,
  cxDropDownEdit, ComCtrls, cxStyles, cxCustomData, cxFilter, uBaseInfoDef, uModelFunIntf,
  cxData, cxDataStorage, cxDBData, cxGridLevel, cxClasses, cxMemo, cxCalendar, Forms, uDefCom;

const
  EXPPlusInt = '[1-9]\d*|0'; //正整数(允许0)的正则表达式
  EXPInt = '(0|-?[1-9]\d*)'; //整数
  EXPFloat = '(-?\d+)(\.\d+)'; //浮点数

type
  //记录一个界面控件和对应参数等信息
  PDBComItem = ^TDBComItem;
  TDBComItem = record
    Component: TControl; //绑定的控件
    SetDBName: string; //赋值时的字段
    GetDBName: string; //取值时的字段
    BasicType: TBasicType;//是否是基本信息字段
    ShowFields: string;//显示基本信息哪个字段
    TypeId: string;//基本信息赋值取值用此字段
    EditType: TColField;//输入的类型
  end;

  TDBComArray = array of PDBComItem;

  //管理和控制一个界面里面的控件对应的数据库参数
  TFormDBComItem = class(TObject)
  private
    FOwnerFrom: TForm;
    FModelFun: IModelFun;
    FDBComList: TDBComArray;
    FOnSelectBasic: TSelectBasicinfoEvent; //弹出TC类选择框

    procedure TCButtonClick(Sender: TObject; AButtonIndex: Integer);//基本信息类型，点击按钮弹出TC框
    procedure EdtKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);//基本信息类型，回车弹出TC框
  protected

  public
    constructor Create(AOwner: TForm);
    destructor Destroy; override;

    procedure GetDataFormParam(AParam: TParamObject); //从TParamObject中取值
    procedure SetDataToParam(AParam: TParamObject); //给ParamObject赋值

    function AddItem(AControl: TControl; ASetDBNane: string; AGetDBName: string; AEditType: TColField = cfString): PDBComItem; overload; //通过已有的控件添加一个数据项
    function AddItem(AControl: TControl; ADBName: string): PDBComItem; overload;
    function AddItem(AControl: TControl; ASetDBName, AGetDBName, AFieldsList: string; ABasicType: TBasicType): PDBComItem; overload;
    procedure ClearItemData;

    procedure SetBasicItemValue(AControl: TControl; ASelectBasicData: TSelectBasicData);//给绑定了基本信息的控件赋值

    function GetItemValue(AControl: TControl): Variant;//回去控件的值
    procedure SetReadOnly(AControl: TControl; AReadOnly: Boolean = True);//设置是否只读
  published
    property DBComList: TDBComArray read FDBComList;
    property OnSelectBasic: TSelectBasicinfoEvent read FOnSelectBasic write FOnSelectBasic;
    
  end;

implementation

uses uSysSvc, uOtherIntf, cxCheckBox, Graphics, Messages, uPubFun;


{ TFormDBComItem }

function TFormDBComItem.AddItem(AControl: TControl; ASetDBNane,
  AGetDBName: string; AEditType: TColField = cfString): PDBComItem;
var
  aLen: Integer;
  aItem: PDBComItem;
  aEdt: TcxButtonEdit;
begin
  aItem := New(PDBComItem);
  aItem.Component := AControl;
  aItem.SetDBName := ASetDBNane;
  aItem.GetDBName := AGetDBName;
  aItem.BasicType := btNo;
  aItem.EditType := AEditType;

  if AControl is TcxButtonEdit then
  begin
    aEdt := TcxButtonEdit(AControl);
    aEdt.OnKeyDown := EdtKeyDown;

    aEdt.Properties.MaskKind := emkRegExprEx;
    case AEditType of
      cfInt: aEdt.Properties.EditMask := EXPInt;
      cfPlusInt: aEdt.Properties.EditMask := EXPPlusInt;
      cfFloat: aEdt.Properties.EditMask := EXPFloat;
    else

    end;
  end
  else if AControl is TcxDateEdit then
  begin
    TcxDateEdit(AControl).OnKeyDown := EdtKeyDown;
  end;
  
  aLen := Length(FDBComList) + 1;
  SetLength(FDBComList, aLen);
  FDBComList[aLen - 1] := aItem;
  Result := aItem;
end;

function TFormDBComItem.AddItem(AControl: TControl;
  ADBName: string): PDBComItem;
begin
  Result := AddItem(AControl, ADBName, ADBName);
end;

function TFormDBComItem.AddItem(AControl: TControl; ASetDBName, AGetDBName, AFieldsList: string;
  ABasicType: TBasicType): PDBComItem;
var
  aDBComItem: PDBComItem;
begin
  aDBComItem := AddItem(AControl, ASetDBName, AGetDBName);
  aDBComItem.BasicType := ABasicType;
  aDBComItem.ShowFields := AFieldsList;
  Result := aDBComItem;
  if AControl is TcxButtonEdit then
  begin
    TcxButtonEdit(AControl).Properties.OnButtonClick := TCButtonClick;
  end
  else
  begin
    raise(SysService as IExManagement).CreateSysEx('控件[' + AControl.ClassName + ']不是TcxButtonEdit类型控件，不支持基本信息弹出框！');
  end;
end;

procedure TFormDBComItem.EdtKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
  begin
    if Sender is TcxButtonEdit then TCButtonClick(Sender, 0);
    FOwnerFrom.Perform(WM_NEXTDLGCTL, 0, 0); //焦点跳转到下一个控件
//    FOwnerFrom.SelectNext(ActiveControl, True, True);
//    TWinControl(FOwnerFrom).SelectNext(TcxButtonEdit(Sender), True, False);
  end;
end;

procedure TFormDBComItem.ClearItemData;
var
  i: Integer;
  aItem: PDBComItem;
begin
  inherited;
  for i := 0 to Length(Self.DBComList) - 1 do
  begin
    aItem := Self.DBComList[i];
    if aItem.Component is TcxButtonEdit then
    begin
      TcxButtonEdit(aItem.Component).Text := '';
      if not IsSaveToLocal(aItem.BasicType) then
      begin
        TcxButtonEdit(aItem.Component).Properties.Buttons.Clear;
      end;
    end
    else if aItem.Component is TcxComboBox then
    begin
      if TcxComboBox(aItem.Component).Properties.Items.Count > 0 then
        TcxComboBox(aItem.Component).ItemIndex := 0
      else
        TcxComboBox(aItem.Component).ItemIndex := -1;
    end
    else if aItem.Component is TcxCheckBox then
    begin
      TcxCheckBox(aItem.Component).Checked := False;
    end
    else if aItem.Component is TcxMemo then  
    begin
      TcxMemo(aItem.Component).Text := '';
    end
    else if aItem.Component is TcxDateEdit then
    begin
      TcxDateEdit(aItem.Component).Text := FormatdateTime('YYYY-MM-DD', Now);
    end
    else
    begin
      raise(SysService as IExManagement).CreateSysEx('绑定未知类型的控件[' + aItem.Component.ClassName + '],请设置清空数据方式！');
    end;
  end;
end;

constructor TFormDBComItem.Create(AOwner: TForm);
begin
  SetLength(FDBComList, 0);
  FOwnerFrom := AOwner;
  FModelFun := SysService as IModelFun;
end;

destructor TFormDBComItem.Destroy;
var
  i: Integer;
begin
  for i := 0 to Length(FDBComList) - 1 do
  begin
    Dispose(FDBComList[i]);
  end;
  SetLength(FDBComList, 0);
  inherited;
end;

procedure TFormDBComItem.GetDataFormParam(AParam: TParamObject);
var
  i: Integer;
  aItem: PDBComItem;
  aValue: string;
begin
  inherited;
  for i := 0 to Length(Self.DBComList) - 1 do
  begin
    aItem := Self.DBComList[i];
    if aItem.Component is TcxButtonEdit then
    begin
      aValue := AParam.AsString(aItem.GetDBName);
      if IsSaveToLocal(aItem.BasicType) and (not StringEmpty(aValue)) then
      begin
        aItem.TypeId := aValue;
        aValue := FModelFun.GetLocalValue(aItem.BasicType, aItem.ShowFields, aValue);
      end;
      TcxButtonEdit(aItem.Component).Text := aValue;
    end
    else if aItem.Component is TcxComboBox then
    begin
      TcxComboBox(aItem.Component).ItemIndex := AParam.AsInteger(aItem.GetDBName);
    end
    else if aItem.Component is TcxCheckBox then
    begin
      TcxCheckBox(aItem.Component).Checked := AParam.AsInteger(aItem.GetDBName) = 1;
    end
    else if aItem.Component is TcxMemo then
    begin
      TcxMemo(aItem.Component).Text := AParam.AsString(aItem.GetDBName);
    end
    else if aItem.Component is TcxDateEdit then
    begin
      TcxDateEdit(aItem.Component).Text := AParam.AsString(aItem.GetDBName);
    end
    else
    begin
      raise(SysService as IExManagement).CreateSysEx('绑定未知类型的控件[' + aItem.Component.ClassName + '],请设置赋值方式！');
    end;
  end;
end;

function TFormDBComItem.GetItemValue(AControl: TControl): Variant;
var
  i: Integer;
  aItem: PDBComItem;
  aValue: string;
  aFindCon: Boolean;
begin
  inherited;
  Result := '';
  aFindCon := False;
  for i := 0 to Length(Self.DBComList) - 1 do
  begin
    aItem := Self.DBComList[i];
    if aItem.Component = AControl then
    begin
      aFindCon := True;
      if aItem.Component is TcxButtonEdit then
      begin
        aValue := Trim(TcxButtonEdit(aItem.Component).Text);
        if IsSaveToLocal(aItem.BasicType) then
        begin
          aValue := aItem.TypeId;
        end;
        Result := aValue;
      end
      else if aItem.Component is TcxComboBox then
      begin
        Result := TcxComboBox(aItem.Component).ItemIndex;
      end
      else if aItem.Component is TcxCheckBox then
      begin
        if TcxCheckBox(aItem.Component).Checked then
          Result := 1
        else
          Result := 0;
      end
      else if aItem.Component is TcxMemo then
      begin
        Result :=  Trim(TcxButtonEdit(aItem.Component).Text)
      end
      else if aItem.Component is TcxDateEdit then
      begin
        Result :=  Trim(TcxDateEdit(aItem.Component).Text);
      end
      else
      begin
        raise(SysService as IExManagement).CreateSysEx('绑定未知类型的控件[' + aItem.Component.ClassName + '],请设置取值方式！');
      end;
      Break;
    end;
  end;
  if not aFindCon then
  begin
    FModelFun.ShowMsgBox('没有发现绑定的控件！','提示')
  end;
end;

procedure TFormDBComItem.SetBasicItemValue(AControl: TControl;
  ASelectBasicData: TSelectBasicData);
var
  i, aReturnCount: Integer;
  aItem: PDBComItem;
begin
  for i := 0 to Length(FDBComList) - 1 do
  begin
    aItem := FDBComList[i];
    if aItem.Component = AControl then
    begin
      TcxButtonEdit(aItem.Component).Text := ASelectBasicData.FullName;
      aItem.TypeId := ASelectBasicData.TypeId;
      Break;
    end;
  end;
end;

procedure TFormDBComItem.SetDataToParam(AParam: TParamObject);
var
  i: Integer;
  aItem: PDBComItem;
  aValue: string;
begin
  inherited;
  for i := 0 to Length(Self.DBComList) - 1 do
  begin
    aItem := Self.DBComList[i];
    AParam.Add('@' + aItem.SetDBName, GetItemValue(aItem.Component));
  end;
end;

procedure TFormDBComItem.TCButtonClick(Sender: TObject;
  AButtonIndex: Integer);
var
  i, aReturnCount: Integer;
  aBasicType: TBasicType;
  aSelectParam: TSelectBasicParam;
  aSelectOptions: TSelectBasicOptions;
  aReturnArray: TSelectBasicDatas;
  aItem: PDBComItem;
begin
  for i := 0 to Length(FDBComList) - 1 do
  begin
    aItem := FDBComList[i];
    if aItem.Component is TcxButtonEdit then
    begin
      if IsSaveToLocal(aItem.BasicType) then
      begin
        if aItem.Component = Sender then
        begin
          if TcxButtonEdit(aItem.Component).Properties.ReadOnly then Exit;
          OnSelectBasic(aItem.Component, aItem.BasicType, aSelectParam, aSelectOptions, aReturnArray, aReturnCount);
          if aReturnCount >= 1 then
          begin
            SetBasicItemValue(aItem.Component, aReturnArray[0]);
          end;
          Break;
        end;
      end;
    end;
  end;
end;

procedure TFormDBComItem.SetReadOnly(AControl: TControl;
  AReadOnly: Boolean);
var
  i: Integer;
  aItem: PDBComItem;
  aValue: string;
begin
  inherited;
  for i := 0 to Length(Self.DBComList) - 1 do
  begin
    aItem := DBComList[i];
    if Assigned(AControl) then
    begin
      if AControl <> aItem.Component then Continue;
    end;

    if aItem.Component is TcxButtonEdit then
    begin
      TcxButtonEdit(aItem.Component).Properties.ReadOnly := AReadOnly;
    end
    else if aItem.Component is TcxComboBox then
    begin
      TcxComboBox(aItem.Component).Properties.ReadOnly := AReadOnly;
    end
    else if aItem.Component is TcxCheckBox then
    begin
      TcxCheckBox(aItem.Component).Properties.ReadOnly := AReadOnly;
    end
    else if aItem.Component is TcxMemo then
    begin
      TcxButtonEdit(aItem.Component).Properties.ReadOnly := AReadOnly;
    end
    else if aItem.Component is TcxDateEdit then
    begin
      TcxDateEdit(aItem.Component).Properties.ReadOnly := AReadOnly;
    end
    else
    begin
      raise(SysService as IExManagement).CreateSysEx('绑定未知类型的控件[' + aItem.Component.ClassName + ']!');
    end;
  end;
end;

initialization

finalization

end.

