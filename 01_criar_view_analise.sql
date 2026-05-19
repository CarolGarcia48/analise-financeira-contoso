-- Faturamento Total

declare @faturamentototal float = 
(select
sum(SalesAmount) as 'Faturamento total'
from
factsales)

select format (@faturamentototal, 'N') as 'Faturamento Total'

-- QTD vendas

declare @totaldevendas int = 
(
select
count(SalesKey) as 'Quantidade total de vendas'
from
factsales)

select format (@totaldevendas, 'N') as 'Total Vendido'


-- Nome + faturamento do produto mais vendido

declare @produtomaisvendido varchar(100)
declare @fatprodutomaisvendido float

select top (1) 
@produtomaisvendido = ProductName, 
@fatprodutomaisvendido = sum(SalesAmount)
from FactSales
inner join DimProduct
on FactSales.ProductKey = DimProduct.ProductKey
group by ProductName
order by
sum(SalesAmount) desc

select @produtomaisvendido as 'Produto mais Vendido',
format (@fatprodutomaisvendido, 'N') as 'Faturamento'

-- Ticket médio

select format (@faturamentototal/@totaldevendas, 'N') as 'Ticket Médio'

-- País com maior faturamento

declare @paiscommaisvendas varchar (100) 
declare @fatpaiscommaisvendas float

select top (1)
@paiscommaisvendas = SalesTerritoryCountry,
@fatpaiscommaisvendas = sum (SalesAmount)
from
FactSales
inner join DimStore on FactSales.StoreKey = DimStore.StoreKey
inner join DimSalesTerritory on DimStore.GeographyKey = DimSalesTerritory.GeographyKey
group by SalesTerritoryCountry
order by 
sum (SalesAmount) desc


select @paiscommaisvendas as 'País com mais Vendas',
format (@fatpaiscommaisvendas, 'N') as 'Faturamento país com mais vendas'

-- Canal com mais venda e sua quantidade

declare @canalcommaisvendas varchar (100) 
declare @fatcanalcommaisvendas float

select top (1)
@canalcommaisvendas = ChannelName, 
@fatcanalcommaisvendas = sum (SalesAmount) 
from
FactSales
inner join DimChannel
on
FactSales.channelKey = DimChannel.ChannelKey
group by
ChannelName
order by sum (SalesAmount) desc

select @canalcommaisvendas as 'Canal com mais Vendas',
format (@fatcanalcommaisvendas, 'N') as 'Faturamento canal com mais vendas'

-- Categoria com maior faturamento

declare @categoriamaisvendida varchar (100) 
declare @fatcategoriamaisvendida float

select top(1)
@categoriamaisvendida = ProductCategoryName,
@fatcategoriamaisvendida = sum(SalesAmount) 
from
FactSales
inner join DimProduct on FactSales.ProductKey = DimProduct.ProductKey
inner join DimProductSubcategory on DimProduct.ProductSubcategoryKey = DimProductSubcategory.ProductSubcategoryKey
inner join DimProductCategory on DimProductSubcategory.ProductCategoryKey = DimProductCategory.ProductCategoryKey	
group by
ProductCategoryName
order by 
sum(SalesAmount)
desc

select @categoriamaisvendida as 'Categoria Produto',
format (@fatcategoriamaisvendida, 'N') as 'Produto de maior faturamento'

-- Lucro por ano e mês 

select 
format(sum(SalesAmount - TotalCost),'N') as 'Lucro',
CalendarYear as 'Ano',
CalendarMonthLabel as 'Mês'
from
FactSales
inner join DimDate on FactSales.DateKey = DimDate.Datekey
group by CalendarYear, CalendarMonthLabel
order by
sum(SalesAmount - TotalCost) desc
