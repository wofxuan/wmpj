IF OBJECT_ID('dbo.pbx_Stock_LoadIni') IS NOT NULL 
    DROP PROCEDURE dbo.pbx_Stock_LoadIni
go

--查询期初库存商品信息

CREATE PROCEDURE pbx_Stock_LoadIni
    (
      @ParPTypeId VARCHAR(50) ,
      @KTypeId VARCHAR(50) ,
      @Operator VARCHAR(50)    --操作员ID
    )
AS 
    SET NOCOUNT ON
    DECLARE @aSQL VARCHAR(8000)
    
    DECLARE @id_len INT ,
        @NewParPTypeId VARCHAR(50)

    IF @ParPTypeId = '' 
        SET @ParPTypeId = '00000'
        
    IF @ParPTypeId = '00000'
        OR @ParPTypeId = '%' 
        SELECT  @id_len = 5, @NewParPTypeId = '%'
    ELSE 
        BEGIN
            SELECT  @id_len = LEN(@ParPTypeId) + 5, @NewParPTypeId = @ParPTypeId + '%'	
        END 
       
        
    IF @KTypeId = '00000'
        OR @KTypeId = '' 
        SELECT  @KTypeId = '%'
    ELSE 
        SELECT  @KTypeId = @KTypeId + '%'
        
    SELECT  bp.*, ISNULL(Qty, 0) Qty, ISNULL(Total, 0) Total, ISNULL(GoodsOrderId, 0) GoodsOrderId, CASE WHEN QTY <> 0 THEN dbo.Fun_CovTotalDivQty(Total, Qty)
                                                                                                         ELSE 0
                                                                                                    END Price
    FROM    ( SELECT    p.PTypeId, p.PUsercode, p.PFullname, p.Parid, p.RowIndex
              FROM      dbo.tbx_Base_Ptype p
              WHERE     p.ptypeid LIKE CASE WHEN @ParPTypeId = '00000' THEN ''
                                            ELSE @ParPTypeId
                                       END + '%'
                        AND deleted = 0
            ) bp
            LEFT JOIN ( SELECT  LEFT(sg.PTypeId, @id_len) PTypeId, SUM(Qty) Qty, SUM(Total) Total, MIN(CASE WHEN LEN(LEFT(sg.PTypeId, @id_len)) < LEN(sg.PTypeId) THEN 0
                                                                                                            ELSE GoodsOrderId
                                                                                                       END) GoodsOrderId
                        FROM    dbo.tbx_Stock_Goods_Ini sg
                        WHERE   sg.KTypeId LIKE '%'
                                AND sg.PTypeId LIKE '%'
                        GROUP BY LEFT(sg.PTypeId, @id_len)
                      ) sgi ON bp.PTypeId = sgi.PTypeId
    WHERE   bp.Parid = @ParPTypeId
    ORDER BY bp.RowIndex 
            
    --EXEC(@aSQL)        
    RETURN 0

GO 
