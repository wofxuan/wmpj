IF OBJECT_ID('dbo.pbx_Base_UpdateP') IS NOT NULL 
    DROP PROCEDURE dbo.pbx_Base_UpdateP
go

--  ********************************************************************************************                                                                               
--  ||   过程名称：pbx_Base_UpdateP                                                 
--  ||   过程功能：修改基本信息--商品                                              
--  ********************************************************************************************
CREATE PROCEDURE pbx_Base_UpdateP
    (
      @TypeId VARCHAR(50) ,
      @Parid VARCHAR(50) ,
      @FullName VARCHAR(66) ,
      @UserCode VARCHAR(50) ,
      @Namepy VARCHAR(60) ,
      @Comment VARCHAR(250) ,
      --上面是基本信息必须的参数
      @Name VARCHAR(30) ,
      @Model VARCHAR(60) ,
      @Standard VARCHAR(120) ,
      @Area VARCHAR(30) ,
      @CostMode INT ,
      @UsefulLifeday INT ,
      @IsStop INT ,
      --下面面是基本信息必须的参数
      @ErrorValue VARCHAR(500) OUTPUT  
    )
AS 
    DECLARE @OldCostMode INT
    DECLARE @OldProperty INT
    DECLARE @lSonNum INT
    DECLARE @OldIsSerial INT    
    DECLARE @dbname VARCHAR(30)
    DECLARE @checkValue INT
    DECLARE @UpdateTag INT --基本信息更新标识
    SET nocount ON
	
    SELECT  @dbname = 'tbx_Base_Ptype'

    IF EXISTS ( SELECT  [Pusercode]
                FROM    tbx_Base_Ptype
                WHERE   PtypeId <> '00000'
                        AND [PtypeId] <> @typeid
                        AND [Pusercode] = @usercode
                        AND [deleted] <> 1 ) 
        BEGIN
            SET @ErrorValue = '该记录的编号或全名与其它记录相同,不能更新！'
            GOTO ErrorGeneral
        END


	--如果叶子已经过帐，则不能修改成本算法
	--如果已经过帐，则不能修改成本算法
    --由非加权平均法改为加权平均法，则合并批次
	--由加权平均法改非为加权平均法，则判断是否有负库存
	
    SET @UpdateTag = 0
    --基本信息更新标识  
    --EXEC dbo.P_hh_XW_BaseUpdateTag @BaseType = @dbname, @UpdateTag = @UpdateTag OUTPUT
      
    UPDATE  dbo.tbx_Base_Ptype
    SET     [Parid] = @Parid, [PUsercode] = @UserCode, [PFullname] = @FullName, [PComment] = @Comment, [Name] = @Name, [pnamepy] = @Namepy, [Standard] = @Standard, [Model] = @Model, [Area] = @Area, [UsefulLifeday] = @UsefulLifeday, [Costmode] = @CostMode, [IsStop] = @IsStop, [Updatetag] = @UpdateTag
    WHERE   PTypeId = @typeId

    IF @@ROWCOUNT = 0 
        BEGIN
            SET @errorValue = '更新记录操作失败，请稍后重试！'
            GOTO ErrorGeneral
        END
        
    GOTO success
	

    Success:		 --成功完成函数
    RETURN 0
    
    ErrorGeneral:    --检查数据是错误，不需要回滚
    RETURN -1   
    
    ErrorRollback:   --数据操作是错误，需要回滚
    --ROLLBACK TRAN insertproc 
    RETURN -2 
go
