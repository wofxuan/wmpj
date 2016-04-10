IF OBJECT_ID('dbo.pbx_Sys_ReBuild') IS NOT NULL 
    DROP PROCEDURE dbo.pbx_Sys_ReBuild
go

--  ********************************************************************************************                                                                               
--  ||   过程名称：pbx_Sys_ReBuild                                                 
--  ||   过程功能：系统重建                                          
--  ********************************************************************************************
CREATE PROCEDURE pbx_Sys_ReBuild
    (
      @ClearStock INT ,--清除库存商品和会计科目的期初值
      @ClearBak INT ,--清除草稿库
      --下面面是必须的参数
      @ErrorValue VARCHAR(500) OUTPUT  
    )
AS 
    SET NOCOUNT ON
    
    BEGIN TRAN DelBill
	
    TRUNCATE TABLE dbo.tbx_Bill_Order_M
    TRUNCATE TABLE dbo.tbx_Bill_Order_D
    TRUNCATE TABLE dbo.tbx_Bill_M
    TRUNCATE TABLE dbo.tbx_Bill_D_Bak
    TRUNCATE TABLE dbo.tbx_Bill_Buy_D
    TRUNCATE TABLE dbo.tbx_Bill_Sale_D
    TRUNCATE TABLE dbo.tbx_Bill_Other_D
    TRUNCATE TABLE dbo.tbx_Bill_NumberRecords
    
    IF @ClearStock = 1
    BEGIN
		TRUNCATE TABLE dbo.tbx_Stock_Goods
		TRUNCATE TABLE dbo.tbx_Stock_Goods_Ini
		TRUNCATE TABLE dbo.tbx_Stock_Glide	
    END
    
    UPDATE dbo.tbx_Sys_Param SET PValue = '0' WHERE PName = 'InitOver'
      
    COMMIT TRAN DelBill
    
    GOTO Success    

    Success:		 --成功完成函数
    RETURN 0
    
    ErrorGeneral:    --检查数据是错误，不需要回滚
    RETURN -1   
    
    ErrorRollback:   --数据操作是错误，需要回滚
    ROLLBACK TRAN DelBill
    RETURN -2 
go
