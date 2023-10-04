/* 1. Com os projetos de duração entre 3 e 5 meses, inclusive os que possuem um preço menor que R$30.000. Mostre os nomes, a duração e o custo, todos com apelidos. */
CREATE VIEW Projetos_3_5_Meses_Custo_Menor_30000 AS
SELECT
	PNome Nome,
	PDuracao Duracao,
	PCusto Custo
FROM
	Projeto P
WHERE
	P.PDuracao >= 3
	AND P.PDuracao <= 5
	AND P.PCusto < 30000;

/* 2. Com os projetos que tenham custo inferior a R$ 30.000,00 e apenas 1 peça fornecida. Mostrar nome e custo do projeto */
CREATE VIEW Projetos_Custo_Menor_30000_UMA_PECA AS
SELECT
	P.PNome Nome,
	P.PCusto Custo
FROM
	Projeto P
WHERE
	P.PCusto < 30000
	AND P.PNro IN (
		SELECT
			DISTINCT FP.PNro
		FROM
			Fornece_Para FP
		WHERE
			FP.Quant = 1
	);

/* 3. Criar uma visão com os nomes e os códigos das peças que são fornecidas */
CREATE VIEW Pecas_Fornecidas AS
SELECT
	Pe.PeNro Cod,
	Pe.PeNome Nome
FROM
	Peca Pe
WHERE
	Pe.PeNro IN (
		SELECT
			DISTINCT FP.PeNro
		FROM
			Fornece_Para FP
		WHERE
			FP.PeNro = Pe.PeNro
	);

/* 4. Visão com os nomes de fornecedores e suas peças (nomes) fornecidas */
CREATE VIEW Fornecedores_Pecas AS TALVEZ SEJAM 7
SELECT
	F.FNome Fornecedor,
	P.PeNome Peça,
	P.PeNro
FROM
	Fornecedor F,
	Peca P
WHERE
	P.PeNro IN (
		SELECT
			FP.PeNro
		FROM
			Fornece_Para FP
		WHERE
			F.FNro = FP.FNro
			AND P.PeNro = FP.PeNro
	);

/* 5. Com os nomes de projetos e as peças (nome) fornecidas que sejam da cor Vermelho */
CREATE VIEW Projetos_Pecas_Vermelhas AS
SELECT
	P.PNome Projeto,
	Pe.PeNome Peça
FROM
	Projeto P,
	Peca Pe
WHERE
	Pe.PeNro IN (
		SELECT
			Fp.PeNro
		FROM
			Fornece_Para Fp
		WHERE
			Fp.PeNro = Pe.PeNro
			AND Fp.PNro = P.PNro
	)
	AND Pe.PeCor = 'Vermelho';

/* EX1 */
SELECT
	*
FROM
	Projetos_3_5_Meses_Custo_Menor_30000;

/* EX2 */
SELECT
	*
FROM
	Projetos_Custo_Menor_30000_UMA_PECA;

/* EX3 */
SELECT
	*
FROM
	Pecas_Fornecidas;

/* EX4 */
SELECT
	*
FROM
	Fornecedores_Pecas;

/* EX5 */
SELECT
	*
FROM
	Projetos_Pecas_Vermelhas;