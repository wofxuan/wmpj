IF OBJECT_ID('dbo.pbx_Base_GetOneInfo') IS NOT NULL 
    DROP PROCEDURE dbo.pbx_Base_GetOneInfo
go
--  ********************************************************************************************
--  ||                                                                                        
--  ||   �������ƣ�p_hh_getonebaseinfo                                                
--  ||   ���̹��ܣ�ȡ�û�����Ϣ������¼
--  ||=========================================================================================
--  ||   ����˵����  ��������         ����            ����                              �������
--  ||            -----------------------------------------------------------------------------
--  ||            @cmode 	char(5)		:������Ϣ���Ͳ���			in
--  ||            @sztypeid 	varchar(25)	:�ڵ�typeid			in
--  ||=========================================================================================   
--  ||   ������ʷ��  ����         ����         ����          ����
--  ||            -----------------------------------------------------------------------------
--  ||              alter         mx         2015.03.26   first alter                                     
--  ********************************************************************************************

CREATE     PROCEDURE pbx_Base_GetOneInfo
    (
      @cmode VARCHAR(5) ,
      @sztypeid VARCHAR(50) ,
      @errorValue VARCHAR(50) OUTPUT --���ش�����Ϣ
    )
AS 
    DECLARE @rowcount_var INT
--���ذ�
    IF @cmode = 'I' 
        BEGIN
            SELECT  a.*
            FROM    tbx_Base_PackageInfo a
            WHERE   a.ITypeId = @sztypeid 
            SELECT  @rowcount_var = @@rowcount
        END
        
    IF @cmode = 'P' 
        BEGIN
            SELECT  a.*
            FROM    dbo.tbx_Base_Ptype a
            WHERE   a.PTypeId = @sztypeid 
            SELECT  @rowcount_var = @@rowcount
        END
        
    IF @cmode = 'B' 
        BEGIN
            SELECT  a.*
            FROM    dbo.tbx_Base_Btype a
            WHERE   a.BTypeId = @sztypeid 
            SELECT  @rowcount_var = @@rowcount
        END
    IF @cmode = 'E' 
        BEGIN
            SELECT  a.*
            FROM    dbo.tbx_Base_Etype a
            WHERE   a.ETypeId = @sztypeid 
            SELECT  @rowcount_var = @@rowcount
        END 
    IF @cmode = 'D' 
        BEGIN
            SELECT  a.*
            FROM    dbo.tbx_Base_Dtype a
            WHERE   a.DTypeId = @sztypeid 
            SELECT  @rowcount_var = @@rowcount
        END   
    IF @cmode = 'K' 
        BEGIN
            SELECT  a.*
            FROM    dbo.tbx_Base_Ktype a
            WHERE   a.KTypeId = @sztypeid 
            SELECT  @rowcount_var = @@rowcount
        END   
        
    IF @rowcount_var = 1 
        RETURN 0
    ELSE 
        BEGIN
            SET @errorValue = '�ü�¼�ѱ�ɾ�������ݲ����������飡'
            RETURN -1           
        END	
go
