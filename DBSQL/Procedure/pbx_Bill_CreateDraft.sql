IF OBJECT_ID('dbo.pbx_Bill_CreateDraft') IS NOT NULL 
    DROP PROCEDURE dbo.pbx_Bill_CreateDraft
go

CREATE PROCEDURE dbo.pbx_Bill_CreateDraft
    (
      @ModiDly INT , --是否是修改单据 0 否，1 是
      @ADraft INT , --1 存草稿，3 过账
      @OldVchCode INT ,
      @NewVchCode INT OUT ,
       --下面面是存储过程必须的参数
      @ErrorValue VARCHAR(500) OUTPUT  
    )
AS 
    DECLARE @net INT ,
        @smode CHAR ,
        @szSql NVARCHAR(4000) ,
        @Stab VARCHAR(50) ,
        @Stabndx VARCHAR(50) ,
        @inputNo VARCHAR(50)
    DECLARE @vchtype INT

    DECLARE @SYS_SALEAR_LIMIT INT
    DECLARE @dLimit NUMERIC(22, 10) ,
        @dAr NUMERIC(22, 10) ,
        @dArdly NUMERIC(22, 10) ,
        @dTemp NUMERIC(22, 10)

    DECLARE @ModiVchcode VARCHAR(50)
    DECLARE @szDtypeid VARCHAR(50) ,
        @szKTypeID2 VARCHAR(50) ,
        @szgatherbtypeid VARCHAR(50) ,
        @feebtypeid VARCHAR(50) ,
        @szzctypeid VARCHAR(50)

    BEGIN TRAN updata
    COMMIT TRAN updata

    SET @net = 0


    RETURN @net

    ErrorGeneral:    --检查数据是错误，不需要回滚
    --DELETE  FROM tbx_Bill_Order_D
    --WHERE   Vchcode = @NewVchCode
    --DELETE  FROM tbx_Bill_Order_M
    --WHERE   Vchcode = @NewVchCode	 
    RETURN -1   
    
    ErrorRollback:   --数据操作是错误，需要回滚
    ROLLBACK TRAN Account 
    --DELETE  FROM tbx_Bill_Order_D
    --WHERE   Vchcode = @NewVchCode
    --DELETE  FROM tbx_Bill_Order_M
    --WHERE   Vchcode = @NewVchCode
    RETURN -2 

go
GO
GO