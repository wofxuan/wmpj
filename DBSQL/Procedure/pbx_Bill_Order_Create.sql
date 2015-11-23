IF OBJECT_ID('dbo.pbx_Bill_Order_Create') IS NOT NULL 
    DROP PROCEDURE dbo.pbx_Bill_Order_Create
go

--  ********************************************************************************************                                                                                  
--  ||   过程名称：pbx_Bill_Order_Create                                                
--  ||   过程功能：进货或者销售订单过账
--  ********************************************************************************************

CREATE PROCEDURE dbo.pbx_Bill_Order_Create
    (
      @OldVchCode INT ,
      @NewvchCode INT ,
       --下面面是存储过程必须的参数
      @ErrorValue VARCHAR(500) OUTPUT  
    )
AS 
    DECLARE @net INT ,
        @inputNo VARCHAR(50)
    DECLARE @sdate VARCHAR(10)
    DECLARE @nVchtype INT ,
        @nPeriod INT ,
        @nYearPeriod INT ,
        @DeptID VARCHAR(50)
    DECLARE @modiDly CHAR(1)
    DECLARE @ntotal NUMERIC(22, 10)
    DECLARE @YPratypeid VARCHAR(50)
    DECLARE @flag INT
    DECLARE @szBTypeID VARCHAR(50) 
    DECLARE @szKTypeID VARCHAR(50) 
    DECLARE @szETypeID VARCHAR(50) 
    DECLARE @SzPtypeid VARCHAR(50) 
    DECLARE @szATypeID VARCHAR(500)

    SET @net = 0

    --SELECT  @nPeriod = ISNULL(SubValue, 0)
    --FROM    SysData
    --WHERE   SubName = 'Period'
    --IF @nPeriod <= 0
    --    OR @nPeriod > 12 
    --    BEGIN
    --        SET @net = -11
    --        GOTO ErrorGeneral
    --    END
    --SELECT  @nYearPeriod = ISNULL(SubValue, 0)
    --FROM    SysData
    --WHERE   SubName = 'YearPeriod'
 
    --IF EXISTS ( SELECT  1
    --            FROM    dbo.sysdata
    --            WHERE   SubName = 'iniover'
    --                    AND SubValue <> '1' )
    --    AND EXISTS ( SELECT 1
    --                 FROM   BakDlyOrder
    --                 WHERE  vchcode = @newvchcode
    --                        AND ptypeid = ''
    --                        AND atypeid <> '0000100001' ) 
    --    BEGIN
    --        SET @net = -824
    --        GOTO ErrorGeneral
    --    END
 

    SELECT  @szBTypeID = '', @szKTypeID = '', @szETypeID = '', @SzPtypeid = '', @flag = 1

    SELECT  @nVchtype = VchType, @sdate = InputDate, @szETypeID = ETypeID, @szbtypeid = btypeid, @inputNo = inputNo, @modiDly = RedWord, @DeptID = DtypeId
    FROM    dbo.tbx_Bill_Order_M
    WHERE   vchcode = @newvchcode	
    IF @nVchtype = 8 
        BEGIN
            SET @flag = 1
            SET @YPratypeid = '0000200005'	--预收账款
        END
    ELSE 
        BEGIN
            SET @flag = -1 
            SET @YPratypeid = '0000100009' --预付账款
        END

    IF @szBTypeID <> '' 
        IF NOT EXISTS ( SELECT  btypeid
                        FROM    dbo.tbx_Base_Btype
                        WHERE   btypeid = @szBTypeID
                                AND Deleted = 0
                                AND bSonNum = 0 ) 
            BEGIN
                SET @ErrorValue = '单位不存在或者已经删除'
                GOTO ErrorGeneral
            END
    IF @szETypeID <> '' 
        IF NOT EXISTS ( SELECT  etypeid
                        FROM    dbo.tbx_Base_Etype
                        WHERE   etypeid = @szETypeID
                                AND Deleted = 0
                                AND eSonNum = 0 ) 
            BEGIN
                SET @ErrorValue = '经手人不存在或者已经删除'
                GOTO ErrorGeneral
            END
    IF @DeptID <> '' 
        IF NOT EXISTS ( SELECT  Dtypeid
                        FROM    dbo.tbx_Base_Dtype
                        WHERE   Dtypeid = @DeptID
                                AND Deleted = 0
                                AND dSonNum = 0 ) 
            BEGIN
                SET @ErrorValue = '部门不存在或者已经删除'
                GOTO ErrorGeneral
            END
    IF @inputNo <> ''
        AND @inputNo <> '00000' 
        IF NOT EXISTS ( SELECT  etypeid
                        FROM    tbx_Base_Etype
                        WHERE   etypeid = @inputNo
                                AND Deleted = 0
                                AND eSonNum = 0 ) 
            BEGIN
                SET @ErrorValue = '制单人不存在或者已经删除'
                GOTO ErrorGeneral
            END
	
    IF EXISTS ( SELECT  1
                FROM    dbo.tbx_Bill_Order_D dly ,
                        dbo.tbx_Base_Ptype p
                WHERE   p.ptypeid = dly.ptypeid
                        AND vchcode = @newvchcode
                        AND ( deleted = 1
                              OR pSonNum <> 0
                            ) ) 
        BEGIN
            SELECT TOP 1
                    @SzPtypeid = dly.ptypeid
            FROM    tbx_Bill_Order_D dly ,
                    tbx_Base_Ptype p
            WHERE   p.ptypeid = dly.ptypeid
                    AND vchcode = @newvchcode
                    AND ( deleted = 1
                          OR pSonNum <> 0
                        )
			
            SET @ErrorValue = '商品不存在或者已经删除'
            GOTO ErrorGeneral		
		
        END
    --IF EXISTS ( SELECT  1
    --            FROM    tbx_Bill_Order_D dly ,
    --                    dbo.atype a
    --            WHERE   a.atypeid = dly.atypeid
    --                    AND vchcode = @newvchcode
    --                    AND ( deleted = 1
    --                          OR aSonNum <> 0
    --                        ) ) 
    --    BEGIN
    --        SELECT TOP 1
    --                @szATypeID = dly.atypeid
    --        FROM    tbx_Bill_Order_D dly ,
    --                dbo.atype a
    --        WHERE   a.atypeid = dly.atypeid
    --                AND vchcode = @newvchcode
    --                AND ( deleted = 1
    --                      OR aSonNum <> 0
    --                    )
			
    --        SET @net = -137
    --        GOTO ErrorGeneral		
		
    --    END

