-- Incremental payment activity migration for existing Techrent databases.
CREATE OR ALTER PROCEDURE dbo.usp_GetPaymentActivity
	@PageNumber INT = 1,
	@PageSize INT = 10,
	@SearchTerm NVARCHAR(200) = NULL,
	@SortDirection NVARCHAR(10) = 'DESC',
	@TotalCount INT = NULL OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

	IF @PageNumber < 1 SET @PageNumber = 1;
	IF @PageSize < 1 SET @PageSize = 10;

	-- Calculate total matching rows
	SELECT @TotalCount = COUNT(*)
	FROM dbo.TransactionPayment p
	WHERE (
		@SearchTerm IS NULL
		OR CAST(p.PaymentID AS NVARCHAR(36)) LIKE '%' + @SearchTerm + '%'
		OR CAST(p.TransactionID AS NVARCHAR(36)) LIKE '%' + @SearchTerm + '%'
		OR p.PaymentType LIKE '%' + @SearchTerm + '%'
		OR p.PaymentMethod LIKE '%' + @SearchTerm + '%'
		OR CAST(p.Amount AS NVARCHAR(30)) LIKE '%' + @SearchTerm + '%'
		OR CONVERT(NVARCHAR(30), p.CreatedAt, 120) LIKE '%' + @SearchTerm + '%'
	);

	DECLARE @Offset INT = (@PageNumber - 1) * @PageSize;

	-- Return the requested page
	IF (UPPER(@SortDirection) = 'ASC')
	BEGIN
		SELECT PaymentID, TransactionID, PaymentType, Amount, PaymentMethod, CreatedAt
		FROM dbo.TransactionPayment p
		WHERE (
			@SearchTerm IS NULL
			OR CAST(p.PaymentID AS NVARCHAR(36)) LIKE '%' + @SearchTerm + '%'
			OR CAST(p.TransactionID AS NVARCHAR(36)) LIKE '%' + @SearchTerm + '%'
			OR p.PaymentType LIKE '%' + @SearchTerm + '%'
			OR p.PaymentMethod LIKE '%' + @SearchTerm + '%'
			OR CAST(p.Amount AS NVARCHAR(30)) LIKE '%' + @SearchTerm + '%'
			OR CONVERT(NVARCHAR(30), p.CreatedAt, 120) LIKE '%' + @SearchTerm + '%'
		)
		ORDER BY CreatedAt ASC
		OFFSET @Offset ROWS FETCH NEXT @PageSize ROWS ONLY;
	END
	ELSE
	BEGIN
		SELECT PaymentID, TransactionID, PaymentType, Amount, PaymentMethod, CreatedAt
		FROM dbo.TransactionPayment p
		WHERE (
			@SearchTerm IS NULL
			OR CAST(p.PaymentID AS NVARCHAR(36)) LIKE '%' + @SearchTerm + '%'
			OR CAST(p.TransactionID AS NVARCHAR(36)) LIKE '%' + @SearchTerm + '%'
			OR p.PaymentType LIKE '%' + @SearchTerm + '%'
			OR p.PaymentMethod LIKE '%' + @SearchTerm + '%'
			OR CAST(p.Amount AS NVARCHAR(30)) LIKE '%' + @SearchTerm + '%'
			OR CONVERT(NVARCHAR(30), p.CreatedAt, 120) LIKE '%' + @SearchTerm + '%'
		)
		ORDER BY CreatedAt DESC
		OFFSET @Offset ROWS FETCH NEXT @PageSize ROWS ONLY;
	END
END
GO
