IF OBJECT_ID('dbo.pbx_Base_SavePTypeUnit') IS NOT NULL 
    DROP PROCEDURE dbo.pbx_Base_SavePTypeUnit
go

--  ********************************************************************************************                                                                                  
--  ||   过程名称：pbx_Base_SavePTypeUnit                                                
--  ||   过程功能：保存商品的多单位信息
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
    --            SET @errorValue = '商品已经存在并且停用!'
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

    Success:		 --成功完成函数
    RETURN 0
    ErrorGeneral:    --检查数据是错误，不需要回滚
    RETURN -1   
    ErrorRollback:   --数据操作是错误，需要回滚
    --ROLLBACK TRAN insertproc 
    RETURN -2 
go
