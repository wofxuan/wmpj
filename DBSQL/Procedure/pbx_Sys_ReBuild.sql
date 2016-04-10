IF OBJECT_ID('dbo.pbx_Sys_ReBuild') IS NOT NULL 
    DROP PROCEDURE dbo.pbx_Sys_ReBuild
go

--  ********************************************************************************************                                                                               
--  ||   �������ƣ�pbx_Sys_ReBuild                                                 
--  ||   ���̹��ܣ�ϵͳ�ؽ�                                          
--  ********************************************************************************************
CREATE PROCEDURE pbx_Sys_ReBuild
    (
      @ClearStock INT ,--��������Ʒ�ͻ�ƿ�Ŀ���ڳ�ֵ
      @ClearBak INT ,--����ݸ��
      --�������Ǳ���Ĳ���
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

    Success:		 --�ɹ���ɺ���
    RETURN 0
    
    ErrorGeneral:    --��������Ǵ��󣬲���Ҫ�ع�
    RETURN -1   
    
    ErrorRollback:   --���ݲ����Ǵ�����Ҫ�ع�
    ROLLBACK TRAN DelBill
    RETURN -2 
go
