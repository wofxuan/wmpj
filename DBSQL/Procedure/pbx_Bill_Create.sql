IF OBJECT_ID('dbo.pbx_Bill_Create') IS NOT NULL 
    DROP PROCEDURE dbo.pbx_Bill_Create
go

--  ********************************************************************************************                                                                                  
--  ||   过程名称：pbx_Bill_Create                                                
--  ||   过程功能：进货单，者销售单等单据通用过账
--  ********************************************************************************************

CREATE PROCEDURE dbo.pbx_Bill_Create
    (
      @OldVchCode INT ,
      @NewvchCode INT ,
       --下面面是存储过程必须的参数
      @ErrorValue VARCHAR(500) OUTPUT  
    )
AS 
    DECLARE @nRet INT ,
        @inputNo VARCHAR(50)
    DECLARE @sdate VARCHAR(10) ,
        @GOODS_ID VARCHAR(25) 
    DECLARE @nVchtype INT ,
        @nPeriod INT ,
        @nYearPeriod INT ,
        @unit INT
        
    DECLARE @szBlockno VARCHAR(20) ,
        @szProdate VARCHAR(12) 
        
    DECLARE @modiDly CHAR(1)
    DECLARE @ntotal NUMERIC(22, 10)
    DECLARE @YPratypeid VARCHAR(50)
    DECLARE @flag INT
    DECLARE @szBTypeID VARCHAR(50) 
    DECLARE @szKTypeID VARCHAR(50) 
    DECLARE @szETypeID VARCHAR(50) 
    DECLARE @SzPtypeid VARCHAR(50) 
    DECLARE @szATypeID VARCHAR(500)
    DECLARE @execsql VARCHAR(8000)
    
    DECLARE @dQty NUMERIC(22, 10) ,
        @dPrice NUMERIC(22, 10) ,
        @dTotal NUMERIC(22, 10) ,
        @dUnitRate NUMERIC(22, 10)
    
    SELECT  @GOODS_ID = '0000100001'
    
    --SELECT  @nPeriod = ISNULL(SubValue, 0)
    --FROM    SysData
    --WHERE   SubName = 'Period'
    SELECT  @nPeriod = 1
    
    
    SELECT  @nVchType = VchType
    FROM    dbo.tbx_Bill_M
    WHERE   VchCode = @NewvchCode
    
    SET @nRet = 0
    BEGIN TRAN Account
------------------------------进货单------------------------------
    IF @nVchType = 3 
        BEGIN
            SELECT  @execsql = 'declare CreateDly_cursor cursor for 
								select ATypeID, PTypeID, KTypeID, qty, Price, Total, blockno, prodate, Unit, UnitRate
                                from tbx_Bill_D_Bak where Vchcode= ' + CAST(@NewvchCode AS VARCHAR(10))
            EXEC (@execsql)
            
            
            OPEN CreateDly_cursor

            WHILE 0 = 0 
                BEGIN
                    FETCH NEXT FROM CreateDly_cursor INTO @szATypeID, @szPTypeID, @szKTypeID, @dQty, @dPrice, @dTotal, @szBlockno, @szProdate, @Unit, @dUnitRate
                    IF @@FETCH_STATUS <> 0 
                        BREAK
                        
                    EXEC @nRet = pbx_Bill_ModifyDbf @nVchType, @OldVchCode, @GOODS_ID, @szPTypeID, '', @szETypeID, @szKTypeID, @nPeriod, @dQty, @dTotal, @szBlockno, @szProdate, 0, @Unit, @dUnitRate, @ErrorValue
                    IF @nRet < 0 
                        GOTO ErrorRollback
                        
--						INSERT  INTO dlybuy ( vchcode, Date, VchType, ATypeID, PTypeID, BTypeID, ETypeID, KTypeID, KTypeID2, qty, SideQty, Price, Total, costPrice, CostTotal, discount, discountPrice, discountTotal, tax, taxPrice, taxTotal, tax_Total, Blockno, Prodate, comment, period, YearPeriod, UsedType, costmode, unit, OrderCode, OrderDlyCode, InvoceTotal, InvoceTag, DeptID, RetailPrice, Pstutas, AssQty, AssPrice, AssDiscountPrice, AssTaxPrice, UnitRate, FeeTotal, InPrice, InTotal, pgholqty, pgholInqty, copySdlyorder, UsefulEndDate )
--                       VALUES  ( @nVchcode, @tDate, @nVchType, @szATypeID, @szPTypeID, @szBTypeID, @szETypeID, @szKTypeID, @szKTypeID2, @dQty, @dSideQty, @dPrice, @dTotal, @dCostPrice, @dCostTotal, @dDiscount, @dDiscountPrice, @dDiscountTotal, @dTax, @dTaxPrice, @dTaxTotal, @dTax_Total, @szBlockno, @szProdate, @szMemo, @nPeriod, @nYearPeriod, @UsedType, @nCostMode, @unit, @nOrderCode, @nOrderDlyCode, @dInvoceTotal, @nInvoceTag, @DeptID, @RetailPrice, @nPstatus, @dAssQty, @dAssPrice, @dAssDiscountPrice, @dAssTaxPrice, @dUnitRate, @dFeeTotal, @dInPrice, @dInTotal, @dpgholqty, @npgholInqty, @ncopySdlyorder, @UsefulEndDate )
				
