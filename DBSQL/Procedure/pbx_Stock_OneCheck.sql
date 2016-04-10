IF OBJECT_ID('dbo.pbx_Stock_OneCheck') IS NOT NULL 
    DROP PROCEDURE dbo.pbx_Stock_OneCheck
GO
--  ********************************************************************************************
--  ||                                                                                        
--  ||   �������ƣ�pbx_Stock_OneCheck
--  ||   ���̹��ܣ���ȡ��������һ���̵����ݱ��
--  ||=========================================================================================

CREATE    PROCEDURE pbx_Stock_OneCheck
    (
      @KTypeId VARCHAR(50) , --�ֿ�ID
      @ETypeid VARCHAR(50) , --����ԱID
      @CheckDate VARCHAR(10) OUTPUT , --�̵�����
      @Updatetag INT OUT ,  --�̵��
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

    ErrorGeneral:    --��������Ǵ��󣬲���Ҫ�ع�
    RETURN -1  


GO
