-- Split customers out of Users into a dedicated Customers table and remap Transactions.
-- This script is idempotent and preserves existing GUIDs for customers.

IF OBJECT_ID(N'dbo.Customers', N'U') IS NULL
BEGIN
	CREATE TABLE dbo.Customers
	(
		CustomerID UNIQUEIDENTIFIER NOT NULL CONSTRAINT PK_Customers PRIMARY KEY,
		FirstName NVARCHAR(24) NOT NULL,
		LastName NVARCHAR(24) NOT NULL,
		Occupation NVARCHAR(32) NOT NULL CONSTRAINT CK_Customers_Occupation CHECK (Occupation IN ('Student','Employed','Unemployed','Other')),
		Email NVARCHAR(32) NOT NULL,
		MobileNumber NVARCHAR(12) NULL,
		OrganizationAddress NVARCHAR(300) NULL,
		IdentificationCard VARBINARY(MAX) NULL,
		CreatedAt DATETIME2(7) NOT NULL DEFAULT SYSUTCDATETIME(),
		CONSTRAINT UQ_Customers_Email UNIQUE (Email)
	);
END
GO

CREATE OR ALTER PROCEDURE dbo.usp_GetTransactionsByCustomer
	@UserID UNIQUEIDENTIFIER
AS
BEGIN
	SET NOCOUNT ON;
	SELECT t.TransactionID, t.UserID, c.FirstName, c.LastName,
		   t.CreatedAt, t.DueAt, t.Status, t.IsArchived, t.Receipt
	FROM dbo.Transactions t
	INNER JOIN dbo.Customers c ON c.CustomerID = t.UserID
	WHERE t.UserID = @UserID
	ORDER BY t.CreatedAt DESC;
END
GO

-- Copy existing customer rows from Users preserving UserID as CustomerID
INSERT INTO dbo.Customers (CustomerID, FirstName, LastName, Occupation, Email, MobileNumber, OrganizationAddress, IdentificationCard, CreatedAt)
SELECT u.UserID, u.FirstName, u.LastName, u.Occupation, u.Email, u.MobileNumber, u.OrganizationAddress, u.IdentificationCard, u.CreatedAt
FROM dbo.Users u
WHERE u.Role = 'Customer'
  AND NOT EXISTS (SELECT 1 FROM dbo.Customers c WHERE c.CustomerID = u.UserID);
GO

-- Update Transactions foreign key: point UserID to Customers.CustomerID instead of Users.UserID
-- Drop existing FK if present
IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'FK_Transactions_Users' AND parent_object_id = OBJECT_ID(N'dbo.Transactions'))
BEGIN
	ALTER TABLE dbo.Transactions DROP CONSTRAINT FK_Transactions_Users;
END
GO

-- Add new foreign key constraint to Customers (column remains UserID for compatibility)
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'FK_Transactions_Customers' AND parent_object_id = OBJECT_ID(N'dbo.Transactions'))
BEGIN
	ALTER TABLE dbo.Transactions
	ADD CONSTRAINT FK_Transactions_Customers FOREIGN KEY (UserID) REFERENCES dbo.Customers(CustomerID);
END
GO

-- Null out audit logs that refer to migrated customer users so we can delete their user rows safely
UPDATE dbo.Logs
SET UserID = NULL
WHERE UserID IN (SELECT UserID FROM dbo.Users WHERE Role = 'Customer');
GO

-- Delete migrated customer rows from Users now that Transactions and Customers have been remapped
DELETE FROM dbo.Users WHERE Role = 'Customer';
GO

-- Restrict Users role constraint to Admin and RentalStaff only
IF OBJECT_ID(N'dbo.CK_Users_Role', N'C') IS NOT NULL
BEGIN
	ALTER TABLE dbo.Users DROP CONSTRAINT CK_Users_Role;
END
GO

IF NOT EXISTS
(
	SELECT 1
	FROM sys.check_constraints
	WHERE name = N'CK_Users_Role'
	  AND parent_object_id = OBJECT_ID(N'dbo.Users')
)
BEGIN
	ALTER TABLE dbo.Users ADD CONSTRAINT CK_Users_Role CHECK (Role IN ('RentalStaff','Admin'));
