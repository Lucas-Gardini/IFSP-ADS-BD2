USE Fabrica
GO

-- 1. Crie uma Stored Procedure que receba o código do projeto e uma determinada quantidade de peças 
--    e mostre o nome do projeto e fornecedores que possuam quantidades iguais ou superiores à quantidade passada.

DROP PROCEDURE IF EXISTS sp_proj_fornec_qtd_pecas_ig_maior
GO

CREATE PROCEDURE sp_proj_fornec_qtd_pecas_ig_maior (
	@id_proj AS INT,
	@qtd_pecas AS INT
) 
AS
BEGIN
	SELECT 		P.PNome AS Projeto, F.FNome AS Fornecedor, SUM(FP.Quant) AS 'Quantidade de Pecas'
	FROM 		Fornece_Para FP
	JOIN		Projeto P ON FP.PNro = P.PNro
	JOIN		Fornecedor F ON FP.FNro = F.FNro
	WHERE		P.PNro = @id_proj
	GROUP BY 	P.PNome, F.FNome
	HAVING		SUM(FP.Quant) > @qtd_pecas
END
GO

EXECUTE sp_proj_fornec_qtd_pecas_ig_maior 4, 2;
GO

-- 2. Faça uma Stored Procedure que receba o código do projeto e mostre o nome do projeto, peças 
--    e fornecedores com o valor total das peças (quantidade * preço).

DROP PROCEDURE IF EXISTS sp_proj_pecas_fornec_valor_total
GO

CREATE PROCEDURE sp_proj_pecas_fornec_valor_total (
	@id_proj AS INT
)
AS
BEGIN
	SELECT 	P.PNome AS Projeto, PE.PeNome AS Peca, F.FNome AS Fornecedor, FP.Quant * PE.PePreco AS 'Valor Total'
	FROM	Fornece_Para FP
	JOIN	Projeto P ON FP.PNro = P.PNro
	JOIN	Peca PE ON FP.PeNro = PE.PeNro
	JOIN	Fornecedor F ON FP.FNro = F.FNro
	WHERE	P.PNro = @id_proj
END
GO

EXECUTE sp_proj_pecas_fornec_valor_total 4;
GO

-- 3. Faça uma Stored Procedure que some os números pares de 50 a 100.

DROP PROCEDURE IF EXISTS sp_somar_pares_50_a_100
GO

CREATE PROCEDURE sp_somar_pares_50_a_100
AS
BEGIN
	DECLARE @soma AS INT = 0
	DECLARE @contador AS INT = 50;
	WHILE	@contador <= 100
	BEGIN
		IF 	@contador % 2 = 0
		BEGIN
			SET @soma = @soma + @contador
		END
		SET @contador = @contador + 1
	END		
	PRINT @soma
END
GO

EXECUTE sp_somar_pares_50_a_100
GO

-- 4. Crie uma SP que retorne todos os projetos (nome, número e custo) que são supridos por um número de fornecedor
--    e um número de peça enviados como parâmetros.4

DROP PROCEDURE IF EXISTS sp_projetos_by_fornecedor_peca
GO

CREATE PROCEDURE sp_projetos_by_fornecedor_peca (
	@id_fornec AS INT,
	@id_peca AS INT
)
AS
BEGIN
	SELECT 	P.PNro AS 'Número Projeto', P.PNome AS Projeto, PE.PeNome AS 'Peca', PE.PePreco * FP.Quant AS 'Custo'
	FROM	Fornece_Para FP
	JOIN	Projeto P ON FP.PNro = P.PNro
	JOIN	Peca PE ON FP.PeNro = PE.PeNro
	JOIN	Fornecedor F ON FP.FNro = F.FNro
	WHERE	F.FNro = @id_fornec AND @id_peca = PE.PeNro
END
GO

EXECUTE sp_projetos_by_fornecedor_peca 4, 4
GO

-- 5. Obtenha o nome das peças que não são utilizadas em nenhum projeto. Pesquise o comando Except ou Any.

DROP PROCEDURE IF EXISTS sp_pecas_sem_projeto
GO

CREATE PROCEDURE sp_pecas_sem_projeto
AS
BEGIN
    SELECT *
    FROM Peca
    EXCEPT
    SELECT Peca.*
    FROM Peca
    JOIN Fornece_Para ON Peca.PeNro = Fornece_Para.PeNro;
END;
GO

EXECUTE sp_pecas_sem_projeto
GO
