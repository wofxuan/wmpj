IF OBJECT_ID('dbo.pbx_Sys_InitOver') IS NOT NULL 
    DROP PROCEDURE dbo.pbx_Sys_InitOver
go

-- ���ʡ�������

CREATE PROCEDURE pbx_Sys_InitOver
    (
      @DoType INT ,--0:������,1:����
      @ErrorValue VARCHAR(500) OUTPUT 
    )
AS 
    DECLARE @Return INT
    DECLARE @IsInitOver INT
    
    IF @DoType = 1 
        BEGIN
            SELECT  @IsInitOver = PValue
            FROM    dbo.tbx_Sys_Param
            WHERE   PName = 'InitOver'
            IF @IsInitOver = 1 
                BEGIN
                    SET @ErrorValue = 'ϵͳ�Ѿ����ˣ����������ˣ������ٿ���'
                    GOTO ErrorGeneral
                END
                
            DELETE  dbo.tbx_Stock_Goods_Ini
            WHERE   Qty = 0 AND Total = 0
            IF @@ERROR <> 0 
                BEGIN
                    SET @ErrorValue = 'ɾ���ڳ����ʧ��'
                    GOTO ErrorGeneral
                END
                
            BEGIN TRAN InitOver
            --���ÿ��ʱ�־
            UPDATE  dbo.tbx_Sys_Param SET PValue = '1' WHERE PName = 'InitOver'
            IF @@ERROR <> 0 goto ErrorRollback		
            
            --���ڳ���渴�Ƶ�����
            TRUNCATE TABLE dbo.tbx_Stock_Goods
            SET IDENTITY_INSERT tbx_Stock_Goods ON
            INSERT  INTO dbo.tbx_Stock_Goods ( GoodsOrderId, PTypeId, KTypeId, JobNumber, OutFactoryDate, Qty, Price, Total, GoodsOrder )
                    SELECT  GoodsOrderId, PTypeId, KTypeId, JobNumber, OutFactoryDate, Qty, Price, Total, GoodsOrder
                    FROM    dbo.tbx_Stock_Goods_Ini 
            SET IDENTITY_INSERT tbx_Stock_Goods OFF
            
            --  �޸�aType�����ƷӦ��Ӧ��
            --	���㴢ֵ���
            --	д���ڳ��ʱ�
            COMMIT TRAN InitOver
        END
    ELSE 
        BEGIN
			BEGIN TRAN InitOver
            --���ÿ��ʱ�־
            UPDATE  dbo.tbx_Sys_Param SET PValue = '0' WHERE PName = 'InitOver'
            
			TRUNCATE TABLE dbo.tbx_Stock_Goods
			
            COMMIT TRAN InitOver
        END
    
    GOTO Success

    Success:		 --�ɹ���ɺ���
    RETURN 0
    
    ErrorGeneral:    --��������Ǵ��󣬲���Ҫ�ع�
    RETURN -1   
    
    ErrorRollback:   --���ݲ����Ǵ�����Ҫ�ع�
    ROLLBACK TRAN InitOver 
    RETURN -2 
GO
