-- Basic schema for Techrent (development)
CREATE TABLE [dbo].[Customers]
(
	CustomerId INT IDENTITY(1,1) PRIMARY KEY,
	CustomerCode AS ('CUS-' + RIGHT('0000' + CAST(CustomerId AS VARCHAR(4)),4)) PERSISTED,
	FullName NVARCHAR(200) NOT NULL,
	Mobile NVARCHAR(50) NULL,
	Email NVARCHAR(200) NULL,
	CreatedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME()
);

CREATE TABLE [dbo].[Equipment]
(
	EquipmentId INT IDENTITY(1,1) PRIMARY KEY,
	Name NVARCHAR(200) NOT NULL,
	Category NVARCHAR(100) NULL,
	RentalRate DECIMAL(18,2) NOT NULL DEFAULT 0,
	AvailableQuantity INT NOT NULL DEFAULT 0
);

CREATE TABLE [dbo].[RentalTransactions]
(
	RentalTransactionId INT IDENTITY(1,1) PRIMARY KEY,
	TransactionCode AS ('TRX-' + FORMAT(RentalTransactionId,'0000')) PERSISTED,
	CustomerId INT NOT NULL REFERENCES dbo.Customers(CustomerId),
	CreatedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
	DueDate DATETIME2 NOT NULL,
	Status NVARCHAR(50) NOT NULL DEFAULT 'Ongoing',
	RentalFee DECIMAL(18,2) NOT NULL DEFAULT 0,
	SecurityDeposit DECIMAL(18,2) NOT NULL DEFAULT 0
);

CREATE TABLE [dbo].[RentalItems]
(
	RentalItemId INT IDENTITY(1,1) PRIMARY KEY,
	RentalTransactionId INT NOT NULL REFERENCES dbo.RentalTransactions(RentalTransactionId),
	EquipmentId INT NOT NULL REFERENCES dbo.Equipment(EquipmentId),
	SerialNumber NVARCHAR(100) NULL,
	Quantity INT NOT NULL DEFAULT 1,
	Rate DECIMAL(18,2) NOT NULL DEFAULT 0
);

CREATE TABLE [dbo].[AuditLogs]
(
	AuditId INT IDENTITY(1,1) PRIMARY KEY,
	Category NVARCHAR(100) NULL,
	Description NVARCHAR(MAX) NULL,
	PerformedBy NVARCHAR(200) NULL,
	CreatedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME()
);
