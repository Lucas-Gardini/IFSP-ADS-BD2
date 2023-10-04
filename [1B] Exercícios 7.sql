-- 1. Desenvolva uma função que receba o número do projeto e retorne os nomes e os preços das peças
--    que são fornecidas e que tenham preços inferiores a R$ 20,00. Inclua a chamada à função. 

DROP FUNCTION IF EXISTS getPecasFornecidas
GO

CREATE FUNCTION getPecasFornecidas (
	@idProj INT
)
RETURNS TABLE
RETURN (
	SELECT 	PE.PeNome AS 'Peça', PE.PePreco as 'Preço'
	FROM	Fornece_Para FP
	JOIN	Peca PE ON FP.PeNro = PE.PeNro
	JOIN	Projeto P ON FP.PNro = P.PNro
	WHERE	P.PNro = @idProj
	AND		PE.PePreco < 20
)
GO

SELECT * FROM dbo.getPecasFornecidas(2)
GO

-- 2. Crie uma função que receba o código de uma peça e o código de um projeto, retornando os nomes dos projetos
--    e peças e as quantidades fornecidas desse par de parâmetros. Inclua a chamada à função. 

DROP FUNCTION IF EXISTS getProjetosPecasQtd;
GO

CREATE FUNCTION getProjetosPecasQtd (
    @idProj INT,
    @idPeca INT
)
RETURNS TABLE
RETURN (
    SELECT  P.PNome AS 'Projeto', PE.PeNome AS 'Peça', SUM(FP.Quant) AS 'Quantidade'
    FROM    Fornece_Para FP
    JOIN    Peca PE ON FP.PeNro = PE.PeNro
    JOIN    Projeto P ON FP.PNro = P.PNro
    WHERE   PE.PeNro = @idPeca
    AND     P.PNro = @idProj
    GROUP BY P.PNro, PE.PeNro, P.PNome, PE.PeNome
);
GO

SELECT * FROM getProjetosPecasQtd(5, 4);


-- 3. Elabore uma função que receba o código de um fornecedor e retorne o nome das peças fornecidas 
--    que tenham preços superiores a R$ 20,00 e participam de projetos com períodos de até 4 meses. Inclua a chamada à função.

DROP FUNCTION IF EXISTS getPecasFornecidasPrecoMaior20ProjetoMesAte4
GO

CREATE FUNCTION getPecasFornecidasPrecoMaior20ProjetoMesAte4 (
	@idFornec INT
)
RETURNS TABLE
RETURN (
	SELECT 	PE.PeNome
	FROM	Fornece_Para FP
	JOIN	Peca PE ON FP.PeNro = PE.PeNro
	JOIN	Projeto P ON FP.PNro = P.PNro
	-- JOIN	Fornecedor F ON FP.FNro = F.FNro
	WHERE	FP.FNro = @idFornec
	AND		PE.PePreco > 20
	AND		CAST(P.PDuracao AS INT) <= 4
)
GO

SELECT * FROM getPecasFornecidasPrecoMaior20ProjetoMesAte4(5)
GO