-- Stored procedures for the Techrent ERD contract.
GO
CREATE OR ALTER PROCEDURE dbo.usp_CreateCustomer
	@FirstName NVARCHAR(24),
	@LastName NVARCHAR(24),
	@Occupation NVARCHAR(32),
	@Email NVARCHAR(32),
	@MobileNumber NVARCHAR(12) = NULL,
	@OrganizationAddress NVARCHAR(300) = NULL,
	@IdentificationCard VARBINARY(MAX),
	@UserID UNIQUEIDENTIFIER OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	SET @UserID = NEWID();
	INSERT INTO dbo.Users (UserID, FirstName, LastName, Role, Occupation, Email, MobileNumber, OrganizationAddress, IdentificationCard)
	VALUES (@UserID, @FirstName, @LastName, 'Customer', @Occupation, @Email, @MobileNumber, @OrganizationAddress, @IdentificationCard);
END
GO

CREATE OR ALTER PROCEDURE dbo.usp_GetCustomerById
	@UserID UNIQUEIDENTIFIER
AS
BEGIN
	SET NOCOUNT ON;
	SELECT UserID, FirstName, LastName, Role, Occupation, Email, MobileNumber, OrganizationAddress, IdentificationCard, CreatedAt
	FROM dbo.Users
	WHERE UserID = @UserID AND Role = 'Customer';
END
GO

CREATE OR ALTER PROCEDURE dbo.usp_GetCustomerByEmail
	@Email NVARCHAR(32)
AS
BEGIN
	SET NOCOUNT ON;
	SELECT UserID, FirstName, LastName, Role, Occupation, Email, MobileNumber, OrganizationAddress, IdentificationCard, CreatedAt
	FROM dbo.Users
	WHERE Email = @Email AND Role = 'Customer';
END
GO

CREATE OR ALTER PROCEDURE dbo.usp_SearchCustomers
	@Keyword NVARCHAR(32) = NULL
AS
BEGIN
	SET NOCOUNT ON;
	SELECT UserID, FirstName, LastName, Role, Occupation, Email, MobileNumber, OrganizationAddress, IdentificationCard, CreatedAt
	FROM dbo.Users
	WHERE Role = 'Customer'
	  AND (@Keyword IS NULL OR FirstName LIKE '%' + @Keyword + '%' OR LastName LIKE '%' + @Keyword + '%'
			  OR MobileNumber LIKE '%' + @Keyword + '%' OR Email LIKE '%' + @Keyword + '%');
END
GO

CREATE OR ALTER PROCEDURE dbo.usp_UpdateCustomer
	@UserID UNIQUEIDENTIFIER,
	@FirstName NVARCHAR(24),
	@LastName NVARCHAR(24),
	@Occupation NVARCHAR(32),
	@Email NVARCHAR(32),
	@MobileNumber NVARCHAR(12) = NULL,
	@OrganizationAddress NVARCHAR(300) = NULL,
	@IdentificationCard VARBINARY(MAX) = NULL
AS
BEGIN
	SET NOCOUNT ON;
	UPDATE dbo.Users
	SET FirstName = @FirstName, LastName = @LastName, Occupation = @Occupation, Email = @Email,
		MobileNumber = @MobileNumber, OrganizationAddress = @OrganizationAddress, IdentificationCard = @IdentificationCard
	WHERE UserID = @UserID AND Role = 'Customer';
END
GO

CREATE OR ALTER PROCEDURE dbo.usp_CreateEquipment
	@Category NVARCHAR(30),
	@Type NVARCHAR(30),
	@Status NVARCHAR(30),
	@Model NVARCHAR(200),
	@SKU NVARCHAR(100),
	@Image VARBINARY(MAX) = NULL,
	@Stock INT,
	@BaseRentalFee DECIMAL(18,2),
	@SecurityDeposit DECIMAL(18,2),
	@EquipmentID UNIQUEIDENTIFIER OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	SET @EquipmentID = NEWID();
	INSERT INTO dbo.Equipments (EquipmentID, Category, Type, Status, Model, SKU, Image, Stock, BaseRentalFee, SecurityDeposit)
	VALUES (@EquipmentID, @Category, @Type, @Status, @Model, @SKU, @Image, @Stock, @BaseRentalFee, @SecurityDeposit);
