IF OBJECT_ID('dbo.pbx_Limit_Save_RU') IS NOT NULL 
    DROP PROCEDURE dbo.pbx_Limit_Save_RU
GO
--  ********************************************************************************************
--  ||                                                                                        
--  ||   过程名称：pbx_Limit_Save_RU
--  ||   过程功能：增加一个用户和角色点映射关系
--  ||=========================================================================================

CREATE    PROCEDURE pbx_Limit_Save_RU
    (
      @LRGUID VARCHAR(50) , --角色ID
      @UserId VARCHAR(50) , --用户ID
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

    ErrorGeneral:    --检查数据是错误，不需要回滚
    RETURN -1  


GO
