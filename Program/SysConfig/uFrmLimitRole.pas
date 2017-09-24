unit uFrmLimitRole;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uFrmMDI, cxStyles, cxCustomData, cxGraphics, cxFilter, cxData,
  cxDataStorage, cxEdit, dxBar, dxBarExtItems, cxClasses, ImgList,
  ActnList, DB, DBClient, cxGridLevel, cxControls, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGrid, ExtCtrls, ComCtrls,
  cxContainer, cxTreeView, cxPC, uGridConfig, uModelFunIntf, uModelLimitIntf, uFrmApp,
  cxTL, cxInplaceContainer, cxGroupBox;

type
  TfrmLimitRole = class(TfrmMDI)
    btnAdd: TdxBarLargeButton;
    actAdd: TAction;
    btnModify: TdxBarLargeButton;
    btnDel: TdxBarLargeButton;
    actModify: TAction;
    actDel: TAction;
    pnlRolelist: TPanel;
    tvRole: TcxTreeView;
    pnlAction: TPanel;
    pcLimit: TcxPageControl;
    tsBase: TcxTabSheet;
    gridBase: TcxGrid;
    gridTVBase: TcxGridTableView;
    gridLVBase: TcxGridLevel;
    tsBill: TcxTabSheet;
    tsReport: TcxTabSheet;
    tsData: TcxTabSheet;
    tsOther: TcxTabSheet;
    btnSave: TdxBarLargeButton;
    actSaveRoleAction: TAction;
    cdsBase: TClientDataSet;
    actSetRoleAction: TAction;
    btnSetRoleAction: TdxBarLargeButton;
    actAddUser: TAction;
    btnAddUser: TdxBarLargeButton;
    gbUser: TcxGroupBox;
    tvUser: TcxTreeView;
    actDelUser: TAction;
    btnDelUser: TdxBarLargeButton;
    gridBill: TcxGrid;
    gridTVBill: TcxGridTableView;
    gridLVBill: TcxGridLevel;
    cdsBill: TClientDataSet;
    gridReport: TcxGrid;
    gridTVReport: TcxGridTableView;
    gridLVReport: TcxGridLevel;
    cdsReport: TClientDataSet;
    procedure actAddExecute(Sender: TObject);
    procedure actModifyExecute(Sender: TObject);
    procedure actDelExecute(Sender: TObject);
    procedure actSetRoleActionExecute(Sender: TObject);
    procedure actSaveRoleActionExecute(Sender: TObject);
    procedure tvRoleChange(Sender: TObject; Node: TTreeNode);
    procedure actAddUserExecute(Sender: TObject);
    procedure actDelUserExecute(Sender: TObject);
  private
    { Private declarations }
    FModelLimit: IModelLimit;
    FGridBase, FGridBill, FGridReport: TGridItem;
    FModelFun: IModelFun;
    
    procedure BeforeFormShow; override;
    procedure BeforeFormDestroy; override;
    procedure InitParamList; override;
    procedure IniGridField; override;
    procedure LoadGridData(ATypeid: string = ''); override;
    procedure LoadRoleTree;
    procedure LoadUserTree;
    function GetNodeData(AFullname, ATypeid: string): PNodeData;
    function SelNodeData(ATV: TcxTreeView): PNodeData;
    procedure SetOptState(AReadOnly: Boolean);
    function SaveRoleAction: Boolean;
  public
    { Public declarations }
  end;

var
  frmLimitRole: TfrmLimitRole;

implementation

uses uBaseFormPlugin, uSysSvc, uDBIntf, uMoudleNoDef, uModelControlIntf, uDefCom, uParamObject,
  uOtherIntf, uPubFun, uBaseInfoDef;

{$R *.dfm}

{ TfrmLimitRole }

procedure TfrmLimitRole.BeforeFormDestroy;
begin
  inherited;
  FreeBaseTVData(tvRole);
  FGridBase.Free;
  FGridBill.Free;
  FGridReport.Free;
end;

procedure TfrmLimitRole.BeforeFormShow;
begin
  inherited;
  FModelLimit := IModelLimit((SysService as IModelControl).GetModelIntf(IModelLimit));
  FModelFun := SysService as IModelFun;

  FGridBase := TGridItem.Create(fnLimitSetBase, gridBase, gridTVBase);
  FGridBase.SetGridCellSelect(True);
  FGridBase.ShowMaxRow := False;

  FGridBill := TGridItem.Create(fnLimitSetBill, gridBill, gridTVBill);
  FGridBill.SetGridCellSelect(True);
  FGridBill.ShowMaxRow := False;


  FGridReport := TGridItem.Create(fnLimitSetReport, gridReport, gridTVBill);
  FGridReport.SetGridCellSelect(True);
  FGridReport.ShowMaxRow := False;
  
  LoadRoleTree();
  LoadUserTree();
  IniGridField();
  LoadGridData();

  SetOptState(True);

  pcLimit.ActivePage := tsBase;
