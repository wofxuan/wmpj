unit uModelLimit;

interface

uses
  Classes, Windows, SysUtils, DBClient, Controls, uPubFun, uParamObject, uBusinessLayerPlugin,
  uBaseInfoDef, uModelParent, uModelLimitIntf;

type
  TModelLimit = class(TModelBase, IModelLimit) //权限设置
  private

  protected
    function UserLimitData(ALimitType: Integer; AUserID: string; ACdsLimit: TClientDataSet): Integer; //加载用户对应类型的权限
    function LimitData(AParam: TParamObject; ACdsLimit: TClientDataSet): Integer; //功能,角色等数据
    function SaveLimit(ASaveType: Integer; ASaveData: TParamObject; AOutPutData: TParamObject): Integer; //保存角色，或角色与用户映射等
    function CheckLimit(ALimitDo: Integer; ALimitId, AUserId: string): Boolean; //判断某个用户是否具有某种权限点某种操作
    function GetLimitId(AKeyId: Integer): string; //某个模块对应的LimitId
  public

  end;

var
  gLimitIdKeyList: TStringList;

procedure IniLimitIdKeyList;

implementation

uses uSysSvc, uModelFunCom, uOtherIntf, uMoudleNoDef;

procedure IniLimitIdKeyList;
begin
  gLimitIdKeyList.Add(IntToString(fnMdlBasePtypeList) + '={48B70E42-705F-48C3-928F-FD94280F14D7}');
  gLimitIdKeyList.Add(IntToString(fnMdlBaseBtypeList) + '={D56591FC-49A2-4C6E-8A43-1A04D553CED2}');
  gLimitIdKeyList.Add(IntToString(fnMdlBaseEtypeList) + '={11831D9E-664A-4DD7-8B6A-8D286A15F31B}');
  gLimitIdKeyList.Add(IntToString(fnMdlBaseDtypeList) + '={64E32F93-0BED-40E6-8EE5-3AA25FA8D3B2}');
  gLimitIdKeyList.Add(IntToString(fnMdlBaseKtypeList) + '={3E91FE79-1072-4B99-AFD3-E4759B6C11ED}');

  gLimitIdKeyList.Add(IntToString(fnMdlBillOrderBuy) + '={C68FA10B-741B-462E-9646-6A37E8A79543}');
  gLimitIdKeyList.Add(IntToString(fnMdlBillBuy) + '={CD40BCFC-099E-476D-8560-5F65A7F9441D}');
  gLimitIdKeyList.Add(IntToString(fnMdlBillGathering) + '={4D06B1CD-38AA-431D-84ED-534676C46645}');
  gLimitIdKeyList.Add(IntToString(fnMdlBillOrderSale) + '={6138233E-9524-423F-881C-DAF556611881}');
  gLimitIdKeyList.Add(IntToString(fnMdlBillSale) + '={5AF10361-EAF6-4C63-B0CD-71B15802C9FC}');
  gLimitIdKeyList.Add(IntToString(fnMdlBillPayment) + '={50202B7A-256F-4B40-A142-8F78F9AE82A4}');
  gLimitIdKeyList.Add(IntToString(fnMdlBillAllot) + '={30B95AAD-6ABA-4BBF-94B8-FF9C8B3E059A}');

  gLimitIdKeyList.Add(IntToString(fnMdlReportGoods) + '={AE2801FC-192F-4965-9994-7E6E74366510}');
  gLimitIdKeyList.Add(IntToString(fnMdlReportOrderBuy) + '={38C6C242-121E-4F3F-B0B7-2E51B8C4F9DE}');
  gLimitIdKeyList.Add(IntToString(fnMdlReportBuy) + '={20C50FBF-5B4C-44AF-900B-4087BFB98880}');
  gLimitIdKeyList.Add(IntToString(fnMdlReportOrderSale) + '={350BF069-4CD4-4CBF-8F62-AEF407148AD4}');
  gLimitIdKeyList.Add(IntToString(fnMdlReportSale) + '={7CDCC33E-9355-46ED-8E4B-6AE919F8AC2E}');
end;
{ TModelLimit }

function TModelLimit.CheckLimit(ALimitDo: Integer; ALimitId, AUserId: string): Boolean;
var
  aRet: Integer;
  aCheckParam: TParamObject;
begin
  Result := False;
  aCheckParam := TParamObject.Create;
  try
    aCheckParam.Add('@LimitId', ALimitId);
    aCheckParam.Add('@LimitDo', ALimitDo);
    aCheckParam.Add('@UserId', AUserId);
    aRet := gMFCom.ExecProcByName('pbx_Limit_Check', aCheckParam);
    if aRet <> 0 then
    begin
//      gMFCom.ShowMsgBox(aCheckParam.AsString('@ErrorValue'), '提示', mbtInformation);
      raise (SysService as IExManagement).CreateFunEx(aCheckParam.AsString('@ErrorValue'));
    end;
    Result := aRet = 0;
  finally
    aCheckParam.Free;
  end;
end;

function TModelLimit.GetLimitId(AKeyId: Integer): string;
var
  aIndex: Integer;
