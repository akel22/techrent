-- Incremental authentication migration for existing Techrent databases.
IF COL_LENGTH(N'dbo.Users', N'PasswordHash') IS NULL
BEGIN
	ALTER TABLE dbo.Users ADD PasswordHash VARBINARY(64) NULL;
END
GO

IF COL_LENGTH(N'dbo.Users', N'PasswordSalt') IS NULL
BEGIN
	ALTER TABLE dbo.Users ADD PasswordSalt VARBINARY(32) NULL;
END
GO

CREATE OR ALTER PROCEDURE dbo.usp_CreateAuthenticatedUser
	@FirstName NVARCHAR(24),
	@LastName NVARCHAR(24),
	@Email NVARCHAR(32),
	@Role NVARCHAR(24),
	@PasswordHash VARBINARY(64),
	@PasswordSalt VARBINARY(32),
	@CanProvision BIT,
	@UserID UNIQUEIDENTIFIER OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

	IF @Role NOT IN ('Admin', 'RentalStaff')
		THROW 51010, 'Only Admin and RentalStaff users can be registered.', 1;

	IF EXISTS (SELECT 1 FROM dbo.Users) AND ISNULL(@CanProvision, 0) = 0
		THROW 51011, 'Only an authenticated administrator can register additional users.', 1;

	SET @UserID = NEWID();
	INSERT INTO dbo.Users
	(
		UserID, FirstName, LastName, Role, Occupation, Email,
		IdentificationCard, PasswordHash, PasswordSalt, IsActive
	)
	VALUES
	(
		@UserID, @FirstName, @LastName, @Role, 'Other', @Email,
		NULL, @PasswordHash, @PasswordSalt, 1
	);
END
GO

IF COL_LENGTH(N'dbo.Users', N'IsActive') IS NULL
BEGIN
	ALTER TABLE dbo.Users ADD IsActive BIT NOT NULL
		CONSTRAINT DF_Users_IsActive DEFAULT 1;
END
GO

CREATE OR ALTER PROCEDURE dbo.usp_GetUserForAuthentication
	@Email NVARCHAR(32)
AS
BEGIN
	SET NOCOUNT ON;

	SELECT UserID, FirstName, LastName, Role, Email, PasswordHash, PasswordSalt, IsActive
	FROM dbo.Users
	WHERE Email = @Email
	  AND Role IN ('Admin', 'RentalStaff')
	  AND IsActive = 1;
END
GO

CREATE OR ALTER PROCEDURE dbo.usp_GetUserForAuthorization
	@UserID UNIQUEIDENTIFIER
AS
BEGIN
	SET NOCOUNT ON;

	SELECT UserID, FirstName, LastName, Role, Email, PasswordHash, PasswordSalt, IsActive
	FROM dbo.Users
	WHERE UserID = @UserID;
END
GO

CREATE OR ALTER PROCEDURE dbo.usp_SetUserPassword
	@UserID UNIQUEIDENTIFIER,
	@PasswordHash VARBINARY(64),
	@PasswordSalt VARBINARY(32)
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE dbo.Users
	SET PasswordHash = @PasswordHash,
		PasswordSalt = @PasswordSalt
	WHERE UserID = @UserID
	  AND Role IN ('Admin', 'RentalStaff')
	  AND IsActive = 1;

	SELECT CAST(CASE WHEN @@ROWCOUNT = 1 THEN 1 ELSE 0 END AS BIT) AS PasswordUpdated;
END
GO
