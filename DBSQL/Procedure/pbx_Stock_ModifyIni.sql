IF OBJECT_ID('dbo.pbx_Stock_ModifyIni') IS NOT NULL 
    DROP PROCEDURE dbo.pbx_Stock_ModifyIni
go

-- �ڳ���Ʒ����޸�

CREATE PROCEDURE pbx_Stock_ModifyIni
    (
      @PTypeId VARCHAR(25) ,
      @KTypeId VARCHAR(25) ,
      @Qty NUMERIC(22, 10) ,
      @Total NUMERIC(22, 10) ,
      @Memo VARCHAR(255) ,    --���к�˵��
      @JobNumber VARCHAR(20) ,     --���ţ���ѯ���к�ʱ�ã�
      @OrderID INT OUTPUT ,
      @ErrorValue VARCHAR(500) OUTPUT 
    )
AS 
    DECLARE @Return INT
    DECLARE @InitOver INT
    
    SELECT  @InitOver = PValue
    FROM    dbo.tbx_Sys_Param
    WHERE   PName = 'InitOver'
    
    IF ISNULL(@InitOver, 0) = 1
    BEGIN
		SET @ErrorValue='�Ѿ����ˣ������޸��ڳ����ݣ�'
		GOTO ErrorGeneral 	
    END
    
    IF NOT EXISTS ( SELECT  1
                    FROM    dbo.tbx_Base_Ptype
                    WHERE   PTypeId = @PTypeId
                            AND PSonnum = 0
                            AND Deleted = 0 ) 
        BEGIN
            SET @ErrorValue = '����Ʒ�Ѿ���ɾ�����߷��࣡'	
            GOTO ErrorGeneral
        END
    IF NOT EXISTS ( SELECT  1
                    FROM    dbo.tbx_Base_Ktype
                    WHERE   KTypeId = @KTypeId
                            AND KSonnum = 0
                            AND Deleted = 0 ) 
        BEGIN
            SET @ErrorValue = '�òֿ��Ѿ���ɾ�����߷��࣡'	
            GOTO ErrorGeneral
        END
    IF NOT EXISTS ( SELECT  1
                    FROM    dbo.tbx_Base_Ptype
                    WHERE   PTypeId = @PTypeId
                            AND Costmode = 0 ) 
        BEGIN
            SET @ErrorValue = '����Ʒ�ɱ��㷨�Ѿ������ģ�'	
            GOTO ErrorGeneral
        END

    DELETE  FROM dbo.tbx_Stock_Goods_Ini
    WHERE   PTypeId = @PTypeId
            AND KTypeId = @KTypeId
            
    IF ( @Qty = 0 ) 
        GOTO Success
        
    INSERT  dbo.tbx_Stock_Goods_Ini ( PTypeId, KTypeId, Qty, Price, Total )
    VALUES  ( @PTypeId, @KTypeId, @Qty, dbo.Fun_CovTotalDivQty(@Total, @Qty), @Total )

    SET @Return = @@ERROR
    IF @@ROWCOUNT = 0 
        GOTO OtherError
	
    SET @OrderID = @@IDENTITY
    
    GOTO Success

    Success:		 --�ɹ���ɺ���
    RETURN 0
    
    ErrorGeneral:    --��������Ǵ��󣬲���Ҫ�ع�
    RETURN -1   
    
    ErrorRollback:   --���ݲ����Ǵ�����Ҫ�ع�
    --ROLLBACK TRAN insertproc 
    RETURN -2 
    
    OtherError:
    RETURN @Return
GO
