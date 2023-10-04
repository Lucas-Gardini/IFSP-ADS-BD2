SELECT TOP 1 * FROM Projeto;

-- Join implícito
SELECT 		P.PNome Projeto, PE.PeNome Peca, SUM(Fp.Quant) 'Quantidade Fornecida' 
FROM 		Projeto P, Peca PE, Fornece_Para FP
WHERE 		P.PNro = 4
AND 		P.PNro = FP.PNro
AND 		PE.PeNro = fp.PeNro
GROUP BY 	Pe.PeNome, P.PNome
HAVING 		SUM(FP.Quant) > 0
GO

-- Join explícito
SELECT      P.PNome Projeto, PE.PeNome Peca, SUM(Fp.Quant) 'Quantidade Fornecida' 
FROM  		Fornece_Para FP
INNER JOIN 	Peca PE on FP.PeNro = PE.PeNro
INNER JOIN	Projeto P on FP.PNro = P.PNro
WHERE       P.PNro = 4
AND         P.PNro = FP.PNro
GROUP BY    Pe.PeNome, P.PNome
HAVING      SUM(FP.Quant) > 0
GO