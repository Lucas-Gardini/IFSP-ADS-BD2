-- 1. Crie uma Stored Procedure de nome sp_ex1_proj que receba como parâmetro o código do projeto e mostre
-- o nome e a duração do mesmo.

CREATE PROCEDURE sp_ex1_proj (
	@CodProj AS INT
)
AS 
BEGIN
	SELECT	PNome AS Nome, PDuracao AS Duracao
	FROM	Projeto
	WHERE	PNro = @CodProj
END
GO

EXECUTE sp_ex1_proj 1;
GO

-- 2. Crie uma Stored Procedure de nome sp_ex2_forn que receba um texto como parâmetro, indicando um trecho
-- do nome do fornecedor, e mostre o nome e a categoria do fornecedor.

CREATE PROCEDURE sp_ex2_forn (
	@ParteNome VARCHAR(50)
)
AS
BEGIN
	SELECT	FNome AS Nome, FCateg AS Categoria
	FROM	Fornecedor
	WHERE	FNome LIKE @ParteNome + '%'
END
GO

EXECUTE sp_ex2_forn 'P';
GO

-- 3. Crie uma Stored Procedure de nome sp_ex3_peça que inclua na tabela peça somente 3 campos: número, 
-- nome e preço. Inclua uma peça.

CREATE PROCEDURE sp_ex3_peca (
	@NumPeca AS INT,
	@NomePeca AS VARCHAR(15),
	@PrecoPeca AS FLOAT
) 
AS
BEGIN
	INSERT INTO Peca(PeNro, PeNome, PePreco)
	VALUES		(@NumPeca, @NomePeca, @PrecoPeca)
END
GO

EXEC sp_ex3_peca 8, 'NovaPeca', 34.50;
SELECT * FROM Peca;
GO

-- 4. Crie uma Stored Procedure de nome sp_ex4_peça que altere a peça incluída em pelo menos 2 campos.

CREATE PROCEDURE sp_ex4_peca (
	@NumPeca AS INT,
	@NomePeca AS VARCHAR(15),
	@CorPeca AS VARCHAR(15)
) AS BEGIN
	UPDATE	Peca
	SET		PeNome = @NomePeca,
			PeCor = @CorPeca
	WHERE	PeNro = @NumPeca
END
GO

EXEC sp_ex4_peca 8, 'PecaModificada', 'Vermelha';
SELECT * FROM Peca;
GO


-- 5. Crie uma Stored Procedure de nome sp_ex5_peça que exclua a peça anterior, que foi incluída e 
-- alterada no exercício anterior.

CREATE PROCEDURE sp_ex5_peca (
	@NumPeca AS INT
)
AS
BEGIN
	DELETE FROM Peca
	WHERE		PeNro = @NumPeca
END
GO

EXEC sp_ex5_peca 8;
SELECT * FROM Peca;
GO

