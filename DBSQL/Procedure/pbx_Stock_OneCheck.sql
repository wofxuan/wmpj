IF OBJECT_ID('dbo.pbx_Stock_OneCheck') IS NOT NULL 
    DROP PROCEDURE dbo.pbx_Stock_OneCheck
GO
--  ********************************************************************************************
--  ||                                                                                        
--  ||   过程名称：pbx_Stock_OneCheck
--  ||   过程功能：获取或者增加一个盘点数据标记
--  ||=========================================================================================

CREATE    PROCEDURE pbx_Stock_OneCheck
    (
      @KTypeId VARCHAR(50) , --仓库ID
      @ETypeid VARCHAR(50) , --操作员ID
      @CheckDate VARCHAR(10) OUTPUT , --盘点日期
      @Updatetag INT OUT ,  --盘点号
      @ErrorValue VARCHAR(500) OUTPUT 
    )
AS 
    IF @CheckDate = '' 
        BEGIN
            SELECT  @Updatetag = MIN(UpdateTag)
            FROM    dbo.tbx_Stock_Check
            WHERE   UpdateTag < 0
                    AND KTypeId = @KTypeId
                    
            SELECT  @Updatetag = UpdateTag, @CheckDate = CheckDate
            FROM    dbo.tbx_Stock_Check
            WHERE   UpdateTag = @Updatetag 
        END
    ELSE 
        BEGIN   -- first
            SELECT  @UpdateTag = ISNULL(MIN(UpdateTag), 0)
            FROM    dbo.tbx_Stock_Check
            WHERE   UpdateTag < 0
                    AND KTypeId = @KTypeId
                    
            IF @UpdateTag <> 0 
                BEGIN
                    SELECT  @Updatetag = UpdateTag, @CheckDate = CheckDate
                    FROM    dbo.tbx_Stock_Check
                    WHERE   UpdateTag = @UpdateTag  
                    GOTO Success
                END
                
            SELECT  @Updatetag = ( ISNULL(MIN(UpdateTag), -1000000) - 1 )
            FROM    dbo.tbx_Stock_Check
            WHERE   updatetag < 0 
            --IF @CheckDate < dbo.f_getCurYearPerStart(0) 
            --    GOTO error102
                
            SELECT  @Updatetag = ( ISNULL(MIN(UpdateTag), -1000000) - 1 )
            FROM    dbo.tbx_Stock_Check
            WHERE   UpdateTag < 0 
            
            INSERT  INTO dbo.tbx_Stock_Check ( KTypeId, PTypeId, CheckDate, UpdateTag, ETypeId )
            VALUES  ( @KTypeId, '', @CheckDate, @Updatetag, @ETypeid )
            
            IF @@RowCount = 0 
                GOTO ErrorGeneral
            ELSE 
                GOTO Success

        END

    Success:
    RETURN 0

    ErrorGeneral:    --检查数据是错误，不需要回滚
    RETURN -1  


GO
