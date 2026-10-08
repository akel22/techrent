-- ERD schema for Techrent (development)
IF OBJECT_ID(N'dbo.TransactionPayment', N'U') IS NOT NULL DROP TABLE dbo.TransactionPayment;
IF OBJECT_ID(N'dbo.TransactionEquipments', N'U') IS NOT NULL DROP TABLE dbo.TransactionEquipments;
IF OBJECT_ID(N'dbo.Logs', N'U') IS NOT NULL DROP TABLE dbo.Logs;
IF OBJECT_ID(N'dbo.Transactions', N'U') IS NOT NULL DROP TABLE dbo.Transactions;
IF OBJECT_ID(N'dbo.Equipments', N'U') IS NOT NULL DROP TABLE dbo.Equipments;
IF OBJECT_ID(N'dbo.Users', N'U') IS NOT NULL DROP TABLE dbo.Users;

CREATE TABLE dbo.Users
(
	UserID UNIQUEIDENTIFIER NOT NULL CONSTRAINT PK_Users PRIMARY KEY DEFAULT NEWSEQUENTIALID(),
	FirstName NVARCHAR(24) NOT NULL,
	LastName NVARCHAR(24) NOT NULL,
	Role NVARCHAR(24) NOT NULL CONSTRAINT CK_Users_Role CHECK (Role IN ('Customer', 'RentalStaff', 'Admin')),
	Occupation NVARCHAR(32) NOT NULL CONSTRAINT CK_Users_Occupation CHECK (Occupation IN ('Student', 'Employed', 'Unemployed', 'Other')),
	Email NVARCHAR(32) NOT NULL,
	MobileNumber NVARCHAR(12) NULL,
	OrganizationAddress NVARCHAR(300) NULL,
	IdentificationCard VARBINARY(MAX) NOT NULL,
	CreatedAt DATETIME2(7) NOT NULL CONSTRAINT DF_Users_CreatedAt DEFAULT SYSUTCDATETIME(),
	CONSTRAINT UQ_Users_Email UNIQUE (Email)
);

CREATE TABLE dbo.Equipments
(
	EquipmentID UNIQUEIDENTIFIER NOT NULL CONSTRAINT PK_Equipments PRIMARY KEY DEFAULT NEWSEQUENTIALID(),
	Category NVARCHAR(30) NOT NULL CONSTRAINT CK_Equipments_Category CHECK (Category IN ('Laptop', 'Desktop', 'Monitor', 'Projector', 'Peripheral', 'Other')),
	"Type" NVARCHAR(30) NOT NULL CONSTRAINT CK_Equipments_Type CHECK (Type IN ('Obsolete', 'Standard', 'Professional')),
	"Status" NVARCHAR(30) NOT NULL CONSTRAINT CK_Equipments_Status CHECK (Status IN ('Available', 'Rented', 'Maintenance')),
	"Model" NVARCHAR(200) NOT NULL,
	SKU NVARCHAR(100) NOT NULL,
	"Image" VARBINARY(MAX) NULL,
	Stock INT NOT NULL CONSTRAINT DF_Equipments_Stock DEFAULT 0,
	BaseRentalFee DECIMAL(18,2) NOT NULL CONSTRAINT DF_Equipments_BaseRentalFee DEFAULT 0,
	SecurityDeposit DECIMAL(18,2) NOT NULL CONSTRAINT DF_Equipments_SecurityDeposit DEFAULT 0,
	CreatedAt DATETIME2(7) NOT NULL CONSTRAINT DF_Equipments_CreatedAt DEFAULT SYSUTCDATETIME(),
	CONSTRAINT UQ_Equipments_SKU UNIQUE (SKU),
	CONSTRAINT CK_Equipments_Stock CHECK (Stock >= 0),
	CONSTRAINT CK_Equipments_BaseRentalFee CHECK (BaseRentalFee >= 0),
	CONSTRAINT CK_Equipments_SecurityDeposit CHECK (SecurityDeposit >= 0)
);

