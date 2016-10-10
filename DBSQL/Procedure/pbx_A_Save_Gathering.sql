IF OBJECT_ID('dbo.pbx_A_Save_Gathering') IS NOT NULL 
    DROP PROCEDURE dbo.pbx_A_Save_Gathering
GO
--  ********************************************************************************************
--  ||                                                                                        
--  ||   �������ƣ�pbx_A_Save_Gathering
--  ||   ���̹��ܣ�һ��������տ�Ľ����Ӧ�ĵ���
--  ||=========================================================================================

CREATE    PROCEDURE pbx_A_Save_Gathering
    (
      @BTypeID VARCHAR(50) ,
      @VchCode INT ,
      @VchType INT ,
      @GatheringVchCode INT ,
      @Total NUMERIC(22, 10) ,
      @DoTypt INT , --�������ͣ�1���룬2�޸ģ�3����@GatheringVchCodeɾ��
      @ErrorValue VARCHAR(500) OUTPUT 
    )
AS 
    IF ( @DoTypt = 1 ) 
        BEGIN
            INSERT  INTO dbo.tbx_Bill_A_Gathering ( BtypeId, VchCode, VchType, GatheringVchCode, Total )
            VALUES  ( @BTypeID, @VchCode, @VchType, @GatheringVchCode, @Total )
        END
        
    IF ( @DoTypt = 2 ) 
        BEGIN
            UPDATE  dbo.tbx_Bill_A_Gathering
            SET     Total = @Total
            WHERE   VchCode = @VchCode
                    AND GatheringVchCode = @GatheringVchCode
        END
        
    IF ( @DoTypt = 3 ) 
        BEGIN
            DELETE  dbo.tbx_Bill_A_Gathering
            WHERE   GatheringVchCode = @GatheringVchCode
        END
        
    Success:
    RETURN 0

    ErrorGeneral:    --��������Ǵ��󣬲���Ҫ�ع�
    RETURN -1  


GO
