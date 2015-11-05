unit uBillData;

interface

uses
  Classes, uPackData, Variants;

type
  //����������
  TBillData = class(TPackData)
  private
    FIsModi: Boolean;
    FVchCode: Integer;
    FDraft: Integer;
    FPRODUCT_TRADE: Integer;
    FVchType: Integer;
    FDetailData: TPackData;
    FAccountData: TPackData;
    FVchcode1: Integer;

    procedure SetAccountData(const Value: TPackData);
    procedure SetDetailData(const Value: TPackData);
    procedure SetDraft(const Value: Integer);
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
    property PRODUCT_TRADE: Integer read FPRODUCT_TRADE write SetPRODUCT_TRADE; //��ҵ��ʾ�� 0 �Ի�ϵ�У� 1 ��𽨲�ϵ�У� 2 ��ƥƤ��ϵ�У�3 ������ҵ
    property Draft: Integer read FDraft write SetDraft; //�������� 1:�ݸ� 3:����
    property IsModi: Boolean read FIsModi write SetIsModi; //�Ƿ��޸ĵ���
    property VchCode: Integer read FVchCode write SetVchCode; //���ݱ���
    property VchType: Integer read FVchType write SetVchType; //��������
    property DetailData: TPackData read FDetailData write SetDetailData; //��ϸ������
    property AccountData: TPackData read FAccountData write SetAccountData; //��������
    property VchCode1: Integer read FVchcode1 write SetVchcode1; //���۵�ʱ��ͬʱ��������۵���
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
  Draft := 0;
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

procedure TBillData.SetDraft(const Value: Integer);
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


