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
      @NewVchCode INT ,
       --下面面是存储过程必须的参数
      @ErrorValue VARCHAR(500) OUTPUT  
    )
AS 
    DECLARE @nRet INT 
    DECLARE @GOODS_ID VARCHAR(25) 
        
    DECLARE @modiDly CHAR(1)
    DECLARE @YPratypeid VARCHAR(50)
    DECLARE @flag INT
    DECLARE @execsql VARCHAR(8000)
    
    DECLARE @aVchType INT,
		@aColRowNo INT ,
        @aCostmode INT ,
        @aUnit INT ,
        @aGoodsNo INT ,
        @aOrderVchType INT ,
        @aOrderCode INT ,
        @aOrderDlyCode INT ,
        @aPStutas INT ,
        @aYearPeriod INT
          
    DECLARE @aAtypeId VARCHAR(50) ,
        @aBtypeId VARCHAR(50) ,
        @aEtypeId VARCHAR(50) ,
        @aDtypeId VARCHAR(50) ,
        @aKtypeId VARCHAR(50) ,
        @aKtypeId2 VARCHAR(50) ,
        @aPtypeId VARCHAR(50) ,
        @aBlockNo VARCHAR(20) ,
        @aProDate VARCHAR(10) ,
        @aUsefulEndDate VARCHAR(10) ,
        @aJhDate VARCHAR(50)
          
    DECLARE @aUnitRate NUMERIC(22, 10) ,
        @aQty NUMERIC(22, 10) ,
        @aPrice NUMERIC(22, 10) ,
        @aTotal NUMERIC(22, 10) ,
        @aDisCount NUMERIC(22, 10) ,
        @aDisCountPrice NUMERIC(22, 10) ,
        @aDisCountTotal NUMERIC(22, 10) ,
        @aTaxRate NUMERIC(22, 10) ,
        @aTaxPrice NUMERIC(22, 10) ,
        @aTaxTotal NUMERIC(22, 10) ,
        @aAssQty NUMERIC(22, 10) ,
        @aAssPrice NUMERIC(22, 10) ,
        @aAssDiscountPrice NUMERIC(22, 10) ,
        @aAssTaxPrice NUMERIC(22, 10) ,
        @aCostPrice NUMERIC(22, 10) ,
        @aCostTotal NUMERIC(22, 10) ,
        @aToQty NUMERIC(22, 10) ,
        @aRedword CHAR(2) ,
        @aInputDate VARCHAR(10) ,
        @aPeriod SMALLINT ,
        @aUsedType CHAR(1) ,
        @aComment VARCHAR(256)

    SELECT  @GOODS_ID = '0000100001'
    
    --SELECT  @nPeriod = ISNULL(SubValue, 0)
    --FROM    SysData
    --WHERE   SubName = 'Period'
    SELECT  @aPeriod = 1
    SELECT @aYearPeriod = 1    
    
    SELECT  @aVchType = VchType
    FROM    dbo.tbx_Bill_M
    WHERE   VchCode = @NewvchCode
    
    SET @nRet = 0
    BEGIN TRAN Account
------------------------------进货单---------------------------
    IF @aVchType = 3 
        BEGIN
            SELECT  @execsql = 'declare CreateDly_cursor cursor for 
								select ColRowNo, ATypeID, PTypeID, KTypeID, Qty, Price, Total, Blockno, Prodate, Unit, UnitRate
                                from tbx_Bill_D_Bak where Vchcode= ' + CAST(@NewVchCode AS VARCHAR(10))
            EXEC (@execsql)
            
            OPEN CreateDly_cursor

            WHILE 0 = 0 
                BEGIN
                    FETCH NEXT FROM CreateDly_cursor INTO @aColRowNo, @aATypeID, @aPTypeID, @aKTypeID, @aQty, @aPrice, @aTotal, @ablockno, @aprodate, @aUnit, @aUnitRate
                    IF @@FETCH_STATUS <> 0 
                        BREAK
                        
                    EXEC @nRet = pbx_Bill_ModifyDbf @aVchType, @OldVchCode, @GOODS_ID, @aPTypeID, '', @aETypeID, @aKTypeID, @aPeriod, @aQty, @aTotal, @aBlockno, @aProdate, 0, @aUnit, @aUnitRate, @ErrorValue
                    IF @nRet < 0 
                        GOTO ErrorRollback
                        
                    INSERT dbo.tbx_Bill_Buy_D ( VchCode, VchType, ColRowNo, ATypeID, PTypeID, KTypeID, Qty, Price, Total, Blockno, Prodate, Unit, UnitRate )
                    VALUES  ( @NewvchCode, @aVchType, @aColRowNo, @aATypeID, @aPTypeID, @aKTypeID, @aQty, @aPrice, @aTotal, @aBlockno, @aProdate, @aUnit, @aUnitRate)
                    IF @@rowcount <= 0 
                    BEGIN
						SET @ErrorValue = '插入明细失败！'
						GOTO ErrorRollback		
                    END
                        
