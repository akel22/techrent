/*
	Techrent database deployment
	SQL Server / SQL Server Express

	This script is safe to run repeatedly. It creates missing objects and
	upgrades the existing schema without dropping application data.
*/

SET XACT_ABORT ON;
GO

IF OBJECT_ID(N'dbo.Users', N'U') IS NULL
BEGIN
	CREATE TABLE dbo.Users
	(
		UserID UNIQUEIDENTIFIER NOT NULL CONSTRAINT PK_Users PRIMARY KEY DEFAULT NEWSEQUENTIALID(),
		FirstName NVARCHAR(24) NOT NULL,
		LastName NVARCHAR(24) NOT NULL,
		Role NVARCHAR(24) NOT NULL CONSTRAINT DF_Users_Role DEFAULT 'RentalStaff',
		Occupation NVARCHAR(32) NOT NULL,
		Email NVARCHAR(32) NOT NULL,
		MobileNumber NVARCHAR(12) NULL,
		OrganizationAddress NVARCHAR(300) NULL,
		IdentificationCard VARBINARY(MAX) NULL,
		CreatedAt DATETIME2(7) NOT NULL CONSTRAINT DF_Users_CreatedAt DEFAULT SYSUTCDATETIME()
	);
END
GO

IF OBJECT_ID(N'dbo.Customers', N'U') IS NULL
BEGIN
	CREATE TABLE dbo.Customers
	(
		CustomerID UNIQUEIDENTIFIER NOT NULL CONSTRAINT PK_Customers PRIMARY KEY DEFAULT NEWSEQUENTIALID(),
		FirstName NVARCHAR(24) NOT NULL,
		LastName NVARCHAR(24) NOT NULL,
		Occupation NVARCHAR(32) NOT NULL CONSTRAINT CK_Customers_Occupation CHECK (Occupation IN ('Student', 'Employed', 'Unemployed', 'Other')),
		Email NVARCHAR(32) NOT NULL,
		MobileNumber NVARCHAR(12) NULL,
		OrganizationAddress NVARCHAR(300) NULL,
		IdentificationCard VARBINARY(MAX) NULL,
		CreatedAt DATETIME2(7) NOT NULL CONSTRAINT DF_Customers_CreatedAt DEFAULT SYSUTCDATETIME(),
		CONSTRAINT UQ_Customers_Email UNIQUE (Email)
	);
END
GO

IF OBJECT_ID(N'dbo.Equipments', N'U') IS NULL
BEGIN
	CREATE TABLE dbo.Equipments
	(
		EquipmentID UNIQUEIDENTIFIER NOT NULL CONSTRAINT PK_Equipments PRIMARY KEY DEFAULT NEWSEQUENTIALID(),
		Category NVARCHAR(30) NOT NULL,
		[Type] NVARCHAR(30) NOT NULL,
		[Status] NVARCHAR(30) NOT NULL CONSTRAINT DF_Equipments_Status DEFAULT 'Available',
		[Model] NVARCHAR(200) NOT NULL,
		SKU NVARCHAR(100) NOT NULL,
		[Image] VARBINARY(MAX) NULL,
		Stock INT NOT NULL CONSTRAINT DF_Equipments_Stock DEFAULT 0,
		BaseRentalFee DECIMAL(18,2) NOT NULL CONSTRAINT DF_Equipments_BaseRentalFee DEFAULT 0,
		SecurityDeposit DECIMAL(18,2) NOT NULL CONSTRAINT DF_Equipments_SecurityDeposit DEFAULT 0,
		CreatedAt DATETIME2(7) NOT NULL CONSTRAINT DF_Equipments_CreatedAt DEFAULT SYSUTCDATETIME()
	);
END
GO

IF COL_LENGTH(N'dbo.Equipments', N'BaseRentalFee') IS NULL
	ALTER TABLE dbo.Equipments ADD BaseRentalFee DECIMAL(18,2) NOT NULL CONSTRAINT DF_Equipments_BaseRentalFee_Upgrade DEFAULT 0;
GO
IF COL_LENGTH(N'dbo.Equipments', N'SecurityDeposit') IS NULL
	ALTER TABLE dbo.Equipments ADD SecurityDeposit DECIMAL(18,2) NOT NULL CONSTRAINT DF_Equipments_SecurityDeposit_Upgrade DEFAULT 0;
GO

