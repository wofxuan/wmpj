IF OBJECT_ID('dbo.pbx_Bill_Is_Order_D') IS NOT NULL 
    DROP PROCEDURE dbo.pbx_Bill_Is_Order_D
go

--  ********************************************************************************************                                                                                  
--  ||   �������ƣ�pbx_Bill_Is_Order_D                                               
--  ||   ���̹��ܣ���Ӷ�������ϸ��Ϣ
--  ********************************************************************************************

CREATE  PROCEDURE [pbx_Bill_Is_Order_D]
    (
      @RowId VARCHAR(8000) ,
      @VchCode VARCHAR(50) ,
      @VchType VARCHAR(50) ,
      @ColRowNo VARCHAR(8000) ,
      @Atypeid VARCHAR(8000) ,
      @Btypeid VARCHAR(8000) ,
      @Etypeid VARCHAR(8000) ,
      @Dtypeid VARCHAR(8000) ,
      @Ktypeid VARCHAR(8000) ,
      @Ktypeid2 VARCHAR(8000) ,
      @PtypeId VARCHAR(8000) ,
      @CostMode VARCHAR(8000) ,
      @UnitRate VARCHAR(8000) ,
      @Unit VARCHAR(8000) ,
      @Blockno VARCHAR(8000) ,
      @Prodate VARCHAR(8000) ,
      @UsefulEndDate VARCHAR(8000) = '' ,
      @Jhdate VARCHAR(8000) ,
      @GoodsNo VARCHAR(8000) ,
      @Qty VARCHAR(8000) ,
      @Price VARCHAR(8000) ,
      @Total VARCHAR(8000) ,
      @Discount VARCHAR(8000) ,
      @DiscountPrice VARCHAR(8000) ,
      @DiscountTotal VARCHAR(8000) ,
      @TaxRate VARCHAR(8000) ,
      @TaxPrice VARCHAR(8000) ,
      @TaxTotal VARCHAR(8000) ,
      @AssQty VARCHAR(8000) ,
      @AssPrice VARCHAR(8000) ,
      @AssDiscountPrice VARCHAR(8000) ,
      @AssTaxPrice VARCHAR(8000) ,
      @CostTotal VARCHAR(8000) ,
      @CostPrice VARCHAR(8000) ,
      @OrderCode VARCHAR(8000) = '' ,
      @OrderDlyCode VARCHAR(8000) = '' ,
      @OrderVchType VARCHAR(8000) = '' ,
      @Comment VARCHAR(8000) ,
      @InputDate VARCHAR(8000) ,
      @Usedtype VARCHAR(8000) ,
      @Period VARCHAR(8000) ,
      @PStatus VARCHAR(8000) = '' ,
      @YearPeriod VARCHAR(8000) = '' ,
      
      @ErrorValue VARCHAR(500) OUTPUT --���ش�����Ϣ 
    )
