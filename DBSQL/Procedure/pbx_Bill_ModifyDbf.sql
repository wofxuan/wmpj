IF OBJECT_ID('dbo.pbx_Bill_ModifyDbf') IS NOT NULL 
    DROP PROCEDURE dbo.pbx_Bill_ModifyDbf
go

--  ********************************************************************************************                                                                                  
--  ||   过程名称：pbx_Bill_ModifyDbf                                                
--  ||   过程功能：通用修改库存数据
--  ********************************************************************************************

CREATE PROCEDURE dbo.pbx_Bill_ModifyDbf
    (
      @nVchType INT ,
      @nVchCode INT ,
      @szatypeid VARCHAR(25) ,
      @szptypeid VARCHAR(25) ,
      @szbtypeid VARCHAR(25) ,
      @szetypeid VARCHAR(25) ,
      @szktypeid VARCHAR(25) ,
      @szperiod VARCHAR(2) ,--00为期初，其它为当前
      @dQty NUMERIC(22, 10) ,
      @dTotal NUMERIC(22, 10) ,
      @szBlockno VARCHAR(20) ,
      @szProdate VARCHAR(20) ,
      @nGoodsNo INT ,
      @nUcode INT ,
      @dURate NUMERIC(22, 10) ,		
       --下面面是存储过程必须的参数
      @ErrorValue VARCHAR(500) OUTPUT  
    )
AS 
    DECLARE @nRet INT ,
        @inputNo VARCHAR(50) ,
        @GoodsDate VARCHAR(50)
        
    DECLARE @Costmode INT 
-------Costing  method------------
    DECLARE @AVERAGE SMALLINT
    DECLARE @FIFO SMALLINT
    DECLARE @LIFO SMALLINT
    DECLARE @HAND SMALLINT

    SELECT  @AVERAGE = 0
    SELECT  @FIFO = 1
    SELECT  @LIFO = 2
    SELECT  @HAND = 3
