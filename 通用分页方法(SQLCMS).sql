USE [W101]
GO
/****** Object:  StoredProcedure [dbo].[SQLCMS_GenericPager]    Script Date: 06/21/2013 15:16:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--ALTER PROCEDURE [dbo].[SQLCMS_GenericPager] 
--(
DECLARE 
	@Tables nvarchar(4000)='V_W101_BasicAgreementDetail MT',
	@PK varchar(200)='outlet_no',
	@MainTable varchar(200)='V_W101_BasicAgreementDetail',
	@Sort varchar(250) = 'outlet_no desc',
	@PageNumber int = 1,
	@PageSize int = 10,
	@Fields nvarchar(4000) = '*',
	@Filter nvarchar(4000) = '',
	@Group varchar(1000) = ''
--)

--AS

/*Find the @PK type*/
DECLARE @TABLESCHEMA varchar(100)
DECLARE @PKTable varchar(100)
DECLARE @PKName varchar(100)
DECLARE @type varchar(100)
DECLARE @Collate varchar(100)
DECLARE @prec int

SET @TABLESCHEMA =SUBSTRING(@MainTable, 0, CHARINDEX('.',@MainTable))
SET @PKTable = SUBSTRING(@MainTable, CHARINDEX('.',@MainTable)+1, LEN(@MainTable))
SET @PKName =@PK

SELECT @type=t.name, @prec=c.prec
FROM sysobjects o 
JOIN syscolumns c on o.id=c.id
JOIN systypes t on c.xusertype=t.xusertype
WHERE o.name = @PKTable AND c.name = @PKName

IF CHARINDEX('char', @type) > 0
   SET @type = @type + '(' + CAST(@prec AS varchar) + ')'

IF CHARINDEX('char', @type) > 0
  SET @Collate = ' collate database_default'
ELSE
  SET @Collate = ''

DECLARE @strPageSize varchar(50)
DECLARE @strStartRow varchar(50)
DECLARE @strFilter varchar(1000)
DECLARE @strGroup varchar(1000)

IF @Sort IS NULL OR @Sort = ''
	SET @Sort = 'MT.['+@PK+']'

IF @PageNumber < 1
	SET @PageNumber = 1

SET @strPageSize = CAST(@PageSize AS varchar(50))
SET @strStartRow = CAST(((@PageNumber - 1)*@PageSize + 1) AS varchar(50))

IF @Filter IS NOT NULL AND @Filter != ''
	SET @strFilter = ' WHERE ' + @Filter + ' '
ELSE
	SET @strFilter = ''

IF @Group IS NOT NULL AND @Group != ''
	SET @strGroup = ' GROUP BY ' + @Group + ' '
ELSE
	SET @strGroup = ''

DECLARE @sql AS NVARCHAR(4000) =
'DECLARE @PageSize int
SET @PageSize = ' + @strPageSize + '
DECLARE @PK ' + @type + '
DECLARE @tblPK TABLE (
            PK  ' + @type + ' NOT NULL PRIMARY KEY
            )

DECLARE PagingCursor CURSOR DYNAMIC READ_ONLY FOR
SELECT MT.['  + @PK + ']'+@Collate+' FROM ' + @Tables + @strFilter + ' ' + @strGroup + ' ORDER BY ' + @Sort + '
OPEN PagingCursor
FETCH RELATIVE ' + @strStartRow + ' FROM PagingCursor INTO @PK
SET NOCOUNT ON
WHILE @PageSize > 0 AND @@FETCH_STATUS = 0
BEGIN
            INSERT @tblPK (PK)  VALUES (@PK'+@Collate+')
            FETCH NEXT FROM PagingCursor INTO @PK
            SET @PageSize = @PageSize - 1
END
CLOSE       PagingCursor
DEALLOCATE  PagingCursor
SELECT ' + @Fields + ' FROM ' + @Tables + ' JOIN @tblPK tblPK ON MT.[' + @PK + ']  '+@Collate+'= tblPK.PK ' + @strFilter + ' ' + @strGroup + ' ORDER BY ' + @Sort+'
SELECT COUNT(MT.['  + @PK + '] '+@Collate+') AS TotalRows FROM ' + @Tables + @strFilter

PRINT @sql

EXEC(@sql)

