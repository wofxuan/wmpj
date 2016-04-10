IF OBJECT_ID('dbo.pbx_Base_SavePTypeUnit') IS NOT NULL 
    DROP PROCEDURE dbo.pbx_Base_SavePTypeUnit
go

--  ********************************************************************************************                                                                                  
--  ||   �������ƣ�pbx_Base_SavePTypeUnit                                                
--  ||   ���̹��ܣ�������Ʒ�Ķ൥λ��Ϣ
--  ********************************************************************************************

CREATE      PROCEDURE pbx_Base_SavePTypeUnit
    (
      @PTypeId VARCHAR(50) ,
      @UnitName VARCHAR(10) ,
      @URate NUMERIC(22, 10) ,
      @IsBase INT ,
      @BarCode VARCHAR(60) ,
      @Comment VARCHAR(200) ,
      @OrdId VARCHAR(21) ,
      @ErrorValue VARCHAR(500) OUTPUT 
    )
AS 
    SET nocount ON
        
    --IF @IsStop = 1 
    --    IF EXISTS ( SELECT  1
    --                FROM    tbx_Base_Btype
    --                WHERE   [btypeId] = @typeid_1
    --                        AND bsonnum > 0 ) 
    --        BEGIN
    --            SET @errorValue = '��Ʒ�Ѿ����ڲ���ͣ��!'
    --            GOTO ErrorGeneral
    --        END
   
    IF EXISTS ( SELECT  1
                FROM    tbx_Base_PtypeUnit
                WHERE   PTypeId = @PTypeId
                        AND OrdId = @OrdId ) 
        BEGIN
            UPDATE  dbo.tbx_Base_PtypeUnit
            SET     UnitName = @UnitName, URate = @URate, IsBase = @IsBase, BarCode = @BarCode, Comment = @Comment
            WHERE   PTypeId = @PTypeId
                    AND OrdId = @OrdId
        END
    ELSE 
        BEGIN
            INSERT  dbo.tbx_Base_PtypeUnit ( PTypeId, UnitName, URate, IsBase, BarCode, Comment, OrdId )
            VALUES  ( @PTypeId, @UnitName, @URate, @IsBase, @BarCode, @Comment, @OrdId )	
        END


    GOTO Success

    Success:		 --�ɹ���ɺ���
    RETURN 0
    ErrorGeneral:    --��������Ǵ��󣬲���Ҫ�ع�
    RETURN -1   
    ErrorRollback:   --���ݲ����Ǵ�����Ҫ�ع�
    --ROLLBACK TRAN insertproc 
    RETURN -2 
go