CREATE TABLE dbo.Transactions
(
	TransactionID UNIQUEIDENTIFIER NOT NULL CONSTRAINT PK_Transactions PRIMARY KEY DEFAULT NEWSEQUENTIALID(),
	UserID UNIQUEIDENTIFIER NOT NULL,
	"Status" NVARCHAR(12) NOT NULL CONSTRAINT DF_Transactions_Status DEFAULT 'Ongoing',
	CreatedAt DATETIME2(7) NOT NULL CONSTRAINT DF_Transactions_CreatedAt DEFAULT SYSUTCDATETIME(),
	DueAt DATETIME2(7) NOT NULL,
	Receipt VARBINARY(MAX) NULL,
	ReturnConditionNotes NVARCHAR(500) NULL,
	CONSTRAINT FK_Transactions_Users FOREIGN KEY (UserID) REFERENCES dbo.Users(UserID),
	CONSTRAINT CK_Transactions_Status CHECK (Status IN ('Ongoing', 'Overdue', 'Late', 'Done'))
);

CREATE TABLE dbo.TransactionEquipments
(
	TransactionID UNIQUEIDENTIFIER NOT NULL,
	EquipmentID UNIQUEIDENTIFIER NOT NULL,
	Quantity INT NOT NULL CONSTRAINT DF_TransactionEquipments_Quantity DEFAULT 1,
	RentalFee DECIMAL(18,2) NOT NULL CONSTRAINT DF_TransactionEquipments_RentalFee DEFAULT 0,
	DepositFee DECIMAL(18,2) NOT NULL CONSTRAINT DF_TransactionEquipments_DepositFee DEFAULT 0,
	CONSTRAINT PK_TransactionEquipments PRIMARY KEY (TransactionID, EquipmentID),
	CONSTRAINT FK_TransactionEquipments_Transactions FOREIGN KEY (TransactionID) REFERENCES dbo.Transactions(TransactionID),
	CONSTRAINT FK_TransactionEquipments_Equipments FOREIGN KEY (EquipmentID) REFERENCES dbo.Equipments(EquipmentID),
	CONSTRAINT CK_TransactionEquipments_Quantity CHECK (Quantity > 0),
	CONSTRAINT CK_TransactionEquipments_RentalFee CHECK (RentalFee >= 0),
	CONSTRAINT CK_TransactionEquipments_DepositFee CHECK (DepositFee >= 0)
);

CREATE TABLE dbo.TransactionPayment
(
	PaymentID UNIQUEIDENTIFIER NOT NULL CONSTRAINT PK_TransactionPayment PRIMARY KEY DEFAULT NEWSEQUENTIALID(),
	TransactionID UNIQUEIDENTIFIER NOT NULL,
	PaymentType NVARCHAR(20) NOT NULL CONSTRAINT CK_TransactionPayment_PaymentType CHECK (PaymentType IN ('RentalFee', 'Deposit', 'LateFee')),
	Amount DECIMAL(18,2) NOT NULL,
	PaymentMethod NVARCHAR(30) NOT NULL CONSTRAINT CK_TransactionPayment_PaymentMethod CHECK (PaymentMethod IN ('Cash', 'GCash')),
	CreatedAt DATETIME2(7) NOT NULL CONSTRAINT DF_TransactionPayment_CreatedAt DEFAULT SYSUTCDATETIME(),
	CONSTRAINT FK_TransactionPayment_Transactions FOREIGN KEY (TransactionID) REFERENCES dbo.Transactions(TransactionID),
	CONSTRAINT CK_TransactionPayment_Amount CHECK (Amount >= 0)
);

CREATE TABLE dbo.Logs
(
	LogID UNIQUEIDENTIFIER NOT NULL CONSTRAINT PK_Logs PRIMARY KEY DEFAULT NEWSEQUENTIALID(),
	UserID UNIQUEIDENTIFIER NOT NULL,
	UserLogged VARCHAR(32) NOT NULL,
	LoggedAt DATETIME2(7) NOT NULL CONSTRAINT DF_Logs_LoggedAt DEFAULT SYSUTCDATETIME(),
	"Description" NVARCHAR(MAX) NULL,
	CONSTRAINT FK_Logs_Users FOREIGN KEY (UserID) REFERENCES dbo.Users(UserID)
);

CREATE INDEX IX_Transactions_UserID_Status ON dbo.Transactions (UserID, Status);
CREATE INDEX IX_TransactionPayment_TransactionID ON dbo.TransactionPayment (TransactionID);
CREATE INDEX IX_Logs_UserID_LoggedAt ON dbo.Logs (UserID, LoggedAt DESC);
