-- 1. Faça uma Stored Procedure com um cursor que receba todos os projetos que têm custo superior a R$ 25.000,00
--    e selecione todos os nomes e categorias de fornecedores que fornecem para estes projetos.
DROP PROCEDURE IF EXISTS projetos_custo_25mil_mais_nomes_categorias_fornecedores;
GO

CREATE PROCEDURE projetos_custo_25mil_mais_nomes_categorias_fornecedores AS
BEGIN
	-- Variáveis
	DECLARE @ProjetoID INT
	DECLARE @ProjetoCusto MONEY
	DECLARE @Retorno TABLE (
		NomeFornecedor VARCHAR(30),
		CategoriaFornecedor VARCHAR(1)
	)

	-- Criar um cursor
	DECLARE projetosCursor CURSOR FOR
	SELECT  PNro, PCusto
	FROM 	Projeto

	-- Abrir o cursor
	OPEN projetosCursor

	-- Inicializar variáveis
	FETCH NEXT FROM projetosCursor INTO @ProjetoID, @ProjetoCusto

	-- Loop através das linhas
	WHILE @@FETCH_STATUS = 0
	BEGIN
		-- Processar os dados
		IF @ProjetoCusto > 25000
		BEGIN
			INSERT INTO @Retorno 
				SELECT 	F.FNome, F.FCateg 
				FROM 	Fornece_Para FP 
				JOIN 	Fornecedor F ON FP.FNro = F.FNro
				WHERE	FP.PNro = @ProjetoID
		END

		-- Obter a próxima linha
		FETCH NEXT FROM projetosCursor INTO @ProjetoID, @ProjetoCusto;
	END

	-- Seleciona o resultado da tabela final
	SELECT DISTINCT * FROM @Retorno

	-- Fechar o cursor
	CLOSE projetosCursor

	-- Liberar recursos do cursor
	DEALLOCATE projetosCursor
END
GO

EXECUTE projetos_custo_25mil_mais_nomes_categorias_fornecedores
GO

-- 2. Crie um Trigger que é disparado quando se atualiza uma categoria qualquer de Fornecedor,
--    com um cursor que armazene os fornecedores que não são das categorias ‘A’, ‘B’ e ‘C’, e atualize suas categorias para ‘C’.
DROP TRIGGER IF EXISTS trigger_fornecedor_categ
GO

CREATE TRIGGER trigger_fornecedor_categ ON Fornecedor
AFTER UPDATE
AS
BEGIN
	-- Variáveis
	DECLARE @FornecedorID INT

	-- Criar um cursor
	DECLARE fornecedoresCursor CURSOR FOR
	SELECT  FNro
	FROM 	Fornecedor
	WHERE	FCateg NOT IN ('A', 'B', 'C')

	-- Abrir o cursor
	OPEN fornecedoresCursor

	-- Inicializar variáveis
	FETCH NEXT FROM fornecedoresCursor INTO @FornecedorID

	-- Loop através das linhas
	WHILE @@FETCH_STATUS = 0
	BEGIN
		-- Processar os dados
		UPDATE 	Fornecedor
		SET		FCateg = 'C'
		WHERE	FNro = @FornecedorID

		-- Obter a próxima linha
		FETCH NEXT FROM fornecedoresCursor INTO @FornecedorID;
	END

	-- Fechar o cursor
	CLOSE fornecedoresCursor

	-- Liberar recursos do cursor
	DEALLOCATE fornecedoresCursor
END
GO

SELECT * FROM Fornecedor
UPDATE Fornecedor SET FCateg = 'D' WHERE FNro = 2
GO

-- 3. Faça uma Stored Procedure que armazene em um cursor todos os códigos de projetos que têm fornecedores
--    que são da categoria A ou B. Atualize todos os custos desses projetos de tais fornecedores em 10%.
DROP PROCEDURE IF EXISTS atualiza_10pc_projeto_fornec_a_b
GO

CREATE PROCEDURE atualiza_10pc_projeto_fornec_a_b 
AS
BEGIN
	-- Variáveis
	DECLARE @ProjetosID INT

	-- Criar um cursor
	DECLARE projetosCursor CURSOR FOR
	SELECT  FP.PNro
	FROM 	Fornece_Para FP
	JOIN	Fornecedor F ON FP.FNro = F.FNro
	WHERE	F.FCateg IN ('A', 'B')

	-- Abrir o cursor
	OPEN projetosCursor

	-- Inicializar variáveis
	FETCH NEXT FROM projetosCursor INTO @ProjetosID

	-- Loop através das linhas
	WHILE @@FETCH_STATUS = 0
	BEGIN
		-- Processar os dados
		UPDATE 	Projeto
		SET		PCusto = PCusto + (PCusto * (10 / 100))
		WHERE	PNro = @ProjetosID

		-- Obter a próxima linha
		FETCH NEXT FROM projetosCursor INTO @ProjetosID;
	END

	-- Fechar o cursor
	CLOSE projetosCursor

	-- Liberar recursos do cursor
	DEALLOCATE projetosCursor
END
GO

SELECT * FROM Projeto
EXECUTE atualiza_10pc_projeto_fornec_a_b
GO

-- 4. Faça uma Stored Procedure com um cursor que receba o código do fornecedor,
--    selecionando todos os projetos nos quais este fornecedor possui fornecimento e aumente em 15% o custo de tais projetos.
DROP PROCEDURE IF EXISTS atualiza_15pc_projeto_fornec_especifico
GO

CREATE PROCEDURE atualiza_15pc_projeto_fornec_especifico (@FornecedorID INT)
AS
BEGIN
	-- Variáveis
	DECLARE @ProjetosID INT

	-- Criar um cursor
	DECLARE projetosCursor CURSOR FOR
	SELECT  PNro
	FROM 	Fornece_Para
	WHERE	FNro = @FornecedorID

	-- Abrir o cursor
	OPEN projetosCursor

	-- Inicializar variáveis
	FETCH NEXT FROM projetosCursor INTO @ProjetosID

	-- Loop através das linhas
	WHILE @@FETCH_STATUS = 0
	BEGIN
		-- Processar os dados
		UPDATE 	Projeto
		SET		PCusto = PCusto + (PCusto * (15 / 100))
		WHERE	PNro = @ProjetosID
		-- Obter a próxima linha
		FETCH NEXT FROM projetosCursor INTO @ProjetosID;
	END

	-- Fechar o cursor
	CLOSE projetosCursor

	-- Liberar recursos do cursor
	DEALLOCATE projetosCursor
END
GO

SELECT * FROM Projeto
EXECUTE atualiza_15pc_projeto_fornec_especifico 2
GO