-- Exemplo PROCEDURE
CREATE PROCEDURE exemplo_procedure AS BEGIN
SELECT
	COUNT(*) AS TotalClientes
FROM
	Clientes;
END
GO

EXEC exemplo_procedure;
GO

-- Exemplo PROCEDURE com PARÂMETROS
CREATE PROCEDURE exemplo_procedure_parametros(
	@exemp_num AS int,
	@exemp_nome AS varchar(20),
	@exemp_cid AS varchar(20),
	@exemp_categ AS varchar(1)
) AS
INSERT INTO
	Exemplo(ENro, ENome, ECidade, ECateg)
VALUES
	(
		@exemp_num,
		@exemp_nome,
		@exemp_cid,
		@exemp_categ
	);
GO

EXEC exemplo_procedure_parametros 1,
'Nome',
'Cidade',
'C';
GO

-- Exemplo PROCEDURE com GROUP BY
CREATE PROCEDURE sp_pecas_totais AS 
BEGIN
	SELECT 	P.PeNro, P.PeNome, SUM(P.PePreco * FP.Quant) total
	FROM Peca P, Fornece_Para FP
	WHERE P.PeNro = FP.PeNro
	GROUP BY P.PeNro, P.PeNome
END
GO