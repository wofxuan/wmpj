IF OBJECT_ID('dbo.pbx_Bill_Is_Sale_D') IS NOT NULL 
    DROP PROCEDURE dbo.pbx_Bill_Is_Sale_D
go

--  ********************************************************************************************                                                                                  
--  ||   过程名称：pbx_Bill_Is_Sale_D                                               
--  ||   过程功能：添加销售单的明细信息
--  ********************************************************************************************

CREATE  PROCEDURE [pbx_Bill_Is_Sale_D]
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
      
      @ErrorValue VARCHAR(500) OUTPUT --返回错误信息 
    )
AS 
    DECLARE @dUnitRateTemp NUMERIC(22, 10)


    DECLARE @EndDlyOrder INT ,
        @BeginOrderDly INT ,
        @Ret INT
    DECLARE @Splitstr VARCHAR(10)
    SET @Splitstr = 'ǎǒǜ'


    BEGIN TRAN OrderSaveDly

    SELECT  @BeginOrderDly = ISNULL(MAX(DlyOrder), 0)
    FROM    dbo.tbx_Bill_D_Bak

    IF OBJECT_ID('tempdb..#0') IS NOT NULL DROP TABLE #0
	IF OBJECT_ID('tempdb..#1') IS NOT NULL DROP TABLE #1
	IF OBJECT_ID('tempdb..#2') IS NOT NULL DROP TABLE #2
	IF OBJECT_ID('tempdb..#3') IS NOT NULL DROP TABLE #3
	IF OBJECT_ID('tempdb..#4') IS NOT NULL DROP TABLE #4
	IF OBJECT_ID('tempdb..#5') IS NOT NULL DROP TABLE #5
	IF OBJECT_ID('tempdb..#6') IS NOT NULL DROP TABLE #6
	IF OBJECT_ID('tempdb..#7') IS NOT NULL DROP TABLE #7
	IF OBJECT_ID('tempdb..#8') IS NOT NULL DROP TABLE #8
	IF OBJECT_ID('tempdb..#9') IS NOT NULL DROP TABLE #9
	IF OBJECT_ID('tempdb..#10') IS NOT NULL DROP TABLE #10
	IF OBJECT_ID('tempdb..#11') IS NOT NULL DROP TABLE #11
	IF OBJECT_ID('tempdb..#12') IS NOT NULL DROP TABLE #12
	IF OBJECT_ID('tempdb..#13') IS NOT NULL DROP TABLE #13
	IF OBJECT_ID('tempdb..#14') IS NOT NULL DROP TABLE #14
	IF OBJECT_ID('tempdb..#15') IS NOT NULL DROP TABLE #15
	IF OBJECT_ID('tempdb..#16') IS NOT NULL DROP TABLE #16
	IF OBJECT_ID('tempdb..#17') IS NOT NULL DROP TABLE #17
	IF OBJECT_ID('tempdb..#18') IS NOT NULL DROP TABLE #18
	IF OBJECT_ID('tempdb..#19') IS NOT NULL DROP TABLE #19
	IF OBJECT_ID('tempdb..#20') IS NOT NULL DROP TABLE #20
	IF OBJECT_ID('tempdb..#21') IS NOT NULL DROP TABLE #21
	IF OBJECT_ID('tempdb..#22') IS NOT NULL DROP TABLE #22
	IF OBJECT_ID('tempdb..#23') IS NOT NULL DROP TABLE #23
	IF OBJECT_ID('tempdb..#24') IS NOT NULL DROP TABLE #24
	IF OBJECT_ID('tempdb..#25') IS NOT NULL DROP TABLE #25
	IF OBJECT_ID('tempdb..#26') IS NOT NULL DROP TABLE #26
	IF OBJECT_ID('tempdb..#27') IS NOT NULL DROP TABLE #27
	IF OBJECT_ID('tempdb..#28') IS NOT NULL DROP TABLE #28
	IF OBJECT_ID('tempdb..#29') IS NOT NULL DROP TABLE #29
	IF OBJECT_ID('tempdb..#30') IS NOT NULL DROP TABLE #30
	IF OBJECT_ID('tempdb..#31') IS NOT NULL DROP TABLE #31
	IF OBJECT_ID('tempdb..#32') IS NOT NULL DROP TABLE #32
	IF OBJECT_ID('tempdb..#33') IS NOT NULL DROP TABLE #33

	select * into  #0 from  dbo.Fun_SplitStr(@RowId, @splitstr) RowId
	select * into  #1 FROM  dbo.Fun_SplitStr(@ColRowNo, @splitstr) ColRowNo 
	select * into  #2 from  dbo.Fun_SplitStr(@AtypeId, @splitstr) AtypeId 
	select * into  #3 from  dbo.Fun_SplitStr(@BtypeId, @splitstr) BtypeId 
	select * into  #4 FROM  dbo.Fun_SplitStr(@EtypeId, @splitstr) EtypeId 
	select * into  #5 FROM  dbo.Fun_SplitStr(@DtypeId, @splitstr) DtypeId 
	select * into  #6 FROM  dbo.Fun_SplitStr(@KtypeId, @splitstr) KtypeId 
	select * into  #7 from  dbo.Fun_SplitStr(@KtypeId2, @splitstr) KtypeId2 
	select * into  #8 FROM  dbo.Fun_SplitStr(@CostMode, @splitstr) ColRowNo 
	select * into  #9 from  dbo.Fun_SplitStr(@Blockno, @splitstr) Blockno 
	select * into #10 from  dbo.Fun_SplitStr(@ProDate, @splitstr) ProDate 
	select * into #11 from  dbo.Fun_SplitStr(@UsefulEndDate, @splitstr) UsefulEndDate 
	select * into #12 from  dbo.Fun_SplitStr(@JhDate, @splitstr) JhDate 
	select * into #13 from  dbo.Fun_SplitStr(@Goodsno, @splitstr) Goodsno 
	select * into #14 from  dbo.Fun_SplitStr(@AssQty, @splitstr) AssQty
	select * into #15 from  dbo.Fun_SplitStr(@AssPrice, @splitstr) AssPrice 
	select * into #16 from  dbo.Fun_SplitStr(@Total, @splitstr) Total 
	select * into #17 from  dbo.Fun_SplitStr(@Discount, @splitstr) Discount 
	select * into #18 from  dbo.Fun_SplitStr(@AssDiscountPrice, @splitstr) AssDiscountPrice 
	select * into #19 from  dbo.Fun_SplitStr(@Discounttotal, @splitstr) Discounttotal 
	select * into #20 from  dbo.Fun_SplitStr(@TaxRate, @splitstr) TaxRate 
	select * into #21 from  dbo.Fun_SplitStr(@AssTaxPrice, @splitstr) AssTaxPrice 
	select * into #22 from  dbo.Fun_SplitStr(@TaxTotal, @splitstr) TaxTotal 
	select * into #23 from  dbo.Fun_SplitStr(@CostPrice, @splitstr) CostPrice 
	select * into #24 from  dbo.Fun_SplitStr(@CostTotal, @splitstr) CostTotal 
	select * into #25 from  dbo.Fun_SplitStr(@OrderVchType, @splitstr) OrderVchType 
	select * into #26 from  dbo.Fun_SplitStr(@OrderCode, @splitstr) OrderCode 
	select * into #27 from  dbo.Fun_SplitStr(@OrderDlyCode, @splitstr) OrderDlyCode 
	select * into #28 from  dbo.Fun_SplitStr(@PStatus, @splitstr) PStatus 
	select * into #29 from  dbo.Fun_SplitStr(@InputDate, @splitstr) InputDate 
	select * into #30 from  dbo.Fun_SplitStr(@Period, @splitstr) Period 
	select * into #31 from  dbo.Fun_SplitStr(@YearPeriod, @splitstr) YearPeriod 
	select * into #32 from  dbo.Fun_SplitStr(@Usedtype, @splitstr) Usedtype 
	select * into #33 from  dbo.Fun_SplitStr(@Comment, @splitstr) Comment 

    INSERT  INTO dbo.tbx_Bill_D_Bak
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
                    dbo.Fun_CovToQty(dbo.Fun_StrToNumeric(P.URate, 1) * dbo.Fun_StrToNumeric(AssQty.Col, 0)) Qty ,
                    dbo.Fun_CovToPrice(dbo.Fun_StrToNumeric(AssPrice.Col, 0) / dbo.Fun_StrToNumeric(P.URate, 1)) Price ,
                    ISNULL(Total.Col, 0) ,
                    ISNULL(Discount.Col, 0) ,
                    dbo.Fun_CovToPrice(dbo.Fun_StrToNumeric(AssDiscountPrice.Col, 0) / dbo.Fun_StrToNumeric(P.URate, 1)) DiscountPrice ,
                    ISNULL(DiscountTotal.Col, 0) ,
                    ISNULL(TaxRate.Col, 0) ,
                    dbo.Fun_CovToPrice(dbo.Fun_StrToNumeric(AssTaxPrice.Col, 0) / dbo.Fun_StrToNumeric(P.URate, 1)) TaxPrice ,
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
            FROM #0 szRowId
				LEFT JOIN #1 ColRowNo ON szRowId.Id = ColRowNo.Id
				LEFT JOIN #2 AtypeId ON szRowId.Id = AtypeId.Id
				LEFT JOIN #3 BtypeId ON szRowId.Id = BtypeId.Id
				LEFT JOIN #4 EtypeId ON szRowId.Id = EtypeId.Id
				LEFT JOIN #5 DtypeId ON szRowId.Id = DtypeId.Id
				LEFT JOIN #6 KtypeId ON szRowId.Id = KtypeId.Id
				LEFT JOIN #7 KtypeId2 ON szRowId.Id = KtypeId2.Id
				LEFT JOIN #8 CostMode ON szRowId.Id = CostMode.Id
				LEFT JOIN #9 Blockno ON szRowId.Id = Blockno.Id
				LEFT JOIN #10 ProDate ON szRowId.Id = ProDate.Id
				LEFT JOIN #11 UsefulEndDate ON szRowId.ID = UsefulEndDate.ID
				LEFT JOIN #12 JhDate ON szRowId.ID = JhDate.ID
				LEFT JOIN #13 Goodsno ON szRowId.Id = Goodsno.Id
				LEFT JOIN #14 AssQty ON szRowId.Id = AssQty.Id
				LEFT JOIN #15 AssPrice ON szRowId.Id = AssPrice.Id
				LEFT JOIN #16 Total ON szRowId.Id = Total.Id
				LEFT JOIN #17 Discount ON szRowId.Id = Discount.Id
				LEFT JOIN #18 AssDiscountPrice ON szRowId.Id = AssDiscountPrice.Id
				LEFT JOIN #19 Discounttotal ON szRowId.Id = Discounttotal.Id
				LEFT JOIN #20 TaxRate ON szRowId.Id = TaxRate.Id
				LEFT JOIN #21 AssTaxPrice ON szRowId.Id = AssTaxPrice.Id
				LEFT JOIN #22 TaxTotal ON szRowId.Id = TaxTotal.Id
				LEFT JOIN #23 CostPrice ON szRowId.Id = CostPrice.Id
				LEFT JOIN #24 CostTotal ON szRowId.Id = CostTotal.Id
				LEFT JOIN #25 OrderVchType ON szRowId.Id = OrderVchType.Id
				LEFT JOIN #26 OrderCode ON szRowId.Id = OrderCode.Id
				LEFT JOIN #27 OrderDlyCode ON szRowId.Id = OrderDlyCode.Id
				LEFT JOIN #28 PStatus ON szRowId.Id = PStatus.Id
				LEFT JOIN #29 InputDate ON szRowId.Id = InputDate.Id
				LEFT JOIN #30 Period ON szRowId.Id = Period.Id
				LEFT JOIN #31 YearPeriod ON szRowId.Id = YearPeriod.Id
				LEFT JOIN #32 Usedtype ON szRowId.Id = Usedtype.Id
				LEFT JOIN #33 Comment ON szRowId.Id = Comment.Id
				LEFT JOIN ( SELECT  pu.Id ,
							pu.PtypeId ,
							1 Unit ,
							1.0 URate --ISNULL(URate, 1) URate
					FROM    ( SELECT    PtypeIdlist.Id ,
										PtypeIdlist.col PtypeId ,
										1 unit--unit.col unit
								FROM      dbo.Fun_SplitStr(@PtypeId, @splitstr) PtypeIdlist ,
										dbo.Fun_SplitStr(@Unit, @splitstr) Unit
								WHERE     PtypeIdlist.Id = unit.ID
							) pu
							--LEFT JOIN Xw_ptypeunit unit ON p.ptypeid = unit.PtypeId
							--                               AND unit.ordid = p.unit
                                
					) P ON szRowId.Id = p.Id
            WHERE   szRowId.col <> ''
            ORDER BY szRowId.Id
    IF @@ERROR <> 0
    BEGIN
		SET @ErrorValue = '批量插入明细数据失败！'
		GOTO ErrorRollback
    END
        
    SET @EndDlyOrder = @@IDENTITY

	IF OBJECT_ID('tempdb..#0') IS NOT NULL DROP TABLE #0
	IF OBJECT_ID('tempdb..#1') IS NOT NULL DROP TABLE #1
	IF OBJECT_ID('tempdb..#2') IS NOT NULL DROP TABLE #2
	IF OBJECT_ID('tempdb..#3') IS NOT NULL DROP TABLE #3
	IF OBJECT_ID('tempdb..#4') IS NOT NULL DROP TABLE #4
	IF OBJECT_ID('tempdb..#5') IS NOT NULL DROP TABLE #5
	IF OBJECT_ID('tempdb..#6') IS NOT NULL DROP TABLE #6
	IF OBJECT_ID('tempdb..#7') IS NOT NULL DROP TABLE #7
	IF OBJECT_ID('tempdb..#8') IS NOT NULL DROP TABLE #8
	IF OBJECT_ID('tempdb..#9') IS NOT NULL DROP TABLE #9
	IF OBJECT_ID('tempdb..#10') IS NOT NULL DROP TABLE #10
	IF OBJECT_ID('tempdb..#11') IS NOT NULL DROP TABLE #11
	IF OBJECT_ID('tempdb..#12') IS NOT NULL DROP TABLE #12
	IF OBJECT_ID('tempdb..#13') IS NOT NULL DROP TABLE #13
	IF OBJECT_ID('tempdb..#14') IS NOT NULL DROP TABLE #14
	IF OBJECT_ID('tempdb..#15') IS NOT NULL DROP TABLE #15
	IF OBJECT_ID('tempdb..#16') IS NOT NULL DROP TABLE #16
	IF OBJECT_ID('tempdb..#17') IS NOT NULL DROP TABLE #17
	IF OBJECT_ID('tempdb..#18') IS NOT NULL DROP TABLE #18
	IF OBJECT_ID('tempdb..#19') IS NOT NULL DROP TABLE #19
	IF OBJECT_ID('tempdb..#20') IS NOT NULL DROP TABLE #20
	IF OBJECT_ID('tempdb..#21') IS NOT NULL DROP TABLE #21
	IF OBJECT_ID('tempdb..#22') IS NOT NULL DROP TABLE #22
	IF OBJECT_ID('tempdb..#23') IS NOT NULL DROP TABLE #23
	IF OBJECT_ID('tempdb..#24') IS NOT NULL DROP TABLE #24
	IF OBJECT_ID('tempdb..#25') IS NOT NULL DROP TABLE #25
	IF OBJECT_ID('tempdb..#26') IS NOT NULL DROP TABLE #26
	IF OBJECT_ID('tempdb..#27') IS NOT NULL DROP TABLE #27
	IF OBJECT_ID('tempdb..#28') IS NOT NULL DROP TABLE #28
	IF OBJECT_ID('tempdb..#29') IS NOT NULL DROP TABLE #29
	IF OBJECT_ID('tempdb..#30') IS NOT NULL DROP TABLE #30
	IF OBJECT_ID('tempdb..#31') IS NOT NULL DROP TABLE #31
	IF OBJECT_ID('tempdb..#32') IS NOT NULL DROP TABLE #32
	IF OBJECT_ID('tempdb..#33') IS NOT NULL DROP TABLE #33

    COMMIT TRAN OrderSaveDly

    SELECT  DlyOrder
    FROM    tbx_Bill_D_Bak
    WHERE   DlyOrder > @BeginOrderDly
            AND DlyOrder <= @EndDlyOrder
    ORDER BY DlyOrder

    GOTO Success

    Success:		 --成功完成函数
    RETURN 0
    ErrorGeneral:    --检查数据是错误，不需要回滚
    RETURN -1   
    ErrorRollback:   --数据操作是错误，需要回滚
    ROLLBACK TRAN OrderSaveDly 
    RETURN -2 

go