--是否被调用
    --IF @oldVchcode <> 0 
    --    BEGIN
    --        EXEC @net = dbo.P_HH_CanChangeOrder @nVchtype, @oldVchcode
    --        IF @net < 0 
    --            BEGIN
    --                SET @net = -157
    --                GOTO ErrorGeneral	
    --            END
    --    END

    IF EXISTS ( SELECT  1
                FROM    tbx_Bill_Order_D dly ,
                        dbo.tbx_Base_Ktype k
                WHERE   k.ktypeid = dly.ktypeid
                        AND dly.ktypeid <> ''
                        AND vchcode = @newvchcode
                        AND ( deleted = 1
                              OR kSonNum <> 0
                            ) ) 
        BEGIN
            SELECT TOP 1
                    @SzKtypeid = dly.ktypeid
            FROM    tbx_Bill_Order_D dly ,
                    tbx_Base_Ktype k
            WHERE   k.ktypeid = dly.ktypeid
                    AND dly.ktypeid <> ''
                    AND vchcode = @newvchcode
                    AND ( deleted = 1
                          OR kSonNum <> 0
                        )			
		
            SET @ErrorValue = '仓库不存在或者已经删除'
            GOTO ErrorGeneral				
        END
	
   -- IF EXISTS ( SELECT  1
   --             FROM    tbx_Bill_Order_D dly ,
   --                     dbo.tbx_Base_Ptype p
   --             WHERE   p.ptypeid = dly.ptypeid
   --                     AND vchcode = @newvchcode
   --                     AND ( Ptypetype = 1
   --                           OR SNManCode = 1
   --                           OR pgmancode IN ( 1, 2 )
   --                         )
   --                     AND unit > 0 ) 
   --     BEGIN
   --         SELECT TOP 1
   --                 @SzPtypeid = dly.ptypeid
   --         FROM    bakdlyorder dly ,
   --                 ptype p
   --         WHERE   p.ptypeid = dly.ptypeid
   --                 AND vchcode = @newvchcode
   --                 AND ( Ptypetype = 1
   --                       OR SNManCode = 1
   --                       OR pgmancode IN ( 1, 2 )
   --                     )
   --                 AND unit > 0
   --         ORDER BY dlyorder				
		
   --         SET @net = -149
   --         GOTO ErrorGeneral		
		 ----服务类，序列号，明细码 不支持多单位
   --     END
	
  --  IF EXISTS ( SELECT  1
  --              FROM    bakdlyorder dly ,
  --                      ptype p
  --              WHERE   p.ptypeid = dly.ptypeid
  --                      AND vchcode = @newvchcode
  --                      AND SNManCode = 1
  --                      AND p.costmode NOT IN ( 0, 3 ) ) 
  --      BEGIN
  --          SELECT TOP 1
  --                  @SzPtypeid = dly.ptypeid
  --          FROM    bakdlyorder dly ,
  --                  ptype p
  --          WHERE   p.ptypeid = dly.ptypeid
  --                  AND vchcode = @newvchcode
  --                  AND SNManCode = 1
  --                  AND p.costmode NOT IN ( 0, 3 )
  --          ORDER BY dlyorder				
  --          SET @net = -150
  --          GOTO ErrorGeneral
		----序列号的成本算法不支持先进，后进
  --      END
	
  --  IF EXISTS ( SELECT  1
  --              FROM    dbo.tbx_Bill_Order_D dly ,
  --                      dbo.tbx_Base_Ptype p
  --              WHERE   p.ptypeid = dly.ptypeid
  --                      AND vchcode = @newvchcode
  --                      AND ( ( pgManCode IN ( 1, 2 )
  --                              AND p.costmode NOT IN ( 0, 3 )
  --                            )
  --                            OR ( Ptypetype = 1
  --                                 AND p.costmode <> 0
  --                               )
  --                          ) ) 
  --      BEGIN
  --          SELECT TOP 1
  --                  @SzPtypeid = dly.ptypeid
  --          FROM    tbx_Bill_Order_D dly ,
  --                  tbx_Base_Ptype p
  --          WHERE   p.ptypeid = dly.ptypeid
  --                  AND vchcode = @newvchcode
  --                  AND ( ( pgManCode IN ( 1, 2 )
  --                          AND p.costmode NOT IN ( 0, 3 )
  --                        )
  --                        OR ( Ptypetype = 1
  --                             AND p.costmode <> 0
  --                           )
  --                      )
  --          ORDER BY dlyorder						
  --          SET @net = -147
  --          GOTO ErrorGeneral   
		----服务类商品，或明细码商品不支持非加权
  --      END