IF OBJECT_ID(N'dbo.Transactions', N'U') IS NULL
BEGIN
	CREATE TABLE dbo.Transactions
	(
		TransactionID UNIQUEIDENTIFIER NOT NULL CONSTRAINT PK_Transactions PRIMARY KEY DEFAULT NEWSEQUENTIALID(),
		UserID UNIQUEIDENTIFIER NOT NULL,
		[Status] NVARCHAR(12) NOT NULL CONSTRAINT DF_Transactions_Status DEFAULT 'Ongoing',
		CreatedAt DATETIME2(7) NOT NULL CONSTRAINT DF_Transactions_CreatedAt DEFAULT SYSUTCDATETIME(),
		DueAt DATETIME2(7) NOT NULL,
		Receipt VARBINARY(MAX) NULL,
		ReturnConditionNotes NVARCHAR(500) NULL,
		IsArchived BIT NOT NULL CONSTRAINT DF_Transactions_IsArchived DEFAULT 0
	);
END
GO

IF COL_LENGTH(N'dbo.Users', N'IdentificationCard') IS NULL
	ALTER TABLE dbo.Users ADD IdentificationCard VARBINARY(MAX) NULL;
GO
IF OBJECT_ID(N'dbo.Users', N'U') IS NOT NULL
	ALTER TABLE dbo.Users ALTER COLUMN IdentificationCard VARBINARY(MAX) NULL;
GO
IF COL_LENGTH(N'dbo.Users', N'CreatedAt') IS NULL
	ALTER TABLE dbo.Users ADD CreatedAt DATETIME2(7) NOT NULL CONSTRAINT DF_Users_CreatedAt_Upgrade DEFAULT SYSUTCDATETIME();
GO
IF COL_LENGTH(N'dbo.Transactions', N'IsArchived') IS NULL
	ALTER TABLE dbo.Transactions ADD IsArchived BIT NOT NULL CONSTRAINT DF_Transactions_IsArchived_Upgrade DEFAULT 0;
GO
IF COL_LENGTH(N'dbo.Transactions', N'ReturnConditionNotes') IS NULL
	ALTER TABLE dbo.Transactions ADD ReturnConditionNotes NVARCHAR(500) NULL;
GO

IF OBJECT_ID(N'dbo.CK_Transactions_Status', N'C') IS NOT NULL
	ALTER TABLE dbo.Transactions DROP CONSTRAINT CK_Transactions_Status;
GO
ALTER TABLE dbo.Transactions
	ADD CONSTRAINT CK_Transactions_Status
	CHECK ([Status] IN (N'Ongoing', N'Overdue', N'Late', N'Done'));
GO

IF NOT EXISTS
(
	SELECT 1
	FROM sys.check_constraints
	WHERE name = N'CK_Users_Role'
	  AND parent_object_id = OBJECT_ID(N'dbo.Users')
)
BEGIN
	ALTER TABLE dbo.Users
		ADD CONSTRAINT CK_Users_Role CHECK (Role IN (N'RentalStaff', N'Admin'));
END
GO

IF OBJECT_ID(N'dbo.TransactionEquipments', N'U') IS NULL
BEGIN
	CREATE TABLE dbo.TransactionEquipments
	(
		TransactionID UNIQUEIDENTIFIER NOT NULL,
		EquipmentID UNIQUEIDENTIFIER NOT NULL,
		Quantity INT NOT NULL CONSTRAINT DF_TransactionEquipments_Quantity DEFAULT 1,
		RentalFee DECIMAL(18,2) NOT NULL CONSTRAINT DF_TransactionEquipments_RentalFee DEFAULT 0,
		DepositFee DECIMAL(18,2) NOT NULL CONSTRAINT DF_TransactionEquipments_DepositFee DEFAULT 0,
		CONSTRAINT PK_TransactionEquipments PRIMARY KEY (TransactionID, EquipmentID)

	);
END
GO

IF OBJECT_ID(N'dbo.TransactionPayment', N'U') IS NULL
BEGIN
	CREATE TABLE dbo.TransactionPayment
	(
		PaymentID UNIQUEIDENTIFIER NOT NULL CONSTRAINT PK_TransactionPayment PRIMARY KEY DEFAULT NEWSEQUENTIALID(),
		TransactionID UNIQUEIDENTIFIER NOT NULL,
		PaymentType NVARCHAR(30) NOT NULL,
		Amount DECIMAL(18,2) NOT NULL,
		PaymentMethod NVARCHAR(30) NOT NULL,
		CreatedAt DATETIME2(7) NOT NULL CONSTRAINT DF_TransactionPayment_CreatedAt DEFAULT SYSUTCDATETIME()
	);
