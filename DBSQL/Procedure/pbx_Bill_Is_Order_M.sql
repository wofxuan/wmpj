IF OBJECT_ID('dbo.pbx_Bill_Is_Order_M') IS NOT NULL 
    DROP PROCEDURE dbo.pbx_Bill_Is_Order_M
go

--  ********************************************************************************************                                                                                  
--  ||   �������ƣ�pbx_Bill_Is_Order_M                                                
--  ||   ���̹��ܣ���Ӷ�����������Ϣ
--  ********************************************************************************************

CREATE  PROCEDURE [pbx_Bill_Is_Order_M]
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
      
      --�������Ǵ洢���̱���Ĳ���
      @ErrorValue VARCHAR(500) OUTPUT  
    )
AS 
    INSERT  INTO dbo.tbx_Bill_Order_M ( InputDate, Number, VchType, Summary, Comment, BtypeId, EtypeId, DtypeId, KtypeId, KtypeId2, Period, YearPeriod, RedWord, Total, Defdiscount, GatheringDate )
    VALUES  ( @InputDate, @Number, @VchType, @Summary, @Comment, @Btypeid, @EtypeId, @DtypeId, @KtypeId, @KtypeId2, @Period, @YearPeriod, @RedWord, @Total, @Defdiscount, @GatheringDate ) 
    IF @@rowcount = 0 
        RETURN -1
    ELSE 
        RETURN @@identity


go
