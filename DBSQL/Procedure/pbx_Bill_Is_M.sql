IF OBJECT_ID('dbo.pbx_Bill_Is_M') IS NOT NULL 
    DROP PROCEDURE dbo.pbx_Bill_Is_M
go

--  ********************************************************************************************                                                                                  
--  ||   �������ƣ�pbx_Bill_Is_M                                                
--  ||   ���̹��ܣ���ӽ����������۵���ͨ�õĵ��ݵ�������Ϣ
--  ********************************************************************************************

CREATE  PROCEDURE [pbx_Bill_Is_M]
    (
      @InputDate VARCHAR(10) ,
      @Number VARCHAR(40) ,
      @VchType INT ,
      @Summary VARCHAR(256) ,
      @Comment VARCHAR(256) ,
      @Btypeid VARCHAR(50) ,
      @Etypeid VARCHAR(50) ,
      @Dtypeid VARCHAR(50) ,
      @Ktypeid VARCHAR(50) ,
      @Ktypeid2 VARCHAR(50) ,
      @Period SMALLINT ,
      @YearPeriod INT ,
      @RedWord CHAR(1) ,
      @Total NUMERIC ,
      @Defdiscount NUMERIC ,
      @GatheringDate VARCHAR(25) ,
      @Attach INT ,
      @InvoceTag INT ,
      @IsRetail INT ,
      --�������Ǵ洢���̱���Ĳ���
      @ErrorValue VARCHAR(500) OUTPUT  
    )
AS 
    INSERT  INTO dbo.tbx_Bill_M
            ( InputDate ,
              Number ,
              VchType ,
              Summary ,
              Comment ,
              BtypeId ,
              EtypeId ,
              DtypeId ,
              KtypeId ,
              KtypeId2 ,
              Period ,
              YearPeriod ,
              RedWord ,
              Total ,
              Defdiscount ,
              GatheringDate,
              Attach ,
			  InvoceTag ,
			  IsRetail 
            )
    VALUES  ( @InputDate ,
              @Number ,
              @VchType ,
              @Summary ,
              @Comment ,
              @Btypeid ,
              @EtypeId ,
              @DtypeId ,
              @KtypeId ,
              @KtypeId2 ,
              @Period ,
              @YearPeriod ,
              @RedWord ,
              @Total ,
              @Defdiscount ,
              @GatheringDate,
              @Attach ,
			  @InvoceTag ,
			  @IsRetail
            ) 
    IF @@rowcount = 0 
        RETURN -1
    ELSE 
        RETURN @@identity


go