END
GO

IF OBJECT_ID(N'dbo.Logs', N'U') IS NULL
BEGIN
	CREATE TABLE dbo.Logs
	(
		LogID UNIQUEIDENTIFIER NOT NULL CONSTRAINT PK_Logs PRIMARY KEY DEFAULT NEWSEQUENTIALID(),
		UserID UNIQUEIDENTIFIER NULL,
		UserLogged NVARCHAR(100) NOT NULL,
		LoggedAt DATETIME2(7) NOT NULL CONSTRAINT DF_Logs_LoggedAt DEFAULT SYSUTCDATETIME(),
		[Description] NVARCHAR(MAX) NULL
	);
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'UQ_Users_Email' AND object_id = OBJECT_ID(N'dbo.Users'))
	CREATE UNIQUE INDEX UQ_Users_Email ON dbo.Users(Email);
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'UQ_Equipments_SKU' AND object_id = OBJECT_ID(N'dbo.Equipments'))
	CREATE UNIQUE INDEX UQ_Equipments_SKU ON dbo.Equipments(SKU);
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_Transactions_UserID_Status' AND object_id = OBJECT_ID(N'dbo.Transactions'))
	CREATE INDEX IX_Transactions_UserID_Status ON dbo.Transactions(UserID, Status);
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_TransactionPayment_TransactionID' AND object_id = OBJECT_ID(N'dbo.TransactionPayment'))
	CREATE INDEX IX_TransactionPayment_TransactionID ON dbo.TransactionPayment(TransactionID);
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_Logs_UserID_LoggedAt' AND object_id = OBJECT_ID(N'dbo.Logs'))
	CREATE INDEX IX_Logs_UserID_LoggedAt ON dbo.Logs(UserID, LoggedAt DESC);
GO

IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'FK_Transactions_Users' AND parent_object_id = OBJECT_ID(N'dbo.Transactions'))
	ALTER TABLE dbo.Transactions DROP CONSTRAINT FK_Transactions_Users;
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'FK_Transactions_Customers' AND parent_object_id = OBJECT_ID(N'dbo.Transactions'))
	ALTER TABLE dbo.Transactions ADD CONSTRAINT FK_Transactions_Customers FOREIGN KEY (UserID) REFERENCES dbo.Customers(CustomerID);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'FK_TransactionEquipments_Transactions')
	ALTER TABLE dbo.TransactionEquipments ADD CONSTRAINT FK_TransactionEquipments_Transactions FOREIGN KEY (TransactionID) REFERENCES dbo.Transactions(TransactionID);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'FK_TransactionEquipments_Equipments')
	ALTER TABLE dbo.TransactionEquipments ADD CONSTRAINT FK_TransactionEquipments_Equipments FOREIGN KEY (EquipmentID) REFERENCES dbo.Equipments(EquipmentID);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'FK_TransactionPayment_Transactions')
	ALTER TABLE dbo.TransactionPayment ADD CONSTRAINT FK_TransactionPayment_Transactions FOREIGN KEY (TransactionID) REFERENCES dbo.Transactions(TransactionID);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'FK_Logs_Users')
	ALTER TABLE dbo.Logs ADD CONSTRAINT FK_Logs_Users FOREIGN KEY (UserID) REFERENCES dbo.Users(UserID);
GO

CREATE OR ALTER PROCEDURE dbo.usp_CreateCustomer
	@FirstName NVARCHAR(24), @LastName NVARCHAR(24), @Occupation NVARCHAR(32),
	@Email NVARCHAR(32), @MobileNumber NVARCHAR(12) = NULL,
	@OrganizationAddress NVARCHAR(300) = NULL, @IdentificationCard VARBINARY(MAX) = NULL,
	@UserID UNIQUEIDENTIFIER OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	SET @UserID = NEWID();
	INSERT INTO dbo.Customers(CustomerID, FirstName, LastName, Occupation, Email, MobileNumber, OrganizationAddress, IdentificationCard)
	VALUES(@UserID, @FirstName, @LastName, @Occupation, @Email, @MobileNumber, @OrganizationAddress, @IdentificationCard);
