-- Persists return condition notes when an active rental is completed.
IF COL_LENGTH(N'dbo.Transactions', N'ReturnConditionNotes') IS NULL
BEGIN
	ALTER TABLE dbo.Transactions
		ADD ReturnConditionNotes NVARCHAR(500) NULL;
END
GO

CREATE OR ALTER PROCEDURE dbo.usp_CompleteTransaction
	@TransactionID UNIQUEIDENTIFIER,
	@ReturnConditionNotes NVARCHAR(500) = NULL
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE dbo.Transactions
	SET Status = 'Done',
		ReturnConditionNotes = @ReturnConditionNotes
	WHERE TransactionID = @TransactionID
	  AND IsArchived = 0
	  AND Status <> 'Done';
END
GO
