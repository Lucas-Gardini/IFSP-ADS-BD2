-- 5. Crie um cursor para a tabela “Fornecedor”. Armazene nesse cursor o nome do fornecedor,
--    bem como a categoria do mesmo. Para os fornecedores das Categorias “A” e “B”, 
--    mostre os nomes do fornecedor juntamente com o texto “Excelentes Fornecedores”.
--    Caso contrário, imprima os nomes do fornecedor juntamente com o texto “Fornecedores Meia Boca”. 

-- Declaração de variáveis
DECLARE @Fornecedor VARCHAR(30)
DECLARE @Categoria CHAR

DECLARE @FornecedoresClassificacao TABLE (Nome VARCHAR(30), Classificacao VARCHAR(25))

-- Criar um cursor
DECLARE fornecedoresCursor CURSOR FOR
SELECT  FNome, FCateg
FROM 	Fornecedor

-- Abrir o cursor
OPEN fornecedoresCursor

-- Inicializar variáveis
FETCH NEXT FROM fornecedoresCursor INTO @Fornecedor, @Categoria

-- Loop através das linhas
WHILE @@FETCH_STATUS = 0
BEGIN
	-- Processar os dados
	IF @Categoria IN ('A', 'B')
		INSERT INTO @FornecedoresClassificacao VALUES(@Fornecedor, 'Excelentes Fornecedores')
	ELSE
		INSERT INTO @FornecedoresClassificacao VALUES(@Fornecedor, 'Fornecedores Meia Boca')

	-- Obter a próxima linha
	FETCH NEXT FROM fornecedoresCursor INTO @Fornecedor, @Categoria
END

SELECT * FROM @FornecedoresClassificacao

-- Fechar o cursor
CLOSE fornecedoresCursor

-- Liberar recursos do cursor
DEALLOCATE fornecedoresCursor

-- 6. Utilizando cursores, realize uma consulta que retorne todos os nomes de Projetos 
--    e seus respectivos custos e durações e mostre somente esses dados. 

-- Declaração de variáveis
DECLARE @Projeto VARCHAR(30)
DECLARE @Custo MONEY
DECLARE @Duracao VARCHAR(15)

-- Criar um cursor
DECLARE projetosCustosDuracoesCursor CURSOR FOR
SELECT  PNome, PCusto, PDuracao
FROM 	Projeto

-- Abrir o cursor
OPEN projetosCustosDuracoesCursor

-- Inicializar variáveis
FETCH NEXT FROM projetosCustosDuracoesCursor INTO @Projeto, @Custo, @Duracao

-- Loop através das linhas
WHILE @@FETCH_STATUS = 0
BEGIN
	-- Processar os dados
	PRINT @Projeto + ' ' + CAST(@Custo AS VARCHAR(255)) + ' ' + @Duracao

	-- Obter a próxima linha
	FETCH NEXT FROM projetosCustosDuracoesCursor INTO @Projeto, @Custo, @Duracao
END

-- Fechar o cursor
CLOSE projetosCustosDuracoesCursor

-- Liberar recursos do cursor
DEALLOCATE projetosCustosDuracoesCursor

-- 7. Realize uma consulta que retorne em um cursor o número de todas as peças
--    que são fornecidas para um fornecedor, sendo que o fornecedor é selecionado
--    através da passagem de um parâmetro, juntamente com uma porcentagem para
--    reajuste das peças selecionadas, que serão reajustadas uma a uma com tal porcentagem. 
DROP PROCEDURE IF EXISTS mostra_atualiza_pecas_fornecedor
GO

CREATE PROCEDURE mostra_atualiza_pecas_fornecedor (@FornecedorID INT, @Reajuste FLOAT)
AS
BEGIN
	-- Variáveis
	DECLARE @PecasID INT	

	-- Criar um cursor
	DECLARE pecasCursor CURSOR FOR
	SELECT  FP.PeNro
	FROM 	Fornece_Para FP
	WHERE 	FP.FNro = @FornecedorID

	-- Abrir o cursor
	OPEN pecasCursor

	-- Inicializar variáveis
	FETCH NEXT FROM pecasCursor INTO @PecasID

	-- Loop através das linhas
	WHILE @@FETCH_STATUS = 0
	BEGIN
		-- Processar os dados
		UPDATE 	Peca
		SET		PePreco = PePreco + (PePreco * (@Reajuste / 100.0))
		WHERE	PeNro = @PecasID

		-- Obter a próxima linha
		FETCH NEXT FROM pecasCursor INTO @PecasID
	END

	-- Fechar o cursor
	CLOSE pecasCursor

	-- Liberar recursos do cursor
	DEALLOCATE pecasCursor
END
GO

SELECT * FROM Peca
EXECUTE mostra_atualiza_pecas_fornecedor 2, 15.4