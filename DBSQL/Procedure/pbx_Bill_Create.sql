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
    DECLARE @InitOver INT
    
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
        @aComment VARCHAR(256),
        @aMTotal NUMERIC(22, 10)

    SELECT  @GOODS_ID = '0000100001'
    
    --SELECT  @nPeriod = ISNULL(SubValue, 0)
    --FROM    SysData
    --WHERE   SubName = 'Period'
    SELECT  @aPeriod = 1
    SELECT @aYearPeriod = 1    
    
    SELECT  @aVchType = VchType
    FROM    dbo.tbx_Bill_M
    WHERE   VchCode = @NewvchCode
    
    SELECT  @InitOver = PValue
    FROM    dbo.tbx_Sys_Param
    WHERE   PName = 'InitOver'
    
    IF ISNULL(@InitOver, 0) <> 1
    BEGIN
		SET @ErrorValue='没有开账，不能过账！'
		GOTO ErrorGeneral 	
    END
    
    
    SET @nRet = 0
    SET @aMTotal = 0
    BEGIN TRAN Account
------------------------------进货单---------------------------
    IF @aVchType = 3 
        BEGIN
            SELECT  @execsql = 'declare CreateDly_cursor cursor for 
								select ColRowNo, ATypeID, PTypeID, KTypeID, Qty, Price, Total, Blockno, Prodate, Unit, UnitRate, Costmode, Comment
                                from tbx_Bill_D_Bak where Vchcode= ' + CAST(@NewVchCode AS VARCHAR(10))
            EXEC (@execsql)
            
            OPEN CreateDly_cursor

            WHILE 0 = 0 
                BEGIN
                    FETCH NEXT FROM CreateDly_cursor INTO @aColRowNo, @aATypeID, @aPTypeID, @aKTypeID, @aQty, @aPrice, @aTotal, @ablockno, @aprodate, @aUnit, @aUnitRate, @aCostmode, @aComment
                    IF @@FETCH_STATUS <> 0 
                        BREAK
                        
                    EXEC @nRet = pbx_Bill_ModifyDbf @aVchType, @OldVchCode, @GOODS_ID, @aPTypeID, '', @aETypeID, @aKTypeID, @aPeriod, @aQty, @aTotal, @aBlockno, @aProdate, 0, @aUnit, @aUnitRate, @ErrorValue OUT
                    IF @nRet < 0 
                        GOTO ErrorRollback
                        
                    INSERT dbo.tbx_Bill_Buy_D ( VchCode, VchType, ColRowNo, ATypeID, PTypeID, KTypeID, Qty, Price, Total, Blockno, Prodate, Unit, UnitRate ,Costmode, Comment)
                    VALUES  ( @NewVchCode, @aVchType, @aColRowNo, @aATypeID, @aPTypeID, @aKTypeID, @aQty, @aPrice, @aTotal, @aBlockno, @aProdate, @aUnit, @aUnitRate, @aCostmode, @aComment)
                    IF @@rowcount <= 0 
                    BEGIN
						SET @ErrorValue = '插入明细失败！'
						GOTO ErrorRollback		
                    END
                    
                    SET @aMTotal = @aMTotal + @aTotal     
                END --cursor while end
                
            UPDATE  dbo.tbx_Bill_M
            SET     Total = @aMTotal
            WHERE   VchCode = @NewVchCode
                
            CLOSE CreateDly_cursor
            DEALLOCATE CreateDly_cursor
            GOTO Finish
        END
------------------------------进货单处理结束----------------------

------------------------------销售单------------------------------
    IF @aVchType = 4 
        BEGIN
            SELECT  @execsql = 'declare CreateDly_cursor cursor for 
								select ColRowNo, ATypeID, PTypeID, KTypeID, Qty, Price, Total, Blockno, Prodate, Unit, UnitRate, Costmode, Comment
                                from tbx_Bill_D_Bak where Vchcode= ' + CAST(@NewVchCode AS VARCHAR(10))
            EXEC (@execsql)
            
            OPEN CreateDly_cursor

            WHILE 0 = 0 
                BEGIN
                    FETCH NEXT FROM CreateDly_cursor INTO @aColRowNo, @aATypeID, @aPTypeID, @aKTypeID, @aQty, @aPrice, @aTotal, @ablockno, @aprodate, @aUnit, @aUnitRate, @aCostmode, @aComment
                    IF @@FETCH_STATUS <> 0 
                        BREAK
                    
                    SET @aMTotal = @aMTotal + @aTotal    
                    
                    SET @aQty = -@aQty
                    SET @aTotal = -@aTotal 
                    
                    EXEC @nRet = pbx_Bill_ModifyDbf @aVchType, @OldVchCode, @GOODS_ID, @aPTypeID, '', @aETypeID, @aKTypeID, @aPeriod, @aQty, @aTotal, @aBlockno, @aProdate, 0, @aUnit, @aUnitRate, @ErrorValue OUT
                    IF @nRet < 0 
                        GOTO ErrorRollback
                        
                    INSERT dbo.tbx_Bill_Sale_D ( VchCode, VchType, ColRowNo, ATypeID, PTypeID, KTypeID, Qty, Price, Total, Blockno, Prodate, Unit, UnitRate , Costmode, Comment, UsedType)
                    VALUES  ( @NewvchCode, @aVchType, @aColRowNo, @aATypeID, @aPTypeID, @aKTypeID, @aQty, @aPrice, @aTotal, @aBlockno, @aProdate, @aUnit, @aUnitRate, @aCostmode, @aComment, '')
                    IF @@rowcount <= 0 
                    BEGIN
						SET @ErrorValue = '插入明细失败！'
						GOTO ErrorRollback		
                    END
                        
                END --cursor while end
                
            UPDATE  dbo.tbx_Bill_M
            SET     Total = @aMTotal
            WHERE   VchCode = @NewVchCode
            
            CLOSE CreateDly_cursor
            DEALLOCATE CreateDly_cursor
            GOTO Finish
        END