END
GO

CREATE OR ALTER PROCEDURE dbo.usp_SearchEquipment
	@Keyword NVARCHAR(200) = NULL
AS
BEGIN
	SET NOCOUNT ON;
	SELECT EquipmentID, Category, Type, Status, Model, SKU, Image, Stock, BaseRentalFee, SecurityDeposit, CreatedAt
	FROM dbo.Equipments
	WHERE @Keyword IS NULL OR Model LIKE '%' + @Keyword + '%' OR Category LIKE '%' + @Keyword + '%' OR SKU LIKE '%' + @Keyword + '%';
END
GO

CREATE OR ALTER PROCEDURE dbo.usp_GetEquipmentById
	@EquipmentID UNIQUEIDENTIFIER
AS
BEGIN
	SET NOCOUNT ON;
	SELECT EquipmentID, Category, Type, Status, Model, SKU, Image, Stock, BaseRentalFee, SecurityDeposit, CreatedAt
	FROM dbo.Equipments
	WHERE EquipmentID = @EquipmentID;
END
GO

CREATE OR ALTER PROCEDURE dbo.usp_UpdateEquipment
	@EquipmentID UNIQUEIDENTIFIER,
	@Type NVARCHAR(30),
	@Status NVARCHAR(30),
	@Stock INT,
	@BaseRentalFee DECIMAL(18,2),
	@SecurityDeposit DECIMAL(18,2)
AS
BEGIN
	SET NOCOUNT ON;
	UPDATE dbo.Equipments
	SET [Type] = @Type, [Status] = @Status, Stock = @Stock,
		BaseRentalFee = @BaseRentalFee, SecurityDeposit = @SecurityDeposit
	WHERE EquipmentID = @EquipmentID;
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
	IF @DueAt <= @StartAt OR @BillableHours <= 0 THROW 51000, 'The rental period and billable hours are invalid.', 1;
	SET @TransactionID = NEWID();
	INSERT INTO dbo.Transactions (TransactionID, UserID, Status, StartAt, DueAt, BillableHours)
	VALUES (@TransactionID, @UserID, 'Ongoing', @StartAt, @DueAt, @BillableHours);
END
GO

CREATE OR ALTER PROCEDURE dbo.usp_AddTransactionEquipment
	@TransactionID UNIQUEIDENTIFIER,
	@EquipmentID UNIQUEIDENTIFIER,
	@Quantity INT,
	@RentalFee DECIMAL(18,2),
	@DepositFee DECIMAL(18,2)
AS
BEGIN
	SET NOCOUNT ON;
	INSERT INTO dbo.TransactionEquipments (TransactionID, EquipmentID, Quantity, RentalFee, DepositFee)
	VALUES (@TransactionID, @EquipmentID, @Quantity, @RentalFee, @DepositFee);
	UPDATE dbo.Equipments SET Stock = Stock - @Quantity WHERE EquipmentID = @EquipmentID;
END
GO

CREATE OR ALTER PROCEDURE dbo.usp_GetActiveRentals
AS
BEGIN
	SET NOCOUNT ON;
	UPDATE dbo.Transactions
	SET Status = CASE WHEN DueAt < DATEADD(DAY, -3, SYSUTCDATETIME()) THEN 'Overdue' ELSE 'Late' END
	WHERE IsArchived = 0 AND Status IN ('Ongoing', 'Overdue', 'Late') AND DueAt < SYSUTCDATETIME();
	SELECT t.TransactionID, t.UserID, u.FirstName, u.LastName, t.CreatedAt, t.StartAt, t.DueAt, t.BillableHours, t.Status, t.IsArchived, t.Receipt
	FROM dbo.Transactions t
	INNER JOIN dbo.Users u ON u.UserID = t.UserID
	WHERE t.Status IN ('Ongoing', 'Overdue', 'Late')
	  AND t.IsArchived = 0
	ORDER BY t.DueAt ASC;
END
GO

