BEGIN
DECLARE @Exists bit
IF EXISTS (SELECT DimProductSalespersonID
FROM dbo.DimProductSalesperson
WHERE @ProductCD = @ProductCD AND
@CompanyNBR = @CompanyNBR AND
@SalespersonNBR = @SalespersonNBR)
BEGIN
SET @Exists = 1
END
ELSE
BEGIN
SET @Exists = 0
END
RETURN @Exists
END