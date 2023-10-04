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

DELETE FROM Peca WHERE PeNro = 70
INSERT INTO Peca VALUES (70, 'Nome da Peça', 25.70, 'Amarelo')
SELECT * FROM Peca

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

DELETE FROM Peca WHERE PeNro = 70
SELECT * FROM Peca

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
			SET		PeCor = 'Amarelo', PePreco = I.PePreco
			FROM 	inserted I
			JOIN	Peca P ON I.PeNro = P.PeNro
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

UPDATE Peca SET PeNome = 'Troca de Nome2', PePreco = 29.99 WHERE PeNro = 70
SELECT * FROM Peca

UPDATE Peca SET PeCor = 'Preto', PePreco = 35.99 WHERE PeNro = 70
SELECT * FROM Peca

-- 4 - Faça um trigger para uma inserção na tabela peça que ao invés de inserir um valor para Pecor, troque-o para 'Roxo'. 
DROP TRIGGER IF EXISTS trigger_ao_inserir_bota_roxo;
GO

CREATE TRIGGER trigger_ao_inserir_bota_roxo ON Peca
INSTEAD OF INSERT
AS
BEGIN
	INSERT INTO		Peca (PeNro, PeNome, PePreco, PeCor)
	SELECT 			PeNro, PeNome, PePreco, 'Roxo' 
	FROM 			inserted
END
GO

DELETE FROM Peca WHERE PeNro = 75
INSERT INTO Peca VALUES (75, 'Peça Roxa', 32.90, 'Azul')
SELECT * FROM Peca
