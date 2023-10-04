-- Exemplo TRIGGERS

USE Fabrica

-- 1 - Após incluir uma peça com atributo cor 'Amarelo', modifique tal cor para 'Azul'. 
DROP TRIGGER IF EXISTS trigger_peca_amarela_azul;
GO

CREATE TRIGGER trigger_peca_amarela_azul ON Peca
AFTER INSERT
AS
BEGIN
	UPDATE 	Peca
	SET		PeCor = 'Azul'
	WHERE	Peca.PeNro IN (SELECT PeNro FROM inserted) 
	AND		PeCor = 'Amarelo'
END
GO

-- 2 - Ao invés de deletar uma peça, crie um trigger para modificar o atributo PePreco dela para 50. 
DROP TRIGGER IF EXISTS trigger_nao_deleta_bota_50;
GO

CREATE TRIGGER trigger_nao_deleta_bota_50 ON Peca
INSTEAD OF DELETE
AS
BEGIN
	UPDATE	Peca
	SET		PePreco = 50
	WHERE	PeNro IN (SELECT PeNro FROM deleted)
END
GO

-- 3 - Crie um trigger para, ao invés de atualizar o nome de uma peça com um valor qualquer,
--	   atualize o campo Pecor dela para 'Amarelo'. 
DROP TRIGGER IF EXISTS trigger_nao_atualiza_bota_amarelo;
GO

CREATE TRIGGER trigger_nao_atualiza_bota_amarelo ON Peca
INSTEAD OF UPDATE
AS
BEGIN
	IF UPDATE(PeNome)
		BEGIN
			UPDATE 	Peca
			SET		PeCor = 'Amarelo'
			WHERE	PeNro IN (SELECT PeNro FROM deleted)
		END
	ELSE
		BEGIN
			UPDATE 	Peca
			SET 	PeCor = I.PeCor, PePreco = I.PePreco
			FROM 	inserted I
			JOIN	Peca P ON I.PeNro = P.PeNro
		END
END
GO

-- 4 - Faça um trigger para uma inserção na tabela peça que ao invés de inserir um valor para Pecor, troque-o para 'Roxo'. 
DROP TRIGGER IF EXISTS trigger_nao_atualiza_bota_amarelo;
GO

CREATE TRIGGER trigger_ao_inserir_bota_roxo ON Peca
AFTER INSERT
AS
BEGIN
	UPDATE	Peca
	SET		PeCor = 'Roxo'
	WHERE	PeNro IN (SELECT PeNro FROM inserted)
END
GO