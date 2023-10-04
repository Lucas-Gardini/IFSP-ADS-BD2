-- 1. Crie uma função que retorne os nomes das peças, fornecedores e projetos com peças de preço maior que $ 20
--    e que são fornecidas por empresas de São Paulo e utilizadas por projeto com duração maior que 2 meses.
--    Inclua a chamada à função. 
DROP FUNCTION IF EXISTS funcao1;
GO

CREATE  FUNCTION funcao1()
RETURNS @tabela1 TABLE (
	Peca TEXT,
	Fornecedor TEXT,
	Projeto TEXT
)
AS
BEGIN
	INSERT INTO @tabela1
	SELECT 		PE.PeNome, F.FNome, P.PNome
	FROM		Fornece_Para FP
	JOIN		Fornecedor F ON FP.FNro = F.FNro
	JOIN		Projeto P ON FP.PNro = P.PNro
	JOIN		Peca PE ON FP.PeNro = PE.PeNro
	WHERE		F.FCidade = 'São Paulo'
	AND			PE.PePreco > 20
	AND			P.PDuracao > 2	
	RETURN	
END
GO

SELECT * FROM funcao1()

-- 2. Obtenha o nome dos projetos e de seus fornecedores que possuem algum fornecimento de fornecedor da cidade de Campinas.
--    Inclua a chamada à função. 
DROP FUNCTION IF EXISTS funcao2;
GO

CREATE FUNCTION funcao2()
RETURNS @tabela2 TABLE (
	Projeto TEXT,
	Fornecedor TEXT
)
AS
BEGIN
	INSERT INTO @tabela2
	SELECT		P.PNome, F.FNome
	FROM		Fornece_Para FP
	JOIN		Projeto P ON FP.PNro = P.PNro
	JOIN		Fornecedor F ON FP.FNro = F.FNro
	WHERE		F.FCidade = 'Campinas'
	AND			FP.Quant > 0
RETURN
END
GO

SELECT * FROM funcao2()

-- 3. Desenvolva uma função que retorne o nome dos projetos e das peças não fornecidas por fornecedores de categoria B. 
--    Inclua a chamada à função. 
DROP FUNCTION IF EXISTS funcao3;
GO

CREATE FUNCTION funcao3()
RETURNS @tabela3 TABLE (
	Projeto TEXT,
	Pecas TEXT
)
AS
BEGIN
	INSERT INTO @tabela3
	SELECT 		P.PNome, PE.PeNome
	FROM		Fornece_Para FP
	JOIN		Projeto P ON FP.PNro = P.PNro
	JOIN		Peca PE ON FP.PeNro = PE.PeNro
	JOIN		Fornecedor F ON FP.FNro = F.FNro
	WHERE		F.FCateg != 'B'		
RETURN
END
GO

SELECT * FROM funcao3()

-- 4. Crie uma função que receba a quantidade de peças fornecidas e o código da peça e retorne os nomes dos projetos
--    e fornecedores que fornecem tal peça em quantidade inferior ao parâmetro fornecido. 
DROP FUNCTION IF EXISTS funcao4;
GO

CREATE FUNCTION funcao4(
	@idPeca AS INT,
	@qtdPecas AS INT
)
RETURNS @tabela4 TABLE (
	Projeto TEXT,
	Fornecedor Text
)
AS
BEGIN
	INSERT INTO @tabela4
	SELECT		P.PNome, F.FNome
	FROM		Fornece_Para FP
	JOIN		Projeto P ON FP.PNro = P.PNro
	JOIN		Fornecedor F ON FP.FNro = F.FNro
	WHERE		FP.PeNro = @idPeca 
	AND			FP.Quant < @qtdPecas
RETURN
END
GO

SELECT * FROM funcao4(1, 2)