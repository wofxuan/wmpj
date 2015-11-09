IF OBJECT_ID('dbo.pbx_Bill_ClearSaveCreate') IS NOT NULL 
    DROP PROCEDURE dbo.pbx_Bill_ClearSaveCreate
go

--  ********************************************************************************************                                                                                  
--  ||   �������ƣ�pbx_Bill_ClearSaveCreate                                                
--  ||   ���̹��ܣ����浥�ݹ�����ʧ�ܵ�ʱ��ɾ����ǰ���������
--  ********************************************************************************************

CREATE    PROCEDURE [pbx_Bill_ClearSaveCreate]
    (
      @PRODUCT_TRADE INT ,
      @Modi INT ,
      @VchType INT ,
      @NewVchCode INT ,
      @OldVchCode INT   
   
    )
AS 
    IF @NewVCHCODE = 0 
        RETURN 0

    BEGIN TRAN DelBak

    IF @VchType IN ( 7, 8 ) --���������۶���
        BEGIN
            DELETE  FROM tbx_Bill_Order_M
            WHERE   VchCode = @NewVchCode
	
            DELETE  FROM dbo.tbx_Bill_Order_D
            WHERE   VchCode = @NewVchCode	
        END


    COMMIT TRAN DelBak

Go