end;

procedure TfrmLimitRole.IniGridField;
var
  aColInfo: TColInfo;
begin
  inherited;
  FGridBase.ClearField();
  FGridBase.AddField('LAGUID', 'LAGUID', -1);
  FGridBase.AddField('LimitValue', 'LimitValue', -1, cfInt);
  aColInfo := FGridBase.AddField('LAName', '模块名称', 200);
  aColInfo.GridColumn.Options.Editing := False;
  FGridBase.AddCheckBoxCol('LView', '查看', 1, 0);
  FGridBase.AddCheckBoxCol('LAdd', '新增', 1, 0);
  FGridBase.AddCheckBoxCol('LClass', '分类', 1, 0);
  FGridBase.AddCheckBoxCol('LModify', '修改', 1, 0);
  FGridBase.AddCheckBoxCol('LDel', '删除', 1, 0);
  FGridBase.AddCheckBoxCol('LPrint', '打印', 1, 0);
  FGridBase.InitGridData;

  FGridBill.ClearField();
  FGridBill.AddField('LAGUID', 'LAGUID', -1);
  FGridBill.AddField('LimitValue', 'LimitValue', -1, cfInt);
  aColInfo := FGridBill.AddField('LAName', '模块名称', 200);
  aColInfo.GridColumn.Options.Editing := False;
  FGridBill.AddCheckBoxCol('LView', '查看', 1, 0);
  FGridBill.AddCheckBoxCol('LInput', '输入', 1, 0);
  FGridBill.AddCheckBoxCol('LSettle', '过账', 1, 0);
  FGridBill.AddCheckBoxCol('LPrint', '打印', 1, 0);
  FGridBill.InitGridData;

  FGridReport.ClearField();
  FGridReport.AddField('LAGUID', 'LAGUID', -1);
  FGridReport.AddField('LimitValue', 'LimitValue', -1, cfInt);
  aColInfo := FGridReport.AddField('LAName', '模块名称', 200);
  aColInfo.GridColumn.Options.Editing := False;
  FGridReport.AddCheckBoxCol('LView', '查看', 1, 0);
  FGridReport.AddCheckBoxCol('LPrint', '打印', 1, 0);
  FGridBill.InitGridData;
end;

procedure TfrmLimitRole.InitParamList;
begin
  inherited;
  MoudleNo := fnMdlLimitRole;
end;

procedure TfrmLimitRole.LoadGridData(ATypeid: string);
var
  aNodeData: PNodeData;
begin
  inherited;
  aNodeData := SelNodeData(tvRole);
  if not Assigned(aNodeData) then Exit;
  
  FModelLimit.UserLimitData(Limit_Base, aNodeData.Typeid, cdsBase);
  FGridBase.LoadData(cdsBase);

  FModelLimit.UserLimitData(Limit_Bill, aNodeData.Typeid, cdsBill);
  FGridBill.LoadData(cdsBill);

  FModelLimit.UserLimitData(Limit_Report, aNodeData.Typeid, cdsReport);
  FGridReport.LoadData(cdsReport);
end;

procedure TfrmLimitRole.LoadRoleTree;
var
  aCdsRole: TClientDataSet;
  aParam: TParamObject;
  aNodeData: PNodeData;
  aRootNode: TTreeNode;
begin
  FreeBaseTVData(tvRole);
  tvRole.Items.Clear;

  aRootNode := tvRole.Items.AddChildObject(nil, '角色列表', nil);

  aCdsRole := TClientDataSet.Create(nil);
  aParam := TParamObject.Create;
  tvRole.Items.BeginUpdate;
  try
    aParam.Add('@QryType', 1);
    FModelLimit.LimitData(aParam, aCdsRole);
    aCdsRole.First;
    while not aCdsRole.Eof do
    begin
      aNodeData := GetNodeData(aCdsRole.FieldByName('LRName').AsString, aCdsRole.FieldByName('LRGUID').AsString);
      tvRole.Items.AddChildObject(aRootNode, aNodeData.Fullname, aNodeData);

      aCdsRole.Next;
    end;

    tvRole.FullExpand;
    tvRole.Items.GetFirstNode.GetNext.Selected := True;
    tvRole.SetFocus;
  finally
    tvRole.Items.EndUpdate;
    aParam.Free;
    aCdsRole.Free;
  end;