begin
  Result := '';
  aIndex := gLimitIdKeyList.IndexOfName(IntToString(AKeyId));
  if aIndex >= 0 then
    Result := gLimitIdKeyList.ValueFromIndex[aIndex];
end;

function TModelLimit.LimitData(AParam: TParamObject;
  ACdsLimit: TClientDataSet): Integer;
begin
  try
    Result := gMFCom.ExecProcBackData('pbx_Limit_QryData', AParam, ACdsLimit);
  finally
  end;
end;

function TModelLimit.SaveLimit(ASaveType: Integer; ASaveData,
  AOutPutData: TParamObject): Integer;
var
  aRoleName, aSQL, aRoleId, aUserId, aSucMsg: string;
  aRoleGUID: TGUID;
begin
  Result := -1;
  aSQL := EmptyStr;
  case ASaveType of
    Limit_Save_Role:
      begin
        aRoleName := Trim(ASaveData.AsString('RoleName'));
        if StringEmpty(aRoleName) then
        begin
          gMFCom.ShowMsgBox('角色名称不能为空！', '错误', mbtError);
          Exit;
        end;
        CreateGUID(aRoleGUID);
        aRoleId := GUIDToString(aRoleGUID);
        aSQL := ' INSERT INTO dbo.tbx_Limit_Role ( LRGUID, LRName) ' +
          ' VALUES  ( ' + QuotedStr(aRoleId) + ', ' + QuotedStr(aRoleName) + ')';

        aSucMsg := '保存角色成功！';
      end;
    Limit_Modify_Role:
      begin
        aRoleName := Trim(ASaveData.AsString('RoleName'));
        if StringEmpty(aRoleName) then
        begin
          gMFCom.ShowMsgBox('角色名称不能为空！', '错误', mbtError);
          Exit;
        end;
        aRoleId := Trim(ASaveData.AsString('RoleId'));

        aSQL := ' UPDATE dbo.tbx_Limit_Role SET LRName = ' + QuotedStr(aRoleName) +
          ' WHERE LRGUID = ' + QuotedStr(aRoleId);

        aSucMsg := '修改角色成功！';
      end;
    Limit_Del_Role:
      begin
        if gMFCom.ShowMsgBox('数据删除后不能恢复，请确认删除！', '提示',
          mbtInformation, mbbOKCancel) <> mrok then Exit;

        aRoleId := Trim(ASaveData.AsString('RoleId'));
        aSQL := ' DELETE dbo.tbx_Limit_Role WHERE LRGUID = ' + QuotedStr(aRoleId);
        aSucMsg := '删除角色成功！';
      end;
    Limit_Save_RoleAction:
      begin
        Result := gMFCom.ExecProcByName('pbx_Limit_Save_RA', ASaveData);
        if Result <> 0 then
        begin
          gMFCom.ShowMsgBox(ASaveData.AsString('@ErrorValue'), '提示', mbtInformation);
        end;
        Exit;
      end;
    Limit_Save_RU:
      begin
        Result := gMFCom.ExecProcByName('pbx_Limit_Save_RU', ASaveData);
        if Result <> 0 then
        begin
          gMFCom.ShowMsgBox(ASaveData.AsString('@ErrorValue'), '提示', mbtInformation);
        end;
        Exit;
      end;
    Limit_Del_RU:
      begin
        if gMFCom.ShowMsgBox('数据删除后不能恢复，请确认删除！', '提示',
          mbtInformation, mbbOKCancel) <> mrok then Exit;

        aRoleId := Trim(ASaveData.AsString('RoleId'));
        aUserId := Trim(ASaveData.AsString('UserId'));
        aSQL := ' DELETE dbo.tbx_Limit_RU WHERE LRGUID = ' + QuotedStr(aRoleId) + ' AND UserId = ' + QuotedStr(aUserId);
        aSucMsg := '删除用户成功！';
      end;
  else

  end;
  if not StringEmpty(aSQL) then
  begin
    Result := gMFCom.OpenSQL(aSQL);
    if Result < 0 then
    begin
      (SysService as ILog).WriteLogTxt(ltErrFun, '执行SQL<' + aSQL + '>错误');
      gMFCom.ShowMsgBox('执行数据操作错误！', '错误', mbtError);
      Exit;
    end
    else
    begin
      gMFCom.ShowMsgBox(aSucMsg, '提示', mbtInformation);
    end;
  end;
end;

function TModelLimit.UserLimitData(ALimitType: Integer; AUserID: string;
  ACdsLimit: TClientDataSet): Integer;
var
  aList: TParamObject;
begin
  aList := TParamObject.Create;
  try
    aList.Add('@RUID', AUserID);
    aList.Add('@RUType', 1);
    aList.Add('@LimitType', ALimitType);
    Result := gMFCom.ExecProcBackData('pbx_Limit_User', aList, ACdsLimit);
  finally
    aList.Free;
  end;
end;

initialization
  gClassIntfManage.addClass(TModelLimit, IModelLimit);
  gLimitIdKeyList := TStringList.Create;
  IniLimitIdKeyList();

finalization
  gLimitIdKeyList.Free;

end.

