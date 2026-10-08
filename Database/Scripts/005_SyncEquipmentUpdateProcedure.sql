-- Synchronizes the equipment update procedure for databases deployed before the current equipment contract.
GO
CREATE OR ALTER PROCEDURE dbo.usp_UpdateEquipment
	@EquipmentID UNIQUEIDENTIFIER,
	@Type NVARCHAR(30),
	@Status NVARCHAR(30),
	@Stock INT,
	@BaseRentalFee DECIMAL(18,2),
	@SecurityDeposit DECIMAL(18,2)
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE dbo.Equipments
	SET [Type] = @Type,
		[Status] = @Status,
		Stock = @Stock,
		BaseRentalFee = @BaseRentalFee,
		SecurityDeposit = @SecurityDeposit
	WHERE EquipmentID = @EquipmentID;
END
GO
