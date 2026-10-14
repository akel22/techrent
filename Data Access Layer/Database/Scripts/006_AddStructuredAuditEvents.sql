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

CREATE OR ALTER PROCEDURE dbo.usp_InsertAudit
	@UserID UNIQUEIDENTIFIER,
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
