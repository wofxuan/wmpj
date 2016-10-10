IF OBJECT_ID('dbo.pbx_Limit_QryData') IS NOT NULL 
    DROP PROCEDURE dbo.pbx_Limit_QryData
go

--查询用户或角色列表

CREATE PROCEDURE pbx_Limit_QryData
    (
      @QryType INT ,  --1角色，2角色用户映射表,
      @Custom VARCHAR(500) = '' ,--默认参数 
      @ErrorValue VARCHAR(500) OUTPUT 
    )
AS 
    SET NOCOUNT ON
    DECLARE @aSQL VARCHAR(8000)

    IF ( @QryType = 1 ) 
        BEGIN
            SELECT  *
            FROM    dbo.tbx_Limit_Role
            ORDER BY LRRowIndex
        END
    ELSE 
        IF ( @QryType = 2 ) 
            BEGIN
                SELECT  lr.*, be.EFullname
                FROM    dbo.tbx_Limit_RU lr
                        LEFT JOIN dbo.tbx_Base_Etype be ON lr.UserId = be.ETypeId 
                WHERE lr.LRGUID = @Custom
                ORDER BY lr.UserId  	
            END

            
    --EXEC(@aSQL)        
    RETURN 0

GO 
