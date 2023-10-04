CREATE PROCEDURE sp_ex_4
AS
BEGIN
	DECLARE @n AS INT
	DECLARE @soma AS INT
	SET @n = 50
	SET @soma = 0
	WHILE (@n <= 100)
	BEGIN
		IF (@n % 2 ) = 0
		BEGIN
			PRINT CAST(@n AS VARCHAR) + '+' +  CAST(@soma AS VARCHAR)
			SET @soma = @soma + @n
			PRINT '=' + CAST(@soma AS VARCHAR)
		END
		--PRINT @soma
		SET @n = @n + 1
	END
END
