IF OBJECT_ID('dbo.pbx_Bill_ModifyDbf') IS NOT NULL 
    DROP PROCEDURE dbo.pbx_Bill_ModifyDbf
go

--  ********************************************************************************************                                                                                  
--  ||   �������ƣ�pbx_Bill_ModifyDbf                                                
--  ||   ���̹��ܣ�ͨ���޸Ŀ������
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
      @szperiod VARCHAR(2) ,--00Ϊ�ڳ�������Ϊ��ǰ
      @dQty NUMERIC(22, 10) ,
      @dTotal NUMERIC(22, 10) ,
      @szBlockno VARCHAR(20) ,
      @szProdate VARCHAR(20) ,
      @nGoodsNo INT ,
      @nUcode INT ,
      @dURate NUMERIC(22, 10) ,		
       --�������Ǵ洢���̱���Ĳ���
      @ErrorValue VARCHAR(500) OUTPUT  
    )
AS 
    DECLARE @nRet INT ,
        @inputNo VARCHAR(50)
        
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
        @dCostTotalOut NUMERIC(22, 10) --�ɱ���������
        
    DECLARE @goodsorderId INTEGER ,
        @UpdategoodsorderId INTEGER
     
    DECLARE @nInputZero INT    
    SET @nInputZero = 0 --����ǳ��ⵥ��,��ʾ�Ƿ�0�ɱ�ǿ�Ƴ��� 0 ����, 1 ��;�������⣬��˱�־��ʾ�Ƿ����0������� 0 ����, 1 ��(��ʱ���ڻ�����)
    
    SET @goodsorderId = 0
    SET @dCostTotalOut = 0 
    
    SELECT  @Costmode = Costmode
    FROM    dbo.tbx_Base_Ptype
    WHERE   PTypeId = @szptypeid
	
    SELECT  @dTotaltemp = 0, @dQtytemp = 0, @dCostTotaltemp = 0, @dCostQtytemp = 0, @dPricetemp = 0, @dCostPricetemp = 0
	
    IF @szperiod <> '00' --���˺�
        BEGIN
            IF @Costmode = @AVERAGE 
                BEGIN
                    IF @dQty = 0 
                        BEGIN
                            SET @ErrorValue = '����Ϊ0'
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
                            IF @dQty < 0  --����
                                BEGIN
                                    IF @dTotal <> 0  --���⣬�г�����
                                        BEGIN
                                            IF @dCostQtytemp < ABS(@dQty) 
                                                BEGIN
                                                    SET @ErrorValue = '��ǰ�����������'
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
                                                
                                            --���䶯 dlyorder����0�������˺�����
                                            INSERT  INTO tbx_Stock_Glide ( VchCode, VchType, DlyOrder, ptypeid, ktypeid, GoodsOrder, JobNumber, OutFactoryDate, Qty, Price, Total, GoodsDate )
                                            VALUES  ( @nVchCode, @nVchType, 0, @szptypeid, @szktypeid, 0, @szBlockno, @szProdate, @dQty, Dbo.Fun_CovTotalDivQty(@dTotal, @dQty), @dTotal, GETDATE() )
                                            IF @@RowCount = 0 
                                                GOTO ErrorNoRec	
                                            SELECT  @dCostTotalOut = @dTotal
                                            GOTO Success
                                        END
                                    ELSE --�����޳�����
                                        BEGIN
                                            IF @dCostQtytemp = ABS(@dQty) --����������ڳ�������ʱ
                                                BEGIN
                                                    IF ( ( @dCosttotaltemp > 0 )
                                                         AND ( @nInputZero = 0 )
                                                       )
                                                        OR --���ɱ�����0,���Ҳ�0�ɱ�ǿ�Ƴ���
                                                        ( @dCosttotaltemp = 0 ) --���ɱ�����0������0�ɱ�����ʱ  
                                                        BEGIN
                                                            DELETE  FROM tbx_Stock_Goods
                                                            WHERE   goodsorderId = @UpdategoodsorderId                
                                                            IF @@RowCount = 0 
                                                                GOTO ErrorNoRec	
                                                        
															--���䶯 dlyorder����0�������˺�����
                                                            INSERT  INTO tbx_Stock_Glide ( VchCode, VchType, DlyOrder, ptypeid, ktypeid, GoodsOrder, JobNumber, OutFactoryDate, Qty, Price, Total, GoodsDate )
                                                            VALUES  ( @nVchCode, @nVchType, 0, @szptypeid, @szktypeid, 0, @szBlockno, @szProdate, @dQty, -1 * Dbo.Fun_CovTotalDivQty(@dCosttotaltemp, @dQty), -1 * @dCosttotaltemp, GETDATE() )
                                                            IF @@RowCount = 0 
                                                                GOTO ErrorNoRec	
                                                            SELECT  @dCostTotalOut = -@dCostTotaltemp
                                                            GOTO Success     
                                                        END	
                                                    ELSE --@dCosttotaltemp< = �����ͽ��� ��0�ɱ�ǿ�Ƴ���
                                                        BEGIN 
                                                            IF ( @nInputZero = 1 ) 
                                                                SELECT  @dTotaltemp = 0--0�ɱ�ǿ�Ƴ���
                                                            ELSE --�ɱ��쳣,ȡ�������
                                                                        --BEGIN							
                                                                        --    SELECT  @dTotaltemp = recprice
                                                                        --    FROM    dbo.fn_GetUnitRecPrice(@szPtypeid, @nUcode)				
                                                                        --    SET @dTotaltemp = @dTotaltemp / @dURate
                                                                        --    SET @dTotaltemp = dbo.f_CovToTotal(CAST(@dQty AS NUMERIC(22, 10)) * CAST(@dTotaltemp AS NUMERIC(22, 10)))
                                                                        --    IF ( @dTotaltemp > = 0 ) 
                                                                        --        GOTO ErrorInputCostPric --�������Ϊ0
                                                                        --END
                                                                SELECT  @dTotaltemp = @dCostTotaltemp + @dTotaltemp
                                                            SELECT  @dQtytemp = @dCostQtytemp + @dQty--0	
                                                                    
                                                                                                                                        
                                                            UPDATE  tbx_Stock_Goods
                                                            SET     total = @dTotaltemp, qty = @dQtytemp, price = 0
                                                            WHERE   goodsorderId = @UpdategoodsorderId
                                                            IF @@RowCount = 0 
                                                                GOTO ErrorNoRec
                                                                
															--���䶯 dlyorder����0�������˺�����
                                                            INSERT  INTO tbx_Stock_Glide ( VchCode, VchType, DlyOrder, ptypeid, ktypeid, GoodsOrder, JobNumber, OutFactoryDate, Qty, Price, Total, GoodsDate )
                                                            VALUES  ( @nVchCode, @nVchType, 0, @szptypeid, @szktypeid, 0, @szBlockno, @szProdate, @dQty, Dbo.Fun_CovTotalDivQty(( @dTotaltemp - @dCosttotaltemp ), @dQty), ( @dTotaltemp - @dCosttotaltemp ), GETDATE() )
                                                            IF @@RowCount = 0 
                                                                GOTO ErrorNoRec
                                                            SELECT  @dCostTotalOut = @dTotaltemp - @dCosttotaltemp
                                                            GOTO Success
                                                        END
                                                END
                                            ELSE 
                                                BEGIN
                                                    IF @dCostQtytemp < ABS(@dQty) --�������С�ڳ������� 
                                                        BEGIN
                                                            SET @ErrorValue = '��ǰ�����������'
                                                            GOTO ErrorCloseCursor
                                                        END	
                                                    IF ( ( @dCostQtytemp > 0 )
                                                         AND ( @dCosttotaltemp = 0 )
                                                       ) 
                                                        SELECT  @dCostPricetemp = 0
                                                    ELSE 
                                                        BEGIN
                                                            IF ( @nInputZero = 1 ) 
                                                                SELECT  @dCostPricetemp = 0 --ǿ�Ƴ���
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
                                                            --            GOTO errorInputCostPrice --�ɱ���Ϊ����0
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
                                                        
                                                    --���䶯 dlyorder����0�������˺�����    
                                                    INSERT  INTO tbx_Stock_Glide ( VchCode, VchType, DlyOrder, ptypeid, ktypeid, GoodsOrder, JobNumber, OutFactoryDate, Qty, Price, Total, GoodsDate )
                                                    VALUES  ( @nVchCode, @nVchType, 0, @szptypeid, @szktypeid, 0, @szBlockno, @szProdate, @dQty, @dCostPricetemp, @dCostTotalOut, GETDATE() )
                                                    IF @@RowCount = 0 
                                                        GOTO ErrorNoRec
                                                    GOTO Success
                                                END
                                        END
                                END
                            ELSE --�м�¼���
                                BEGIN
                                    --IF ( ( @dTotal = 0 )
                                    --     AND ( @nInputZero = 0 )
                                    --   ) --�����Ϊ0�����Ҳ�����0�������
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
                                    --        SELECT  @dTotal = dbo.f_CovToTotal(CAST(@dCostPriceTemp AS NUMERIC(22, 10)) * CAST(@dQty AS NUMERIC(22, 10)))  --�Ѿ��п����
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
                                
									--���䶯 dlyorder����0�������˺�����   
                                    IF @dQty = 0 
                                        BEGIN
                                            INSERT  INTO tbx_Stock_Glide ( VchCode, VchType, DlyOrder, ptypeid, ktypeid, GoodsOrder, JobNumber, OutFactoryDate, Qty, Price, Total, GoodsDate )
                                            VALUES  ( @nVchCode, @nVchType, 0, @szptypeid, @szktypeid, 0, @szBlockno, @szProdate, @dQty, 0, @dTotal, GETDATE() )
                                            IF @@RowCount = 0 
                                                GOTO ErrorNoRec
                                        END	
                                    ELSE 
                                        BEGIN
                                            INSERT  INTO tbx_Stock_Glide ( VchCode, VchType, DlyOrder, ptypeid, ktypeid, GoodsOrder, JobNumber, OutFactoryDate, Qty, Price, Total, GoodsDate )
                                            VALUES  ( @nVchCode, @nVchType, 0, @szptypeid, @szktypeid, 0, @szBlockno, @szProdate, @dQty, Dbo.Fun_CovTotalDivQty(@dTotal, @dQty), @dTotal, GETDATE() )
                                            IF @@RowCount = 0 
                                                GOTO ErrorNoRec
                                        END
                                                
                                    SELECT  @dCostTotalOut = @dTotal
                                    GOTO Success
                                END
                        END
                    ELSE --����޼�¼
                        BEGIN
                            IF @dQty < 0 
                                BEGIN
                                    SET @ErrorValue = '��ǰ�����������'
                                    GOTO ErrorCloseCursor
                                END
                                
                            --IF ( ( @dTotal = 0 )
                            --     AND ( @nInputZero = 0 )
                            --   ) --�����Ϊ0�����Ҳ�����0�������,����ⲻǿ�Ƴ���
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
                            
                            --���䶯 dlyorder����0�������˺�����   
                            INSERT  INTO tbx_Stock_Glide ( VchCode, VchType, DlyOrder, ptypeid, ktypeid, GoodsOrder, JobNumber, OutFactoryDate, Qty, Price, Total, GoodsDate )
                            VALUES  ( @nVchCode, @nVchType, 0, @szptypeid, @szktypeid, 0, @szBlockno, @szProdate, @dQty, @dCostPricetemp, @dTotal, GETDATE() )
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
        BEGIN		 /*---------------------�޸��ڳ�--------------------*/
            PRINT '�޸��ڳ�'
        END 
	
    Success:		 --�ɹ���ɺ���
    DEALLOCATE    ModIFyDbf_CURSOR
    RETURN 0


    ErrorGeneral:    --�������ʱ���󣬲���Ҫ�ع�
    RETURN -1   
    
    ErrorRollback:   --���ݲ���ʱ������Ҫ�ع�
    RETURN -2 

    ErrorCloseCursor:   --���ݲ���ʱ������Ҫ�ر��α�
    DEALLOCATE ModIFyDbf_CURSOR
    RETURN -3 
    
    ErrorNoRec:    --�������ʱ����û�м�¼
    SET @ErrorValue = '���¼�¼����'
    DEALLOCATE ModIFyDbf_CURSOR
    RETURN -4

    ErrorInputCostPric:    --�������ʱ�����������Ϊ0
    SET @ErrorValue = '-�������Ϊ0'
    DEALLOCATE ModIFyDbf_CURSOR
    RETURN -5

GO 
