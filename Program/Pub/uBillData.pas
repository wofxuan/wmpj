unit uBillData;

interface

uses
  Classes, uPackData, Variants, uDefCom;

type
  //单据数据类
  TBillData = class(TPackData)
  private
    FIsModi: Boolean;
    FVchCode: Integer;
    FDraft: TBillSaveState;
    FPRODUCT_TRADE: Integer;
    FVchType: Integer;
    FDetailData: TPackData;
    FAccountData: TPackData;
    FVchcode1: Integer;

    procedure SetAccountData(const Value: TPackData);
    procedure SetDetailData(const Value: TPackData);
    procedure SetDraft(const Value: TBillSaveState);
    procedure SetIsModi(const Value: Boolean);
    procedure SetPRODUCT_TRADE(const Value: Integer);
    procedure SetVchCode(const Value: Integer);
    procedure SetVchType(const Value: Integer);
    procedure SetVchcode1(const Value: Integer);
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure Clear; override;
  published
    property PRODUCT_TRADE: Integer read FPRODUCT_TRADE write SetPRODUCT_TRADE; //行业表示； 0 辉煌系列； 1 五金建材系列； 2 布匹皮革系列；3 电脑行业
    property Draft: TBillSaveState read FDraft write SetDraft; //操作类型 1:草稿 3:过账
    property IsModi: Boolean read FIsModi write SetIsModi; //是否修改单据
    property VchCode: Integer read FVchCode write SetVchCode; //单据编码
    property VchType: Integer read FVchType write SetVchType; //单据类型
    property DetailData: TPackData read FDetailData write SetDetailData; //明细表数据
    property AccountData: TPackData read FAccountData write SetAccountData; //帐务数据
    property VchCode1: Integer read FVchcode1 write SetVchcode1; //零售单时，同时保存的零售单号
  end;

implementation

{ TBillData }

constructor TBillData.Create;
begin
  inherited;
  FDetailData := TPackData.Create;
  FAccountData := TPackData.Create;
end;

destructor TBillData.Destroy;
begin
  FDetailData.Free;
  FAccountData.Free;
  inherited;
end;

procedure TBillData.Clear;
begin
  inherited;
  PRODUCT_TRADE := 0;
  Draft := sbNone;
  isModi := False;
  vchCode := 0;
  vchType := 0;
  FDetailData.Clear;
  FAccountData.Clear;
end;

procedure TBillData.SetAccountData(const Value: TPackData);
begin
  FAccountData := Value;
end;

procedure TBillData.SetDraft(const Value: TBillSaveState);
begin
  FDraft := Value;
end;

procedure TBillData.SetisModi(const Value: Boolean);
begin
  FisModi := Value;
end;

procedure TBillData.SetPRODUCT_TRADE(const Value: Integer);
begin
  FPRODUCT_TRADE := Value;
end;

procedure TBillData.SetvchCode(const Value: Integer);
begin
  FVchCode := Value;
end;

procedure TBillData.SetvchType(const Value: Integer);
begin
  FVchType := Value;
end;

procedure TBillData.SetVchcode1(const Value: Integer);
begin
  FVchcode1 := Value;
end;

procedure TBillData.SetDetailData(const Value: TPackData);
begin
  FDetailData := Value;
end;

end.



