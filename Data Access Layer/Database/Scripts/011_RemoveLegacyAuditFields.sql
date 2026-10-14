-- Removes legacy audit fields after procedures have been updated to use the supported audit contract.

CREATE OR ALTER PROCEDURE dbo.usp_InsertAudit
	@UserID UNIQUEIDENTIFIER = NULL,
	@UserLogged NVARCHAR(100),
	@Category NVARCHAR(30) = NULL,
	@EventType NVARCHAR(60) = NULL,
	@Description NVARCHAR(MAX) = NULL,
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
		Description
	)
	VALUES
	(
		@LogID,
		@UserID,
		@UserLogged,
		@Category,
		@EventType,
		@Description
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
		l.Description
	FROM dbo.Logs l
	LEFT JOIN dbo.Users u ON u.UserID = l.UserID
	ORDER BY l.LoggedAt DESC;
END
GO

IF EXISTS
(
	SELECT 1
	FROM sys.indexes
	WHERE name = N'IX_Logs_Category_Outcome_LoggedAt'
	  AND object_id = OBJECT_ID(N'dbo.Logs')
)
BEGIN
	DROP INDEX IX_Logs_Category_Outcome_LoggedAt ON dbo.Logs;
END
GO

IF NOT EXISTS
(
	SELECT 1
	FROM sys.indexes
	WHERE name = N'IX_Logs_Category_LoggedAt'
	  AND object_id = OBJECT_ID(N'dbo.Logs')
)
BEGIN
	CREATE INDEX IX_Logs_Category_LoggedAt
		ON dbo.Logs (Category, LoggedAt DESC);
END
GO

IF COL_LENGTH(N'dbo.Logs', N'Outcome') IS NOT NULL
	ALTER TABLE dbo.Logs DROP COLUMN Outcome;
GO

IF COL_LENGTH(N'dbo.Logs', N'AffectedRecordType') IS NOT NULL
	ALTER TABLE dbo.Logs DROP COLUMN AffectedRecordType;
GO

IF COL_LENGTH(N'dbo.Logs', N'AffectedRecordId') IS NOT NULL
	ALTER TABLE dbo.Logs DROP COLUMN AffectedRecordId;
GO

IF COL_LENGTH(N'dbo.Logs', N'FailureDetail') IS NOT NULL
	ALTER TABLE dbo.Logs DROP COLUMN FailureDetail;
GO
