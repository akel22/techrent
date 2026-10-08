-- Incremental audit event migration for existing Techrent databases.
IF COL_LENGTH(N'dbo.Logs', N'Category') IS NULL
BEGIN
	ALTER TABLE dbo.Logs ADD Category NVARCHAR(30) NULL;
END
GO

IF COL_LENGTH(N'dbo.Logs', N'EventType') IS NULL
BEGIN
	ALTER TABLE dbo.Logs ADD EventType NVARCHAR(60) NULL;
END
GO

IF COL_LENGTH(N'dbo.Logs', N'Outcome') IS NULL
BEGIN
	ALTER TABLE dbo.Logs ADD Outcome NVARCHAR(20) NULL;
END
GO

IF COL_LENGTH(N'dbo.Logs', N'AffectedRecordType') IS NULL
BEGIN
	ALTER TABLE dbo.Logs ADD AffectedRecordType NVARCHAR(40) NULL;
END
GO

IF COL_LENGTH(N'dbo.Logs', N'AffectedRecordId') IS NULL
BEGIN
	ALTER TABLE dbo.Logs ADD AffectedRecordId NVARCHAR(100) NULL;
END
GO

IF COL_LENGTH(N'dbo.Logs', N'FailureDetail') IS NULL
BEGIN
	ALTER TABLE dbo.Logs ADD FailureDetail NVARCHAR(1000) NULL;
END
GO

IF NOT EXISTS
(
	SELECT 1
	FROM sys.indexes
	WHERE name = N'IX_Logs_Category_Outcome_LoggedAt'
	  AND object_id = OBJECT_ID(N'dbo.Logs')
)
BEGIN
	CREATE INDEX IX_Logs_Category_Outcome_LoggedAt
		ON dbo.Logs (Category, Outcome, LoggedAt DESC);
END
GO

CREATE OR ALTER PROCEDURE dbo.usp_InsertAudit
	@UserID UNIQUEIDENTIFIER,
	@UserLogged NVARCHAR(100),
	@Category NVARCHAR(30) = NULL,
	@EventType NVARCHAR(60) = NULL,
	@Outcome NVARCHAR(20) = NULL,
	@AffectedRecordType NVARCHAR(40) = NULL,
	@AffectedRecordId NVARCHAR(100) = NULL,
	@Description NVARCHAR(MAX) = NULL,
	@FailureDetail NVARCHAR(1000) = NULL,
	@LogID UNIQUEIDENTIFIER OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	SET @LogID = NEWID();

	INSERT INTO dbo.Logs
	(
		LogID,
		UserID,
		UserLogged,
		Category,
		EventType,
		Outcome,
		AffectedRecordType,
		AffectedRecordId,
		Description,
		FailureDetail
	)
	VALUES
	(
		@LogID,
		@UserID,
		@UserLogged,
		@Category,
		@EventType,
		@Outcome,
		@AffectedRecordType,
		@AffectedRecordId,
		@Description,
		@FailureDetail
	);
END
GO

CREATE OR ALTER PROCEDURE dbo.usp_GetRecentAudits
	@MaxRows INT = 100
AS
BEGIN
	SET NOCOUNT ON;

	SELECT TOP (@MaxRows)
		l.LogID,
		l.UserID,
		l.UserLogged,
		u.Role,
		l.LoggedAt,
		l.Category,
		l.EventType,
		l.Outcome,
		l.AffectedRecordType,
		l.AffectedRecordId,
		l.Description,
		l.FailureDetail
	FROM dbo.Logs l
	LEFT JOIN dbo.Users u ON u.UserID = l.UserID
	ORDER BY l.LoggedAt DESC;
END
GO
