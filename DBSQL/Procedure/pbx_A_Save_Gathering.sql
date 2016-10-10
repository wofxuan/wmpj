IF OBJECT_ID('dbo.pbx_A_Save_Gathering') IS NOT NULL 
    DROP PROCEDURE dbo.pbx_A_Save_Gathering
GO
--  ********************************************************************************************
--  ||                                                                                        
--  ||   过程名称：pbx_A_Save_Gathering
--  ||   过程功能：一条付款单或收款单的结算对应的单据
--  ||=========================================================================================

CREATE    PROCEDURE pbx_A_Save_Gathering
    (
      @BTypeID VARCHAR(50) ,
      @VchCode INT ,
      @VchType INT ,
      @GatheringVchCode INT ,
      @Total NUMERIC(22, 10) ,
      @DoTypt INT , --操作类型，1插入，2修改，3根据@GatheringVchCode删除
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

    ErrorGeneral:    --检查数据是错误，不需要回滚
    RETURN -1  


GO