------------------------------销售单处理结束--------------------------

------------------------------调拨单------------------------------
    IF @aVchType = 5 
        BEGIN
            SELECT  @execsql = 'declare CreateDly_cursor cursor for 
								select ColRowNo, ATypeID, PTypeID, KTypeID, Qty, Price, Total, Blockno, Prodate, Unit, UnitRate, Costmode, Comment, KtypeId2
                                from tbx_Bill_D_Bak where Vchcode= ' + CAST(@NewVchCode AS VARCHAR(10))
            EXEC (@execsql)
            
            OPEN CreateDly_cursor

            WHILE 0 = 0 
                BEGIN
                    FETCH NEXT FROM CreateDly_cursor INTO @aColRowNo, @aATypeID, @aPTypeID, @aKTypeID, @aQty, @aPrice, @aTotal, @ablockno, @aprodate, @aUnit, @aUnitRate, @aCostmode, @aComment, @aKtypeId2
                    IF @@FETCH_STATUS <> 0 
                        BREAK
                    
                    SET @aQty = -@aQty
                    
                    EXEC @nRet = pbx_Bill_ModifyDbf @aVchType, @OldVchCode, @GOODS_ID, @aPTypeID, '', @aETypeID, @aKTypeID, @aPeriod, @aQty, @aTotal, @aBlockno, @aProdate, 0, @aUnit, @aUnitRate, @ErrorValue OUT
                    IF @nRet < 0 
                        GOTO ErrorRollback
                        
                    INSERT dbo.tbx_Bill_Other_D ( VchCode, VchType, ColRowNo, ATypeID, PTypeID, KTypeID, KtypeId2, Qty, Price, Total, Blockno, Prodate, Unit, UnitRate , Costmode, Comment)
                    VALUES  ( @NewvchCode, @aVchType, @aColRowNo, @aATypeID, @aPTypeID, @aKTypeID, @aKtypeId2, @aQty, @aPrice, @aTotal, @aBlockno, @aProdate, @aUnit, @aUnitRate, @aCostmode, @aComment)
                    IF @@rowcount <= 0 
                    BEGIN
						SET @ErrorValue = '插入明细失败！'
						GOTO ErrorRollback		
                    END
                    
                    IF @aCostmode IN ( 1, 2 ) --如果是先进先出或后进先出,用此方法
                        BEGIN
                            PRINT '先进先出或后进先出过账未实现'
                        END
                    ELSE 
                        BEGIN
                            SET @aQty = -@aQty
                            
							EXEC @nRet = pbx_Bill_ModifyDbf @aVchType, @OldVchCode, @GOODS_ID, @aPTypeID, '', @aETypeID, @aKtypeId2, @aPeriod, @aQty, @aTotal, @aBlockno, @aProdate, 0, @aUnit, @aUnitRate, @ErrorValue OUT
							IF @nRet < 0 
								GOTO ErrorRollback
						END
						
                    INSERT dbo.tbx_Bill_Other_D ( VchCode, VchType, ColRowNo, ATypeID, PTypeID, KTypeID, KtypeId2, Qty, Price, Total, Blockno, Prodate, Unit, UnitRate , Costmode, Comment, UsedType)
                    VALUES  ( @NewvchCode, @aVchType, @aColRowNo, @aATypeID, @aPTypeID, @aKTypeID, @aKtypeId2, @aQty, @aPrice, @aTotal, @aBlockno, @aProdate, @aUnit, @aUnitRate, @aCostmode, @aComment, '')
					
					SET @aMTotal = @aMTotal + @aTotal    
                END --cursor while end
                
            UPDATE  dbo.tbx_Bill_M
            SET     Total = @aMTotal
            WHERE   VchCode = @NewVchCode
            
            CLOSE CreateDly_cursor
            DEALLOCATE CreateDly_cursor
            GOTO Finish
        END
------------------------------调拨单处理结束--------------------------
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

    EXEC dbo.pbx_Bill_ClearSaveCreate 0, 0, @aVchType, @NewVchCode, @OldVchCode

    RETURN -1   
    
    ErrorRollback:   --数据操作是错误，需要回滚
    ROLLBACK TRAN Account 

    EXEC dbo.pbx_Bill_ClearSaveCreate 0, 0, @aVchType, @NewVchCode, @OldVchCode

    RETURN -2 

GO 
