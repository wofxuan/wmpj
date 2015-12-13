IF OBJECT_ID('dbo.pbx_Base_CreateID') IS NOT NULL 
    DROP PROCEDURE dbo.pbx_Base_CreateID
go

--  ********************************************************************************************
--  ||                                                                                        
--  ||   pbx_BasicCreateID                                                 
--  ||   ���̹��ܣ���ӻ�����Ϣ--����id��
--  ||=========================================================================================
--  ||   ����˵����  ��������         ����            ����                     �������
--  ||            -----------------------------------------------------------------------------
--  ||  	@parid		varchar(25),			--��id
--  ||  	@dbname 	varchar(30),			--����
--  ||  	@createdid	varchar(25) output,		--typeid
--  ||  	@nson		int output,			--sonnum
--  ||  	@ncount 	int output,			--soncount
--  ||  	@nparrec	int output			--parrec
--  ||=========================================================================================                                         
--  ********************************************************************************************

CREATE         PROCEDURE pbx_Base_CreateID
    (
      @parid VARCHAR(50) ,			--��id
      @dbname VARCHAR(30) ,			--����
      @createdid VARCHAR(50) OUTPUT ,		--typeid
      @nson INT OUTPUT ,			--sonnum
      @ncount INT OUTPUT ,			--soncount
      @nparrec INT OUTPUT ,			--parrec
      @errorValue VARCHAR(50) OUTPUT--���ش�����Ϣ
    )
AS 
    DECLARE @execsql VARCHAR(500)
    DECLARE @sztypeid VARCHAR(50)
    DECLARE @root_id VARCHAR(25)
    DECLARE @bank_id VARCHAR(25)
    DECLARE @fixed_id VARCHAR(25)
    DECLARE @expense_id VARCHAR(25)
    DECLARE @goods_income_id VARCHAR(25)
    DECLARE @par VARCHAR(25)
    DECLARE @sonnum INT
    DECLARE @soncount INT
    DECLARE @temprec INT
    DECLARE @iniover VARCHAR(10)
    DECLARE @tempsql VARCHAR(400) 
    DECLARE @flag INT
    SELECT  @root_id = '00000'

--��� @parid�ǲ��Ǹ���

    SET @flag = 0
    
    IF @dbname = 'tbx_Base_Ptype' SELECT  @flag = CASE WHEN PSonnum > 0 THEN 1 ELSE 0 END FROM tbx_Base_Ptype WHERE   Ptypeid = @parid
    IF @dbname = 'tbx_Base_Btype' SELECT  @flag = CASE WHEN BSonnum > 0 THEN 1 ELSE 0 END FROM tbx_Base_Btype WHERE   Btypeid = @parid
    IF @dbname = 'tbx_Base_Etype' SELECT  @flag = CASE WHEN ESonnum > 0 THEN 1 ELSE 0 END FROM tbx_Base_Etype WHERE   Etypeid = @parid
    IF @dbname = 'tbx_Base_Dtype' SELECT  @flag = CASE WHEN DSonnum > 0 THEN 1 ELSE 0 END FROM tbx_Base_Dtype WHERE   Dtypeid = @parid
    IF @dbname = 'tbx_Base_Ktype' SELECT  @flag = CASE WHEN KSonnum > 0 THEN 1 ELSE 0 END FROM tbx_Base_Ktype WHERE   Ktypeid = @parid
    
    IF @flag = 1 GOTO nocheckpard

--exec getsysvalue 'iniover', @iniover output �Ƿ���

    IF @dbname = 'tbx_Base_Ptype' 
    BEGIN
		PRINT '���ݼ��'
--�ж���Ʒ�Ƿ������ȡID������
--if exists(select 1 from itemSaleDetail where [ptypeid]=@parid)  goto error102
    END

    nocheckpard:
--	����id��
    SET nocount ON
    IF @dbname = 'tbx_Base_Ptype' DECLARE checkid_cursor CURSOR FOR SELECT  ptypeid ,psonnum ,parid ,soncount ,prec FROM tbx_Base_Ptype WHERE Ptypeid = @parid 
    IF @dbname = 'tbx_Base_Btype' DECLARE checkid_cursor CURSOR FOR SELECT  btypeid ,bsonnum ,parid ,soncount ,brec FROM tbx_Base_Btype WHERE Btypeid = @parid 
    IF @dbname = 'tbx_Base_Etype' DECLARE checkid_cursor CURSOR FOR SELECT  etypeid ,esonnum ,parid ,soncount ,erec FROM tbx_Base_Etype WHERE Etypeid = @parid 
    IF @dbname = 'tbx_Base_Dtype' DECLARE checkid_cursor CURSOR FOR SELECT  dtypeid ,dsonnum ,parid ,soncount ,drec FROM tbx_Base_Dtype WHERE Dtypeid = @parid 
    IF @dbname = 'tbx_Base_Ktype' DECLARE checkid_cursor CURSOR FOR SELECT  ktypeid ,ksonnum ,parid ,soncount ,krec FROM tbx_Base_Ktype WHERE Ktypeid = @parid 
	OPEN checkid_cursor
    FETCH NEXT FROM checkid_cursor INTO @sztypeid, @sonnum, @par, @soncount, @temprec

    SELECT  @nson = @sonnum
    SELECT  @ncount = @soncount
    SELECT  @nparrec = @temprec
	
    IF ( @@fetch_status = -2 )
        OR ( @@fetch_status = -1 ) 
        BEGIN
            CLOSE checkid_cursor
            DEALLOCATE checkid_cursor
            SET @errorValue = '����ID�Ų����ڣ�'
            GOTO ErrorGeneral
        END
    ELSE 
        BEGIN 
            DECLARE @tempid VARCHAR(5) , @nreturn INT
            SELECT  @soncount = @soncount + 1
            EXEC @nreturn= Fun_TypeIDIntToStr @soncount, @tempid OUT
            IF @nreturn = -1 
                BEGIN
                    CLOSE checkid_cursor
                    DEALLOCATE checkid_cursor
					SET @errorValue = '��ȡ��IDʧ�ܣ����Ժ����ԣ�'
					GOTO ErrorGeneral

                END 
            ELSE 
                BEGIN
                    IF @sztypeid = '00000' 
                        SELECT  @createdid = @tempid
                    ELSE 
                        BEGIN
                            SELECT  @createdid = RTRIM(@sztypeid) + @tempid
                        END
                END
        END

    CLOSE checkid_cursor
    DEALLOCATE checkid_cursor
    GOTO Success
    
    Success:		 --�ɹ���ɺ���
    RETURN 0
    ErrorGeneral:    --��������Ǵ��󣬲���Ҫ�ع�
    RETURN -1   
    ErrorRollback:   --���ݲ����Ǵ�����Ҫ�ع�
    --ROLLBACK TRAN insertproc 
    RETURN -2 
go
