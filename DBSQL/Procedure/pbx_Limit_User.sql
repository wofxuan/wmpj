IF OBJECT_ID('dbo.pbx_Limit_User') IS NOT NULL 
    DROP PROCEDURE dbo.pbx_Limit_User
go

--��ѯ�û����ɫȨ��

CREATE PROCEDURE pbx_Limit_User
    (
      @RUID VARCHAR(50) , --��ɫ���û�ID
      @RUType INT ,  --0δ���壬1��ɫID��2�û�ID
      @LimitType INT ,  --0δ���ã�1������Ϣ��2���ݣ�3����4���ݣ�5����
      @ErrorValue VARCHAR(500) OUTPUT 
    )
AS 
    SET NOCOUNT ON
    DECLARE @aSQL VARCHAR(8000)

    IF ( @LimitType = 1 ) 
        BEGIN
            SELECT  la.LAGUID, la.LAName, ISNULL(LimitValue, 0) LimitValue, 
				CASE ISNULL(LimitValue & 1, 0) WHEN 1 THEN 1 ELSE 0 END LView, 
				CASE ISNULL(LimitValue & 2, 0) WHEN 2 THEN 1 ELSE 0 END LAdd, 
				CASE ISNULL(LimitValue & 4, 0) WHEN 4 THEN 1 ELSE 0 END LClass, 
				CASE ISNULL(LimitValue & 8, 0) WHEN 8 THEN 1 ELSE 0 END LModify, 
				CASE ISNULL(LimitValue & 16, 0) WHEN 16 THEN 1 ELSE 0 END LDel, 
				CASE ISNULL(LimitValue & 32, 0) WHEN 32 THEN 1 ELSE 0 END LPrint
            FROM    tbx_Limit_Action la
                    LEFT JOIN tbx_Limit_Action_Role lar ON la.LAGUID = lar.LAGUID
                                                           AND lar.RUType = @RUType
                                                           AND lar.RUID = @RUID
            WHERE   la.LAType = @LimitType
            ORDER BY la.LARowIndex
        END
	 ELSE IF ( @LimitType = 2 )
		 BEGIN
			SELECT  la.LAGUID, la.LAName, ISNULL(LimitValue, 0) LimitValue, 
				CASE ISNULL(LimitValue & 1, 0) WHEN 1 THEN 1 ELSE 0 END LView, 
				CASE ISNULL(LimitValue & 2, 0) WHEN 2 THEN 1 ELSE 0 END LInput, 
				CASE ISNULL(LimitValue & 4, 0) WHEN 4 THEN 1 ELSE 0 END LSettle, 
				CASE ISNULL(LimitValue & 8, 0) WHEN 8 THEN 1 ELSE 0 END LPrint
			FROM    tbx_Limit_Action la
					LEFT JOIN tbx_Limit_Action_Role lar ON la.LAGUID = lar.LAGUID
														   AND lar.RUType = @RUType
														   AND lar.RUID = @RUID
			WHERE   la.LAType = @LimitType
			ORDER BY la.LARowIndex
		 END      
    --EXEC(@aSQL)        
    RETURN 0

GO 
