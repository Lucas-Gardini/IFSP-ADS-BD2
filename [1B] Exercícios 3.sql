-- 1. Crie uma StoredProcedure que receba o nº do projeto e liste os nomes dos mesmos e os nomes de peças, bem como as quantidades fornecidas, renomeando as colunas. 

DROP PROCEDURE IF EXISTS sp_fornecimento_projetos;
GO

CREATE PROCEDURE sp_fornecimento_projetos (
	@id_proj INT
) 
AS
BEGIN
	SELECT 		P.PNome Projeto, PE.PeNome Peca, Fp.Quant 'Quantidade Fornecida' 
	FROM 		Fornece_Para FP
	JOIN		Projeto P ON Fp.PNro = P.PNro
	JOIN		Peca PE ON FP.PeNro = PE.PeNro
	WHERE 		P.PNro = @id_proj
	-- GROUP BY 	Pe.PeNome, P.PNome
	-- HAVING 		SUM(FP.Quant) > 0
END
GO

EXECUTE sp_fornecimento_projetos 4;
GO

-- 2. Enviar o código do projeto para a stored procedure e listar o nome do projeto e do fornecedor referente a este código do projeto.

DROP PROCEDURE IF EXISTS sp_fornecedor_projeto;
GO

CREATE PROCEDURE sp_fornecedor_projeto (
	@id_proj INT
)
AS
BEGIN
	SELECT 	P.PNome Projeto, F.FNome Fornecedor
	FROM 	Fornece_Para FP
	JOIN 	Projeto P ON FP.PNro = P.PNro
	JOIN	Fornecedor F ON FP.FNro = F.FNro
	WHERE 	P.PNro = @id_proj
END
GO

EXECUTE sp_fornecedor_projeto 2;
GO

-- 3. Criar uma Stored Procedure que receba a quantidade de peças fornecidas e verifique quais quantidades estão abaixo desse valor, 
--	  mostrando o nome do projeto, da peça e do fornecedor. 

DROP PROCEDURE IF EXISTS sp_qtd_pecas_fornecidas_menor_que;
GO

CREATE PROCEDURE sp_qtd_pecas_fornecidas_menor_que (
	@qtd_pecas INT
)
AS
BEGIN 
	SELECT 		P.PNome Projeto, PE.PeNome Peca, F.FNome Fornecedor, FP.Quant 'Quantidade Fornecida'
	FROM 		Fornece_Para FP
	JOIN 		Projeto P ON FP.PNro = P.PNro
	JOIN		Fornecedor F ON FP.FNro = F.FNro
	JOIN		Peca PE ON FP.PeNro = PE.PeNro
	WHERE		FP.Quant < @qtd_pecas
END
GO

EXECUTE sp_qtd_pecas_fornecidas_menor_que 5;
GO

-- 4. Crie uma Stored Procedure que receba uma quantidade de peças e mostre os nomes de projetos,
--    peças e fornecedores que possuam quantidades iguais ou inferiores à quantidade passada. 

DROP PROCEDURE IF EXISTS sp_qtd_pecas_fornecidas_menor_igual_que;
GO

CREATE PROCEDURE sp_qtd_pecas_fornecidas_menor_igual_que(
	@qtd_pecas INT
)
AS
BEGIN 
	SELECT 		P.PNome Projeto, PE.PeNome Peca, F.FNome Fornecedor, FP.Quant 'Quantidade Fornecida'
	FROM 		Fornece_Para FP
	JOIN 		Projeto P ON FP.PNro = P.PNro
	JOIN		Fornecedor F ON FP.FNro = F.FNro
	JOIN		Peca PE ON FP.PeNro = PE.PeNro
	WHERE		FP.Quant <= @qtd_pecas
END
GO

EXECUTE sp_qtd_pecas_fornecidas_menor_igual_que 2;
GO