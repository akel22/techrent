-- Stored procedure skeletons for Techrent
GO
CREATE PROCEDURE dbo.usp_CreateCustomer
	@FullName NVARCHAR(200),
	@Mobile NVARCHAR(50) = NULL,
	@Email NVARCHAR(200) = NULL,
	@CustomerId INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	INSERT INTO dbo.Customers (FullName, Mobile, Email)
	VALUES (@FullName, @Mobile, @Email);
	SET @CustomerId = SCOPE_IDENTITY();
END
GO

CREATE PROCEDURE dbo.usp_GetCustomerById
	@CustomerId INT
AS
BEGIN
	SET NOCOUNT ON;
	SELECT CustomerId, CustomerCode, FullName, Mobile, Email, CreatedAt FROM dbo.Customers WHERE CustomerId = @CustomerId;
END
GO

CREATE PROCEDURE dbo.usp_GetCustomerByCode
	@CustomerCode NVARCHAR(50)
AS
BEGIN
	SET NOCOUNT ON;
	SELECT CustomerId, CustomerCode, FullName, Mobile, Email, CreatedAt FROM dbo.Customers WHERE CustomerCode = @CustomerCode;
END
GO

CREATE PROCEDURE dbo.usp_SearchCustomers
	@Keyword NVARCHAR(200)
AS
BEGIN
	SET NOCOUNT ON;
	SELECT CustomerId, CustomerCode, FullName, Mobile, Email, CreatedAt
	FROM dbo.Customers
	WHERE @Keyword IS NULL OR FullName LIKE '%' + @Keyword + '%' OR Mobile LIKE '%' + @Keyword + '%' OR Email LIKE '%' + @Keyword + '%';
END
GO

CREATE PROCEDURE dbo.usp_UpdateCustomer
	@CustomerId INT,
	@FullName NVARCHAR(200),
	@Mobile NVARCHAR(50) = NULL,
	@Email NVARCHAR(200) = NULL
AS
BEGIN
	SET NOCOUNT ON;
	UPDATE dbo.Customers SET FullName = @FullName, Mobile = @Mobile, Email = @Email WHERE CustomerId = @CustomerId;
END
GO

CREATE PROCEDURE dbo.usp_SearchEquipment
	@Keyword NVARCHAR(200) = NULL
AS
BEGIN
	SET NOCOUNT ON;
	SELECT EquipmentId, Name, Category, RentalRate, AvailableQuantity
	FROM dbo.Equipment
	WHERE @Keyword IS NULL OR Name LIKE '%' + @Keyword + '%' OR Category LIKE '%' + @Keyword + '%';
END
GO

CREATE PROCEDURE dbo.usp_GetEquipmentById
	@EquipmentId INT
AS
BEGIN
	SET NOCOUNT ON;
	SELECT EquipmentId, Name, Category, RentalRate, AvailableQuantity FROM dbo.Equipment WHERE EquipmentId = @EquipmentId;
END
GO

CREATE PROCEDURE dbo.usp_IsSerialAvailable
	@SerialNumber NVARCHAR(100),
	@IsAvailable BIT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	IF EXISTS (SELECT 1 FROM dbo.RentalItems WHERE SerialNumber = @SerialNumber)
		SET @IsAvailable = 0;
	ELSE
		SET @IsAvailable = 1;
END
GO

CREATE PROCEDURE dbo.usp_CreateRental
	@CustomerId INT,
	@DueDate DATETIME2,
	@RentalFee DECIMAL(18,2),
	@SecurityDeposit DECIMAL(18,2),
	@RentalTransactionId INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	INSERT INTO dbo.RentalTransactions (CustomerId, DueDate, RentalFee, SecurityDeposit)
	VALUES (@CustomerId, @DueDate, @RentalFee, @SecurityDeposit);
	SET @RentalTransactionId = SCOPE_IDENTITY();
END
GO

CREATE PROCEDURE dbo.usp_AddRentalItem
	@RentalTransactionId INT,
	@EquipmentId INT,
	@Quantity INT,
	@SerialNumber NVARCHAR(100) = NULL
AS
BEGIN
	SET NOCOUNT ON;
	INSERT INTO dbo.RentalItems (RentalTransactionId, EquipmentId, Quantity, SerialNumber, Rate)
	VALUES (@RentalTransactionId, @EquipmentId, @Quantity, @SerialNumber, (SELECT RentalRate FROM dbo.Equipment WHERE EquipmentId = @EquipmentId));
	UPDATE dbo.Equipment SET AvailableQuantity = AvailableQuantity - @Quantity WHERE EquipmentId = @EquipmentId;
END
GO

CREATE PROCEDURE dbo.usp_GetActiveRentals
AS
BEGIN
	SET NOCOUNT ON;
	SELECT rt.RentalTransactionId, rt.TransactionCode, rt.CustomerId, c.FullName AS CustomerName, rt.CreatedAt, rt.DueDate, rt.Status, rt.RentalFee, rt.SecurityDeposit
	FROM dbo.RentalTransactions rt
	JOIN dbo.Customers c ON c.CustomerId = rt.CustomerId
	WHERE rt.Status = 'Ongoing'
	ORDER BY rt.DueDate ASC;
END
GO

CREATE PROCEDURE dbo.usp_GetRentalById
	@RentalTransactionId INT
AS
BEGIN
	SET NOCOUNT ON;
	SELECT rt.RentalTransactionId, rt.TransactionCode, rt.CustomerId, c.FullName AS CustomerName, rt.CreatedAt, rt.DueDate, rt.Status, rt.RentalFee, rt.SecurityDeposit
	FROM dbo.RentalTransactions rt
	JOIN dbo.Customers c ON c.CustomerId = rt.CustomerId
	WHERE rt.RentalTransactionId = @RentalTransactionId;

	SELECT ri.RentalItemId, ri.EquipmentId, e.Name AS EquipmentName, ri.SerialNumber, ri.Quantity, ri.Rate
	FROM dbo.RentalItems ri
	JOIN dbo.Equipment e ON e.EquipmentId = ri.EquipmentId
	WHERE ri.RentalTransactionId = @RentalTransactionId;
END
GO

CREATE PROCEDURE dbo.usp_CompleteRental
	@RentalTransactionId INT
AS
BEGIN
	SET NOCOUNT ON;
	UPDATE dbo.RentalTransactions SET Status = 'Done' WHERE RentalTransactionId = @RentalTransactionId;
	-- Optionally make returned equipment available again: omitted here to keep behavior explicit
END
GO

CREATE PROCEDURE dbo.usp_InsertAudit
	@Category NVARCHAR(100) = NULL,
	@Description NVARCHAR(MAX) = NULL,
	@PerformedBy NVARCHAR(200) = NULL
AS
BEGIN
	SET NOCOUNT ON;
	INSERT INTO dbo.AuditLogs (Category, Description, PerformedBy)
	VALUES (@Category, @Description, @PerformedBy);
END
GO

CREATE PROCEDURE dbo.usp_GetRecentAudits
	@MaxRows INT = 100
AS
BEGIN
	SET NOCOUNT ON;
	SELECT TOP(@MaxRows) AuditId, Category, Description, PerformedBy, CreatedAt FROM dbo.AuditLogs ORDER BY CreatedAt DESC;
END
GO
