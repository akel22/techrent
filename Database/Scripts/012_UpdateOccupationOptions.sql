-- Replace legacy occupation values and enforce the current occupation options.
IF OBJECT_ID(N'dbo.Users', N'U') IS NOT NULL
BEGIN
	UPDATE dbo.Users
	SET Occupation = CASE
		WHEN Occupation = N'Employee' THEN N'Employed'
		WHEN Occupation = N'Organization' THEN N'Other'
		ELSE Occupation
	END
	WHERE Occupation IN (N'Employee', N'Organization');

	IF EXISTS (SELECT 1 FROM sys.check_constraints WHERE name = N'CK_Users_Occupation' AND parent_object_id = OBJECT_ID(N'dbo.Users'))
		ALTER TABLE dbo.Users DROP CONSTRAINT CK_Users_Occupation;

	ALTER TABLE dbo.Users ADD CONSTRAINT CK_Users_Occupation
		CHECK (Occupation IN (N'Student', N'Employed', N'Unemployed', N'Other'));
END
GO

IF OBJECT_ID(N'dbo.Customers', N'U') IS NOT NULL
BEGIN
	UPDATE dbo.Customers
	SET Occupation = CASE
		WHEN Occupation = N'Employee' THEN N'Employed'
		WHEN Occupation = N'Organization' THEN N'Other'
		ELSE Occupation
	END
	WHERE Occupation IN (N'Employee', N'Organization');

	IF EXISTS (SELECT 1 FROM sys.check_constraints WHERE name = N'CK_Customers_Occupation' AND parent_object_id = OBJECT_ID(N'dbo.Customers'))
		ALTER TABLE dbo.Customers DROP CONSTRAINT CK_Customers_Occupation;

	ALTER TABLE dbo.Customers ADD CONSTRAINT CK_Customers_Occupation
		CHECK (Occupation IN (N'Student', N'Employed', N'Unemployed', N'Other'));
END
GO
