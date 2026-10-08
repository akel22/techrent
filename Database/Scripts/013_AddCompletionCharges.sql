-- Allows return-related charges to be recorded when an active rental is completed.
IF EXISTS (SELECT 1 FROM sys.check_constraints WHERE name = N'CK_TransactionPayment_PaymentType' AND parent_object_id = OBJECT_ID(N'dbo.TransactionPayment'))
BEGIN
	ALTER TABLE dbo.TransactionPayment DROP CONSTRAINT CK_TransactionPayment_PaymentType;
END
GO

ALTER TABLE dbo.TransactionPayment
	ADD CONSTRAINT CK_TransactionPayment_PaymentType CHECK (PaymentType IN ('RentalFee', 'Deposit', 'LateFee', 'DamageCharge'));
GO

CREATE OR ALTER PROCEDURE dbo.usp_CompleteTransaction
	@TransactionID UNIQUEIDENTIFIER,
	@ReturnConditionNotes NVARCHAR(500) = NULL
AS
BEGIN
	SET NOCOUNT ON;

	IF NOT EXISTS (
		SELECT 1
		FROM dbo.Transactions
		WHERE TransactionID = @TransactionID
		  AND IsArchived = 0
		  AND Status <> 'Done'
	)
	BEGIN
		THROW 50001, 'The transaction is missing, archived, or already completed.', 1;
	END

	UPDATE dbo.Transactions
	SET Status = 'Done',
		ReturnConditionNotes = @ReturnConditionNotes
	WHERE TransactionID = @TransactionID
	  AND IsArchived = 0
	  AND Status <> 'Done';
END
GO

CREATE OR ALTER PROCEDURE dbo.usp_CreatePayment
	@TransactionID UNIQUEIDENTIFIER,
	@PaymentType NVARCHAR(30),
	@Amount DECIMAL(18,2),
	@PaymentMethod NVARCHAR(30),
	@PaymentID UNIQUEIDENTIFIER OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

	IF @PaymentType NOT IN ('RentalFee', 'Deposit', 'LateFee', 'DamageCharge')
		THROW 50002, 'The payment type is not supported.', 1;

	IF @PaymentMethod NOT IN ('Cash', 'GCash')
		THROW 50003, 'The payment method is not supported.', 1;

	IF @Amount < 0
		THROW 50004, 'The payment amount cannot be negative.', 1;

	IF NOT EXISTS (SELECT 1 FROM dbo.Transactions WHERE TransactionID = @TransactionID AND IsArchived = 0)
		THROW 50005, 'The transaction is missing or archived.', 1;

	SET @PaymentID = NEWID();
	INSERT INTO dbo.TransactionPayment (PaymentID, TransactionID, PaymentType, Amount, PaymentMethod)
	VALUES (@PaymentID, @TransactionID, @PaymentType, @Amount, @PaymentMethod);
END
GO
