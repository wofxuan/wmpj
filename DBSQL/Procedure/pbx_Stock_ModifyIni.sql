IF OBJECT_ID('dbo.pbx_Stock_ModifyIni') IS NOT NULL 
    DROP PROCEDURE dbo.pbx_Stock_ModifyIni
go

-- 期初商品库存修改

CREATE PROCEDURE pbx_Stock_ModifyIni
    (
      @PTypeId VARCHAR(25) ,
      @KTypeId VARCHAR(25) ,
      @Qty NUMERIC(22, 10) ,
      @Total NUMERIC(22, 10) ,
      @Memo VARCHAR(255) ,    --序列号说明
      @JobNumber VARCHAR(20) ,     --批号（查询序列号时用）
      @OrderID INT OUTPUT ,
      @ErrorValue VARCHAR(500) OUTPUT 
    )
AS 
    DECLARE @Return INT
    DECLARE @InitOver INT
    
    SELECT  @InitOver = PValue
    FROM    dbo.tbx_Sys_Param
    WHERE   PName = 'InitOver'
    
    IF ISNULL(@InitOver, 0) = 1
    BEGIN
		SET @ErrorValue='已经开账，不能修改期初数据！'
		GOTO ErrorGeneral 	
    END
    
    IF NOT EXISTS ( SELECT  1
                    FROM    dbo.tbx_Base_Ptype
                    WHERE   PTypeId = @PTypeId
                            AND PSonnum = 0
                            AND Deleted = 0 ) 
        BEGIN
            SET @ErrorValue = '该商品已经被删除或者分类！'	
            GOTO ErrorGeneral
        END
    IF NOT EXISTS ( SELECT  1
                    FROM    dbo.tbx_Base_Ktype
                    WHERE   KTypeId = @KTypeId
                            AND KSonnum = 0
                            AND Deleted = 0 ) 
        BEGIN
            SET @ErrorValue = '该仓库已经被删除或者分类！'	
            GOTO ErrorGeneral
        END
    IF NOT EXISTS ( SELECT  1
                    FROM    dbo.tbx_Base_Ptype
                    WHERE   PTypeId = @PTypeId
                            AND Costmode = 0 ) 
        BEGIN
            SET @ErrorValue = '该商品成本算法已经被更改！'	
            GOTO ErrorGeneral
        END

    DELETE  FROM dbo.tbx_Stock_Goods_Ini
    WHERE   PTypeId = @PTypeId
            AND KTypeId = @KTypeId
            
    IF ( @Qty = 0 ) 
        GOTO Success
        
    INSERT  dbo.tbx_Stock_Goods_Ini ( PTypeId, KTypeId, Qty, Price, Total )
    VALUES  ( @PTypeId, @KTypeId, @Qty, dbo.Fun_CovTotalDivQty(@Total, @Qty), @Total )

    SET @Return = @@ERROR
    IF @@ROWCOUNT = 0 
        GOTO OtherError
	
    SET @OrderID = @@IDENTITY
    
    GOTO Success

    Success:		 --成功完成函数
    RETURN 0
    
    ErrorGeneral:    --检查数据是错误，不需要回滚
    RETURN -1   
    
    ErrorRollback:   --数据操作是错误，需要回滚
    --ROLLBACK TRAN insertproc 
    RETURN -2 
    
    OtherError:
    RETURN @Return
GO
