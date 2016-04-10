IF OBJECT_ID('dbo.pbx_Stock_QryCheck') IS NOT NULL 
    DROP PROCEDURE dbo.pbx_Stock_QryCheck
go

--查询盘点

CREATE PROCEDURE pbx_Stock_QryCheck
    (
      @KTypeId VARCHAR(50) , --仓库ID
      @ETypeid VARCHAR(50) , --操作员ID
      @CheckDate VARCHAR(10) , --盘点日期
      @Updatetag INT ,  --盘点号
      @ErrorValue VARCHAR(500) OUTPUT 
    )
AS 
    SET NOCOUNT ON
    DECLARE @aSQL VARCHAR(8000)

    SELECT  *
    FROM    dbo.tbx_Stock_Check sc LEFT JOIN dbo.tbx_Base_Ptype bp ON sc.PTypeId = bp.PTypeId
    WHERE   ISNULL(sc.PTypeId, '') <> ''
            AND sc.UpdateTag = @Updatetag
            
    --EXEC(@aSQL)        
    RETURN 0

GO 