--			--库存商品增加
--            IF @dTempTotal <> 0 
--                BEGIN
--                    INSERT  INTO dlya ( vchcode, Date, VchType, ATypeID, BTypeID, ETypeID, KTypeID, Total, period, YearPeriod, UsedType, DeptID )
--                    VALUES  ( @nVchcode, @tDate, @nVchType, @GOODS_ID, @szBTypeID, @szETypeID, @szKTypeID, @dTempTotal, @nPeriod, @nYearPeriod, '', @DeptID )
--                    IF @@rowcount <= 0 
--                        GOTO error1
--                END
----应收应付
--            SELECT  @dTemp = @dTotalMoney - @dTotalInMoney - @dPreferential
--            IF @dTemp <> 0
--               -- if @dTotalInMoney <> @dTotalMoney
--                BEGIN
--                 --       select @dTemp = @dTotalMoney-@dTotalInMoney
--                    INSERT  INTO dlya ( vchcode, Date, VchType, ATypeID, BTypeID, ETypeID, KTypeID, Total, period, YearPeriod, UsedType, DeptID )
--                    VALUES  ( @nVchcode, @tDate, @nVchType, @AP_ID, @szBTypeID, @szETypeID, @szKTypeID, @dTemp, @nPeriod, @nYearPeriod, '', @DeptID )
--                    IF @@rowcount <= 0 
--                        GOTO error1
--                END

--            SELECT  @dTemp = @dFeeEditTotal - @dFeePayTotal
            
--            IF @dTemp <> 0 
--                BEGIN
--                    INSERT  INTO dlya ( vchcode, Date, Vchtype, ATypeID, BTypeID, ETypeID, KTypeID, Total, Period, YearPeriod, UsedType, DeptID )
--                    VALUES  ( @nVchcode, @tDate, @nVchtype, @AP_ID, @szFeeBtypeID, @szETypeID, @szKTypeID, @dTemp, @nPeriod, @nYearPeriod, '', @DeptID )
--                    IF @@rowcount <= 0 
--                        GOTO error1
--                END

--            UPDATE  dlyndx
--            SET     Total = ABS(@dTotalMoney), InvoceTag = @nInvTag
--            WHERE   vchcode = @nVchcode
--            IF @@rowcount <= 0 
--                GOTO error1
                END
            CLOSE CreateDly_cursor
            DEALLOCATE CreateDly_cursor
            GOTO Finish
        END
------------------------------进货单处理结束--------------------------

    Success:		 --成功完成函数
    RETURN 0
    
-----对科目类型进行过帐
    Finish:
		--SET @nRet = 0
		--SELECT  @execsql = 'declare AccountDly_cursor cursor for ' + ' select ATypeID, BTypeID,Total from dlya  where  Vchcode= ' + CAST(@nVchcode AS VARCHAR(10)) + ' and vchtype = ' + CAST(@nVchtype AS VARCHAR(10)) 
		--EXEC (@execsql)
		--OPEN AccountDly_cursor
		--FETCH NEXT FROM AccountDly_cursor INTO @szATypeID, @szBTypeID, @dTotal
		--WHILE @@FETCH_STATUS = 0 
		--	BEGIN

		--		IF @szATypeID <> '' 
		--			BEGIN
		--				EXEC @nRet = ModifyDbf @nVchType, @nVchcode, 0, @tDate, 0, @szATypeID, '', @szBTypeID, @szETypeID, '', @nPeriod, @dTotal, @dTotal, '', '', 0, @dTemp OUTPUT, @Unit, @dUnitRate, 0
		--				IF @nRet < 0 
		--					GOTO errorA
		--			END
		--		FETCH NEXT FROM AccountDly_cursor INTO @szATypeID, @szBTypeID, @dTotal
		--	END
		--CLOSE AccountDly_cursor
		--DEALLOCATE AccountDly_cursor

		--UPDATE  dlyndx
		--SET     draft = 2, Period = @nPeriod, YearPeriod = @nYearPeriod
		--WHERE   vchcode = @nVchcode
		--IF @@rowcount <= 0 
		--	GOTO error1A
    COMMIT TRAN Account
        	   	
    RETURN @nRet
    
    ErrorGeneral:    --检查数据是错误，不需要回滚
    --DELETE  FROM tbx_Bill_Order_D
    --WHERE   Vchcode = @NewVchCode
    --DELETE  FROM tbx_Bill_Order_M
    --WHERE   Vchcode = @NewVchCode	 
    RETURN -1   
    
    ErrorRollback:   --数据操作是错误，需要回滚
    ROLLBACK TRAN Account 
    --DELETE  FROM tbx_Bill_Order_D
    --WHERE   Vchcode = @NewVchCode
    --DELETE  FROM tbx_Bill_Order_M
    --WHERE   Vchcode = @NewVchCode
    RETURN -2 

GO 
