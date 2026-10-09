-- Add required rental timing and rounded-up hourly billing fields.
-- Run this after clearing dependent transaction records. This migration does not drop or recreate tables.
IF OBJECT_ID(N'dbo.Transactions', N'U') IS NULL
BEGIN
	THROW 51002, 'The Transactions table must exist before applying rental timing.', 1;
END
GO

IF (COL_LENGTH(N'dbo.Transactions', N'StartAt') IS NULL OR COL_LENGTH(N'dbo.Transactions', N'BillableHours') IS NULL)
   AND EXISTS (SELECT 1 FROM dbo.Transactions)
BEGIN
	THROW 51003, 'Clear transaction records before adding required rental timing fields.', 1;
END
GO

IF COL_LENGTH(N'dbo.Transactions', N'StartAt') IS NULL
BEGIN
	ALTER TABLE dbo.Transactions
		ADD StartAt DATETIME2(7) NOT NULL;
END
GO

IF COL_LENGTH(N'dbo.Transactions', N'BillableHours') IS NULL
BEGIN
	ALTER TABLE dbo.Transactions
		ADD BillableHours INT NOT NULL;
END
GO

IF OBJECT_ID(N'dbo.CK_Transactions_BillableHours', N'C') IS NULL
BEGIN
	ALTER TABLE dbo.Transactions
		ADD CONSTRAINT CK_Transactions_BillableHours CHECK (BillableHours > 0);
END
GO

IF OBJECT_ID(N'dbo.CK_Transactions_RentalPeriod', N'C') IS NULL
BEGIN
	ALTER TABLE dbo.Transactions
		ADD CONSTRAINT CK_Transactions_RentalPeriod CHECK (DueAt > StartAt);
END
GO

CREATE OR ALTER PROCEDURE dbo.usp_CreateTransaction
	@UserID UNIQUEIDENTIFIER,
	@StartAt DATETIME2(7),
	@DueAt DATETIME2(7),
	@BillableHours INT,
	@TransactionID UNIQUEIDENTIFIER OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

	IF @DueAt <= @StartAt OR @BillableHours <= 0
	BEGIN
		THROW 51000, 'The rental period and billable hours are invalid.', 1;
	END

	SET @TransactionID = NEWID();
	INSERT INTO dbo.Transactions (TransactionID, UserID, Status, StartAt, DueAt, BillableHours)
	VALUES (@TransactionID, @UserID, 'Ongoing', @StartAt, @DueAt, @BillableHours);
END
GO

CREATE OR ALTER PROCEDURE dbo.usp_GetActiveRentals
AS
BEGIN
	SET NOCOUNT ON;
	UPDATE dbo.Transactions
	SET [Status] = CASE WHEN DueAt < DATEADD(DAY, -3, SYSUTCDATETIME()) THEN N'Overdue' ELSE N'Late' END
	WHERE IsArchived = 0 AND [Status] IN (N'Ongoing', N'Overdue', N'Late') AND DueAt < SYSUTCDATETIME();

	SELECT t.TransactionID, t.UserID, c.FirstName, c.LastName, c.Email, c.MobileNumber,
		   t.CreatedAt, t.StartAt, t.DueAt, t.BillableHours, t.[Status], t.IsArchived, t.Receipt
	FROM dbo.Transactions t
	INNER JOIN dbo.Customers c ON c.CustomerID = t.UserID
	WHERE t.[Status] IN (N'Ongoing', N'Overdue', N'Late') AND t.IsArchived = 0
	ORDER BY t.DueAt ASC;
END
GO

CREATE OR ALTER PROCEDURE dbo.usp_GetTransactionLog
AS
BEGIN
	SET NOCOUNT ON;
	UPDATE dbo.Transactions
	SET [Status] = CASE WHEN DueAt < DATEADD(DAY, -3, SYSUTCDATETIME()) THEN N'Overdue' ELSE N'Late' END
	WHERE IsArchived = 0 AND [Status] IN (N'Ongoing', N'Overdue', N'Late') AND DueAt < SYSUTCDATETIME();

	SELECT t.TransactionID, t.UserID, c.FirstName, c.LastName, c.Email, c.MobileNumber,
		   t.CreatedAt, t.StartAt, t.DueAt, t.BillableHours, t.[Status], t.IsArchived, t.Receipt
	FROM dbo.Transactions t
	INNER JOIN dbo.Customers c ON c.CustomerID = t.UserID
	WHERE t.IsArchived = 0
	ORDER BY t.CreatedAt DESC;
END
GO

CREATE OR ALTER PROCEDURE dbo.usp_GetTransactionById
	@TransactionID UNIQUEIDENTIFIER
AS
BEGIN
	SET NOCOUNT ON;

	SELECT t.TransactionID, t.UserID, c.FirstName, c.LastName, c.Email, c.MobileNumber,
		   t.CreatedAt, t.StartAt, t.DueAt, t.BillableHours, t.[Status], t.IsArchived, t.Receipt
	FROM dbo.Transactions t
	INNER JOIN dbo.Customers c ON c.CustomerID = t.UserID
	WHERE t.TransactionID = @TransactionID;

	SELECT te.TransactionID, te.EquipmentID, e.Model, e.SKU, e.Category, e.Type, e.Status,
		   te.Quantity, te.RentalFee, te.DepositFee
	FROM dbo.TransactionEquipments te
	INNER JOIN dbo.Equipments e ON e.EquipmentID = te.EquipmentID
	WHERE te.TransactionID = @TransactionID;
END
GO

CREATE OR ALTER PROCEDURE dbo.usp_GetTransactionsByCustomer
	@UserID UNIQUEIDENTIFIER
AS
BEGIN
	SET NOCOUNT ON;
	SELECT t.TransactionID, t.UserID, c.FirstName, c.LastName, c.Email, c.MobileNumber,
		   t.CreatedAt, t.StartAt, t.DueAt, t.BillableHours, t.[Status], t.IsArchived, t.Receipt
	FROM dbo.Transactions t
	INNER JOIN dbo.Customers c ON c.CustomerID = t.UserID
	WHERE t.UserID = @UserID
	ORDER BY t.CreatedAt DESC;
END
GO
