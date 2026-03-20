-- Criando Relações
-- DW.Fato_Vendas

-- Produtos
ALTER TABLE DW.Fato_Vendas
	WITH CHECK 
	ADD CONSTRAINT [FK_Fato_Vendas_Dim_Produto]
	FOREIGN KEY(ID_Produto)
	REFERENCES DW.Dim_Produto (ID_Produto)

-- Cliente
ALTER TABLE DW.Fato_Vendas
	WITH CHECK 
	ADD CONSTRAINT [FK_Fato_Vendas_Dim_Cliente]
	FOREIGN KEY(ID_Cliente)
	REFERENCES DW.Dim_Cliente (ID_Cliente)

-- Vendedor
ALTER TABLE DW.Fato_Vendas
	WITH CHECK 
	ADD CONSTRAINT [FK_Fato_Vendas_Dim_Vendedor]
	FOREIGN KEY(ID_Vendedor)
	REFERENCES DW.Dim_Vendedor (ID_Vendedor)

-- Geografica 
ALTER TABLE DW.Fato_Vendas
	WITH CHECK 
	ADD CONSTRAINT [FK_Fato_Vendas_Dim_Geografica]
	FOREIGN KEY(ID_Geografica)
	REFERENCES DW.Dim_Geografica (ID_Geografica)

-- Data
ALTER TABLE DW.Fato_Vendas
	WITH CHECK 
	ADD CONSTRAINT [FK_Fato_Vendas_Dim_Data]
	FOREIGN KEY(ID_Data)
	REFERENCES DW.Dim_Data (ID_Data)