END
GO

CREATE OR ALTER PROCEDURE dbo.usp_GetCustomerById @UserID UNIQUEIDENTIFIER AS
BEGIN
	SET NOCOUNT ON;
	SELECT CustomerID, FirstName, LastName, Occupation, Email, MobileNumber, OrganizationAddress, IdentificationCard, CreatedAt
	FROM dbo.Customers WHERE CustomerID = @UserID;
END
GO

CREATE OR ALTER PROCEDURE dbo.usp_GetCustomerByEmail @Email NVARCHAR(32) AS
BEGIN
	SET NOCOUNT ON;
	SELECT CustomerID, FirstName, LastName, Occupation, Email, MobileNumber, OrganizationAddress, IdentificationCard, CreatedAt
	FROM dbo.Customers WHERE Email = @Email;
END
GO

CREATE OR ALTER PROCEDURE dbo.usp_SearchCustomers @Keyword NVARCHAR(32) = NULL AS
BEGIN
	SET NOCOUNT ON;
	SELECT CustomerID, FirstName, LastName, Occupation, Email, MobileNumber, OrganizationAddress, IdentificationCard, CreatedAt
	FROM dbo.Customers
	WHERE (@Keyword IS NULL OR @Keyword = N'' OR FirstName LIKE N'%' + @Keyword + N'%' OR LastName LIKE N'%' + @Keyword + N'%' OR MobileNumber LIKE N'%' + @Keyword + N'%' OR Email LIKE N'%' + @Keyword + N'%')
	ORDER BY LastName, FirstName;
END
GO

CREATE OR ALTER PROCEDURE dbo.usp_UpdateCustomer
	@UserID UNIQUEIDENTIFIER, @FirstName NVARCHAR(24), @LastName NVARCHAR(24), @Occupation NVARCHAR(32),
	@Email NVARCHAR(32), @MobileNumber NVARCHAR(12) = NULL, @OrganizationAddress NVARCHAR(300) = NULL,
	@IdentificationCard VARBINARY(MAX) = NULL
AS
BEGIN
	SET NOCOUNT ON;
	UPDATE dbo.Customers SET FirstName=@FirstName, LastName=@LastName, Occupation=@Occupation, Email=@Email,
		MobileNumber=@MobileNumber, OrganizationAddress=@OrganizationAddress,
		IdentificationCard=COALESCE(@IdentificationCard, IdentificationCard)
	WHERE CustomerID=@UserID;
END
GO

CREATE OR ALTER PROCEDURE dbo.usp_CreateEquipment
	@Category NVARCHAR(30), @Type NVARCHAR(30), @Status NVARCHAR(30), @Model NVARCHAR(200),
	@SKU NVARCHAR(100), @Image VARBINARY(MAX) = NULL, @Stock INT,
	@BaseRentalFee DECIMAL(18,2), @SecurityDeposit DECIMAL(18,2), @EquipmentID UNIQUEIDENTIFIER OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	SET @EquipmentID = NEWID();
	INSERT INTO dbo.Equipments(EquipmentID, Category, [Type], [Status], [Model], SKU, [Image], Stock, BaseRentalFee, SecurityDeposit)
	VALUES(@EquipmentID, @Category, @Type, @Status, @Model, @SKU, @Image, @Stock, @BaseRentalFee, @SecurityDeposit);
END
GO

CREATE OR ALTER PROCEDURE dbo.usp_UpdateEquipment
	@EquipmentID UNIQUEIDENTIFIER, @Type NVARCHAR(30), @Status NVARCHAR(30), @Stock INT,
	@BaseRentalFee DECIMAL(18,2), @SecurityDeposit DECIMAL(18,2)
AS
BEGIN
	SET NOCOUNT ON;
	UPDATE dbo.Equipments
	SET [Type] = @Type, [Status] = @Status, Stock = @Stock,
		BaseRentalFee = @BaseRentalFee, SecurityDeposit = @SecurityDeposit
	WHERE EquipmentID = @EquipmentID;
END
GO

