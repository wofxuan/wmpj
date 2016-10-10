IF OBJECT_ID('dbo.pbx_Limit_Save_RU') IS NOT NULL 
    DROP PROCEDURE dbo.pbx_Limit_Save_RU
GO
--  ********************************************************************************************
--  ||                                                                                        
--  ||   �������ƣ�pbx_Limit_Save_RU
--  ||   ���̹��ܣ�����һ���û��ͽ�ɫ��ӳ���ϵ
--  ||=========================================================================================

CREATE    PROCEDURE pbx_Limit_Save_RU
    (
      @LRGUID VARCHAR(50) , --��ɫID
      @UserId VARCHAR(50) , --�û�ID
      @ErrorValue VARCHAR(500) OUTPUT 
    )
AS 
    IF NOT EXISTS ( SELECT  *
                    FROM    dbo.tbx_Limit_RU
                    WHERE   LRGUID = @LRGUID
                            AND UserId = @UserId ) 
        BEGIN
            INSERT  INTO dbo.tbx_Limit_RU ( LRGUID, UserId )
            VALUES  ( @LRGUID, @UserId )	
        END
	

    Success:
    RETURN 0

    ErrorGeneral:    --��������Ǵ��󣬲���Ҫ�ع�
    RETURN -1  


GO
