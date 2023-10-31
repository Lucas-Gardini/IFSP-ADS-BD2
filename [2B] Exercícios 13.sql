-- 1. Faça duas transações não aninhadas para atualização de custo em 10% na tabela
--    projeto e inserção de um registro na tabela de fornecedores.

BEGIN TRANSACTION atualiza_projeto
	UPDATE 	Peca
	SET		PePreco = PePreco + ((PePreco) * (10 / 100))
	
	IF @@ERROR != 0
		ROLLBACK TRANSACTION
	ELSE
		COMMIT TRANSACTION

BEGIN TRANSACTION insere_registro_projeto
	INSERT INTO Projeto values(255, 'Projeto', '30', 4500)

	IF @@ERROR != 0
		ROLLBACK TRANSACTION
	ELSE
		COMMIT TRANSACTION

-- 2. Reescreva as operações do exercício anterior com duas transações aninhadas.

BEGIN TRANSACTION atualiza_projeto_aninhado
	UPDATE 	Peca
	SET 	PePreco = PePreco + ((PePreco) * (10 / 100))

	BEGIN TRANSACTION insere_registro_projeto_aninhado
		INSERT INTO Projeto VALUES (255, 'Projeto', '30', 4500)

	IF @@ERROR != 0
		ROLLBACK TRANSACTION insere_registro_projeto_aninhado
	ELSE
		COMMIT TRANSACTION insere_registro_projeto_aninhado

-- COMMIT da transação externa
IF @@TRANCOUNT > 0
	COMMIT TRANSACTION atualiza_projeto_aninhado
