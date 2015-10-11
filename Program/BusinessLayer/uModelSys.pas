unit uModelSys;

interface
uses
  Classes, Windows, SysUtils, DBClient, uPubFun, uParamObject, uBusinessLayerPlugin,
  uBaseInfoDef, uModelParent, uModelSysIntf;

type
  TModelTbxCfg = class(TModelBase, IModelTbxCfg)        //系统表格信息配置
  private
    procedure LoadGridData(AType: string; ACdsBaseList: TClientDataSet);
    function CheckTbxCfg(ACheckType: TTbxCheckType): Boolean;
    procedure GetTbxInfoRec(ATbxId: Integer; ACdsBaseList: TClientDataSet);//得到一条具体记录
    function ModfifyTbxInfoRec(ATbxId: Integer; ATbxInfoRec: TParamObject): Boolean;
  protected

  public
  
  end;
implementation

uses uModelFunCom, uOtherIntf;

{ TModelTbxCfg }

function TModelTbxCfg.CheckTbxCfg(ACheckType: TTbxCheckType): Boolean;
var
  aList: TParamObject;
  aSQL, aErrorMsg: string;
  aRet: Integer;
begin
  inherited;
  Result := False;
  aList := TParamObject.Create;
  try
    aList.Add('@OperatorID', gMFCom.OperatorID);
    if ACheckType = tctInsert then
      aList.Add('@CheckType', 'Insert')
    else if ACheckType = tctDel then
      aList.Add('@CheckType', 'Del');
    aRet := gMFCom.ExecProcByName('pbx_Sys_CheckTbxCfg', aList);
    if aRet <> 0 then
    begin
      aErrorMsg := aList.AsString('@errorValue');
      gMFCom.ShowMsgBox(aErrorMsg, '错误', mbtError);
      Exit;
    end;
    Result := True;
  finally
    aList.Free;
  end;
end;

procedure TModelTbxCfg.GetTbxInfoRec(ATbxId: Integer;
  ACdsBaseList: TClientDataSet);
var
  aList: TParamObject;
  aSQL: string;
begin
  aList := TParamObject.Create;
  try
    aSQL := 'SELECT * FROM tbx_Sys_TbxCfg WHERE TbxId = ' + IntToString(ATbxId);
    gMFCom.QuerySQL(aSQL, ACdsBaseList);
  finally
    aList.Free;
  end;
end;

procedure TModelTbxCfg.LoadGridData(AType: string; ACdsBaseList: TClientDataSet);
var
  aSQL: string;
begin
  try
    if AType = 'L' then
    begin
      aSQL := 'SELECT tbxId, tbxName, tbxDefName, tbxType, tbxComment FROM tbx_Sys_TbxCfg order by TbxRowIndex';
    end
    else if AType = 'U' then
    begin
      aSQL := 'SELECT so.name tbxName FROM SysObjects so LEFT JOIN tbx_Sys_TbxCfg tst ON tst.TbxId = so.id WHERE XType = ''U'' AND ( tst.TbxId IS NULL )';
    end
    else if AType = 'D' then
    begin
      aSQL := 'SELECT tbxName FROM dbo.tbx_Sys_TbxCfg WHERE TbxId NOT IN (SELECT id FROM SysObjects WHERE XType = ''U'')';
    end;

    gMFCom.QuerySQL(aSQL, ACdsBaseList);
  finally
  end;
end;

function TModelTbxCfg.ModfifyTbxInfoRec(ATbxId: Integer;
  ATbxInfoRec: TParamObject): Boolean;
var
  aList: TParamObject;
  aRet: Integer;
  aErrorMsg: string;
begin
  if not Assigned(ATbxInfoRec) then Exit;

  Result := False;
  aList := TParamObject.Create;
  try
    aList.Add('@TbxId', ATbxId);
    aList.Add('@TbxDefName', ATbxInfoRec.AsString('TbxDefName'));
    aList.Add('@TbxType', ATbxInfoRec.AsInteger('TbxType'));
    aList.Add('@TbxComment', ATbxInfoRec.AsString('TbxComment'));
    aList.Add('@errorValue', '');

    aRet := gMFCom.ExecProcByName('pbx_Sys_ModfifyTbx', aList);
    if aRet <> 0 then
    begin
      aErrorMsg := aList.AsString('@errorValue');
      gMFCom.ShowMsgBox(aErrorMsg, '错误', mbtError);
      Exit;
    end;
    Result := True;
  finally
    aList.Free;
  end;
end;

initialization
  gClassIntfManage.addClass(TModelTbxCfg, IModelTbxCfg);
  
end.
