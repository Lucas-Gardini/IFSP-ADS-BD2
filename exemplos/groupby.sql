-- Exemplo GROUPBY

SELECT categoria, COUNT(*) AS quantidade
FROM produtos
GROUP BY categoria;


-- Exemplo GROUPBY com HAVING
SELECT categoria, AVG(preco) AS preco_medio
FROM produtos
GROUP BY categoria
HAVING AVG(preco) > 50;