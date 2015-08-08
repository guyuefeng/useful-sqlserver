CREATE TABLE #testMoney
(
    moneyValue money
)
go

INSERT INTO #testMoney
VALUES ($100)
INSERT INTO #testMoney
VALUES (100)
INSERT INTO #testMoney
VALUES (?00)
GO
SELECT * FROM #testMoney
GO

DECLARE @money1 money,  @money2 money

SET    @money1 = 1.00
SET    @money2 = 800.00
SELECT cast(@money1/@money2 as money)


DECLARE @decimal1 decimal(19,4), @decimal2 decimal(19,4)
SET     @decimal1 = 1.00
SET     @decimal2 = 800.00
SELECT  cast(@decimal1/@decimal2 as decimal(19,4))

SELECT  @money1/@money2
SELECT  @decimal1/@decimal2

DROP TABLE #testMoney

GO