IF OBJECT_ID('dbo.pbx_Bill_CreateDraft') IS NOT NULL 
    DROP PROCEDURE dbo.pbx_Bill_CreateDraft
go

CREATE PROCEDURE dbo.pbx_Bill_CreateDraft
    (
      @ModiDly INT , --�Ƿ����޸ĵ��� 0 ��1 ��
      @ADraft INT , --1 ��ݸ壬3 ����
      @OldVchCode INT ,
      @NewVchCode INT OUT ,
       --�������Ǵ洢���̱���Ĳ���
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

    ErrorGeneral:    --��������Ǵ��󣬲���Ҫ�ع�
    --DELETE  FROM tbx_Bill_Order_D
    --WHERE   Vchcode = @NewVchCode
    --DELETE  FROM tbx_Bill_Order_M
    --WHERE   Vchcode = @NewVchCode	 
    RETURN -1   
    
    ErrorRollback:   --���ݲ����Ǵ�����Ҫ�ع�
    ROLLBACK TRAN Account 
    --DELETE  FROM tbx_Bill_Order_D
    --WHERE   Vchcode = @NewVchCode
    --DELETE  FROM tbx_Bill_Order_M
    --WHERE   Vchcode = @NewVchCode
    RETURN -2 

go
GO
GO