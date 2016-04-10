IF OBJECT_ID('dbo.pbx_Stock_SaveCheck') IS NOT NULL 
    DROP PROCEDURE dbo.pbx_Stock_SaveCheck
go

--  ********************************************************************************************                                                                                  
--  ||   �������ƣ�pbx_Stock_SaveCheck                                                
--  ||   ���̹��ܣ�����һ���̵��¼
--  ********************************************************************************************

CREATE PROCEDURE pbx_Stock_SaveCheck
    (
      @KTypeId VARCHAR(50) ,
      @PTypeId VARCHAR(50) ,
      @GoodsOrder INT , --��Ӧ�����е�Goodsorder�ֶ�
      @CheckedQty NUMERIC(22, 10) ,--�̵�����
      @UpdateTag INT ,--�̵��
      @CheckDate VARCHAR(10) ,--�̵�����
      @SCId INT ,
      @JobNumber VARCHAR(20) ,--����
      @OutFactoryDate VARCHAR(13) ,--��������
      @Total NUMERIC(22, 10) ,--
      @ETypeId VARCHAR(50) ,--����Ա
      --�������ǻ�����Ϣ����Ĳ���
      @errorValue VARCHAR(500) OUTPUT --���ش�����Ϣ
    )
AS 
    SET NOCOUNT ON
	
    DECLARE @CostMode INT
    DECLARE @StockQty NUMERIC(22, 10) --�����
    
    SELECT  @CostMode = Costmode
    FROM    dbo.tbx_Base_Ptype
    WHERE   PTypeId = @PTypeId
	
	SET @StockQty = 0
	
    BEGIN TRAN insertproc
    
    IF @SCId = 0 
        BEGIN
            INSERT  INTO dbo.tbx_Stock_Check ( KTypeId, PTypeId, GoodsOrder, CostMode, CheckedQty, UpdateTag, StockQty, CheckDate, JobNumber, OutFactoryDate, Total, ETypeId )
            VALUES  ( @KTypeId, @PTypeId, @GoodsOrder, @CostMode, @CheckedQty, @UpdateTag, @StockQty, @CheckDate, @JobNumber, @OutFactoryDate, @Total, @ETypeId )	
        END
    ELSE 
        BEGIN
            UPDATE  dbo.tbx_Stock_Check
            SET     KTypeId = @KTypeId, PTypeId = @PTypeId, GoodsOrder = @GoodsOrder,
					CostMode = @CostMode, CheckedQty = @CheckedQty, UpdateTag = @UpdateTag,
					StockQty = @StockQty, CheckDate = @CheckDate, JobNumber = @JobNumber,
					OutFactoryDate = @OutFactoryDate, Total = @Total, ETypeId = @ETypeId
            WHERE   SCId = @SCId 
        END 
        
    COMMIT TRAN insertproc
    GOTO success

    Success:		 --�ɹ���ɺ���
    RETURN 0
    ErrorGeneral:    --��������Ǵ��󣬲���Ҫ�ع�
    RETURN -1   
    ErrorRollback:   --���ݲ����Ǵ�����Ҫ�ع�
    ROLLBACK TRAN insertproc 
    RETURN -2 
go
