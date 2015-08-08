PRINT @@TRANCOUNT
--  The BEGIN TRAN statement will increment the
--  transaction count by 1.
BEGIN TRAN
    PRINT @@TRANCOUNT
    BEGIN TRAN
        PRINT @@TRANCOUNT
--  The COMMIT statement will decrement the transaction count by 1.
    COMMIT
    PRINT @@TRANCOUNT
COMMIT
PRINT @@TRANCOUNT


PRINT @@TRANCOUNT
--  The BEGIN TRAN statement will increment the
--  transaction count by 1.
BEGIN TRAN
    PRINT @@TRANCOUNT
    BEGIN TRAN
        PRINT @@TRANCOUNT
--  The ROLLBACK statement will clear the @@TRANCOUNT variable
--  to 0 because all active transactions will be rolled back.
ROLLBACK   --  «Â¡„
PRINT @@TRANCOUNT