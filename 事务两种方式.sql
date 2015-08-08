
-- Old-Style Error Handling

DECLARE @ErrorNBR int

BEGIN TRAN

INSERT Production.Location
(Name, CostRate, Availability)
VALUES
('Tool Verification', 0.00, 0.00)

SELECT @ErrorNBR = @@ERROR

IF @ErrorNBR <> 0
GOTO UndoTran

INSERT Production.Location
(Name, CostRate, Availability)
VALUES
('Frame Forming', 0.00, 0.00)

SELECT @ErrorNBR = @@ERROR

IF @ErrorNBR <> 0
GOTO UndoTran

COMMIT TRAN

UndoTran:
IF @ErrorNBR <> 0
BEGIN
PRINT CAST(@ErrorNBR as varchar(6)) +
' occurred after an attempt to insert into Production.Location'
ROLLBACK TRAN
END

-- Error Handling with TRY...CATCH

BEGIN TRY

BEGIN TRAN

INSERT Production.Location
(Name, CostRate, Availability)
VALUES
('Tool Verification', 0.00, 0.00)

INSERT Production.Location
(Name, CostRate, Availability)
VALUES
('Frame Forming', 0.00, 0.00)

COMMIT TRANSACTION

END TRY

BEGIN CATCH

SELECT ERROR_NUMBER() ErrorNBR, ERROR_SEVERITY() Severity,
ERROR_LINE () ErrorLine, ERROR_MESSAGE() Msg

ROLLBACK TRANSACTION

END CATCH