CREATE OR ALTER PROCEDURE dbo.usp_GetTransactionLog
AS
BEGIN
	SET NOCOUNT ON;
	UPDATE dbo.Transactions
	SET Status = CASE WHEN DueAt < DATEADD(DAY, -3, SYSUTCDATETIME()) THEN 'Overdue' ELSE 'Late' END
	WHERE IsArchived = 0 AND Status IN ('Ongoing', 'Overdue', 'Late') AND DueAt < SYSUTCDATETIME();
	SELECT t.TransactionID, t.UserID, u.FirstName, u.LastName, u.Email, u.MobileNumber,
		   t.CreatedAt, t.StartAt, t.DueAt, t.BillableHours, t.Status, t.IsArchived, t.Receipt
	FROM dbo.Transactions t
	INNER JOIN dbo.Users u ON u.UserID = t.UserID
	WHERE t.IsArchived = 0
	ORDER BY t.CreatedAt DESC;
END
GO

CREATE OR ALTER PROCEDURE dbo.usp_GetTransactionById
	@TransactionID UNIQUEIDENTIFIER
AS
BEGIN
	SET NOCOUNT ON;
	SELECT t.TransactionID, t.UserID, u.FirstName, u.LastName, u.Email, u.MobileNumber, t.CreatedAt, t.StartAt, t.DueAt, t.BillableHours, t.Status, t.IsArchived, t.Receipt
	FROM dbo.Transactions t
	INNER JOIN dbo.Users u ON u.UserID = t.UserID
	WHERE t.TransactionID = @TransactionID;

	SELECT te.TransactionID, te.EquipmentID, e.Model, e.SKU, e.Category, e.Type, e.Status, te.Quantity, te.RentalFee, te.DepositFee
	FROM dbo.TransactionEquipments te
	INNER JOIN dbo.Equipments e ON e.EquipmentID = te.EquipmentID
	WHERE te.TransactionID = @TransactionID;
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

CREATE OR ALTER PROCEDURE dbo.usp_CreatePayment
	@TransactionID UNIQUEIDENTIFIER,
	@PaymentType NVARCHAR(30),
	@Amount DECIMAL(18,2),
	@PaymentMethod NVARCHAR(30),
	@PaymentID UNIQUEIDENTIFIER OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	SET @PaymentID = NEWID();
	INSERT INTO dbo.TransactionPayment (PaymentID, TransactionID, PaymentType, Amount, PaymentMethod)
	VALUES (@PaymentID, @TransactionID, @PaymentType, @Amount, @PaymentMethod);
END
GO

CREATE OR ALTER PROCEDURE dbo.usp_GetPaymentsByTransaction
	@TransactionID UNIQUEIDENTIFIER
AS
BEGIN
	SET NOCOUNT ON;
	SELECT PaymentID, TransactionID, PaymentType, Amount, PaymentMethod, CreatedAt
	FROM dbo.TransactionPayment
	WHERE TransactionID = @TransactionID
	ORDER BY CreatedAt;
END
GO

CREATE OR ALTER PROCEDURE dbo.usp_GetPaymentActivity
AS
BEGIN
	SET NOCOUNT ON;
	SELECT PaymentID, TransactionID, PaymentType, Amount, PaymentMethod, CreatedAt
	FROM dbo.TransactionPayment
	ORDER BY CreatedAt DESC;
END
GO

CREATE OR ALTER PROCEDURE dbo.usp_InsertAudit
	@UserID UNIQUEIDENTIFIER,
	@UserLogged NVARCHAR(100),
	@Description NVARCHAR(MAX) = NULL,
	@LogID UNIQUEIDENTIFIER OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	SET @LogID = NEWID();
	INSERT INTO dbo.Logs (LogID, UserID, UserLogged, Description)
	VALUES (@LogID, @UserID, @UserLogged, @Description);
END
GO

CREATE OR ALTER PROCEDURE dbo.usp_GetRecentAudits
	@MaxRows INT = 100
AS
BEGIN
	SET NOCOUNT ON;
	SELECT TOP (@MaxRows) l.LogID, l.UserID, l.UserLogged, u.Role, l.LoggedAt, l.Description
	FROM dbo.Logs l
	LEFT JOIN dbo.Users u ON u.UserID = l.UserID
	ORDER BY l.LoggedAt DESC;
END
GO