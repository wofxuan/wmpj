unit uModelBaseType;

interface

uses
  Classes, Windows, SysUtils, DBClient, uPubFun, uParamObject, uBaseInfoDef, uDefCom, uBusinessLayerPlugin,
  uModelParent, uModelBaseTypeIntf;

type
  TModelBaseItype = class(TModelBaseType, IModelBaseTypeItype) //基本信息-加载包处理领域
  private

  protected
    function GetSaveProcName: string; override;
    function CheckData(AParamList: TParamObject; var Msg: string): Boolean; virtual; //检查数据
  public
    destructor Destroy; override;

  end;

  TModelBasePtype = class(TModelBaseType, IModelBaseTypePtype) //基本信息-商品处理领域
  private

  protected
    function GetSaveProcName: string; override;
    function CheckData(AParamList: TParamObject; var Msg: string): Boolean; override; //检查数据
  public
    destructor Destroy; override;

  end;

  TModelBaseBtype = class(TModelBaseType, IModelBaseTypeBtype) //基本信息-单位处理领域
  private

  protected
    function GetSaveProcName: string; override;
  public

  end;

  TModelBaseEtype = class(TModelBaseType, IModelBaseTypeEtype) //基本信息-职员处理领域
  private

  protected
    function GetSaveProcName: string; override;
  public

  end;

  TModelBaseDtype = class(TModelBaseType, IModelBaseTypeDtype) //基本信息-部门处理领域
  private

  protected
    function GetSaveProcName: string; override;
  public

  end;

  TModelBaseKtype = class(TModelBaseType, IModelBaseTypeKtype) //基本信息-仓库处理领域
  private

  protected
    function GetSaveProcName: string; override;
  public

  end;

implementation

{ TBusinessBasicLtype }

function TModelBaseItype.CheckData(AParamList: TParamObject;
  var Msg: string): Boolean;
begin

end;

destructor TModelBaseItype.Destroy;
begin

  inherited;
end;

function TModelBaseItype.GetSaveProcName: string;
begin
  Result := inherited GetSaveProcName;
  case Self.DataChangeType of
    dctAdd, dctAddCopy, dctClass:
      begin
        Result := 'pbx_Base_InsertI';                       //增加
      end;
    dctModif:
      begin
        Result := 'pbx_Base_UpdateI';                       //修改
      end;
  end;
end;

{ TModelBasePtype }

function TModelBasePtype.CheckData(AParamList: TParamObject;
  var Msg: string): Boolean;
begin
  Result := False;
  if not IsNumberic(AParamList.AsString('@UsefulLifeday')) then
  begin
    Msg := '有效期必须是数字！';
    Exit;
  end;
  Result := True;
end;

destructor TModelBasePtype.Destroy;
begin

  inherited;
end;

function TModelBasePtype.GetSaveProcName: string;
begin
  Result := inherited GetSaveProcName;
  case Self.DataChangeType of
    dctAdd, dctAddCopy, dctClass:
      begin
        Result := 'pbx_Base_InsertP';                       //增加
      end;
    dctModif:
      begin
        Result := 'pbx_Base_UpdateP';                       //修改
      end;
  end;
end;

{ TModelBaseBtype }

function TModelBaseBtype.GetSaveProcName: string;
begin
  Result := inherited GetSaveProcName;
  case Self.DataChangeType of
    dctAdd, dctAddCopy, dctClass:
      begin
        Result := 'pbx_Base_InsertB';                       //增加
      end;
    dctModif:
      begin
        Result := 'pbx_Base_UpdateB';                       //修改
      end;
  end;
end;

{ TModelBaseDtype }

function TModelBaseDtype.GetSaveProcName: string;
begin
  Result := inherited GetSaveProcName;
  case Self.DataChangeType of
    dctAdd, dctAddCopy, dctClass:
      begin
        Result := 'pbx_Base_InsertD';                       //增加
      end;
    dctModif:
      begin
        Result := 'pbx_Base_UpdateD';                       //修改
      end;
  end;
end;

{ TModelBaseEtype }

function TModelBaseEtype.GetSaveProcName: string;
begin
  Result := inherited GetSaveProcName;
  case Self.DataChangeType of
    dctAdd, dctAddCopy, dctClass:
      begin
        Result := 'pbx_Base_InsertE';                       //增加
      end;
    dctModif:
      begin
        Result := 'pbx_Base_UpdateE';                       //修改
      end;
  end;
end;

{ TModelBaseKtype }

function TModelBaseKtype.GetSaveProcName: string;
begin
  Result := inherited GetSaveProcName;
  case Self.DataChangeType of
    dctAdd, dctAddCopy, dctClass:
      begin
        Result := 'pbx_Base_InsertK';                       //增加
      end;
    dctModif:
      begin
        Result := 'pbx_Base_UpdateK';                       //修改
      end;
  end;
end;

initialization
  gClassIntfManage.addClass(TModelBaseItype, IModelBaseTypeItype);
  gClassIntfManage.addClass(TModelBasePtype, IModelBaseTypePtype);
  gClassIntfManage.addClass(TModelBaseBtype, IModelBaseTypeBtype);
  gClassIntfManage.addClass(TModelBaseEtype, IModelBaseTypeEtype);
  gClassIntfManage.addClass(TModelBaseDtype, IModelBaseTypeDtype);
  gClassIntfManage.addClass(TModelBaseKtype, IModelBaseTypeKtype);
end.

