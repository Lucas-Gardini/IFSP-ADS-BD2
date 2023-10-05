-- 1 - Faça um trigger com variáveis para, ao invés de inserir uma peça com os valores que o usuário informou,
--	   não deixe o preço da peça ser inferior a 5. 
DROP TRIGGER IF EXISTS verifica_insere_peca;
GO

CREATE TRIGGER verifica_insere_peca ON Peca
INSTEAD OF INSERT
AS
BEGIN
	DECLARE @NRO INT
	DECLARE @NOME VARCHAR(15)
	DECLARE @PRECO FLOAT
	DECLARE @COR VARCHAR(15)

    SELECT @NRO = PeNro, @NOME = PeNome, @PRECO = PePreco, @COR = PeCor FROM inserted

	IF @PRECO > 5
		INSERT INTO PECA VALUES (@NRO, @NOME, @PRECO, @COR)
END
GO

INSERT INTO PECA VALUES (69, 'Peca < 5', 4, 'Preto')
INSERT INTO PECA VALUES (94, 'Peca > 5', 6, 'Preto')
SELECT * FROM PECA
GO

-- 2 – Crie um Trigger que ao invés de excluir os fornecedores que não são das categorias ‘A’, ‘B’ e ‘C’,
--     atualize suas categorias para ‘C’. 
DROP TRIGGER IF EXISTS nao_exclui_A_B_C
GO

CREATE TRIGGER nao_exclui_A_B_C ON Fornecedor
INSTEAD OF DELETE
AS
BEGIN
	DELETE 
	FROM 	Fornecedor
	WHERE	FNro IN (
				SELECT 	FNro
				FROM 	deleted 
				WHERE 	FCateg IN ('A', 'B', 'C')
			)
	
	UPDATE 	Fornecedor
	SET		FCateg = 'C'
	WHERE	FNro IN (
				SELECT 	FNro
				FROM	deleted
				WHERE	FCateg NOT IN ('A', 'B',' C')
			)
END
GO

INSERT INTO Fornecedor VALUES (69, 'NOME 1', 'CIDADE 1', 'D')
INSERT INTO Fornecedor VALUES (70, 'NOME 2', 'CIDADE 2', 'C')

DELETE FROM Fornecedor WHERE FNro = 69
DELETE FROM Fornecedor WHERE FNro = 70
SELECT * FROM Fornecedor
GO

-- 3 - Ao se inserir um projeto, verificar se o custo está acima do permitido (50000).
--     Se for, incluir com o limite de 50.000. Se não, incluir com o valor passado. 
DROP FUNCTION IF EXISTS verificaCustoMaximo
DROP TRIGGER IF EXISTS verifica_custo_maximo_projeto
GO

CREATE FUNCTION verificaCustoMaximo (@CUSTO FLOAT, @MAXIMO FLOAT)
RETURNS FLOAT
AS
BEGIN
	DECLARE @RETORNO AS FLOAT

	IF (@CUSTO > @MAXIMO) SET @RETORNO = @MAXIMO
	ELSE SET @RETORNO = @CUSTO

	RETURN @RETORNO
END
GO

CREATE TRIGGER verifica_custo_maximo_projeto ON Projeto
INSTEAD OF INSERT
AS
BEGIN
	INSERT INTO Projeto
	SELECT 		PNro, PNome, PDuracao, dbo.verificaCustoMaximo(PCusto, 50000)
	FROM		inserted
END
GO

INSERT INTO Projeto VALUES (69, 'PROJETO 1', '6', 60000)
INSERT INTO Projeto VALUES (70, 'PROJETO 2', '2', 500)
SELECT * FROM Projeto
GO

-- 4 - Criar uma tabela de Historico de Projetos. 
DROP TABLE IF EXISTS HistoricoProjetos
GO

CREATE TABLE HistoricoProjetos (
	HPNro INT PRIMARY KEY IDENTITY(1,1),
	HPCampo VARCHAR(100) NOT NULL,
	HPValorAntigo TEXT,
	HPValorAtual TEXT
)
GO

-- 5 - Criar um trigger para atualizar a tabela Histórico de Projetos que é disparado quando houver
--     a modificação SOMENTE no atributo PDuração no Projeto. 
DROP TRIGGER IF EXISTS atualiza_historico_projeto_duracao
GO

CREATE TRIGGER atualiza_historico_projeto_duracao ON Projeto
AFTER UPDATE
AS
BEGIN
	IF UPDATE(PDuracao)
		BEGIN
			INSERT INTO HistoricoProjetos (HPCampo, HPValorAntigo, HPValorAtual)
			SELECT 		'PDuracao', CAST(ANTIGO.PDuracao AS VARCHAR), CAST(ATUAL.PDuracao AS VARCHAR)
			FROM 		inserted ATUAL
			JOIN 		deleted ANTIGO ON ATUAL.PNro = ANTIGO.PNro
		END
END
GO

UPDATE Projeto SET PDuracao = '70' WHERE PNro = 69
SELECT * FROM Projeto
SELECT * FROM HistoricoProjetos

-- 6 - Criar 2 tabelas: Projeto_atualizado e Projeto_antigo 
DROP TABLE IF EXISTS Projeto_atualizado
DROP TABLE IF EXISTS Projeto_antigo
GO

CREATE TABLE Projeto_atualizado (
	PNro INT NOT NULL PRIMARY KEY, 
	PNome VARCHAR(30) NOT NULL, 
	PDuracao VARCHAR(15) NOT NULL,
	PCusto MONEY NOT NULL,

	DataInclusao TEXT
);
GO

CREATE TABLE Projeto_antigo (
	PNro INT NOT NULL PRIMARY KEY, 
	PNome VARCHAR(30) NOT NULL, 
	PDuracao VARCHAR(15) NOT NULL,
	PCusto MONEY NOT NULL,

	DataInclusao TEXT
);
GO

-- 7 - Criar um trigger que armazena em uma tabela os dados atualizados
--     do Projeto(Projeto_atualizado) e em outra tabela os dados do Projeto antes de atualizar (Projeto_antigo) 
DROP TRIGGER IF EXISTS mantem_dados_antigos_projeto
GO

CREATE TRIGGER mantem_dados_antigos_projeto ON Projeto
AFTER UPDATE
AS
BEGIN
	BEGIN
		DELETE FROM Projeto_antigo 
		WHERE 		PNro IN (SELECT PNro FROM deleted)

		INSERT INTO Projeto_antigo (PNro, PNome, PDuracao, PCusto, DataInclusao) 
		SELECT 		PNro, PNome, PDuracao, PCusto, FORMAT(GETDATE(), 'yyyy-MM-dd HH:mm:ss') 
		FROM 		deleted
	END

	BEGIN
		DELETE FROM Projeto_atualizado 
		WHERE 		PNro IN (SELECT PNro FROM inserted)
		
		INSERT INTO Projeto_atualizado (PNro, PNome, PDuracao, PCusto, DataInclusao) 
		SELECT 		PNro, PNome, PDuracao, PCusto, FORMAT(GETDATE(), 'yyyy-MM-dd HH:mm:ss') 
		FROM 		inserted
	END
END
GO

DELETE FROM Projeto WHERE PNro = 100
INSERT INTO Projeto VALUES (100, 'PROJETO 100', '100', 100)
UPDATE Projeto SET PNome = 'PROJETO CEM' WHERE PNro = 100

-- SELECT * FROM Projeto
SELECT * FROM Projeto_antigo
SELECT * FROM Projeto_atualizado
