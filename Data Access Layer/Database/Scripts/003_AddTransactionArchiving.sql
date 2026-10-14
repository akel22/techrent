-- Incremental transaction archiving migration for existing Techrent databases.
IF COL_LENGTH(N'dbo.Transactions', N'IsArchived') IS NULL
BEGIN
	ALTER TABLE dbo.Transactions
		ADD IsArchived BIT NOT NULL
			CONSTRAINT DF_Transactions_IsArchived DEFAULT 0;
END
GO

IF OBJECT_ID(N'dbo.CK_Transactions_Status', N'C') IS NOT NULL
BEGIN
	ALTER TABLE dbo.Transactions DROP CONSTRAINT CK_Transactions_Status;
END
GO

ALTER TABLE dbo.Transactions
	ADD CONSTRAINT CK_Transactions_Status
	CHECK (Status IN ('Ongoing', 'Overdue', 'Late', 'Done'));
GO

CREATE OR ALTER PROCEDURE dbo.usp_GetTransactionLog
AS
BEGIN
	SET NOCOUNT ON;

	SELECT t.TransactionID, t.UserID, u.FirstName, u.LastName,
		   t.CreatedAt, t.DueAt, t.Status, t.IsArchived, t.Receipt
	FROM dbo.Transactions t
	INNER JOIN dbo.Users u ON u.UserID = t.UserID
	WHERE t.IsArchived = 0
	ORDER BY t.CreatedAt DESC;
END
GO

CREATE OR ALTER PROCEDURE dbo.usp_CompleteTransaction
	@TransactionID UNIQUEIDENTIFIER
	,@ReturnConditionNotes NVARCHAR(500) = NULL
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE dbo.Transactions
	SET Status = 'Done',
		ReturnConditionNotes = @ReturnConditionNotes
	WHERE TransactionID = @TransactionID
	  AND IsArchived = 0;
END
GO

CREATE OR ALTER PROCEDURE dbo.usp_ArchiveTransaction
	@TransactionID UNIQUEIDENTIFIER
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE dbo.Transactions
	SET IsArchived = 1
	WHERE TransactionID = @TransactionID
	  AND Status = 'Done'
	  AND IsArchived = 0;

	SELECT CAST(CASE WHEN @@ROWCOUNT = 1 THEN 1 ELSE 0 END AS BIT) AS Archived;
END
GO