---------------------
    DECLARE @szJobNumber VARCHAR(20) ,
        @OutFactoryDate VARCHAR(10) 

    DECLARE @dTotaltemp NUMERIC(22, 10) ,
        @dQtytemp NUMERIC(22, 10) ,
        @dCostTotaltemp NUMERIC(22, 10) ,
        @dCostQtytemp NUMERIC(22, 10) ,
        @dPricetemp NUMERIC(22, 10) ,
        @dCostPricetemp NUMERIC(22, 10) ,
        @nPeriod INT ,
        @nGoodsNoTemp INT ,
        @TotalTemp NUMERIC(22, 10) ,
        @dCostTotalOut NUMERIC(22, 10) --成本金额结果输出
        
    DECLARE @goodsorderId INTEGER ,
        @UpdategoodsorderId INTEGER
     
    SELECT @GoodsDate = CONVERT(varchar(100), GETDATE(), 21)
    
    DECLARE @nInputZero INT    
    SET @nInputZero = 0 --如果是出库单据,表示是否0成本强制出库 0 不是, 1 是;如果是入库，则此标志表示是否采用0单价入库 0 不是, 1 是(此时用于获赠单)
    
    SET @goodsorderId = 0
    SET @dCostTotalOut = 0 
    
    SELECT  @Costmode = Costmode
    FROM    dbo.tbx_Base_Ptype
    WHERE   PTypeId = @szptypeid
	
    SELECT  @dTotaltemp = 0, @dQtytemp = 0, @dCostTotaltemp = 0, @dCostQtytemp = 0, @dPricetemp = 0, @dCostPricetemp = 0
	
    IF @szperiod <> '00' --开账后
        BEGIN
            IF @Costmode = @AVERAGE 
                BEGIN
                    IF @dQty = 0 
                        BEGIN
                            SET @ErrorValue = '数量为0'
                            GOTO ErrorGeneral
                        END
                        
                    DECLARE ModIFyDbf_CURSOR CURSOR
                    FOR
                        SELECT  goodsorderID, qty, price, total, jobnumber, OutFactoryDate, GoodsOrder, goodsorderId
                        FROM    dbo.tbx_Stock_Goods
                        WHERE   ptypeid = @szptypeid
                                AND ktypeid = @szktypeid  

                    OPEN  ModIFyDbf_CURSOR
                    FETCH NEXT  FROM ModIFyDbf_CURSOR  INTO @goodsorderID, @dCostQtytemp, @dCostPricetemp, @dCostTotaltemp, @szJobNumber, @OutFactoryDate, @nGoodsNoTemp, @UpdategoodsorderId
                    IF @@FETCH_STATUS = 0 
                        BEGIN
                            IF @dQty < 0  --出库
                                BEGIN
                                    IF @dTotal <> 0  --出库，有出库金额
                                        BEGIN
                                            IF @dCostQtytemp < ABS(@dQty) 
                                                BEGIN
                                                    SET @ErrorValue = '当前库存数量不足'
                                                    GOTO ErrorCloseCursor
                                                END	
                                            SELECT  @dTotaltemp = @dCostTotaltemp + @dTotal
                                            SELECT  @dQtytemp = @dCostQtytemp + @dQty
                                            
                                            IF @dQtytemp = 0
                                                AND @dTotalTemp = 0 
                                                BEGIN
                                                    DELETE  FROM tbx_Stock_Goods
                                                    WHERE   goodsorderId = @UpdategoodsorderId                
                                                    IF @@RowCount = 0 
                                                        GOTO ErrorNoRec	
                                                END
                                            ELSE 
                                                BEGIN
                                                    SELECT  @dCostPricetemp = 0
                                                    IF @dQtytemp <> 0 
                                                        SELECT  @dCostPricetemp = dbo.pbx_Fun_CovToPrice(CAST(@dTotaltemp AS NUMERIC(22, 10)) / CAST(@dQtytemp AS NUMERIC(22, 10)))
	    
                                                    UPDATE  tbx_Stock_Goods
                                                    SET     total = @dTotaltemp, qty = @dQtytemp, price = dbo.pbx_Fun_CovToPrice(@dCostPriceTemp)
                                                    WHERE   goodsorderId = @UpdategoodsorderId
                                                    IF @@RowCount = 0 
                                                        GOTO ErrorNoRec	
         
                                                END
                                                
                                            --库存变动 dlyorder暂填0，等有了后再填
                                            INSERT  INTO tbx_Stock_Glide ( VchCode, VchType, DlyOrder, ptypeid, ktypeid, GoodsOrder, JobNumber, OutFactoryDate, Qty, Price, Total, GoodsDate )
                                            VALUES  ( @nVchCode, @nVchType, 0, @szptypeid, @szktypeid, 0, @szBlockno, @szProdate, @dQty, Dbo.Fun_CovTotalDivQty(@dTotal, @dQty), @dTotal, @GoodsDate )
                                            IF @@RowCount = 0 
                                                GOTO ErrorNoRec	
                                            SELECT  @dCostTotalOut = @dTotal
                                            GOTO Success
                                        END
                                    ELSE --出库无出库金额
                                        BEGIN
                                            IF @dCostQtytemp = ABS(@dQty) --库存数量等于出库数量时
                                                BEGIN
                                                    IF ( ( @dCosttotaltemp > 0 )
                                                         AND ( @nInputZero = 0 )
                                                       )
                                                        OR --库存成本大于0,并且不0成本强制出库
                                                        ( @dCosttotaltemp = 0 ) --库存成本等于0且允许0成本出库时  
                                                        BEGIN
                                                            DELETE  FROM tbx_Stock_Goods
                                                            WHERE   goodsorderId = @UpdategoodsorderId                
                                                            IF @@RowCount = 0 
                                                                GOTO ErrorNoRec	
                                                        
															--库存变动 dlyorder暂填0，等有了后再填
                                                            INSERT  INTO tbx_Stock_Glide ( VchCode, VchType, DlyOrder, ptypeid, ktypeid, GoodsOrder, JobNumber, OutFactoryDate, Qty, Price, Total, GoodsDate )
                                                            VALUES  ( @nVchCode, @nVchType, 0, @szptypeid, @szktypeid, 0, @szBlockno, @szProdate, @dQty, -1 * Dbo.Fun_CovTotalDivQty(@dCosttotaltemp, @dQty), -1 * @dCosttotaltemp, @GoodsDate )
                                                            IF @@RowCount = 0 
                                                                GOTO ErrorNoRec	
                                                            SELECT  @dCostTotalOut = -@dCostTotaltemp
                                                            GOTO Success     
                                                        END	
                                                    ELSE --@dCosttotaltemp< = 数量和金额反号 或0成本强制出库
                                                        BEGIN 
                                                            IF ( @nInputZero = 1 ) 
                                                                SELECT  @dTotaltemp = 0--0成本强制出库
                                                            ELSE --成本异常,取最近进价
                                                                        --BEGIN							
                                                                        --    SELECT  @dTotaltemp = recprice
                                                                        --    FROM    dbo.fn_GetUnitRecPrice(@szPtypeid, @nUcode)				
                                                                        --    SET @dTotaltemp = @dTotaltemp / @dURate
                                                                        --    SET @dTotaltemp = dbo.f_CovToTotal(CAST(@dQty AS NUMERIC(22, 10)) * CAST(@dTotaltemp AS NUMERIC(22, 10)))
                                                                        --    IF ( @dTotaltemp > = 0 ) 
                                                                        --        GOTO ErrorInputCostPric --最近进价为0
                                                                        --END
                                                                SELECT  @dTotaltemp = @dCostTotaltemp + @dTotaltemp
                                                            SELECT  @dQtytemp = @dCostQtytemp + @dQty--0	
                                                                    
                                                                                                                                        
                                                            UPDATE  tbx_Stock_Goods
                                                            SET     total = @dTotaltemp, qty = @dQtytemp, price = 0
                                                            WHERE   goodsorderId = @UpdategoodsorderId
                                                            IF @@RowCount = 0 
                                                                GOTO ErrorNoRec
                                                                
															--库存变动 dlyorder暂填0，等有了后再填
                                                            INSERT  INTO tbx_Stock_Glide ( VchCode, VchType, DlyOrder, ptypeid, ktypeid, GoodsOrder, JobNumber, OutFactoryDate, Qty, Price, Total, GoodsDate )
                                                            VALUES  ( @nVchCode, @nVchType, 0, @szptypeid, @szktypeid, 0, @szBlockno, @szProdate, @dQty, Dbo.Fun_CovTotalDivQty(( @dTotaltemp - @dCosttotaltemp ), @dQty), ( @dTotaltemp - @dCosttotaltemp ), @GoodsDate )
                                                            IF @@RowCount = 0 
                                                                GOTO ErrorNoRec
                                                            SELECT  @dCostTotalOut = @dTotaltemp - @dCosttotaltemp
                                                            GOTO Success
                                                        END
                                                END
                                            ELSE 
                                                BEGIN
                                                    IF @dCostQtytemp < ABS(@dQty) --库存数量小于出库数量 
                                                        BEGIN
                                                            SET @ErrorValue = '当前库存数量不足'
                                                            GOTO ErrorCloseCursor
                                                        END	
                                                    IF ( ( @dCostQtytemp > 0 )
                                                         AND ( @dCosttotaltemp = 0 )
                                                       ) 
                                                        SELECT  @dCostPricetemp = 0
                                                    ELSE 
                                                        BEGIN
                                                            IF ( @nInputZero = 1 ) 
                                                                SELECT  @dCostPricetemp = 0 --强制出库
                                                            --ELSE 
                                                            --    BEGIN
                                                            --        IF @dCostQtytemp = 0
                                                            --            OR @dCosttotaltemp = 0 
                                                            --            BEGIN
                                                            --                IF ( @nVchtype = @CHANGE_PRICE_VCHTYPE ) 
                                                            --                    SELECT  @dCostPricetemp = 0
                                                            --                ELSE 
                                                            --                    BEGIN							
                                                            --                        SELECT  @dCostPricetemp = recprice
                                                            --                        FROM    dbo.fn_GetUnitRecPrice(@szPtypeid, @nUcode)
                                                            --                        SET @dCostPricetemp = dbo.f_CovToprice(CAST(@dCostPricetemp AS NUMERIC(22, 10)) / CAST(@dURate AS NUMERIC(22, 10)))
                                                            --                    END
                                                            --            END
                                                            --        ELSE 
                                                            --            SELECT  @dCostPricetemp = dbo.f_CovToPrice(CAST(@dCostTotaltemp AS NUMERIC(22, 10)) / CAST(@dCostQtyTemp AS NUMERIC(22, 10)))
                                                            --        IF ( @dCostPricetemp <= 0 )
                                                            --            AND ( @nVchtype <> @CHANGE_PRICE_VCHTYPE ) 
                                                            --            GOTO errorInputCostPrice --成本价为负或0
                                                            --    END   	
                                                        END
                                                        
                                                    SELECT  @dCostTotalOut = dbo.Fun_CovToTotal(CAST(@dQty AS NUMERIC(22, 10)) * CAST(@dCostPricetemp AS NUMERIC(22, 10)))
                                                    SELECT  @dTotaltemp = @dCostTotaltemp + @dCostTotalOut  --@dQty*@dCostPricetemp
                                                    SELECT  @dQtytemp = @dCostQtytemp + @dQty
                                                    SELECT  @dCostPricetemp = 0
                                                    IF @dQtytemp <> 0 
                                                        SELECT  @dCostPricetemp = dbo.Fun_CovToprice(CAST(@dTotaltemp AS NUMERIC(22, 10)) / CAST(@dQtytemp AS NUMERIC(22, 10)))

                                                    UPDATE  tbx_Stock_Goods
                                                    SET     total = @dTotaltemp, qty = @dQtytemp, price = @dCostPricetemp
                                                    WHERE   goodsorderId = @UpdategoodsorderId
                                                    IF @@RowCount = 0 
                                                        GOTO ErrorNoRec
                                                        
                                                    --库存变动 dlyorder暂填0，等有了后再填    
                                                    INSERT  INTO tbx_Stock_Glide ( VchCode, VchType, DlyOrder, ptypeid, ktypeid, GoodsOrder, JobNumber, OutFactoryDate, Qty, Price, Total, GoodsDate )
                                                    VALUES  ( @nVchCode, @nVchType, 0, @szptypeid, @szktypeid, 0, @szBlockno, @szProdate, @dQty, @dCostPricetemp, @dCostTotalOut, @GoodsDate )
                                                    IF @@RowCount = 0 
                                                        GOTO ErrorNoRec
                                                    GOTO Success
                                                END
                                        END
                                END
                            ELSE --有记录入库
                                BEGIN
                                    --IF ( ( @dTotal = 0 )
                                    --     AND ( @nInputZero = 0 )
                                    --   ) --入库金额为0，并且不采用0单价入库
                                    --    BEGIN
                                    --        IF @dCostQtytemp = 0
                                    --            OR @dCosttotaltemp = 0 
                                    --            BEGIN			
                                    --                SELECT  @dCostPricetemp = recprice
                                    --                FROM    dbo.Fun_GetUnitRecPrice(@szPtypeid, @nUcode)
                                    --                SET @dCostPricetemp = dbo.f_CovToprice(CAST(@dCostPricetemp AS NUMERIC(22, 10)) / CAST(@dURate AS NUMERIC(22, 10)))			
                                    --            END
                                    --        ELSE 
                                    --            SELECT  @dCostPricetemp = dbo.f_CovToprice(CAST(@dCostTotaltemp AS NUMERIC(22, 10)) / CAST(@dCostQtyTemp AS NUMERIC(22, 10)))
                                    --        IF @dCostPricetemp < = 0 
                                    --            GOTO errorInputCostPrice
                                    --        SELECT  @dTotal = dbo.f_CovToTotal(CAST(@dCostPriceTemp AS NUMERIC(22, 10)) * CAST(@dQty AS NUMERIC(22, 10)))  --已经有库存了
                                    --        IF @dTotal < = 0 
                                    --            GOTO errorInputCostPrice
                                    --    END
                                    
                                    SELECT  @dTotaltemp = @dCostTotaltemp + @dTotal
                                    SELECT  @dQtytemp = @dCostQtytemp + @dQty
                                    SELECT  @dCostPricetemp = 0
                                    IF @dQtytemp <> 0 
                                        SELECT  @dCostPricetemp = dbo.Fun_CovToPrice(CAST(@dTotaltemp AS NUMERIC(22, 10)) / CAST(@dQtytemp AS NUMERIC(22, 10)))
                                    
                                    UPDATE  tbx_Stock_Goods
                                    SET     total = @dTotaltemp, qty = @dQtytemp, price = @dCostPricetemp--,outfactorydate = @szProdate, JobNumber =@szBlockNO
                                    WHERE   goodsorderId = @UpdategoodsorderId
                                    IF @@RowCount = 0 
                                        GOTO ErrorNoRec
                                
									--库存变动 dlyorder暂填0，等有了后再填   
                                    IF @dQty = 0 
                                        BEGIN
                                            INSERT  INTO tbx_Stock_Glide ( VchCode, VchType, DlyOrder, ptypeid, ktypeid, GoodsOrder, JobNumber, OutFactoryDate, Qty, Price, Total, GoodsDate )
                                            VALUES  ( @nVchCode, @nVchType, 0, @szptypeid, @szktypeid, 0, @szBlockno, @szProdate, @dQty, 0, @dTotal, @GoodsDate )
                                            IF @@RowCount = 0 
                                                GOTO ErrorNoRec
                                        END	
                                    ELSE 
                                        BEGIN
                                            INSERT  INTO tbx_Stock_Glide ( VchCode, VchType, DlyOrder, ptypeid, ktypeid, GoodsOrder, JobNumber, OutFactoryDate, Qty, Price, Total, GoodsDate )
                                            VALUES  ( @nVchCode, @nVchType, 0, @szptypeid, @szktypeid, 0, @szBlockno, @szProdate, @dQty, Dbo.Fun_CovTotalDivQty(@dTotal, @dQty), @dTotal, @GoodsDate )
                                            IF @@RowCount = 0 
                                                GOTO ErrorNoRec
                                        END
                                                
                                    SELECT  @dCostTotalOut = @dTotal
                                    GOTO Success
                                END
                        END
                    ELSE --库存无记录
                        BEGIN
                            IF @dQty < 0 
                                BEGIN
                                    SET @ErrorValue = '当前库存数量不足'
                                    GOTO ErrorCloseCursor
                                END
                                
                            --IF ( ( @dTotal = 0 )
                            --     AND ( @nInputZero = 0 )
                            --   ) --入库金额为0，并且不采用0单价入库,或出库不强制出库
                            --    BEGIN         
                            --        SELECT  @dTotal = recprice
                            --        FROM    dbo.fn_GetUnitRecPrice(@szPtypeid, @nUcode)
                            --        SET @dTotal = ( @dTotal / @dURate )
                            --        SET @dTotal = dbo.f_CovToTotal(CAST(@dTotal AS NUMERIC(22, 10)) * CAST(@dQty AS NUMERIC(22, 10)))
		 	    
                            --        IF @dTotal = 0 
                            --            GOTO errorInputCostPrice
                            --    END
                            SELECT  @dCostPricetemp = dbo.Fun_CovToprice(CAST(@dTotal AS NUMERIC(22, 10)) / CAST(@dQty AS NUMERIC(22, 10)))
                            INSERT  tbx_Stock_Goods ( ptypeid, ktypeid, qty, total, price )--,OutFactoryDate, JobNumber)
                            VALUES  ( @szPtypeid, @szKtypeid, @dQty, @dTotal, @dCostPricetemp )--,@szProdate,@szBlockNO)
                            IF @@RowCount = 0 
                                GOTO ErrorNoRec
                            SET @goodsorderID = @@IDENTITY
                            
                            --库存变动 dlyorder暂填0，等有了后再填   
                            INSERT  INTO tbx_Stock_Glide ( VchCode, VchType, DlyOrder, ptypeid, ktypeid, GoodsOrder, JobNumber, OutFactoryDate, Qty, Price, Total, GoodsDate )
                            VALUES  ( @nVchCode, @nVchType, 0, @szptypeid, @szktypeid, 0, @szBlockno, @szProdate, @dQty, @dCostPricetemp, @dTotal, @GoodsDate )
                            IF @@RowCount = 0 
                                GOTO ErrorNoRec
                            SELECT  @dCostTotalOut = @dTotal
                            GOTO Success
                        END
                END
            ELSE 
                IF @Costmode = @FIFO 
                    BEGIN
                        PRINT '@FIFO'
                    END
                ELSE 
                    IF @Costmode = @LIFO 
                        BEGIN
                            PRINT '@LIFO'
                        END
                    ELSE 
                        IF @Costmode = @HAND 
                            BEGIN
                                PRINT '@HAND'
                            END 
        END
    ELSE 
        BEGIN		 /*---------------------修改期初--------------------*/
            PRINT '修改期初'
        END 
	
    Success:		 --成功完成函数
    DEALLOCATE    ModIFyDbf_CURSOR
    RETURN 0


    ErrorGeneral:    --检查数据时错误，不需要回滚
    RETURN -1   
    
    ErrorRollback:   --数据操作时错误，需要回滚
    RETURN -2 

    ErrorCloseCursor:   --数据操作时错误，需要关闭游标
    DEALLOCATE ModIFyDbf_CURSOR
    RETURN -3 
    
    ErrorNoRec:    --检查数据时错误，没有记录
    SET @ErrorValue = '更新记录错误'
    DEALLOCATE ModIFyDbf_CURSOR
    RETURN -4

    ErrorInputCostPric:    --检查数据时错误，最近进价为0
    SET @ErrorValue = '-最近进价为0'
    DEALLOCATE ModIFyDbf_CURSOR
    RETURN -5

GO 