/****打印内容
DECLARE @PageSize int
SET @PageSize = 10
DECLARE @PK nvarchar(10)
DECLARE @tblPK TABLE (
            PK  nvarchar(10) NOT NULL PRIMARY KEY
            )

DECLARE PagingCursor CURSOR DYNAMIC READ_ONLY FOR
SELECT MT.[outlet_no] collate database_default FROM V_W101_BasicAgreementDetail MT  ORDER BY outlet_no desc
OPEN PagingCursor
FETCH RELATIVE 1 FROM PagingCursor INTO @PK
SET NOCOUNT ON
WHILE @PageSize > 0 AND @@FETCH_STATUS = 0
BEGIN
            INSERT @tblPK (PK)  VALUES (@PK collate database_default)
            FETCH NEXT FROM PagingCursor INTO @PK
            SET @PageSize = @PageSize - 1
END
CLOSE       PagingCursor
DEALLOCATE  PagingCursor
SELECT * FROM V_W101_BasicAgreementDetail MT JOIN @tblPK tblPK ON MT.[outlet_no]   collate database_default= tblPK.PK   ORDER BY outlet_no desc
SELECT COUNT(MT.[outlet_no]  collate database_default) AS TotalRows FROM V_W101_BasicAgreementDetail MT

(2 行受影响)
******/



/************************************

完整创建方法

************************************/
ALTER PROCEDURE [dbo].[SQLCMS_GenericPager] 
(
	@Tables nvarchar(4000),
	@PK varchar(200),
	@MainTable varchar(200),
	@Sort varchar(250) = NULL,
	@PageNumber int = 1,
	@PageSize int = 10,
	@Fields nvarchar(4000) = '*',
	@Filter nvarchar(4000) = NULL,
	@Group varchar(1000) = NULL
)

AS

/*Find the @PK type*/
DECLARE @TABLESCHEMA varchar(100)
DECLARE @PKTable varchar(100)
DECLARE @PKName varchar(100)
DECLARE @type varchar(100)
DECLARE @Collate varchar(100)
DECLARE @prec int

SET @TABLESCHEMA =SUBSTRING(@MainTable, 0, CHARINDEX('.',@MainTable))
SET @PKTable = SUBSTRING(@MainTable, CHARINDEX('.',@MainTable)+1, LEN(@MainTable))
SET @PKName =@PK

SELECT @type=t.name, @prec=c.prec
FROM sysobjects o 
JOIN syscolumns c on o.id=c.id
JOIN systypes t on c.xusertype=t.xusertype
WHERE o.name = @PKTable AND c.name = @PKName

IF CHARINDEX('char', @type) > 0
   SET @type = @type + '(' + CAST(@prec AS varchar) + ')'

IF CHARINDEX('char', @type) > 0
  SET @Collate = ' collate database_default'
ELSE
  SET @Collate = ''

DECLARE @strPageSize varchar(50)
DECLARE @strStartRow varchar(50)
DECLARE @strFilter varchar(1000)
DECLARE @strGroup varchar(1000)

IF @Sort IS NULL OR @Sort = ''
	SET @Sort = 'MT.['+@PK+']'

IF @PageNumber < 1
	SET @PageNumber = 1

SET @strPageSize = CAST(@PageSize AS varchar(50))
SET @strStartRow = CAST(((@PageNumber - 1)*@PageSize + 1) AS varchar(50))

IF @Filter IS NOT NULL AND @Filter != ''
	SET @strFilter = ' WHERE ' + @Filter + ' '
ELSE
	SET @strFilter = ''

IF @Group IS NOT NULL AND @Group != ''
	SET @strGroup = ' GROUP BY ' + @Group + ' '
ELSE
	SET @strGroup = ''

EXEC('DECLARE @PageSize int
SET @PageSize = ' + @strPageSize + '
DECLARE @PK ' + @type + '
DECLARE @tblPK TABLE (
            PK  ' + @type + ' NOT NULL PRIMARY KEY
            )

DECLARE PagingCursor CURSOR DYNAMIC READ_ONLY FOR
SELECT MT.['  + @PK + ']'+@Collate+' FROM ' + @Tables + @strFilter + ' ' + @strGroup + ' ORDER BY ' + @Sort + '
OPEN PagingCursor
FETCH RELATIVE ' + @strStartRow + ' FROM PagingCursor INTO @PK
SET NOCOUNT ON
WHILE @PageSize > 0 AND @@FETCH_STATUS = 0
BEGIN
            INSERT @tblPK (PK)  VALUES (@PK'+@Collate+')
            FETCH NEXT FROM PagingCursor INTO @PK
            SET @PageSize = @PageSize - 1
END
CLOSE       PagingCursor
DEALLOCATE  PagingCursor
SELECT ' + @Fields + ' FROM ' + @Tables + ' JOIN @tblPK tblPK ON MT.[' + @PK + ']  '+@Collate+'= tblPK.PK ' + @strFilter + ' ' + @strGroup + ' ORDER BY ' + @Sort+'
SELECT COUNT(MT.['  + @PK + '] '+@Collate+') AS TotalRows FROM ' + @Tables + @strFilter)