end;

procedure TfrmLimitRole.actAddExecute(Sender: TObject);
var
  aName: string;
  aAddRole, aOutParam: TParamObject;
  aNodeData: PNodeData;
  aTreeNode: TTreeNode;
begin
  inherited;
  aName := '';
  if IMsgBox(SysService as IMsgBox).InputBox('角色', '输入角色名称', aName) = mrok then
  begin
    aAddRole := TParamObject.Create;
    aOutParam := TParamObject.Create;
    try
      aAddRole.Add('RoleName', Trim(aName));
      if FModelLimit.SaveLimit(Limit_Save_Role, aAddRole, aOutParam) >= 0 then
      begin
        aNodeData := GetNodeData(aName, aOutParam.AsString('LRGUID'));
        aTreeNode := tvRole.Items.AddChildObject(tvRole.Items.GetFirstNode, aNodeData.Fullname, aNodeData);
        aTreeNode.Selected := True;
        tvRole.SetFocus;
      end;
    finally
      aOutParam.Free;
      aAddRole.Free;
    end;
  end;
end;

function TfrmLimitRole.GetNodeData(AFullname, ATypeid: string): PNodeData;
var
  aNodeData: PNodeData;
begin
  New(aNodeData);
  aNodeData.Leveal := 1;
  aNodeData.Fullname := AFullname;
  aNodeData.Typeid := ATypeid;
  aNodeData.Parid := '';
  Result := aNodeData;
end;

procedure TfrmLimitRole.actModifyExecute(Sender: TObject);
var
  aName: string;
  aAddRole, aOutParam: TParamObject;
  aNodeData: PNodeData;
  aTreeNode: TTreeNode;
begin
  inherited;
  aNodeData := SelNodeData(tvRole);
  if not Assigned(aNodeData) then Exit;
  
  aName := aNodeData.Fullname;
  if IMsgBox(SysService as IMsgBox).InputBox('角色', '输入角色名称', aName) = mrok then
  begin
    aAddRole := TParamObject.Create;
    aOutParam := TParamObject.Create;
    try
      aAddRole.Add('RoleName', Trim(aName));
      aAddRole.Add('RoleId', aNodeData.Typeid);
      if FModelLimit.SaveLimit(Limit_Modify_Role, aAddRole, aOutParam) >= 0 then
      begin
        tvRole.Items.BeginUpdate;
        try
          aTreeNode.Text := aName;
          aNodeData.Fullname := aName;
          tvRole.SetFocus;
        finally
          tvRole.Items.EndUpdate;
        end;
      end;
    finally
      aOutParam.Free;
      aAddRole.Free;
    end;
  end;
end;

procedure TfrmLimitRole.actDelExecute(Sender: TObject);
var
  aName: string;
  aAddRole, aOutParam: TParamObject;
  aNodeData: PNodeData;
  aTreeNode: TTreeNode;
begin
  inherited;
  aNodeData := SelNodeData(tvRole);
  if not Assigned(aNodeData) then Exit;
  
  aAddRole := TParamObject.Create;
  aOutParam := TParamObject.Create;
  try;
    aAddRole.Add('RoleId', aNodeData.Typeid);
    if FModelLimit.SaveLimit(Limit_Del_Role, aAddRole, aOutParam) >= 0 then
    begin
      tvRole.Items.BeginUpdate;
      try
        Dispose(aNodeData);
        tvRole.Items.Delete(aTreeNode);
        tvRole.Items.GetFirstNode.GetNext.Selected := True;
        tvRole.SetFocus;
      finally
        tvRole.Items.EndUpdate;
      end;
    end;
  finally
    aOutParam.Free;
    aAddRole.Free;
  end;
end;

procedure TfrmLimitRole.SetOptState(AReadOnly: Boolean);
begin
  gridTVBill.OptionsData.Editing := not AReadOnly;
  gridTVBase.OptionsData.Editing := not AReadOnly;
  
  btnSave.Enabled := not AReadOnly;
  btnSetRoleAction.Enabled := AReadOnly;
end;

procedure TfrmLimitRole.actSetRoleActionExecute(Sender: TObject);
begin
  inherited;
  SetOptState(False);
end;

