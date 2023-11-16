-- Iniciar uma transação
BEGIN TRANSACTION;

-- Exemplo de operações dentro da transação
DECLARE @NovoSaldoContaA DECIMAL(10, 2);
DECLARE @NovoSaldoContaB DECIMAL(10, 2);
DECLARE @ValorTransferencia DECIMAL(10, 2);

SET @ValorTransferencia = 100.00;  -- Valor a ser transferido

-- Deduzir o valor da Conta A
UPDATE Contas
SET Saldo = Saldo - @ValorTransferencia
WHERE ContaID = 1;

-- Atualizar o novo saldo da Conta A
SELECT @NovoSaldoContaA = Saldo
FROM Contas
WHERE ContaID = 1;

-- Adicionar o valor à Conta B
UPDATE Contas
SET Saldo = Saldo + @ValorTransferencia
WHERE ContaID = 2;

-- Atualizar o novo saldo da Conta B
SELECT @NovoSaldoContaB = Saldo
FROM Contas
WHERE ContaID = 2;

-- Verificar se as operações foram bem-sucedidas
IF @NovoSaldoContaA >= 0 AND @NovoSaldoContaB >= 0
BEGIN
    -- Commit da transação se tudo estiver correto
    COMMIT TRANSACTION;
    PRINT 'Transferência bem-sucedida!';
END
ELSE
BEGIN
    -- Rollback da transação em caso de erro
    ROLLBACK TRANSACTION;
    PRINT 'Erro na transferência. Rollback realizado.';
END;
