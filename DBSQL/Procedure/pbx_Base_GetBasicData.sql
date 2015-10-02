IF OBJECT_ID('dbo.pbx_Base_GetBasicData') IS NOT NULL 
    DROP PROCEDURE dbo.pbx_Base_GetBasicData
go

SET QUOTED_IDENTIFIER OFF 
GO

SET ANSI_NULLS ON 
GO

--  ********************************************************************************************
--  ||                                                                                        
--  ||   过程名称：pbx_Base_GetBasicData                                                 
--  ||   过程功能：得到本地化信息
--  ||=========================================================================================
--  ||   参数说明：  参数名称         类型            意义                     输入输出
--  ||            -----------------------------------------------------------------------------
--  ||            @cMode 	char(5)		:基本信息类型参数			IN
--  ||            @nUpdateTag 	INTEGER	:根节点更新tag			IN
--  ||=========================================================================================                                                                    
--  ********************************************************************************************

CREATE PROCEDURE pbx_Base_GetBasicData
    (
      @cMode VARCHAR(10) ,
      @nUpdateTag INTEGER
    )
AS 
    IF @cMode = 'I' 
        BEGIN
            SELECT  [ITypeId], [Parid], [Leveal], [ISonnum], [Soncount]
            FROM    tbx_Base_PackageInfo
            WHERE   ( @nUpdateTag <= 0 )
                    OR ( UpdateTag > @nUpdateTag )
        END
        
    IF @cMode = 'P' 
        BEGIN
            SELECT  [PTypeId], [Parid], [Soncount], [PSonnum], [PUsercode], [PFullname]
            FROM    tbx_Base_Ptype
            WHERE   ( @nUpdateTag <= 0 )
                    OR ( UpdateTag > @nUpdateTag )
        END
        
    IF @cMode = 'B' 
        BEGIN
            SELECT  [BTypeId], [Parid], [Soncount], [BSonnum], [BUsercode], [BFullname]
            FROM    tbx_Base_Btype
            WHERE   ( @nUpdateTag <= 0 )
                    OR ( UpdateTag > @nUpdateTag )
        END
    IF @cMode = 'E' 
        BEGIN
            SELECT  [ETypeId], [Parid], [Soncount], [ESonnum], [EUsercode], [EFullname]
            FROM    tbx_Base_Etype
            WHERE   ( @nUpdateTag <= 0 )
                    OR ( UpdateTag > @nUpdateTag )
        END
    IF @cMode = 'D' 
        BEGIN
            SELECT  [DTypeId], [Parid], [Soncount], [DSonnum], [DUsercode], [DFullname]
            FROM    tbx_Base_Dtype
            WHERE   ( @nUpdateTag <= 0 )
                    OR ( UpdateTag > @nUpdateTag )
        END
    IF @cMode = 'K' 
        BEGIN
            SELECT  [KTypeId], [Parid], [Soncount], [KSonnum], [KUsercode], [KFullname]
            FROM    tbx_Base_Ktype
            WHERE   ( @nUpdateTag <= 0 )
                    OR ( UpdateTag > @nUpdateTag )
        END
    RETURN 0

go