procedure TfrmLimitRole.actSaveRoleActionExecute(Sender: TObject);
begin
  inherited;
  if SaveRoleAction() then
  begin
    (SysService as IMsgBox).MsgBox(actSaveRoleAction.Caption + '完成！');
    SetOptState(True);
  end;
end;

function TfrmLimitRole.SaveRoleAction: Boolean;
var
  aRow, aOldLimitValue, aNewLimitValue: Integer;
  aLAGUID, aLAName: string;
  aLView, aLAdd, aLClass, aLModify, aLDel, aLPrint, aLInput, aLSettle: Boolean;
  aSaveRole, aOutParam: TParamObject;
  aNodeData: PNodeData;
begin
  inherited;
  FGridBase.GridPost();
  FGridBill.GridPost();
  
  aNodeData := SelNodeData(tvRole);
  if not Assigned(aNodeData) then Exit;

  Result := False;
  aSaveRole := TParamObject.Create;
  aOutParam := TParamObject.Create;
  try
    for aRow := FGridBase.GetFirstRow to FGridBase.GetLastRow do
    begin
      aSaveRole.Clear;
      aOutParam.Clear;

      aLAGUID := FGridBase.GetCellValue('LAGUID', aRow);
      aLAName := FGridBase.GetCellValue('LAName', aRow);

      aLView := FGridBase.GetCellValue('LView', aRow) = 1;
      aLAdd := FGridBase.GetCellValue('LAdd', aRow) = 1;
      aLClass := FGridBase.GetCellValue('LClass', aRow) = 1;
      aLModify := FGridBase.GetCellValue('LModify', aRow) = 1;
      aLDel := FGridBase.GetCellValue('LDel', aRow) = 1;
      aLPrint := FGridBase.GetCellValue('LPrint', aRow) = 1;
    
      aOldLimitValue := FGridBase.GetCellValue('LimitValue', aRow);

      aNewLimitValue := 0;
      if aLView then aNewLimitValue := aNewLimitValue + Limit_Base_View;
      if aLAdd then aNewLimitValue := aNewLimitValue + Limit_Base_Add;
      if aLClass then aNewLimitValue := aNewLimitValue + Limit_Base_Class;
      if aLModify then aNewLimitValue := aNewLimitValue + Limit_Base_Modify;
      if aLDel then aNewLimitValue := aNewLimitValue + Limit_Base_Del;
      if aLPrint then aNewLimitValue := aNewLimitValue + Limit_Base_Print;

      if aNewLimitValue = aOldLimitValue then Continue;
      
      aSaveRole.Add('@LAGUID', aLAGUID);
      aSaveRole.Add('@RUID', aNodeData.Typeid);
      aSaveRole.Add('@RUType', 1);
      aSaveRole.Add('@LimitValue', aNewLimitValue);

      if FModelLimit.SaveLimit(Limit_Save_RoleAction, aSaveRole, aOutParam) < 0 then
      begin
        (SysService as IMsgBox).MsgBox('更新权限<' + aLAName + '>失败');
        Exit;
      end;
    end;

    for aRow := FGridBill.GetFirstRow to FGridBill.GetLastRow do
    begin
      aSaveRole.Clear;
      aOutParam.Clear;

      aLAGUID := FGridBill.GetCellValue('LAGUID', aRow);
      aLAName := FGridBill.GetCellValue('LAName', aRow);

      aLView := FGridBill.GetCellValue('LView', aRow) = 1;
      aLInput := FGridBill.GetCellValue('LInput', aRow) = 1;
      aLSettle := FGridBill.GetCellValue('LSettle', aRow) = 1;
      aLPrint := FGridBill.GetCellValue('LPrint', aRow) = 1;
    
      aOldLimitValue := FGridBill.GetCellValue('LimitValue', aRow);

      aNewLimitValue := 0;
      if aLView then aNewLimitValue := aNewLimitValue + Limit_Bill_View;
      if aLInput then aNewLimitValue := aNewLimitValue + Limit_Bill_Input;
      if aLSettle then aNewLimitValue := aNewLimitValue + Limit_Bill_Settle;
      if aLPrint then aNewLimitValue := aNewLimitValue + Limit_Bill_Print;

      if aNewLimitValue = aOldLimitValue then Continue;
      
      aSaveRole.Add('@LAGUID', aLAGUID);
      aSaveRole.Add('@RUID', aNodeData.Typeid);
      aSaveRole.Add('@RUType', 1);
      aSaveRole.Add('@LimitValue', aNewLimitValue);

      if FModelLimit.SaveLimit(Limit_Save_RoleAction, aSaveRole, aOutParam) < 0 then
      begin
        (SysService as IMsgBox).MsgBox('更新权限<' + aLAName + '>失败');
        Exit;
      end;
    end;
    LoadGridData();
    Result := True;
  finally
    aSaveRole.Free;
    aOutParam.Free;
  end;