CREATE OR ALTER PROCEDURE dbo.usp_SearchEquipment @Keyword NVARCHAR(200) = NULL AS
BEGIN
	SET NOCOUNT ON;
	SELECT EquipmentID, Category, [Type] AS Type, [Status] AS Status, [Model] AS Model, SKU, [Image] AS Image, Stock, BaseRentalFee, SecurityDeposit, CreatedAt
	FROM dbo.Equipments
	WHERE @Keyword IS NULL OR @Keyword = N'' OR [Model] LIKE N'%' + @Keyword + N'%' OR Category LIKE N'%' + @Keyword + N'%' OR SKU LIKE N'%' + @Keyword + N'%'
	ORDER BY CreatedAt DESC;
END
GO

CREATE OR ALTER PROCEDURE dbo.usp_GetEquipmentById @EquipmentID UNIQUEIDENTIFIER AS
BEGIN
	SET NOCOUNT ON;
	SELECT EquipmentID, Category, [Type] AS Type, [Status] AS Status, [Model] AS Model, SKU, [Image] AS Image, Stock, BaseRentalFee, SecurityDeposit, CreatedAt
	FROM dbo.Equipments WHERE EquipmentID=@EquipmentID;
END
GO

CREATE OR ALTER PROCEDURE dbo.usp_CreateTransaction @UserID UNIQUEIDENTIFIER, @DueAt DATETIME2(7), @TransactionID UNIQUEIDENTIFIER OUTPUT AS
BEGIN
	SET NOCOUNT ON;
	SET @TransactionID = NEWID();
	INSERT INTO dbo.Transactions(TransactionID, UserID, [Status], DueAt) VALUES(@TransactionID, @UserID, N'Ongoing', @DueAt);
END
GO

CREATE OR ALTER PROCEDURE dbo.usp_AddTransactionEquipment
	@TransactionID UNIQUEIDENTIFIER, @EquipmentID UNIQUEIDENTIFIER, @Quantity INT, @RentalFee DECIMAL(18,2), @DepositFee DECIMAL(18,2)
AS
BEGIN
	SET NOCOUNT ON;
	IF @Quantity <= 0 THROW 51000, 'Quantity must be greater than zero.', 1;
	UPDATE dbo.Equipments SET Stock = Stock - @Quantity, [Status] = CASE WHEN Stock - @Quantity <= 0 THEN N'Rented' ELSE [Status] END
	WHERE EquipmentID=@EquipmentID AND Stock >= @Quantity AND [Status] <> N'Maintenance';
	IF @@ROWCOUNT = 0 THROW 51001, 'Equipment is unavailable or has insufficient stock.', 1;
	INSERT INTO dbo.TransactionEquipments(TransactionID, EquipmentID, Quantity, RentalFee, DepositFee)
	VALUES(@TransactionID, @EquipmentID, @Quantity, @RentalFee, @DepositFee);
END
GO

CREATE OR ALTER PROCEDURE dbo.usp_GetActiveRentals AS
BEGIN
	SET NOCOUNT ON;
	UPDATE dbo.Transactions
	SET [Status]=CASE WHEN DueAt < DATEADD(DAY,-3,SYSUTCDATETIME()) THEN N'Overdue' ELSE N'Late' END
	WHERE IsArchived=0 AND [Status] IN(N'Ongoing',N'Overdue',N'Late') AND DueAt < SYSUTCDATETIME();
	SELECT t.TransactionID, t.UserID, c.FirstName, c.LastName, c.Email, c.MobileNumber, t.CreatedAt, t.DueAt, t.[Status] AS Status, t.IsArchived, t.Receipt
	FROM dbo.Transactions t INNER JOIN dbo.Customers c ON c.CustomerID=t.UserID
	WHERE t.[Status] IN(N'Ongoing',N'Overdue',N'Late') AND t.IsArchived=0 ORDER BY t.DueAt;
END
GO

CREATE OR ALTER PROCEDURE dbo.usp_GetTransactionLog AS
BEGIN
	SET NOCOUNT ON;
	UPDATE dbo.Transactions
	SET [Status]=CASE WHEN DueAt < DATEADD(DAY,-3,SYSUTCDATETIME()) THEN N'Overdue' ELSE N'Late' END
	WHERE IsArchived=0 AND [Status] IN(N'Ongoing',N'Overdue',N'Late') AND DueAt < SYSUTCDATETIME();
	SELECT t.TransactionID, t.UserID, c.FirstName, c.LastName, c.Email, c.MobileNumber, t.CreatedAt, t.DueAt, t.[Status] AS Status, t.IsArchived, t.Receipt
	FROM dbo.Transactions t INNER JOIN dbo.Customers c ON c.CustomerID=t.UserID WHERE t.IsArchived=0 ORDER BY t.CreatedAt DESC;
