unit uModelBaseType;

interface

uses
  Classes, Windows, SysUtils, DBClient, uPubFun, uParamObject, uBaseInfoDef, uDefCom, uBusinessLayerPlugin,
  uModelParent, uModelBaseTypeIntf;

type
  TModelBaseItype = class(TModelBaseType, IModelBaseTypeItype) //������Ϣ-���ذ���������
  private

  protected
    function GetSaveProcName: string; override;
    function CheckData(AParamList: TParamObject; var Msg: string): Boolean; virtual; //�������
  public
    destructor Destroy; override;

  end;

  TModelBasePtype = class(TModelBaseType, IModelBaseTypePtype) //������Ϣ-��Ʒ��������
  private

  protected
    function GetSaveProcName: string; override;
    function CheckData(AParamList: TParamObject; var Msg: string): Boolean; override; //�������
  public
    destructor Destroy; override;

  end;

  TModelBaseBtype = class(TModelBaseType, IModelBaseTypeBtype) //������Ϣ-��λ��������
  private

  protected
    function GetSaveProcName: string; override;
  public

  end;

  TModelBaseEtype = class(TModelBaseType, IModelBaseTypeEtype) //������Ϣ-ְԱ��������
  private

  protected
    function GetSaveProcName: string; override;
  public

  end;

  TModelBaseDtype = class(TModelBaseType, IModelBaseTypeDtype) //������Ϣ-���Ŵ�������
  private

  protected
    function GetSaveProcName: string; override;
  public

  end;

  TModelBaseKtype = class(TModelBaseType, IModelBaseTypeKtype) //������Ϣ-�ֿ⴦������
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
        Result := 'pbx_Base_InsertI';                       //����
      end;
    dctModif:
      begin
        Result := 'pbx_Base_UpdateI';                       //�޸�
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
    Msg := '��Ч�ڱ��������֣�';
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
        Result := 'pbx_Base_InsertP';                       //����
      end;
    dctModif:
      begin
        Result := 'pbx_Base_UpdateP';                       //�޸�
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
        Result := 'pbx_Base_InsertB';                       //����
      end;
    dctModif:
      begin
        Result := 'pbx_Base_UpdateB';                       //�޸�
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
        Result := 'pbx_Base_InsertD';                       //����
      end;
    dctModif:
      begin
        Result := 'pbx_Base_UpdateD';                       //�޸�
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
        Result := 'pbx_Base_InsertE';                       //����
      end;
    dctModif:
      begin
        Result := 'pbx_Base_UpdateE';                       //�޸�
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
        Result := 'pbx_Base_InsertK';                       //����
      end;
    dctModif:
      begin
        Result := 'pbx_Base_UpdateK';                       //�޸�
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
