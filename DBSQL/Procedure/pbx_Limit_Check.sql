IF OBJECT_ID('dbo.pbx_Limit_Check') IS NOT NULL
    DROP PROCEDURE dbo.pbx_Limit_Check
GO

--�ж�ĳ���û��Ƿ����ĳ��Ȩ�޵�ĳ�ֲ���

CREATE PROCEDURE pbx_Limit_Check
    (
      @LimitId VARCHAR(50) ,  -- Ȩ��ID
      @LimitDo INT ,  --������Ϣ����ز��������ݵ���ز������ȵ�
      @UserId VARCHAR(50) ,--tbx_Limit_RU����û�ID
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
    
    DECLARE @Limit_Base_View INT = 1--������ϢȨ��-�鿴
    DECLARE @Limit_Base_Add INT = 2--������ϢȨ��-����
    DECLARE @Limit_Base_Class INT = 4--������ϢȨ��-����
    DECLARE @Limit_Base_Modify INT = 8--������ϢȨ��-�޸�
    DECLARE @Limit_Base_Del INT = 16--������ϢȨ��-ɾ��
    DECLARE @Limit_Base_Print INT = 32--������ϢȨ��-��ӡ
  
    DECLARE @Limit_Bill_View INT = 1--����Ȩ��-�鿴
    DECLARE @Limit_Bill_Input INT = 2--����Ȩ��-����
    DECLARE @Limit_Bill_Settle INT = 4--����Ȩ��-����
    DECLARE @Limit_Bill_Print INT = 8--����Ȩ��-��ӡ
    
    DECLARE @Limit_Report_View INT = 1--����Ȩ��-�鿴
    DECLARE @Limit_Report_Print INT = 2--����Ȩ��-��ӡ
    
    SET @aRUType = 2 --ͨ���û���ѯ
    SET @aLimitValue = 0
    
    IF @LimitDo = 0
        RETURN -1
     
    IF ( @UserId = '00000' )--��������Ա
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
            IF ( @aLAType = 1 ) --0δ���ã�1������Ϣ��2���ݣ�3����4���ݣ�5���� 
                BEGIN
                    SET @ErrorValue = 'û�й���[(' + @aLAName + ')->('	
                    SET @ErrorValue = @ErrorValue + CASE @LimitDo
                                                      WHEN @Limit_Base_View THEN '�鿴'
                                                      WHEN @Limit_Base_Add THEN '����'
                                                      WHEN @Limit_Base_Class THEN '����'
                                                      WHEN @Limit_Base_Modify THEN '�޸�'
                                                      WHEN @Limit_Base_Del THEN 'ɾ��'
                                                      WHEN @Limit_Base_Print THEN '��ӡ'
                                                      ELSE 'δ����'
                                                    END    
				
                    SET @ErrorValue = @ErrorValue + ')]Ȩ��'
                END	
            ELSE
                IF ( @aLAType = 2 )
                    BEGIN
                        SET @ErrorValue = 'û�й���[(' + @aLAName + ')->('	
                        SET @ErrorValue = @ErrorValue + CASE @LimitDo
                                                          WHEN @Limit_Bill_View THEN '�鿴'
                                                          WHEN @Limit_Bill_Input THEN '����'
                                                          WHEN @Limit_Bill_Settle THEN '����'
                                                          WHEN @Limit_Bill_Print THEN '��ӡ'
                                                          ELSE 'δ����'
                                                        END    
				
                        SET @ErrorValue = @ErrorValue + ')]Ȩ��'
                    END	
                ELSE
                    IF ( @aLAType = 3 )
                        BEGIN
                            SET @ErrorValue = 'û�й���[(' + @aLAName + ')->('	
                            SET @ErrorValue = @ErrorValue + CASE @LimitDo
                                                              WHEN @Limit_Report_View THEN '�鿴'
                                                              WHEN @Limit_Report_Print THEN '��ӡ'
                                                              ELSE 'δ����'
                                                            END    
				
                            SET @ErrorValue = @ErrorValue + ')]Ȩ��'
                        END	
            RETURN -1 
        END    
    --EXEC(@aSQL)        
    RETURN 0

GO 