END
GO

-- Recreate customer stored procedures to operate on dbo.Customers
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
	INSERT INTO dbo.Customers (CustomerID, FirstName, LastName, Occupation, Email, MobileNumber, OrganizationAddress, IdentificationCard)
	VALUES (@UserID, @FirstName, @LastName, @Occupation, @Email, @MobileNumber, @OrganizationAddress, @IdentificationCard);
END
GO

CREATE OR ALTER PROCEDURE dbo.usp_GetCustomerById
	@UserID UNIQUEIDENTIFIER
AS
BEGIN
	SET NOCOUNT ON;
	SELECT CustomerID, FirstName, LastName, Occupation, Email, MobileNumber, OrganizationAddress, IdentificationCard, CreatedAt
	FROM dbo.Customers
	WHERE CustomerID = @UserID;
END
GO

CREATE OR ALTER PROCEDURE dbo.usp_GetCustomerByEmail
	@Email NVARCHAR(32)
AS
BEGIN
	SET NOCOUNT ON;
	SELECT CustomerID, FirstName, LastName, Occupation, Email, MobileNumber, OrganizationAddress, IdentificationCard, CreatedAt
	FROM dbo.Customers
	WHERE Email = @Email;
END
GO

CREATE OR ALTER PROCEDURE dbo.usp_SearchCustomers
	@Keyword NVARCHAR(32) = NULL
AS
BEGIN
	SET NOCOUNT ON;
	SELECT CustomerID, FirstName, LastName, Occupation, Email, MobileNumber, OrganizationAddress, IdentificationCard, CreatedAt
	FROM dbo.Customers
	WHERE (@Keyword IS NULL OR FirstName LIKE '%' + @Keyword + '%' OR LastName LIKE '%' + @Keyword + '%' OR MobileNumber LIKE '%' + @Keyword + '%' OR Email LIKE '%' + @Keyword + '%');
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
	UPDATE dbo.Customers
	SET FirstName = @FirstName, LastName = @LastName, Occupation = @Occupation, Email = @Email,
		MobileNumber = @MobileNumber, OrganizationAddress = @OrganizationAddress, IdentificationCard = @IdentificationCard
	WHERE CustomerID = @UserID;
END
GO

-- Update transaction stored procedures to join Customers for customer name fields
CREATE OR ALTER PROCEDURE dbo.usp_GetActiveRentals
AS
BEGIN
	SET NOCOUNT ON;
	UPDATE dbo.Transactions
	SET Status = CASE WHEN DueAt < DATEADD(DAY, -3, SYSUTCDATETIME()) THEN 'Overdue' ELSE 'Late' END
	WHERE IsArchived = 0 AND Status IN ('Ongoing', 'Overdue', 'Late') AND DueAt < SYSUTCDATETIME();
	SELECT t.TransactionID, t.UserID, c.FirstName, c.LastName, t.CreatedAt, t.DueAt, t.Status, t.IsArchived, t.Receipt
	FROM dbo.Transactions t
	INNER JOIN dbo.Customers c ON c.CustomerID = t.UserID
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
	SELECT t.TransactionID, t.UserID, c.FirstName, c.LastName,
		   t.CreatedAt, t.DueAt, t.Status, t.IsArchived, t.Receipt
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
	SELECT t.TransactionID, t.UserID, c.FirstName, c.LastName, t.CreatedAt, t.DueAt, t.Status, t.IsArchived, t.Receipt
	FROM dbo.Transactions t
	INNER JOIN dbo.Customers c ON c.CustomerID = t.UserID
	WHERE t.TransactionID = @TransactionID;

	SELECT te.TransactionID, te.EquipmentID, e.Model, e.SKU, e.Category, e.Type, e.Status, te.Quantity, te.RentalFee, te.DepositFee
	FROM dbo.TransactionEquipments te
	INNER JOIN dbo.Equipments e ON e.EquipmentID = te.EquipmentID
	WHERE te.TransactionID = @TransactionID;
END
GO
