-- Exemplo VIEW
CREATE VIEW exemplo_view AS
SELECT
	ID,
	Nome + ' ' + Sobrenome AS NomeCompleto
FROM
	Clientes;

-- Exemplo consulta
SELECT
	*
FROM
	exemplo_view;