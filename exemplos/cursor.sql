-- Exemplo de CURSOR em SQL Server
DECLARE @ClienteID INT;
DECLARE @NomeCliente VARCHAR(50);

-- Criar um cursor
DECLARE clienteCursor CURSOR FOR
SELECT ClienteID, Nome
FROM Clientes;

-- Abrir o cursor
OPEN clienteCursor;

-- Inicializar variáveis
FETCH NEXT FROM clienteCursor INTO @ClienteID, @NomeCliente;

-- Loop através das linhas
WHILE @@FETCH_STATUS = 0
BEGIN
    -- Processar os dados
    PRINT 'Cliente ID: ' + CAST(@ClienteID AS VARCHAR(10)) + ', Nome: ' + @NomeCliente;

    -- Obter a próxima linha
    FETCH NEXT FROM clienteCursor INTO @ClienteID, @NomeCliente;
END

-- Fechar o cursor
CLOSE clienteCursor;

-- Liberar recursos do cursor
DEALLOCATE clienteCursor;
