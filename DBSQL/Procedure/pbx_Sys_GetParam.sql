IF OBJECT_ID('dbo.pbx_Sys_GetParam') IS NOT NULL 
    DROP PROCEDURE dbo.pbx_Sys_GetParam
GO

--获取系统参数

CREATE PROCEDURE pbx_Sys_GetParam
    (
      @PName VARCHAR(30) ,
      @ValueReturn VARCHAR(1000) OUTPUT
    )
AS 
    SET NOCOUNT OFF

    IF NOT EXISTS ( SELECT  *
                    FROM    dbo.tbx_Sys_Param
                    WHERE   PName = @PName ) 
        BEGIN
            INSERT  INTO dbo.tbx_Sys_Param ( PName )
            VALUES  ( @PName ) 
        END

        
    SELECT  @ValueReturn = PValue
    FROM    dbo.tbx_Sys_Param
    WHERE   PName = @PName
    
    RETURN 0

GO
