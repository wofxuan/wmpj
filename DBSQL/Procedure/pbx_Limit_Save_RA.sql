IF OBJECT_ID('dbo.pbx_Limit_Save_RA') IS NOT NULL 
    DROP PROCEDURE dbo.pbx_Limit_Save_RA
GO
--  ********************************************************************************************
--  ||                                                                                        
--  ||   �������ƣ�pbx_Limit_Save_RA
--  ||   ���̹��ܣ����ӻ����޸�һ����ɫ��һ��Ȩ�޼�¼
--  ||=========================================================================================

CREATE    PROCEDURE pbx_Limit_Save_RA
    (
      @LAGUID VARCHAR(50) , --Ȩ�޹���ID
      @RUID VARCHAR(50) , --��ɫ���û�ID
      @RUType INT, --0δ���壬1��ɫID��2�û�ID
      @LimitValue INT ,  --Ȩ��ֵ
      
      @ErrorValue VARCHAR(500) OUTPUT 
    )
AS 
	IF EXISTS(SELECT * FROM dbo.tbx_Limit_Action_Role WHERE LAGUID = @LAGUID AND RUID = @RUID AND RUType = @RUType)
	BEGIN
		IF (@LimitValue <> 0) 
		BEGIN
			UPDATE dbo.tbx_Limit_Action_Role
			SET LimitValue = @LimitValue
			WHERE LAGUID = @LAGUID AND RUID = @RUID AND RUType = @RUType 
		END	
		ELSE
		BEGIN
			DELETE dbo.tbx_Limit_Action_Role WHERE LAGUID = @LAGUID AND RUID = @RUID AND RUType = @RUType  
		END
	END
	ELSE 
	BEGIN
		INSERT INTO dbo.tbx_Limit_Action_Role ( LAGUID, RUID, RUType, LimitValue )
		VALUES  ( @LAGUID, @RUID, @RUType, @LimitValue)	
	END
	

    Success:
    RETURN 0

    ErrorGeneral:    --��������Ǵ��󣬲���Ҫ�ع�
    RETURN -1  


GO