--本单据已经在其它地方修改，不能修改/删除
    IF @modiDly = 'F'
        AND @oldVchcode <> 0 
        BEGIN
            IF NOT EXISTS ( SELECT  1
                            FROM    dbo.tbx_Bill_Order_M
                            WHERE   vchcode = @oldVchcode
                                    AND btypeid = @szBTypeID
                                    AND InputDate = @sdate ) 
                BEGIN
                    SET @net = -823
                    GOTO ErrorGeneral	
                END
        END 

    BEGIN TRAN ndxORDER

    IF @oldVchcode <> 0 
        BEGIN
	
            UPDATE  tbx_Bill_Order_M
            SET     InputDate = N.InputDate, Number = N.Number, VchType = N.VchType, Summary = N.Summary, Comment = N.Comment, BtypeId = N.BtypeId, EtypeId = N.EtypeId, DtypeId = N.DtypeId, KtypeId = N.KtypeId, KtypeId2 = N.KtypeId2, Period = N.Period, YearPeriod = N.YearPeriod, RedWord = N.RedWord, Redold = N.Redold, InputNo = N.InputNo, InputNO1 = N.InputNO1, InputNO2 = N.InputNO2, InputNO3 = N.InputNO3, InputNO4 = N.InputNO4, InputNO5 = N.InputNO5, Total = N.Total, Defdiscount = N.Defdiscount, Savedate = N.Savedate, AuditState = N.AuditState, OrderOver = N.OrderOver, UserOver = N.UserOver, GatheringDate = N.GatheringDate
            FROM    ( SELECT    InputDate, Number, VchType, Summary, Comment, BtypeId, EtypeId, DtypeId, KtypeId, KtypeId2, Period, YearPeriod, RedWord, Redold, InputNo, InputNO1, InputNO2, InputNO3, InputNO4, InputNO5, Total, Defdiscount, Savedate, AuditState, OrderOver, UserOver, GatheringDate
                      FROM      tbx_Bill_Order_M
                      WHERE     Vchcode = @Newvchcode
                    ) N
            WHERE   Vchcode = @OldVchcode
            IF @@ERROR <> 0 
                BEGIN
                    SET @net = -101
                    GOTO ErrorRollback
                END			  	 			
        END


 --   IF @modiDly = 'T'
 --       AND EXISTS ( SELECT 1
 --                    FROM   dbo.tbx_Bill_Order_D
 --                    WHERE  vchcode = @newvchcode
 --                           AND ptypeid = ''
 --                           AND atypeid <> '0000100001' ) 
 --       BEGIN
 --           INSERT  INTO DlyA ( vchcode, atypeid, btypeid, etypeid, ktypeid, total, date, period, vchtype, redword, DeptID, usedtype, YearPeriod )
 --                   SELECT  vchcode, atypeid, @szBTypeID, @szETypeID, @szKTypeID, total, @sdate, @nPeriod, @nvchtype, 'F', @DeptID, usedtype, @nYearPeriod
 --                   FROM    BakDlyOrder
 --                   WHERE   vchcode = @newvchcode
 --                           AND ptypeid = ''
 --                           AND atypeid <> '0000100001'
           		    
	----预收账款
 --           SET @ntotal = 0
 --           SELECT  @ntotal = SUM(total)
 --           FROM    BakDlyOrder
 --           WHERE   vchcode = @newvchcode
 --                   AND ptypeid = ''
 --                   AND atypeid <> '0000100001'  
        			  	 	 			 
 --           INSERT  INTO DlyA ( vchcode, atypeid, btypeid, etypeid, ktypeid, total, date, period, vchtype, redword, DeptID, usedtype, YearPeriod )
 --           VALUES  ( @newvchcode, @YPratypeid, @szBTypeID, @szETypeID, @szKTypeID, @flag * @ntotal, @sdate, @nPeriod, @nVchtype, 'F', @DeptID, 2, @nYearPeriod )      
 --       END 

 --   IF @modiDly = 'T' 
 --       BEGIN 				
	----处理订单数据定金数据
 --           DECLARE @szAATypeID VARCHAR(50) ,
 --               @szABTypeID VARCHAR(50) ,
 --               @dTotal NUMERIC(22, 10)
 --           DECLARE @execsql VARCHAR(500)
 --           DECLARE @dTemp NUMERIC(22, 10) ,
 --               @AUnit NUMERIC(22, 10) ,
 --               @dUnitRate NUMERIC(22, 10) ,
 --               @tDate VARCHAR(10)
 --           SET @net = 0
	 		 				
 --           SELECT  @execsql = 'declare AccountDly_cursor cursor for ' + ' SELECT ATypeID,BTypeID, SUM(total) total FROM ( ' + 'select ATypeID, BTypeID,Total from dlya  where  Vchcode= ' + CAST(@newvchcode AS VARCHAR(10)) + ' and vchtype = ' + CAST(@nVchtype AS VARCHAR(10)) + ' ' + ' UNION ALL ' + ' select ATypeID, BTypeID, -Total total from dlya  where  Vchcode= ' + CAST(@oldVchcode AS VARCHAR(10)) + ' and vchtype = ' + CAST(@nVchtype AS VARCHAR(10)) + ' ) a ' + 'GROUP BY ATypeID,BTypeID  HAVING SUM(total) <> 0'             
 --           EXEC (@execsql)
 --           OPEN AccountDly_cursor
 --           FETCH NEXT FROM AccountDly_cursor INTO @szAATypeID, @szABTypeID, @dTotal
 --           WHILE @@FETCH_STATUS = 0 
 --               BEGIN
 --                   IF @szAATypeID <> '' 
 --                       BEGIN
 --                           EXEC @net = ModifyDbf @nVchType, @newvchcode, 0, @tDate, 0, @szAATypeID, '', @szABTypeID, @szETypeID, '', @nPeriod, @dTotal, @dTotal, '', '', 0, @dTemp OUTPUT, @AUnit, @dUnitRate, 0
 --                           IF @net < 0 
 --                               GOTO ErrorGeneral
	              
 --                       END
 --                   FETCH NEXT FROM AccountDly_cursor INTO @szAATypeID, @szABTypeID, @dTotal
 --               END
 --           CLOSE AccountDly_cursor
 --           DEALLOCATE AccountDly_cursor
 --       END

    --IF @modiDly = 'T' 
    --    BEGIN
    --        EXEC @net = p_hh_CanModiOrderBill 'M', @oldVchcode, @newvchcode, @nVchtype
    --        IF @net < 0 
    --            GOTO ErrorRollback
    --    END

	
    IF @OldVchCode = 0 
        BEGIN
            PRINT '审核功能'
            --UPDATE  dbo.tbx_Bill_Order_M
            --SET     AuditState = dbo.fn_getAuditState(VchType, Vchcode)
            --WHERE   Vchcode = @NewVchCode
        END
    ELSE 
        BEGIN
            DELETE  FROM tbx_Bill_Order_M
            WHERE   VchCode = @NewVchCode	
     
            --UPDATE  dbo.tbx_Bill_Order_M
            --SET     AuditState = dbo.fn_getAuditState(VchType, Vchcode)
            --WHERE   Vchcode = @OldVchcode
    
            IF @modiDly = 'T' 
                BEGIN
                    DELETE  FROM tbx_Bill_Order_D
                    WHERE   vchcode = @OldVchCode				
                    --DELETE  FROM dlya
                    --WHERE   VchCode = @OldVchCode
                    --        AND VchType = @nVchtype
                END 
            ELSE 
                BEGIN
                    DELETE  FROM tbx_Bill_Order_D
                    WHERE   VchCode = @OldVchCode
                            AND AtypeId = '0000100001'
                END
		 
            UPDATE  tbx_Bill_Order_D
            SET     VchCode = @OldVchCode
            WHERE   VchCode = @NewVchCode
			 		
            DELETE  FROM tbx_Bill_Order_D
            WHERE   VchCode = @NewVchCode
			
        END

    IF @modiDly = 'T' 
        UPDATE  tbx_Bill_Order_M
        SET     RedWord = 'F'
        WHERE   VchCode = CASE WHEN @OldVchCode = 0 THEN @NewVchCode
                               ELSE @OldVchCode
                          END

    COMMIT TRAN ndxORDER

