USE heranca
GO

-- 1. Faça uma SP para inserir valores na tabela IES (não esqueça que a chave primária é autoincremental). 
DROP PROCEDURE IF EXISTS sp_inserir_IES
GO

CREATE PROCEDURE sp_inserir_IES (
	@nome AS VARCHAR(40)
)
AS 
BEGIN
	INSERT INTO IES(IES_nome)
	VALUES 		(@nome)
END
GO

EXECUTE sp_inserir_IES 'IES-NOME'
GO

-- 2. Faça uma SP para excluir valores da tabela IES. 
DROP PROCEDURE IF EXISTS sp_excluir_IES_by_index
GO

CREATE PROCEDURE sp_excluir_IES_by_index (
	@id AS INT
)
AS
BEGIN
	DELETE FROM IES
	WHERE		IES.IES_codigo = @id
END
GO

EXECUTE sp_excluir_IES_by_index 1
GO

-- 3. Crie uma SP para atualizar o nome (enviado) de uma IES com base no código passado. 
DROP PROCEDURE IF EXISTS sp_atualizar_IES_by_index
GO

CREATE PROCEDURE sp_atualizar_IES_by_index (
	@id AS INT,
	@nome AS VARCHAR(40)
)
AS
BEGIN
	UPDATE	IES
	SET		IES.IES_nome = @nome
	WHERE 	IES.IES_codigo = @id
END
GO

EXECUTE sp_inserir_IES "Item";
GO

EXECUTE sp_atualizar_IES_by_index 2, 'Primeiro IES';
GO

-- 4. Desenvolva uma SP que receba o código de uma pessoa e mostre todas as informações de cliente. 
DROP PROCEDURE IF EXISTS sp_get_cliente_by_index
GO

CREATE PROCEDURE sp_get_cliente_by_index (
	@id AS INT
)
AS
BEGIN
	SELECT 	P.Pes_codigo, C.Cli_cpf, C.Cli_email
	FROM 	Clientes C
	JOIN	Pessoas P ON C.Pes_codigo = P.Pes_codigo
	WHERE	P.Pes_codigo = @id
END
GO

EXECUTE sp_get_cliente_by_index 2;
GO

-- 5. Faça uma SP que retorne informações de todos os estagiários: código e nome da pessoa, a data de entrada do estagiário, o código e o nome da IES. 
DROP PROCEDURE IF EXISTS sp_get_estagiarios
GO

CREATE PROCEDURE sp_get_estagiarios
AS
BEGIN
	SELECT 	E.Pes_codigo, P.Pes_nome, IES.IES_codigo, IES.IES_nome, E.Est_data
	FROM 	Estagiarios E
	JOIN	Pessoas P ON E.Pes_codigo = P.Pes_codigo
	JOIN	IES ON E.IES_codigo = IES.IES_codigo
END
GO

EXECUTE sp_get_estagiarios
GO

-- 6. Faça uma SP que retorne informações (código e nome da pessoa, a data de entrada do estagiário, o código e o nome da IES) 
-- 	  de uma pessoa/estagiário cujo código foi passado para a SP. 

DROP PROCEDURE IF EXISTS sp_get_estagiario_by_index
GO

CREATE PROCEDURE sp_get_estagiario_by_index(
	@id AS INT
)
AS
BEGIN
	SELECT 	E.Pes_codigo, P.Pes_nome, IES.IES_codigo, IES.IES_nome, E.Est_data
	FROM	Estagiarios E
	JOIN	Pessoas P ON E.Pes_codigo = P.Pes_codigo
	JOIN	IES ON E.IES_codigo = IES.IES_codigo
	WHERE	P.Pes_codigo = @id
END
GO

EXECUTE sp_get_estagiario_by_index 10
GO
