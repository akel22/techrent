-- Allows audit records for anonymous authentication failures.
IF EXISTS
(
	SELECT 1
	FROM sys.columns
	WHERE object_id = OBJECT_ID(N'dbo.Logs')
	  AND name = N'UserID'
	  AND is_nullable = 0
)
BEGIN
	ALTER TABLE dbo.Logs ALTER COLUMN UserID UNIQUEIDENTIFIER NULL;
END
GO

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
		LogID, UserID, UserLogged, Category, EventType, Description
	)
	VALUES
	(
		@LogID, @UserID, @UserLogged, @Category, @EventType, @Description
	);
END
GO
