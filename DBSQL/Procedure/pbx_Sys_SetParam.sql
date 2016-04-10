IF OBJECT_ID('dbo.pbx_Sys_SetParam') IS NOT NULL 
    DROP PROCEDURE dbo.pbx_Sys_SetParam
GO

--设置系统参数

CREATE PROCEDURE pbx_Sys_SetParam
    (
      @PName VARCHAR(30) ,
      @PValue VARCHAR(1000)
    )
AS 
    SET NOCOUNT OFF

    IF EXISTS ( SELECT  1
                FROM    dbo.tbx_Sys_Param
                WHERE   PName = @PName ) 
        UPDATE  dbo.tbx_Sys_Param
        SET     PValue = @PValue
        WHERE   PName = @PName 
    ELSE 
        INSERT  INTO dbo.tbx_Sys_Param ( PName, PValue )
        VALUES  ( @PName, @PValue )
    
    RETURN 0

GO