--			--库存商品增加
--            IF @dTempTotal <> 0 
--                BEGIN
--                    INSERT  INTO dlya ( vchcode, Date, VchType, ATypeID, BTypeID, ETypeID, KTypeID, Total, period, YearPeriod, UsedType, DeptID )
--                    VALUES  ( @nVchcode, @tDate, @nVchType, @GOODS_ID, @szBTypeID, @szETypeID, @szKTypeID, @dTempTotal, @nPeriod, @nYearPeriod, '', @DeptID )
--                    IF @@rowcount <= 0 
--                        GOTO error1
--                END
--			--应收应付
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
                END --cursor while end
            CLOSE CreateDly_cursor
            DEALLOCATE CreateDly_cursor
            GOTO Finish
        END
------------------------------进货单处理结束----------------------

------------------------------销售单------------------------------
    IF @aVchType = 4 
        BEGIN
            SELECT  @execsql = 'declare CreateDly_cursor cursor for 
								select ColRowNo, ATypeID, PTypeID, KTypeID, Qty, Price, Total, Blockno, Prodate, Unit, UnitRate
                                from tbx_Bill_D_Bak where Vchcode= ' + CAST(@NewVchCode AS VARCHAR(10))
            EXEC (@execsql)
            
            OPEN CreateDly_cursor

            WHILE 0 = 0 
                BEGIN
                    FETCH NEXT FROM CreateDly_cursor INTO @aColRowNo, @aATypeID, @aPTypeID, @aKTypeID, @aQty, @aPrice, @aTotal, @ablockno, @aprodate, @aUnit, @aUnitRate
                    IF @@FETCH_STATUS <> 0 
                        BREAK
                    
                    SET @aQty = -@aQty
                    SET @aTotal = -@aTotal 
                    
                    EXEC @nRet = pbx_Bill_ModifyDbf @aVchType, @OldVchCode, @GOODS_ID, @aPTypeID, '', @aETypeID, @aKTypeID, @aPeriod, @aQty, @aTotal, @aBlockno, @aProdate, 0, @aUnit, @aUnitRate, @ErrorValue
                    IF @nRet < 0 
                        GOTO ErrorRollback
                        
                    INSERT dbo.tbx_Bill_Sale_D ( VchCode, VchType, ColRowNo, ATypeID, PTypeID, KTypeID, Qty, Price, Total, Blockno, Prodate, Unit, UnitRate )
                    VALUES  ( @NewvchCode, @aVchType, @aColRowNo, @aATypeID, @aPTypeID, @aKTypeID, @aQty, @aPrice, @aTotal, @aBlockno, @aProdate, @aUnit, @aUnitRate)
                    IF @@rowcount <= 0 
                    BEGIN
						SET @ErrorValue = '插入明细失败！'
						GOTO ErrorRollback		
                    END
                        
--			--库存商品增加
--            IF @dTempTotal <> 0 
--                BEGIN
--                    INSERT  INTO dlya ( vchcode, Date, VchType, ATypeID, BTypeID, ETypeID, KTypeID, Total, period, YearPeriod, UsedType, DeptID )
--                    VALUES  ( @nVchcode, @tDate, @nVchType, @GOODS_ID, @szBTypeID, @szETypeID, @szKTypeID, @dTempTotal, @nPeriod, @nYearPeriod, '', @DeptID )
--                    IF @@rowcount <= 0 
--                        GOTO error1
--                END
--			--应收应付
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
                END --cursor while end
            CLOSE CreateDly_cursor
            DEALLOCATE CreateDly_cursor
            GOTO Finish
        END
------------------------------销售单处理结束--------------------------

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

		UPDATE  dbo.tbx_Bill_M
		SET     Draft = 2, Period = @aPeriod, YearPeriod = @aYearPeriod
		WHERE   vchcode = @NewVchCode
		IF @@rowcount <= 0 
		BEGIN
			SET @ErrorValue = '更新过账标志出错'
			GOTO ErrorRollback	
		END

	   DELETE   FROM tbx_Bill_D_Bak
	   WHERE    VchCode = @NewVchCode
	   
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
