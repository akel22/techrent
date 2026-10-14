-- Stored procedure to search and page audit logs
-- Parameters:
-- @Page INT, @PageSize INT
-- @DateFrom DATETIME = NULL, @DateTo DATETIME = NULL
-- @Category NVARCHAR(30) = NULL, @Query NVARCHAR(200) = NULL
-- @TotalRows INT OUTPUT

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER PROCEDURE dbo.usp_SearchAudits
	@Page INT,
	@PageSize INT,
	@DateFrom DATETIME = NULL,
	@DateTo DATETIME = NULL,
	@Category NVARCHAR(30) = NULL,
	@Query NVARCHAR(200) = NULL,
	@TotalRows INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

	-- Normalize query for LIKE matching
	DECLARE @q NVARCHAR(200) = NULL;
	IF (@Query IS NOT NULL AND LTRIM(RTRIM(@Query)) <> '')
		SET @q = '%' + LTRIM(RTRIM(@Query)) + '%';

	-- Compute total rows
	SELECT @TotalRows = COUNT(1)
	FROM dbo.Logs l
	LEFT JOIN dbo.Users u ON l.UserID = u.UserID
	WHERE (@DateFrom IS NULL OR CAST(l.LoggedAt AS DATE) >= CAST(@DateFrom AS DATE))
	  AND (@DateTo IS NULL OR CAST(l.LoggedAt AS DATE) <= CAST(@DateTo AS DATE))
	  AND (@Category IS NULL OR @Category = '' OR l.Category = @Category)
	  AND (
			@q IS NULL
			OR l.UserLogged LIKE @q
			OR ISNULL(u.Role, '') LIKE @q
			OR ISNULL(l.Category, '') LIKE @q
			OR ISNULL(l.EventType, '') LIKE @q
			OR ISNULL(l.Description, '') LIKE @q
		  );

	;WITH Ordered AS (
		SELECT
			l.LogID,
			l.UserID,
			l.UserLogged,
			u.Role,
			l.LoggedAt,
			l.Category,
			l.EventType,
			l.Description,
			ROW_NUMBER() OVER (ORDER BY l.LoggedAt DESC, l.LogID DESC) AS rn
		FROM dbo.Logs l
		LEFT JOIN dbo.Users u ON l.UserID = u.UserID
		WHERE (@DateFrom IS NULL OR CAST(l.LoggedAt AS DATE) >= CAST(@DateFrom AS DATE))
		  AND (@DateTo IS NULL OR CAST(l.LoggedAt AS DATE) <= CAST(@DateTo AS DATE))
		  AND (@Category IS NULL OR @Category = '' OR l.Category = @Category)
		  AND (
				@q IS NULL
				OR l.UserLogged LIKE @q
				OR ISNULL(u.Role, '') LIKE @q
				OR ISNULL(l.Category, '') LIKE @q
				OR ISNULL(l.EventType, '') LIKE @q
				OR ISNULL(l.Description, '') LIKE @q
			  )
	)
	SELECT
		LogID,
		UserID,
		UserLogged,
		Role,
		LoggedAt,
		Category,
		EventType,
		Description
	FROM Ordered
	WHERE rn > (@Page - 1) * @PageSize
	  AND rn <= @Page * @PageSize
	ORDER BY rn;
END
GO
