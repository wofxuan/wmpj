IF OBJECT_ID('dbo.pbx_Stock_SaveCheck') IS NOT NULL 
    DROP PROCEDURE dbo.pbx_Stock_SaveCheck
go

--  ********************************************************************************************                                                                                  
--  ||   过程名称：pbx_Stock_SaveCheck                                                
--  ||   过程功能：保存一条盘点记录
--  ********************************************************************************************

CREATE PROCEDURE pbx_Stock_SaveCheck
    (
      @KTypeId VARCHAR(50) ,
      @PTypeId VARCHAR(50) ,
      @GoodsOrder INT , --对应库存表中的Goodsorder字段
      @CheckedQty NUMERIC(22, 10) ,--盘点数量
      @UpdateTag INT ,--盘点号
      @CheckDate VARCHAR(10) ,--盘点日期
      @SCId INT ,
      @JobNumber VARCHAR(20) ,--批号
      @OutFactoryDate VARCHAR(13) ,--生产日期
      @Total NUMERIC(22, 10) ,--
      @ETypeId VARCHAR(50) ,--操作员
      --下面面是基本信息必须的参数
      @errorValue VARCHAR(500) OUTPUT --返回错误信息
    )
AS 
    SET NOCOUNT ON
	
    DECLARE @CostMode INT
    DECLARE @StockQty NUMERIC(22, 10) --库存量
    
    SELECT  @CostMode = Costmode
    FROM    dbo.tbx_Base_Ptype
    WHERE   PTypeId = @PTypeId
	
	SET @StockQty = 0
	
    BEGIN TRAN insertproc
    
    IF @SCId = 0 
        BEGIN
            INSERT  INTO dbo.tbx_Stock_Check ( KTypeId, PTypeId, GoodsOrder, CostMode, CheckedQty, UpdateTag, StockQty, CheckDate, JobNumber, OutFactoryDate, Total, ETypeId )
            VALUES  ( @KTypeId, @PTypeId, @GoodsOrder, @CostMode, @CheckedQty, @UpdateTag, @StockQty, @CheckDate, @JobNumber, @OutFactoryDate, @Total, @ETypeId )	
        END
    ELSE 
        BEGIN
            UPDATE  dbo.tbx_Stock_Check
            SET     KTypeId = @KTypeId, PTypeId = @PTypeId, GoodsOrder = @GoodsOrder,
					CostMode = @CostMode, CheckedQty = @CheckedQty, UpdateTag = @UpdateTag,
					StockQty = @StockQty, CheckDate = @CheckDate, JobNumber = @JobNumber,
					OutFactoryDate = @OutFactoryDate, Total = @Total, ETypeId = @ETypeId
            WHERE   SCId = @SCId 
        END 
        
    COMMIT TRAN insertproc
    GOTO success

    Success:		 --成功完成函数
    RETURN 0
    ErrorGeneral:    --检查数据是错误，不需要回滚
    RETURN -1   
    ErrorRollback:   --数据操作是错误，需要回滚
    ROLLBACK TRAN insertproc 
    RETURN -2 
go
