-- =============================================
---  两个解决方案
-- =============================================



-- =============================================
-- Author:      ligf
-- Create date: 2012-04-26
-- Description: split函数
-- Debug:       select * from dbo.F_Split('ABC :BC:\C:D:E：',':') 
-- =============================================
ALTER FUNCTION [dbo].[F_Split]
(
  @SourceSql VARCHAR(8000),
  @StrSeprate VARCHAR(10)
)
RETURNS @Temp_Table TABLE ( item VARCHAR(100) )
AS 
BEGIN
    DECLARE @i INT
    SET @SourceSql = RTRIM(LTRIM(@SourceSql))
    SET @i = CHARINDEX(@StrSeprate, @SourceSql)
    WHILE @i >= 1 
    BEGIN
        INSERT  @TEMP_Table
        VALUES  ( LEFT(@SourceSql, @i - 1) )
        SET @SourceSql = SUBSTRING(@SourceSql, @i + 1,
                                   LEN(@SourceSql) - @i)
        SET @i = CHARINDEX(@StrSeprate, @SourceSql)
    END
    IF @SourceSql <> '\' 
        INSERT  @Temp_Table
        VALUES  ( @SourceSql )

    RETURN 
END

GO


-- =============================================
-- Author:      ligf
-- Create date: 2012-04-26
-- Description: split函数
-- Debug:       select * from dbo.F_Split_2('ABC :BC:\C:D:E：',':') 
-- =============================================

CREATE FUNCTION [dbo].[F_Split_2]
(
 @splitstring NVARCHAR(4000),
 @separator CHAR(1) = ','
)
RETURNS @splitstringstable TABLE
(
 [item] NVARCHAR(200)
)
AS
BEGIN
    DECLARE @currentindex INT
    DECLARE @nextindex INT
    DECLARE @returntext NVARCHAR(200)

    SELECT @currentindex=1

    WHILE(@currentindex<=datalength(@splitstring)/2)
    BEGIN
        SELECT @nextindex=charindex(@separator,@splitstring,@currentindex)
        IF(@nextindex=0 OR @nextindex IS NULL)
            SELECT @nextindex=datalength(@splitstring)/2+1
        
        SELECT @returntext=substring(@splitstring,@currentindex,@nextindex-@currentindex)

        INSERT INTO @splitstringstable([item])
        VALUES(@returntext)
        
        SELECT @currentindex=@nextindex+1
    END
    RETURN
END