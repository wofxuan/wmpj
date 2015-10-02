IF OBJECT_ID('dbo.pbx_Base_GetOneInfo') IS NOT NULL 
    DROP PROCEDURE dbo.pbx_Base_GetOneInfo
go
--  ********************************************************************************************
--  ||                                                                                        
--  ||   过程名称：p_hh_getonebaseinfo                                                
--  ||   过程功能：取得基本信息单条记录
--  ||=========================================================================================
--  ||   参数说明：  参数名称         类型            意义                              输入输出
--  ||            -----------------------------------------------------------------------------
--  ||            @cmode 	char(5)		:基本信息类型参数			in
--  ||            @sztypeid 	varchar(25)	:节点typeid			in
--  ||=========================================================================================   
--  ||   过程历史：  操作         作者         日期          描述
--  ||            -----------------------------------------------------------------------------
--  ||              alter         mx         2015.03.26   first alter                                     
--  ********************************************************************************************

CREATE     PROCEDURE pbx_Base_GetOneInfo
    (
      @cmode VARCHAR(5) ,
      @sztypeid VARCHAR(50) ,
      @errorValue VARCHAR(50) OUTPUT --返回错误信息
    )
AS 
    DECLARE @rowcount_var INT
--加载包
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
            SET @errorValue = '该记录已被删除或数据不完整，请检查！'
            RETURN -1           
        END	
go
