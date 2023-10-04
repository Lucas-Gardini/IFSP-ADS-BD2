-- Exemplo FUNCTION

-- Função escalar (scalar functions)
CREATE FUNCTION dbo.SomaDoisNumeros
(
    @Numero1 INT,
    @Numero2 INT
)
RETURNS INT
AS
BEGIN
    DECLARE @Resultado INT
    SET @Resultado = @Numero1 + @Numero2
    RETURN @Resultado
END;

-- Função inline
