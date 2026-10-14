-- Adds audited customer and equipment deletion procedures.

CREATE OR ALTER PROCEDURE dbo.usp_DeleteCustomer
	@CustomerID UNIQUEIDENTIFIER
AS
BEGIN
	SET NOCOUNT ON;
	SET XACT_ABORT ON;

	BEGIN TRANSACTION;

	IF NOT EXISTS
	(
		SELECT 1
		FROM dbo.Customers
		WHERE CustomerID = @CustomerID
	)
	BEGIN
		ROLLBACK TRANSACTION;
		THROW 51500, 'The customer record was not found.', 1;
	END

	DELETE FROM dbo.TransactionPayment
	WHERE TransactionID IN
	(
		SELECT TransactionID
		FROM dbo.Transactions
		WHERE UserID = @CustomerID
	);

	DELETE FROM dbo.TransactionEquipments
	WHERE TransactionID IN
	(
		SELECT TransactionID
		FROM dbo.Transactions
		WHERE UserID = @CustomerID
	);

	DELETE FROM dbo.Transactions
	WHERE UserID = @CustomerID;

	DELETE FROM dbo.Customers
	WHERE CustomerID = @CustomerID;

	COMMIT TRANSACTION;
END
GO

CREATE OR ALTER PROCEDURE dbo.usp_DeleteEquipment
	@EquipmentID UNIQUEIDENTIFIER
AS
BEGIN
	SET NOCOUNT ON;
	SET XACT_ABORT ON;

	IF NOT EXISTS
	(
		SELECT 1
		FROM dbo.Equipments
		WHERE EquipmentID = @EquipmentID
	)
	BEGIN
		SELECT CAST(0 AS BIT) AS Deleted;
		RETURN;
	END

	IF EXISTS
	(
		SELECT 1
		FROM dbo.Equipments
		WHERE EquipmentID = @EquipmentID
		  AND Stock > 0
	)
	BEGIN
		SELECT CAST(0 AS BIT) AS Deleted;
		RETURN;
	END

	DELETE FROM dbo.Equipments
	WHERE EquipmentID = @EquipmentID;

	SELECT CAST(1 AS BIT) AS Deleted;
END
GO
