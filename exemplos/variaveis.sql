-- Exemplo VARIÁVEIS

CREATE PROCEDURE sp_variaveis
AS
BEGIN
	DECLARE @I INT;
	SET @I = 0;
	WHILE @I < 10
	BEGIN
		PRINT @I;
		SET @I = @I + 1;
	END;
END;
GO

EXECUTE sp_variaveis;