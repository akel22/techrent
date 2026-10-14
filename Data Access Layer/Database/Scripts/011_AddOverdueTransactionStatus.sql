  -- Add automatic Late and Overdue status transitions for existing databases.

IF OBJECT_ID(N'dbo.CK_Transactions_Status', N'C') IS NOT NULL
BEGIN
	ALTER TABLE dbo.Transactions DROP CONSTRAINT CK_Transactions_Status;
END
GO

CREATE OR ALTER PROCEDURE dbo.usp_GetTransactionById
	@TransactionID UNIQUEIDENTIFIER
AS
BEGIN
	SET NOCOUNT ON;

	SELECT t.TransactionID, t.UserID, c.FirstName, c.LastName,
		   t.CreatedAt, t.DueAt, t.[Status], t.IsArchived, t.Receipt
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

ALTER TABLE dbo.Transactions
	ADD CONSTRAINT CK_Transactions_Status
	CHECK ([Status] IN (N'Ongoing', N'Overdue', N'Late', N'Done'));
GO

CREATE OR ALTER PROCEDURE dbo.usp_GetActiveRentals
AS
BEGIN
	SET NOCOUNT ON;
	UPDATE dbo.Transactions
	SET [Status] = CASE WHEN DueAt < DATEADD(DAY, -3, SYSUTCDATETIME()) THEN N'Overdue' ELSE N'Late' END
	WHERE IsArchived = 0 AND [Status] IN (N'Ongoing', N'Overdue', N'Late') AND DueAt < SYSUTCDATETIME();

	IF OBJECT_ID(N'dbo.Customers', N'U') IS NOT NULL
	BEGIN
		SELECT t.TransactionID, t.UserID, c.FirstName, c.LastName, c.Email, c.MobileNumber, t.CreatedAt, t.DueAt, t.[Status], t.IsArchived, t.Receipt
		FROM dbo.Transactions t
		INNER JOIN dbo.Customers c ON c.CustomerID = t.UserID
		WHERE t.[Status] IN (N'Ongoing', N'Overdue', N'Late') AND t.IsArchived = 0
		ORDER BY t.DueAt ASC;
	END
	ELSE
	BEGIN
		SELECT t.TransactionID, t.UserID, u.FirstName, u.LastName, u.Email, u.MobileNumber, t.CreatedAt, t.DueAt, t.[Status], t.IsArchived, t.Receipt
		FROM dbo.Transactions t
		INNER JOIN dbo.Users u ON u.UserID = t.UserID
		WHERE t.[Status] IN (N'Ongoing', N'Overdue', N'Late') AND t.IsArchived = 0
		ORDER BY t.DueAt ASC;
	END
END
GO

CREATE OR ALTER PROCEDURE dbo.usp_GetTransactionLog
AS
BEGIN
	SET NOCOUNT ON;
	UPDATE dbo.Transactions
	SET [Status] = CASE WHEN DueAt < DATEADD(DAY, -3, SYSUTCDATETIME()) THEN N'Overdue' ELSE N'Late' END
	WHERE IsArchived = 0 AND [Status] IN (N'Ongoing', N'Overdue', N'Late') AND DueAt < SYSUTCDATETIME();

	IF OBJECT_ID(N'dbo.Customers', N'U') IS NOT NULL
	BEGIN
		SELECT t.TransactionID, t.UserID, c.FirstName, c.LastName,
		   c.Email, c.MobileNumber, t.CreatedAt, t.DueAt, t.[Status], t.IsArchived, t.Receipt
		FROM dbo.Transactions t
		INNER JOIN dbo.Customers c ON c.CustomerID = t.UserID
		WHERE t.IsArchived = 0
		ORDER BY t.CreatedAt DESC;
	END
	ELSE
	BEGIN
		SELECT t.TransactionID, t.UserID, u.FirstName, u.LastName,
			   u.Email, u.MobileNumber, t.CreatedAt, t.DueAt, t.[Status], t.IsArchived, t.Receipt
		FROM dbo.Transactions t
		INNER JOIN dbo.Users u ON u.UserID = t.UserID
		WHERE t.IsArchived = 0
		ORDER BY t.CreatedAt DESC;
	END
END
GO

CREATE OR ALTER PROCEDURE dbo.usp_GetTransactionById
	@TransactionID UNIQUEIDENTIFIER
AS
BEGIN
	SET NOCOUNT ON;

	IF OBJECT_ID(N'dbo.Customers', N'U') IS NOT NULL
	BEGIN
		SELECT t.TransactionID, t.UserID, c.FirstName, c.LastName,
			   c.Email, c.MobileNumber, t.CreatedAt, t.DueAt, t.[Status], t.IsArchived, t.Receipt
		FROM dbo.Transactions t
		INNER JOIN dbo.Customers c ON c.CustomerID = t.UserID
		WHERE t.TransactionID = @TransactionID;
	END
	ELSE
	BEGIN
		SELECT t.TransactionID, t.UserID, u.FirstName, u.LastName,
			   u.Email, u.MobileNumber, t.CreatedAt, t.DueAt, t.[Status], t.IsArchived, t.Receipt
		FROM dbo.Transactions t
		INNER JOIN dbo.Users u ON u.UserID = t.UserID
		WHERE t.TransactionID = @TransactionID;
	END

	SELECT te.TransactionID, te.EquipmentID, e.Model, e.SKU, e.Category, e.Type, e.Status,
		   te.Quantity, te.RentalFee, te.DepositFee
	FROM dbo.TransactionEquipments te
	INNER JOIN dbo.Equipments e ON e.EquipmentID = te.EquipmentID
	WHERE te.TransactionID = @TransactionID;
END
GO
