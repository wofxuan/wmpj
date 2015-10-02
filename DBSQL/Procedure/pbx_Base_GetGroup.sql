IF OBJECT_ID('dbo.pbx_Base_GetGroup') IS NOT NULL 
    DROP PROCEDURE dbo.pbx_Base_GetGroup
go

SET QUOTED_IDENTIFIER OFF 
GO

SET ANSI_NULLS ON 
GO

--  ********************************************************************************************
--  ||                                                                                        
--  ||   过程名称：p_hh_GetBaseGroup                                                 
--  ||   过程功能：得到基本信息的类别树
--  ||=========================================================================================
--  ||   参数说明：  参数名称         类型            意义                     输入输出
--  ||            -----------------------------------------------------------------------------
--  ||            @cMode 	char(5)		:基本信息类型参数			IN
--  ||            @szTypeid 	varchar(50)	:根节点Typeid			IN
--  ||=========================================================================================                                                                    
--  ********************************************************************************************

CREATE PROCEDURE pbx_Base_GetGroup
    (
      @cMode VARCHAR(5) ,
      @szTypeid VARCHAR(50) ,
      @OperatorID VARCHAR(25)
    )
AS 
    DECLARE @sql VARCHAR(8000)
    DECLARE @TableStr VARCHAR(200) , @TableWhereStr VARCHAR(200)
    DECLARE @DTableStr VARCHAR(200) , @DTableWhereStr VARCHAR(200)

    IF @cMode = 'I'  --加载包
        BEGIN
            SELECT  *
            FROM    tbx_Base_PackageInfo
            WHERE   Parid = @szTypeid
            ORDER BY RowIndex , ITypeId
        END 
	
    IF @cMode = 'P'  --商品信息
        BEGIN
		    --exec p_hh_GetRightStr 'P','p',@OperatorID,'N',@TableStr out,@TableWhereStr out		
            SELECT  @sql = 'SELECT *
					FROM  tbx_Base_Ptype p
			         WHERE  p.PARID = ''' + @szTypeid + ''' and p.deleted = 0 ORDER BY RowIndex, p.ptypeid'		
            PRINT ( @sql )
            EXEC(@sql)
        END
    IF @cMode = 'B'  --单位信息
        BEGIN
		    --exec p_hh_GetRightStr 'B','b',@OperatorID,'N',@TableStr out,@TableWhereStr out		
            SELECT  @sql = 'SELECT *
					FROM  tbx_Base_Btype b
			         WHERE  b.PARID = ''' + @szTypeid + ''' and b.deleted = 0 ORDER BY RowIndex, b.btypeid'		
            PRINT ( @sql )
            EXEC(@sql)
        END
    IF @cMode = 'E'  --职员信息
        BEGIN
		    --exec p_hh_GetRightStr 'B','b',@OperatorID,'N',@TableStr out,@TableWhereStr out		
            SELECT  @sql = 'SELECT *
					FROM  tbx_Base_Etype b
			         WHERE  b.PARID = ''' + @szTypeid + ''' and b.deleted = 0 ORDER BY RowIndex, b.Etypeid'		
            PRINT ( @sql )
            EXEC(@sql)
        END
    IF @cMode = 'D'  --部门信息
        BEGIN
		    --exec p_hh_GetRightStr 'B','b',@OperatorID,'N',@TableStr out,@TableWhereStr out		
            SELECT  @sql = 'SELECT *
					FROM  tbx_Base_Dtype b
			         WHERE  b.PARID = ''' + @szTypeid + ''' and b.deleted = 0 ORDER BY RowIndex, b.Dtypeid'		
            PRINT ( @sql )
            EXEC(@sql)
        END
    IF @cMode = 'K'  --仓库信息
        BEGIN
		    --exec p_hh_GetRightStr 'B','b',@OperatorID,'N',@TableStr out,@TableWhereStr out		
            SELECT  @sql = 'SELECT *
					FROM  tbx_Base_Ktype b
			         WHERE  b.PARID = ''' + @szTypeid + ''' and b.deleted = 0 ORDER BY RowIndex, b.Ktypeid'		
            PRINT ( @sql )
            EXEC(@sql)
        END
go


