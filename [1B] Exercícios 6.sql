USE Fabrica;
GO

-- 1. Crie uma variável do tipo Table com os campos número, nome e duração dos projetos. 
--	  Armazene na variável Table todos os projetos com custo superior a R$ 20 000,00. 
--    Em seguida mostre aqueles com duração maior ou igual a 2 meses. 

DECLARE @ProjetosCusto20000DuracaoMaiorIgual2 TABLE (
    Numero INT PRIMARY KEY,
    Nome VARCHAR(30),
    Duracao VARCHAR(15)
)

INSERT INTO @ProjetosCusto20000DuracaoMaiorIgual2 
SELECT 		P.PNro, P.PNome, P.PDuracao 
FROM 		Projeto P
WHERE 		P.PCusto > 20000

SELECT 	* 
FROM 	@ProjetosCusto20000DuracaoMaiorIgual2 
WHERE 	Duracao >= 2
GO

-- 2. Crie uma função para calcular o "delta" de uma equação do 2º grau (as entradas são A, B e C). delta = b² - 4 ac 

DROP FUNCTION IF EXISTS delta;
GO

CREATE FUNCTION delta(
	@a FLOAT,
	@b FLOAT, 
	@c FLOAT
)
RETURNS FLOAT
AS
BEGIN
	DECLARE @delta FLOAT
	SET		@delta = POWER(@b, 2) - (4 * @a * @c)
	RETURN	@delta
END
GO

DECLARE @result FLOAT;
SET		@result = dbo.delta(2, 5, 2)
PRINT	@result
GO

-- 3. Crie uma stored procedure para calcular a(s) raíz(es), se houver(em). 

--    delta < 0 (A = 5, B = 1, C = 5) -> não existem raízes reais. 
--    delta = 0 (A = 2, B = 4, C = 2) -> x = -b / (2 * a) = -1 
--    delta > 0 (A = 2, B = 5, C = 2) -> x1 = -0,5 e x2 = -2 

--    Use a função criada no exercício 2 nesse procedimento. Um exemplo de chamada: 
--	  declare @retorno decimal 
--    set @retorno = dbo.Delta (@A, @B, @C) 

--    Exemplo de execução do procedimento: 
--    CalcDelta 5, 1, 5 
--    CalcDelta 2, 4, 2 
--    CalcDelta 2, 5, 2 

DROP PROCEDURE IF EXISTS sp_raizes_eq_2_grau
GO

CREATE PROCEDURE sp_raizes_eq_2_grau (
	@a FLOAT,
	@b FLOAT, 
	@c FLOAT
)
AS
BEGIN
	DECLARE @delta FLOAT
	SET		@delta = dbo.delta(@a, @b, @c)
	IF		@delta < 0
		PRINT 'Não existem raízes reais!'
	ELSE IF @delta = 0
		PRINT 'x = -b / (2 * a) = ' + CAST(-@b / (2 * @a) AS VARCHAR)
	ELSE
		BEGIN
			-- x = (-b ± √Δ) / (2a)
			DECLARE @x1 FLOAT
			DECLARE @x2 FLOAT
			SET		@x1 = (-@b + SQRT(@delta)) / (2 * @a)
			SET 	@x2 = (-@b - SQRT(@delta)) / (2 * @a)
			PRINT 	'x1 = ' + CAST(@x1 AS VARCHAR) + ' e x2 = ' + CAST(@x2 AS VARCHAR)
		END
END
GO

EXECUTE sp_raizes_eq_2_grau 5, 1, 5 
GO

EXECUTE sp_raizes_eq_2_grau 2, 4, 2 
GO

EXECUTE sp_raizes_eq_2_grau 2, 5, 2 
GO

-- 4. Crie uma função scalar que retorne o preço de uma peça reajustado de acordo com uma porcentagem
--    e um preço passados para a função. Na chamada à função você deve usar o Select/From/Where para 
--	  buscar o preço de uma peça qualquer na tabela Peça. 

DROP FUNCTION IF EXISTS reajustar_valor_peca;
GO

CREATE FUNCTION reajustar_valor_peca(
	@preco AS FLOAT,
	@reajuste AS FLOAT
)
RETURNS FLOAT
AS
BEGIN
	DECLARE @retorno FLOAT
	SET		@retorno = @preco + (@preco * (@reajuste / 100))
	RETURN	@retorno
END
GO

SELECT 	P.PeNome AS Peca, P.PePreco AS PrecoAtual, dbo.reajustar_valor_peca(P.PePreco, 50) AS 'Preco reajustado em 50%'
FROM	Peca P