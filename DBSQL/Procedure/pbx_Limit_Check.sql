IF OBJECT_ID('dbo.pbx_Limit_Check') IS NOT NULL
    DROP PROCEDURE dbo.pbx_Limit_Check
GO

--判断某个用户是否具有某种权限点某种操作

CREATE PROCEDURE pbx_Limit_Check
    (
      @LimitId VARCHAR(50) ,  -- 权限ID
      @LimitDo INT ,  --基本信息的相关操作，单据的相关操作，等等
      @UserId VARCHAR(50) ,--tbx_Limit_RU表的用户ID
      @ErrorValue VARCHAR(500) OUTPUT 
    )
AS
    SET NOCOUNT ON
    DECLARE @aSQL VARCHAR(8000)
    DECLARE @aRUType INT
    DECLARE @aLAType INT
    DECLARE @aLimitValue INT
    DECLARE @aRet INT
    DECLARE @aLAName VARCHAR(50)
    
    DECLARE @Limit_Base_View INT = 1--基本信息权限-查看
    DECLARE @Limit_Base_Add INT = 2--基本信息权限-新增
    DECLARE @Limit_Base_Class INT = 4--基本信息权限-分类
    DECLARE @Limit_Base_Modify INT = 8--基本信息权限-修改
    DECLARE @Limit_Base_Del INT = 16--基本信息权限-删除
    DECLARE @Limit_Base_Print INT = 32--基本信息权限-打印
  
    DECLARE @Limit_Bill_View INT = 1--单据权限-查看
    DECLARE @Limit_Bill_Input INT = 2--单据权限-输入
    DECLARE @Limit_Bill_Settle INT = 4--单据权限-过账
    DECLARE @Limit_Bill_Print INT = 8--单据权限-打印
    
    DECLARE @Limit_Report_View INT = 1--报表权限-查看
    DECLARE @Limit_Report_Print INT = 2--报表权限-打印
    
    SET @aRUType = 2 --通过用户查询
    SET @aLimitValue = 0
    
    IF @LimitDo = 0
        RETURN -1
     
    IF ( @UserId = '00000' )--超级管理员
        BEGIN
            RETURN 0
        END   
    --IF ( @LimitType = 0 ) 
    BEGIN     
        SELECT  @aLimitValue = ISNULL(MAX(ru.LimitValue), 0), @aLAType = la.LAType, @aLAName = la.LAName
        FROM    dbo.tbx_Limit_Action la
                LEFT JOIN ( SELECT  lar.LAGUID, lar.LimitValue
                            FROM    dbo.tbx_Limit_Action_Role lar
                                    INNER JOIN dbo.tbx_Limit_RU lr ON lr.LRGUID = lar.RUID
                                                                      AND lar.RUType = 1
                                                                      AND lr.UserId = @UserId
                                                                      AND ( ( lar.LimitValue & @LimitDo ) = @LimitDo )
                          ) ru ON la.LAGUID = ru.LAGUID
        WHERE   la.LAGUID = @LimitId
        GROUP BY la.LAGUID, la.LAType, la.LAName 
    END

    SET @aRet = CASE @aLimitValue & @LimitDo
                  WHEN @LimitDo THEN 0
                  ELSE -1
                END      
                   
    IF ( @aRet <> 0 )
        BEGIN
            IF ( @aLAType = 1 ) --0未配置，1基本信息，2单据，3报表，4数据，5其它 
                BEGIN
                    SET @ErrorValue = '没有功能[(' + @aLAName + ')->('	
                    SET @ErrorValue = @ErrorValue + CASE @LimitDo
                                                      WHEN @Limit_Base_View THEN '查看'
                                                      WHEN @Limit_Base_Add THEN '新增'
                                                      WHEN @Limit_Base_Class THEN '分类'
                                                      WHEN @Limit_Base_Modify THEN '修改'
                                                      WHEN @Limit_Base_Del THEN '删除'
                                                      WHEN @Limit_Base_Print THEN '打印'
                                                      ELSE '未定义'
                                                    END    
				
                    SET @ErrorValue = @ErrorValue + ')]权限'
                END	
            ELSE
                IF ( @aLAType = 2 )
                    BEGIN
                        SET @ErrorValue = '没有功能[(' + @aLAName + ')->('	
                        SET @ErrorValue = @ErrorValue + CASE @LimitDo
                                                          WHEN @Limit_Bill_View THEN '查看'
                                                          WHEN @Limit_Bill_Input THEN '输入'
                                                          WHEN @Limit_Bill_Settle THEN '过账'
                                                          WHEN @Limit_Bill_Print THEN '打印'
                                                          ELSE '未定义'
                                                        END    
				
                        SET @ErrorValue = @ErrorValue + ')]权限'
                    END	
                ELSE
                    IF ( @aLAType = 3 )
                        BEGIN
                            SET @ErrorValue = '没有功能[(' + @aLAName + ')->('	
                            SET @ErrorValue = @ErrorValue + CASE @LimitDo
                                                              WHEN @Limit_Report_View THEN '查看'
                                                              WHEN @Limit_Report_Print THEN '打印'
                                                              ELSE '未定义'
                                                            END    
				
                            SET @ErrorValue = @ErrorValue + ')]权限'
                        END	
            RETURN -1 
        END    
    --EXEC(@aSQL)        
    RETURN 0

GO 