END
GO

CREATE OR ALTER PROCEDURE dbo.usp_GetTransactionsByCustomer @UserID UNIQUEIDENTIFIER AS
BEGIN
	SET NOCOUNT ON;
	SELECT t.TransactionID, t.UserID, c.FirstName, c.LastName, c.Email, c.MobileNumber, t.CreatedAt, t.DueAt, t.[Status] AS Status, t.IsArchived, t.Receipt
	FROM dbo.Transactions t INNER JOIN dbo.Customers c ON c.CustomerID=t.UserID
	WHERE t.UserID=@UserID ORDER BY t.CreatedAt DESC;
END
GO

CREATE OR ALTER PROCEDURE dbo.usp_GetTransactionById @TransactionID UNIQUEIDENTIFIER AS
BEGIN
	SET NOCOUNT ON;
	SELECT t.TransactionID, t.UserID, c.FirstName, c.LastName, c.Email, c.MobileNumber, t.CreatedAt, t.DueAt, t.[Status] AS Status, t.IsArchived, t.Receipt
	FROM dbo.Transactions t INNER JOIN dbo.Customers c ON c.CustomerID=t.UserID
	WHERE t.TransactionID=@TransactionID;
	SELECT te.TransactionID, te.EquipmentID, e.Model, e.SKU, e.Category, e.[Type] AS Type, e.[Status] AS Status, te.Quantity, te.RentalFee, te.DepositFee
	FROM dbo.TransactionEquipments te INNER JOIN dbo.Equipments e ON e.EquipmentID=te.EquipmentID WHERE te.TransactionID=@TransactionID;
END
GO

CREATE OR ALTER PROCEDURE dbo.usp_CompleteTransaction
	@TransactionID UNIQUEIDENTIFIER,
	@ReturnConditionNotes NVARCHAR(500) = NULL
AS
BEGIN
	SET NOCOUNT ON;
	UPDATE dbo.Transactions SET [Status]=N'Done', ReturnConditionNotes=@ReturnConditionNotes WHERE TransactionID=@TransactionID AND IsArchived=0 AND [Status]<>N'Done';
	IF @@ROWCOUNT = 0 RETURN;
	UPDATE e SET e.Stock=e.Stock+te.Quantity, e.[Status]=CASE WHEN e.[Status]=N'Rented' THEN N'Available' ELSE e.[Status] END
	FROM dbo.Equipments e INNER JOIN dbo.TransactionEquipments te ON te.EquipmentID=e.EquipmentID WHERE te.TransactionID=@TransactionID;
END
GO

CREATE OR ALTER PROCEDURE dbo.usp_ArchiveTransaction @TransactionID UNIQUEIDENTIFIER AS
BEGIN
	SET NOCOUNT ON;
	UPDATE dbo.Transactions SET IsArchived=1 WHERE TransactionID=@TransactionID AND [Status]=N'Done' AND IsArchived=0;
	SELECT CONVERT(BIT, CASE WHEN @@ROWCOUNT=1 THEN 1 ELSE 0 END) AS Archived;
END
GO

CREATE OR ALTER PROCEDURE dbo.usp_CreatePayment
	@TransactionID UNIQUEIDENTIFIER, @PaymentType NVARCHAR(30), @Amount DECIMAL(18,2), @PaymentMethod NVARCHAR(30), @PaymentID UNIQUEIDENTIFIER OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	SET @PaymentID=NEWID();
	INSERT INTO dbo.TransactionPayment(PaymentID, TransactionID, PaymentType, Amount, PaymentMethod) VALUES(@PaymentID,@TransactionID,@PaymentType,@Amount,@PaymentMethod);
END
GO

CREATE OR ALTER PROCEDURE dbo.usp_GetPaymentsByTransaction @TransactionID UNIQUEIDENTIFIER AS
BEGIN
	SET NOCOUNT ON;
	SELECT PaymentID, TransactionID, PaymentType, Amount, PaymentMethod, CreatedAt FROM dbo.TransactionPayment WHERE TransactionID=@TransactionID ORDER BY CreatedAt;
END
GO

