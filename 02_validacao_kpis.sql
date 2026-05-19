-- =========================================
-- VIEW PARA ANÁLISE DE VENDAS CONTOSO
-- =========================================

CREATE OR ALTER  VIEW contoso_analise AS

SELECT

-- Datas  
DimDate.CalendarYear,  
DimDate.CalendarMonthLabel,  

-- Produto  
DimProduct.ProductName,  
DimProductCategory.ProductCategoryName,  

-- Canal  
DimChannel.ChannelName,  

-- País  
DimSalesTerritory.SalesTerritoryCountry,  

-- Métricas  
FactSales.SalesQuantity,  
FactSales.SalesAmount,  
FactSales.TotalCost,  

-- Lucro  
FactSales.SalesAmount - FactSales.TotalCost AS Profit

FROM FactSales

-- Produto
INNER JOIN DimProduct
ON FactSales.ProductKey = DimProduct.ProductKey

INNER JOIN DimProductSubcategory
ON DimProduct.ProductSubcategoryKey = DimProductSubcategory.ProductSubcategoryKey

INNER JOIN DimProductCategory
ON DimProductSubcategory.ProductCategoryKey = DimProductCategory.ProductCategoryKey

-- Canal
INNER JOIN DimChannel
ON FactSales.ChannelKey = DimChannel.ChannelKey

-- País
INNER JOIN DimStore
ON FactSales.StoreKey = DimStore.StoreKey

INNER JOIN DimSalesTerritory
ON DimStore.GeographyKey = DimSalesTerritory.GeographyKey

-- Datas
INNER JOIN DimDate
ON FactSales.DateKey = DimDate.DateKey

