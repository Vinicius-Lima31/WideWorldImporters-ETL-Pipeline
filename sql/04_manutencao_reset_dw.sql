-- Limpeza Completa...

-- Removendo todos DADOS das Dimensões e Fato
DELETE FROM DW.Fato_Vendas;
DELETE FROM DW.Dim_Cliente;
DELETE FROM DW.Dim_Produto;
DELETE FROM DW.Dim_Vendedor;
DELETE FROM DW.Dim_Geografica;
DELETE FROM DW.Dim_Data;

-- Removendo DADOS da Tabela de LOG
TRUNCATE TABLE DW.Log_DW_VENDAS