end;

function TfrmLimitRole.SelNodeData(ATV: TcxTreeView): PNodeData;
var
  aNodeData: PNodeData;
  aTreeNode: TTreeNode;
begin
  Result := nil;
  aTreeNode :=  ATV.Selected;
  if not Assigned(aTreeNode) then Exit;

  aNodeData := aTreeNode.Data;
  if not Assigned(aNodeData) then Exit;

  Result := aNodeData;
end;

procedure TfrmLimitRole.tvRoleChange(Sender: TObject; Node: TTreeNode);
begin
  inherited;
  LoadUserTree();
  LoadGridData();
end;

procedure TfrmLimitRole.LoadUserTree;
var
  aCdsUser: TClientDataSet;
  aParam: TParamObject;
  aNodeData: PNodeData;
  aRootNode: TTreeNode;
begin
  aNodeData := SelNodeData(tvRole);
  if not Assigned(aNodeData) then Exit;

  aCdsUser := TClientDataSet.Create(nil);
  aParam := TParamObject.Create;
  tvUser.Items.BeginUpdate;
  try
    aParam.Add('@QryType', 2);
    aParam.Add('@Custom', aNodeData.Typeid);
    if FModelLimit.LimitData(aParam, aCdsUser) = 0 then
    begin
      FreeBaseTVData(tvUser);
      tvUser.Items.Clear;
      aCdsUser.First;
      while not aCdsUser.Eof do
      begin
        aNodeData := GetNodeData(aCdsUser.FieldByName('EFullname').AsString, aCdsUser.FieldByName('UserId').AsString);
        aRootNode := tvUser.Items.AddChildObject(nil, aNodeData.Fullname, aNodeData);
        aCdsUser.Next;
      end;
    end;
  finally
    tvUser.Items.EndUpdate;
    aParam.Free;
    aCdsUser.Free;
  end;
end;


procedure TfrmLimitRole.actAddUserExecute(Sender: TObject);
var
  aReturnCount: Integer;
  aSelectParam: TSelectBasicParam;
  aSelectOptions: TSelectBasicOptions;
  aReturnArray: TSelectBasicDatas;
  aAddRole, aOutParam: TParamObject;
  aNodeData: PNodeData;
  aRootNode: TTreeNode;
begin
  inherited;
  aNodeData := SelNodeData(tvRole);
  if not Assigned(aNodeData) then Exit;

  DoSelectBasic(btnAddUser, btEtype, aSelectParam, aSelectOptions, aReturnArray, aReturnCount);
  if aReturnCount >= 1 then
  begin
    aAddRole := TParamObject.Create;
    aOutParam := TParamObject.Create;
    try;
      aAddRole.Add('@LRGUID', aNodeData.Typeid);
      aAddRole.Add('@UserId', aReturnArray[0].TypeId);
      if FModelLimit.SaveLimit(Limit_Save_RU, aAddRole, aOutParam) >= 0 then
      begin
        LoadUserTree();
        (SysService as IMsgBox).MsgBox(btnAddUser.Caption + '完成');
      end;
    finally
      aOutParam.Free;
      aAddRole.Free;
    end;
  end;
end;

procedure TfrmLimitRole.actDelUserExecute(Sender: TObject);
var
  aName: string;
  aAddRole, aOutParam: TParamObject;
  aNodeData: PNodeData;
  aTreeNode: TTreeNode;
begin
  inherited;
  aAddRole := TParamObject.Create;
  aOutParam := TParamObject.Create;
  try;
    aNodeData := SelNodeData(tvRole);
    if not Assigned(aNodeData) then Exit;
    aAddRole.Add('RoleId', aNodeData.Typeid);

    aNodeData := SelNodeData(tvUser);
    if not Assigned(aNodeData) then Exit;
    aAddRole.Add('UserId', aNodeData.Typeid);
    if FModelLimit.SaveLimit(Limit_Del_RU, aAddRole, aOutParam) >= 0 then
    begin
      LoadUserTree();
    end;
  finally
    aOutParam.Free;
    aAddRole.Free;
  end;
end;

initialization
  gFormManage.RegForm(TfrmLimitRole, fnMdlLimitRole);

end.

