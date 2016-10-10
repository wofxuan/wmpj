IF OBJECT_ID('dbo.pbx_A_Qry_Balance') IS NOT NULL 
    DROP PROCEDURE dbo.pbx_A_Qry_Balance
GO

--查询付款或收款单的结算的单据

CREATE PROCEDURE pbx_A_Qry_Balance
    (
      @BTypeID VARCHAR(50) ,
      @ETypeID VARCHAR(50) ,
      @StartDate VARCHAR(10) ,
      @EndDate VARCHAR(10) ,
      @VchType INT ,
      @OperatorID VARCHAR(50)
    )
AS 
    DECLARE @sql VARCHAR(8000)
    
    IF @VchType = 7 
        BEGIN
            SET @SQL = 'SELECT  m.VchType, m.VchCode, m.Number, m.Summary, m.InputDate, m.Total JETotal, (m.Total - g.gTotal) YETotal, 0 IsSelect
					FROM    dbo.tbx_Bill_M m
							LEFT JOIN ( SELECT  VchCode, VchType, SUM(Total) gTotal
								FROM    dbo.tbx_Bill_A_Gathering
								GROUP BY VchCode, VchType
							  ) g ON m.VchCode = g.VchCode
									 AND m.VchType = g.VchType
					WHERE   m.Draft = 2 AND m.RedOld = ''F'' AND m.VchType = 3 AND m.BtypeId = ' + @BTypeID
            PRINT ( @SQL )
        END
    ELSE IF @VchType = 6 
        BEGIN
            SET @SQL = 'SELECT  m.VchType, m.VchCode, m.Number, m.Summary, m.InputDate, m.Total JETotal, (m.Total - g.gTotal) YETotal, 0 IsSelect
				FROM    dbo.tbx_Bill_M m
						LEFT JOIN ( SELECT  VchCode, VchType, SUM(Total) gTotal
							FROM    dbo.tbx_Bill_A_Gathering
							GROUP BY VchCode, VchType
						  ) g ON m.VchCode = g.VchCode
								 AND m.VchType = g.VchType
				WHERE   m.Draft = 2 AND m.RedOld = ''F'' AND m.VchType = 4 AND m.BtypeId = ' + @BTypeID
            PRINT ( @SQL )
        END
    EXEC(@SQL)
GO