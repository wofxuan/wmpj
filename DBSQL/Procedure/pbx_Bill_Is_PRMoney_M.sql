IF OBJECT_ID('dbo.pbx_Bill_Is_PRMoney_M') IS NOT NULL 
    DROP PROCEDURE dbo.pbx_Bill_Is_PRMoney_M
go

--  ********************************************************************************************                                                                                  
--  ||   过程名称：pbx_Bill_Is_PRMoney_M                                                
--  ||   过程功能：添加收付款单的主表信息
--  ********************************************************************************************

CREATE  PROCEDURE [pbx_Bill_Is_PRMoney_M]
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
      
      --下面面是存储过程必须的参数
      @ErrorValue VARCHAR(500) OUTPUT  
    )
AS 
    INSERT  INTO dbo.tbx_Bill_M ( InputDate, Number, VchType, Summary, Comment, BtypeId, EtypeId, DtypeId, KtypeId, KtypeId2, Period, YearPeriod, RedWord, Total, Defdiscount, GatheringDate )
    VALUES  ( @InputDate, @Number, @VchType, @Summary, @Comment, @Btypeid, @EtypeId, @DtypeId, @KtypeId, @KtypeId2, @Period, @YearPeriod, @RedWord, @Total, @Defdiscount, @GatheringDate ) 
    IF @@rowcount = 0 
        RETURN -1
    ELSE 
        RETURN @@identity


go
