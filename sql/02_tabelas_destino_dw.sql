-- Criando um SCHEMA
CREATE SCHEMA DW;
GO

-- Criando Tabelas do DW
-- Dim_Produto
CREATE TABLE DW.Dim_Produto (
	-- PK
	ID_Produto INT NOT NULL,

	-- Dados
	Nome_Produto NVARCHAR(200) NOT NULL,
	Cor NVARCHAR(50) NOT NULL,
	Marca NVARCHAR(50) NOT NULL,
	Tamanho NVARCHAR(50) NOT NULL,
	Fornecedor NVARCHAR(100) NOT NULL,

	-- Novas Colunas Para Produto
	Categoria NVARCHAR(50) NOT NULL,
	Subcategoria NVARCHAR(50) NOT NULL,

	Preco_Recomendado DECIMAL(18, 2) NOT NULL,

	-- Metadados
	Data_Linha DATETIME NOT NULL,
	LinhaOrigem NVARCHAR(100) NOT NULL,

	-- Definindo PK
	CONSTRAINT PK_Dim_Produto PRIMARY KEY CLUSTERED(ID_Produto)
)

-- Dim_Cliente
CREATE TABLE DW.Dim_Cliente (
	-- PK
	ID_Cliente INT NOT NULL,

	-- Dados
	Nome_Cliente NVARCHAR(200) NOT NULL,
	Numero_Telefone NVARCHAR(40) NOT NULL,
	Categoria NVARCHAR(100) NOT NULL,
	Credito_Limite decimal(18, 2) NOT NULL,

	
	-- Nova Coluna para Cliente
	Perfil_Credito NVARCHAR(50) NOT NULL,

	-- Metadados
	Data_Linha DATETIME NOT NULL,
	LinhaOrigem NVARCHAR(100) NOT NULL,

	CONSTRAINT PK_Dim_Cliente PRIMARY KEY CLUSTERED (ID_Cliente)
)

-- Dim_Vendedor
CREATE TABLE DW.Dim_Vendedor (
	-- PK
	ID_Vendedor INT NOT NULL,

	-- Dados
	Nome_Vendedor NVARCHAR(100) NOT NULL,
	Email NVARCHAR(200) NOT NULL,
	Metodo_Entrega NVARCHAR(50) NOT NULL,

	-- Metadados
	Data_Linha DATETIME NOT NULL,
	LinhaOrigem NVARCHAR(100) NOT NULL,

	CONSTRAINT PK_Dim_Vendedor PRIMARY KEY CLUSTERED (ID_Vendedor)
)

-- Dim_Geografica
CREATE TABLE DW.Dim_Geografica (
	-- PK
	ID_Geografica INT NOT NULL,

	-- Dados
	Estado NVARCHAR(100) NOT NULL,
	Pais NVARCHAR(120) NOT NULL,

	-- Novas Colunas Geográfica
	Latitude DECIMAL(12, 9) NOT NULL,
	Longitude DECIMAL(12, 9) NOT NULL,

	-- Metadados
	Data_Linha DATETIME NOT NULL,
	LinhaOrigem NVARCHAR(100) NOT NULL,

	CONSTRAINT PK_Dim_Geografica PRIMARY KEY CLUSTERED (ID_Geografica)
)

-- Dim_Data
CREATE TABLE DW.Dim_Data (
	-- PK (SK_DATA ex 20260702)
	ID_Data INT NOT NULL,

	-- Dados
	Data_Completa DATE NOT NULL,
	Ano INT NOT NULL,
	Mes INT NOT NULL,
	Dia INT NOT NULL,
	Semestre INT NOT NULL,
	Trimestre INT NOT NULL,

	Nome_Mes NVARCHAR(20) NOT NULL,
	Semana_Dia NVARCHAR(20) NOT NULL,
	Mes_Ano NVARCHAR(20) NOT NULL,
	Dia_Semana INT NOT NULL,
	Fim_De_Semana bit NOT NULL,
	
	-- Metadados
	Data_Linha DATETIME NOT NULL,
	LinhaOrigem NVARCHAR(100) NOT NULL,

	CONSTRAINT PK_Dim_Data PRIMARY KEY CLUSTERED (ID_Data)
)

-- Fato_Vendas
CREATE TABLE DW.Fato_Vendas (
	-- PK
	ID_Fatura INT NOT NULL,

	-- FK
	ID_Produto INT NOT NULL,
	ID_Cliente INT NOT NULL,
	ID_Vendedor INT NOT NULL,
	ID_Geografica INT NOT NULL,
	ID_Data INT NOT NULL,

	-- Dados
	Quantidade INT NOT NULL,
	Lucro DECIMAL(18, 2) NOT NULL,
	Valor_Liquido_Total DECIMAL(18, 2) NOT NULL,
	Imposto_Pedido DECIMAL(18, 2) NOT NULL,
	Custo DECIMAL(18, 2) NOT NULL,
	Valor_Bruto_Total DECIMAL(18, 2) NOT NULL,
	Imposto_Unitario DECIMAL(18, 2) NOT NULL,
	Valor_Desconto DECIMAL(18, 2) NOT NULL,

	-- Metadados
	Data_Linha DATETIME NOT NULL,
	LinhaOrigem NVARCHAR(100) NOT NULL,

	CONSTRAINT PK_Fato_Vendas PRIMARY KEY CLUSTERED (ID_Fatura)
)

-- Log_Carga
CREATE TABLE DW.Log_DW_VENDAS (
	-- PK
	ID_Log INT IDENTITY PRIMARY KEY,

	-- Dados
	Tabela NVARCHAR(50),	-- Nome da Tabela
	Inicio_Data DATETIME,	-- Inicio da Execução

	-- Tempo de Execução
	Duracao_Data AS DATEDIFF(SECOND, Inicio_Data, Fim_Data),

	Fim_Data DATETIME,		-- Fim da Execução
	Status NVARCHAR(20),	-- Sucesso ou Falha
	Linhas INT,				-- Quantidade de Linhas afetadas
	Erro NVARCHAR(MAX)		-- Descrição de um possivel erro
);