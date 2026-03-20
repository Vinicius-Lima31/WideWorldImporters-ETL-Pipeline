-- WideWorldImporters
USE WideWorldImporters;

-- VIEWS	

-- VW_DIM_PRODUTO
GO
CREATE OR ALTER VIEW VW_DIM_PRODUTO
AS
	SELECT
		si.StockItemID,
		si.StockItemName,
		si.Brand,
		si.Size,
		si.RecommendedRetailPrice,

		co.ColorName,

		sl.SupplierName
	FROM
		[Warehouse].[StockItems] si
	LEFT JOIN
		[Warehouse].[Colors] co
	ON 
		si.ColorID = co.ColorID
	LEFT JOIN 
		[Purchasing].[Suppliers] sl
	ON
		si.SupplierID = sl.SupplierID
GO

-- VW_DIM_CLIENTE
GO
CREATE OR ALTER VIEW VW_DIM_CLIENTE
AS
	SELECT
		cm.CustomerID,
		cm.CustomerName,
		cm.CreditLimit,
		cm.PhoneNumber,

		cc.CustomerCategoryName
	FROM
		[Sales].[Customers] cm
	LEFT JOIN
		[Sales].[CustomerCategories] cc
	ON
		cm.CustomerCategoryID = cc.CustomerCategoryID

GO

-- VW_DIM_VENDEDOR
GO
CREATE OR ALTER VIEW VW_DIM_VENDEDOR
AS
	SELECT
		pp.PersonID,
		pp.FullName,
		pp.EmailAddress,
		dm.DeliveryMethodName
	FROM 
		[Application].[People] pp
	LEFT JOIN 
		[Application].[DeliveryMethods] dm
	ON pp.PersonID = dm.LastEditedBy
	WHERE
		IsSalesperson = 1
GO

-- VW_DIM_GEOGRAFICA
GO
CREATE OR ALTER VIEW VW_DIM_GEOGRAFICA
AS
	SELECT
		sp.StateProvinceID,
		sp.StateProvinceName,

		ct.CountryName
	FROM
		[Application].[StateProvinces] sp
	JOIN
		[Application].[Countries] ct
	ON
		sp.CountryID = ct.CountryID
GO

-- VW_FATO_VENDAS
GO
CREATE OR ALTER VIEW VW_FATO_VENDAS
AS
SELECT
	-- PK (FATO)
	il.InvoiceLineID,		

	il.Quantity,
	il.UnitPrice,
	il.TaxAmount,
	il.LineProfit,

	-- FK das Dimensões
	il.StockItemID,			-- Produto
	ic.CustomerID,			-- Cliente
	ic.SalespersonPersonID,	-- Vendedor
	ic.InvoiceDate,			-- Data    
    cy.StateProvinceID		-- ID do Estado
FROM
    [Sales].[InvoiceLines] il
JOIN
    [Sales].[Invoices] ic 
ON 
	il.InvoiceID = ic.InvoiceID
JOIN 
    [Sales].[Customers] ct 
ON 
	ic.CustomerID = ct.CustomerID
JOIN 
    [Application].[Cities] cy 
ON 
	ct.DeliveryCityID = cy.CityID
JOIN 
    [Application].[StateProvinces] sp 
ON 
	cy.StateProvinceID = sp.StateProvinceID
GO
