IF OBJECT_ID('dbo.pbx_Sys_InitOver') IS NOT NULL 
    DROP PROCEDURE dbo.pbx_Sys_InitOver
go

-- 开帐、反开帐

CREATE PROCEDURE pbx_Sys_InitOver
    (
      @DoType INT ,--0:反开账,1:开账
      @ErrorValue VARCHAR(500) OUTPUT 
    )
AS 
    DECLARE @Return INT
    DECLARE @IsInitOver INT
    
    IF @DoType = 1 
        BEGIN
            SELECT  @IsInitOver = PValue
            FROM    dbo.tbx_Sys_Param
            WHERE   PName = 'InitOver'
            IF @IsInitOver = 1 
                BEGIN
                    SET @ErrorValue = '系统已经开账，可以作账了，不能再开账'
                    GOTO ErrorGeneral
                END
                
            DELETE  dbo.tbx_Stock_Goods_Ini
            WHERE   Qty = 0 AND Total = 0
            IF @@ERROR <> 0 
                BEGIN
                    SET @ErrorValue = '删除期初库存失败'
                    GOTO ErrorGeneral
                END
                
            BEGIN TRAN InitOver
            --设置开帐标志
            UPDATE  dbo.tbx_Sys_Param SET PValue = '1' WHERE PName = 'InitOver'
            IF @@ERROR <> 0 goto ErrorRollback		
            
            --将期初库存复制到库存库
            TRUNCATE TABLE dbo.tbx_Stock_Goods
            SET IDENTITY_INSERT tbx_Stock_Goods ON
            INSERT  INTO dbo.tbx_Stock_Goods ( GoodsOrderId, PTypeId, KTypeId, JobNumber, OutFactoryDate, Qty, Price, Total, GoodsOrder )
                    SELECT  GoodsOrderId, PTypeId, KTypeId, JobNumber, OutFactoryDate, Qty, Price, Total, GoodsOrder
                    FROM    dbo.tbx_Stock_Goods_Ini 
            SET IDENTITY_INSERT tbx_Stock_Goods OFF
            
            --  修改aType库存商品应收应付
            --	计算储值余额
            --	写入期初资本
            COMMIT TRAN InitOver
        END
    ELSE 
        BEGIN
			BEGIN TRAN InitOver
            --设置开帐标志
            UPDATE  dbo.tbx_Sys_Param SET PValue = '0' WHERE PName = 'InitOver'
            
			TRUNCATE TABLE dbo.tbx_Stock_Goods
			
            COMMIT TRAN InitOver
        END
    
    GOTO Success

    Success:		 --成功完成函数
    RETURN 0
    
    ErrorGeneral:    --检查数据是错误，不需要回滚
    RETURN -1   
    
    ErrorRollback:   --数据操作是错误，需要回滚
    ROLLBACK TRAN InitOver 
    RETURN -2 
GO