AS 
    DECLARE @dUnitRateTemp NUMERIC(22, 10)


    DECLARE @EndDlyOrder INT ,
        @BeginOrderDly INT ,
        @Ret INT
    DECLARE @Splitstr VARCHAR(10)
    SET @Splitstr = '������'


    BEGIN TRAN OrderSaveDly

    SELECT  @BeginOrderDly = ISNULL(MAX(DlyOrder), 0)
    FROM    dbo.tbx_Bill_Order_D

    INSERT  INTO dbo.tbx_Bill_Order_D
            ( VchCode ,
              VchType ,
              ColRowNo ,
              AtypeId ,
              BtypeId ,
              EtypeId ,
              DtypeId ,
              KtypeId ,
              KtypeId2 ,
              PtypeId ,
              Costmode ,
              Unit ,
              UnitRate ,
              BlockNo ,
              ProDate ,
              UsefulEndDate ,
              JhDate ,
              GoodsNo ,
              Qty ,
              Price ,
              Total ,
              DisCount ,
              DisCountPrice ,
              DisCountTotal ,
              TaxRate ,
              TaxPrice ,
              TaxTotal ,
              AssQty ,
              AssPrice ,
              AssDiscountPrice ,
              AssTaxPrice ,
              CostPrice ,
              CostTotal ,
              OrderVchType ,
              OrderCode ,
              OrderDlyCode ,
              PStutas ,
              Redword ,
              InputDate ,
              Period ,
              YearPeriod ,
              UsedType ,
              Comment 
            )
            SELECT  CAST(@Vchcode AS INT) ,
                    CAST(@Vchtype AS INT) ,
                    ISNULL(ColRowNo.Col, '') ,
                    ISNULL(AtypeId.Col, '') ,
                    ISNULL(BtypeId.Col, '') ,
                    ISNULL(EtypeId.Col, '') ,
                    ISNULL(DtypeId.Col, '') ,
                    ISNULL(KtypeId.Col, '') ,
                    ISNULL(KtypeId2.Col, '') ,
                    ISNULL(P.PtypeId, '') ,
                    ISNULL(CostMode.Col, 0) ,
                    ISNULL(P.Unit, 0) ,
                    ISNULL(P.URate, 0) ,
                    ISNULL(Blockno.Col, '') ,
                    ISNULL(ProDate.Col, '') ,
                    ISNULL(UsefulEndDate.Col, '') ,
                    ISNULL(JhDate.Col, '') ,
                    ISNULL(Goodsno.Col, '') ,
                    dbo.pbx_Fun_CovToQty(ISNULL(P.URate, 1) * ISNULL(AssQty.Col, 0)) Qty ,
                    dbo.pbx_Fun_CovToPrice(ISNULL(AssPrice.Col, 0) / ISNULL(P.URate, 1)) Price ,
                    ISNULL(Total.Col, 0) ,
                    ISNULL(Discount.Col, 0) ,
                    dbo.pbx_Fun_CovToPrice(ISNULL(AssDiscountPrice.Col, 0) / ISNULL(P.URate, 1)) DiscountPrice ,
                    ISNULL(DiscountTotal.Col, 0) ,
                    ISNULL(TaxRate.Col, 0) ,
                    dbo.pbx_Fun_CovToPrice(ISNULL(AssTaxPrice.Col, 0) / ISNULL(P.URate, 1)) TaxPrice ,
                    ISNULL(TaxTotal.col, 0) ,
                    ISNULL(AssQty.Col, -11) ,
                    ISNULL(AssPrice.Col, 0) ,
                    ISNULL(AssDiscountPrice.Col, 0) ,
                    ISNULL(AssTaxPrice.Col, 0) ,
                    ISNULL(CostPrice.Col, 0) ,
                    ISNULL(CostTotal.Col, 0) ,
                    ISNULL(OrderVchType.Col, 0) , 
                    ISNULL(OrderCode.col, 0) ,
                    ISNULL(OrderDlyCode.col, 0) ,
                    CASE WHEN PStatus.Col = '' THEN 0
                         ELSE ISNULL(PStatus.Col, 0)
                    END ,
                    'F' Redword ,
                    ISNULL([InputDate].Col, '') ,
                    ISNULL(Period.Col, 0) ,
                    CASE WHEN YearPeriod.Col = '' THEN 0
                         ELSE ISNULL(YearPeriod.Col, 0)
                    END ,
                    ISNULL(Usedtype.Col, 0) ,
                    ISNULL(Comment.Col, '')
            FROM    dbo.pbx_Fun_SplitStr(@RowId, @splitstr) szRowId
                    LEFT JOIN dbo.pbx_Fun_SplitStr(@ColRowNo, @splitstr) ColRowNo ON szRowId.Id = ColRowNo.Id
                    LEFT JOIN dbo.pbx_Fun_SplitStr(@AtypeId, @splitstr) AtypeId ON szRowId.Id = AtypeId.Id
                    LEFT JOIN dbo.pbx_Fun_SplitStr(@BtypeId, @splitstr) BtypeId ON szRowId.Id = BtypeId.Id
                    LEFT JOIN dbo.pbx_Fun_SplitStr(@EtypeId, @splitstr) EtypeId ON szRowId.Id = EtypeId.Id
                    LEFT JOIN dbo.pbx_Fun_SplitStr(@DtypeId, @splitstr) DtypeId ON szRowId.Id = DtypeId.Id
                    LEFT JOIN dbo.pbx_Fun_SplitStr(@KtypeId, @splitstr) KtypeId ON szRowId.Id = KtypeId.Id
                    LEFT JOIN dbo.pbx_Fun_SplitStr(@KtypeId2, @splitstr) KtypeId2 ON szRowId.Id = KtypeId2.Id
                    LEFT JOIN dbo.pbx_Fun_SplitStr(@CostMode, @splitstr) CostMode ON szRowId.Id = CostMode.Id
                    LEFT JOIN dbo.pbx_Fun_SplitStr(@Blockno, @splitstr) Blockno ON szRowId.Id = Blockno.Id
                    LEFT JOIN dbo.pbx_Fun_SplitStr(@ProDate, @splitstr) ProDate ON szRowId.Id = ProDate.Id
                    LEFT JOIN dbo.pbx_Fun_SplitStr(@UsefulEndDate, @splitstr) UsefulEndDate ON szRowId.ID = UsefulEndDate.ID
                    LEFT JOIN dbo.pbx_Fun_SplitStr(@JhDate, @splitstr) JhDate ON szRowId.ID = JhDate.ID
                    LEFT JOIN dbo.pbx_Fun_SplitStr(@Goodsno, @splitstr) Goodsno ON szRowId.Id = Goodsno.Id
                    LEFT JOIN dbo.pbx_Fun_SplitStr(@AssQty, @splitstr) AssQty ON szRowId.Id = AssQty.Id
                    LEFT JOIN dbo.pbx_Fun_SplitStr(@AssPrice, @splitstr) AssPrice ON szRowId.Id = AssPrice.Id
                    LEFT JOIN dbo.pbx_Fun_SplitStr(@Total, @splitstr) Total ON szRowId.Id = Total.Id
                    LEFT JOIN dbo.pbx_Fun_SplitStr(@Discount, @splitstr) Discount ON szRowId.Id = Discount.Id
                    LEFT JOIN dbo.pbx_Fun_SplitStr(@AssDiscountPrice, @splitstr) AssDiscountPrice ON szRowId.Id = AssDiscountPrice.Id
                    LEFT JOIN dbo.pbx_Fun_SplitStr(@Discounttotal, @splitstr) Discounttotal ON szRowId.Id = Discounttotal.Id
                    LEFT JOIN dbo.pbx_Fun_SplitStr(@TaxRate, @splitstr) TaxRate ON szRowId.Id = TaxRate.Id
                    LEFT JOIN dbo.pbx_Fun_SplitStr(@AssTaxPrice, @splitstr) AssTaxPrice ON szRowId.Id = AssTaxPrice.Id
                    LEFT JOIN dbo.pbx_Fun_SplitStr(@TaxTotal, @splitstr) TaxTotal ON szRowId.Id = TaxTotal.Id
                    LEFT JOIN dbo.pbx_Fun_SplitStr(@CostPrice, @splitstr) CostPrice ON szRowId.Id = CostPrice.Id
                    LEFT JOIN dbo.pbx_Fun_SplitStr(@CostTotal, @splitstr) CostTotal ON szRowId.Id = CostTotal.Id
                    LEFT JOIN dbo.pbx_Fun_SplitStr(@OrderVchType, @splitstr) OrderVchType ON szRowId.Id = OrderVchType.Id
                    LEFT JOIN dbo.pbx_Fun_SplitStr(@OrderCode, @splitstr) OrderCode ON szRowId.Id = OrderCode.Id
                    LEFT JOIN dbo.pbx_Fun_SplitStr(@OrderDlyCode, @splitstr) OrderDlyCode ON szRowId.Id = OrderDlyCode.Id
                    LEFT JOIN dbo.pbx_Fun_SplitStr(@PStatus, @splitstr) PStatus ON szRowId.Id = PStatus.Id
                    LEFT JOIN dbo.pbx_Fun_SplitStr(@InputDate, @splitstr) InputDate ON szRowId.Id = InputDate.Id
                    LEFT JOIN dbo.pbx_Fun_SplitStr(@Period, @splitstr) Period ON szRowId.Id = Period.Id
                    LEFT JOIN dbo.pbx_Fun_SplitStr(@YearPeriod, @splitstr) YearPeriod ON szRowId.Id = YearPeriod.Id
                    LEFT JOIN dbo.pbx_Fun_SplitStr(@Usedtype, @splitstr) Usedtype ON szRowId.Id = Usedtype.Id
                    LEFT JOIN dbo.pbx_Fun_SplitStr(@Comment, @splitstr) Comment ON szRowId.Id = Comment.Id
                    LEFT JOIN ( SELECT  pu.Id ,
                                        pu.PtypeId ,
                                        1 Unit ,
                                        1 URate --ISNULL(URate, 1) URate
                                FROM    ( SELECT    PtypeIdlist.Id ,
                                                    PtypeIdlist.col PtypeId ,
                                                    1 unit--unit.col unit
                                          FROM      dbo.pbx_Fun_SplitStr(@PtypeId, @splitstr) PtypeIdlist ,
                                                    dbo.pbx_Fun_SplitStr(@Unit, @splitstr) Unit
                                          WHERE     PtypeIdlist.Id = unit.ID
                                        ) pu
                                        --LEFT JOIN Xw_ptypeunit unit ON p.ptypeid = unit.PtypeId
                                        --                               AND unit.ordid = p.unit
                                
                              ) P ON szRowId.Id = p.Id
            WHERE   szRowId.col <> ''
            ORDER BY szRowId.Id
    IF @@ERROR <> 0
    BEGIN
		SET @ErrorValue = '����������ϸ����ʧ�ܣ�'
		GOTO ErrorRollback
    END
        
    SET @EndDlyOrder = @@IDENTITY

    COMMIT TRAN OrderSaveDly

    SELECT  DlyOrder
    FROM    tbx_Bill_Order_D
    WHERE   DlyOrder > @BeginOrderDly
            AND DlyOrder <= @EndDlyOrder
    ORDER BY DlyOrder

    GOTO Success

    Success:		 --�ɹ���ɺ���
    RETURN 0
    ErrorGeneral:    --��������Ǵ��󣬲���Ҫ�ع�
    RETURN -1   
    ErrorRollback:   --���ݲ����Ǵ�����Ҫ�ع�
    ROLLBACK TRAN OrderSaveDly 
    RETURN -2 

go