--跟踪商品单位
    --DECLARE @unit INT ,
    --    @tmpvchcode INT

    --IF @oldVchcode <> 0 
    --    SET @tmpvchcode = @oldVchcode
    --ELSE 
    --    SET @tmpvchcode = @newvchcode
    --DECLARE my_cursor CURSOR
    --FOR
    --    SELECT  ptypeid, unit
    --    FROM    bakdlyorder
    --    WHERE   vchcode = @tmpvchcode
	
    --OPEN my_cursor
		
    --FETCH NEXT FROM my_cursor INTO @szptypeid, @unit
	
	
    --WHILE @@FETCH_STATUS = 0 
    --    BEGIN
    --        EXEC p_hh_GetLastUnit 'W', @nVchType, @szPtypeId, @unit
    --        FETCH NEXT FROM my_cursor INTO @szptypeid, @unit
    --    END
	
    --CLOSE my_cursor
    --DEALLOCATE my_cursor
	
    RETURN @net
    
    Success:		 --成功完成函数
    RETURN 0
    
    ErrorGeneral:    --检查数据是错误，不需要回滚
    DELETE  FROM tbx_Bill_Order_D
    WHERE   Vchcode = @NewVchCode
    DELETE  FROM tbx_Bill_Order_M
    WHERE   Vchcode = @NewVchCode	 
    RETURN -1   
    
    ErrorRollback:   --数据操作是错误，需要回滚
    ROLLBACK TRAN ndxORDER 
    DELETE  FROM tbx_Bill_Order_D
    WHERE   Vchcode = @NewVchCode
    DELETE  FROM tbx_Bill_Order_M
    WHERE   Vchcode = @NewVchCode
    RETURN -2 

GO 