CREATE OR ALTER PROCEDURE dbo.usp_GetPaymentActivity
	@PageNumber INT = 1,
	@PageSize INT = 10,
	@SearchTerm NVARCHAR(200) = NULL,
	@SortDirection NVARCHAR(10) = 'DESC',
	@TotalCount INT = NULL OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

	IF @PageNumber < 1 SET @PageNumber = 1;
	IF @PageSize < 1 SET @PageSize = 10;

	SELECT @TotalCount = COUNT(*)
	FROM dbo.TransactionPayment p
	WHERE (
		@SearchTerm IS NULL
		OR CAST(p.PaymentID AS NVARCHAR(36)) LIKE '%' + @SearchTerm + '%'
		OR CAST(p.TransactionID AS NVARCHAR(36)) LIKE '%' + @SearchTerm + '%'
		OR p.PaymentType LIKE '%' + @SearchTerm + '%'
		OR p.PaymentMethod LIKE '%' + @SearchTerm + '%'
		OR CAST(p.Amount AS NVARCHAR(30)) LIKE '%' + @SearchTerm + '%'
		OR CONVERT(NVARCHAR(30), p.CreatedAt, 120) LIKE '%' + @SearchTerm + '%'
	);

	DECLARE @Offset INT = (@PageNumber - 1) * @PageSize;

	IF (UPPER(@SortDirection) = 'ASC')
	BEGIN
		SELECT PaymentID, TransactionID, PaymentType, Amount, PaymentMethod, CreatedAt
		FROM dbo.TransactionPayment p
		WHERE (
			@SearchTerm IS NULL
			OR CAST(p.PaymentID AS NVARCHAR(36)) LIKE '%' + @SearchTerm + '%'
			OR CAST(p.TransactionID AS NVARCHAR(36)) LIKE '%' + @SearchTerm + '%'
			OR p.PaymentType LIKE '%' + @SearchTerm + '%'
			OR p.PaymentMethod LIKE '%' + @SearchTerm + '%'
			OR CAST(p.Amount AS NVARCHAR(30)) LIKE '%' + @SearchTerm + '%'
			OR CONVERT(NVARCHAR(30), p.CreatedAt, 120) LIKE '%' + @SearchTerm + '%'
		)
		ORDER BY CreatedAt ASC
		OFFSET @Offset ROWS FETCH NEXT @PageSize ROWS ONLY;
	END
	ELSE
	BEGIN
		SELECT PaymentID, TransactionID, PaymentType, Amount, PaymentMethod, CreatedAt
		FROM dbo.TransactionPayment p
		WHERE (
			@SearchTerm IS NULL
			OR CAST(p.PaymentID AS NVARCHAR(36)) LIKE '%' + @SearchTerm + '%'
			OR CAST(p.TransactionID AS NVARCHAR(36)) LIKE '%' + @SearchTerm + '%'
			OR p.PaymentType LIKE '%' + @SearchTerm + '%'
			OR p.PaymentMethod LIKE '%' + @SearchTerm + '%'
			OR CAST(p.Amount AS NVARCHAR(30)) LIKE '%' + @SearchTerm + '%'
			OR CONVERT(NVARCHAR(30), p.CreatedAt, 120) LIKE '%' + @SearchTerm + '%'
		)
		ORDER BY CreatedAt DESC
		OFFSET @Offset ROWS FETCH NEXT @PageSize ROWS ONLY;
	END
END
GO

CREATE OR ALTER PROCEDURE dbo.usp_InsertAudit
	@UserID UNIQUEIDENTIFIER, @UserLogged NVARCHAR(100), @Description NVARCHAR(MAX)=NULL, @LogID UNIQUEIDENTIFIER OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	SET @LogID=NEWID();
	INSERT INTO dbo.Logs(LogID, UserID, UserLogged, [Description]) VALUES(@LogID,@UserID,@UserLogged,@Description);
END
GO

CREATE OR ALTER PROCEDURE dbo.usp_GetRecentAudits @MaxRows INT=100 AS
BEGIN
	SET NOCOUNT ON;
	SELECT TOP (@MaxRows) l.LogID, l.UserID, l.UserLogged, u.Role, l.LoggedAt, l.[Description] AS Description
	FROM dbo.Logs l LEFT JOIN dbo.Users u ON u.UserID = l.UserID ORDER BY l.LoggedAt DESC;
END
GO
