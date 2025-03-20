# We should create the database
Create database Adv;

# then after we should active the data base
use adv;
select * from factinternetsales;
select * from fact_internet_sales_new;
select * from dimproduct;
select * from dimproductsubcategory;
select * from dimproductcategory;

# here both tables should be a union 
SELECT * FROM factinternetsales UNION SELECT * FROM fact_internet_sales_new;

#create the table with the name sales 
CREATE TABLE  Sales AS SELECT * FROM factinternetsales UNION SELECT * FROM fact_internet_sales_new;

#after creating the sales table  name sales . it should run the table with the help of dcl commmand
select * from sales;

#merge the sales table to dimproduct + dimproductsubcategory + dimproductcategory with the help of alias name
CREATE TABLE merged_sales_dimproduct_dimproductsubcategory_dimproductcategory AS SELECT  sales.ProductKey as salesproductkey, sales.OrderDateKey, sales.DueDateKey, sales.ShipDateKey, sales.CustomerKey, sales.PromotionKey, 
sales.CurrencyKey, sales.SalesTerritoryKey, sales.SalesOrderNumber, sales.SalesOrderLineNumber,
sales.RevisionNumber,sales.OrderQuantity,sales.UnitPrice,sales.ExtendedAmount, 
sales.UnitPriceDiscountPct, sales.DiscountAmount, sales.ProductStandardCost, 
sales.TaxAmt, sales.Freight, sales.CarrierTrackingNumber, 
sales.CustomerPONumber, sales.OrderDate, sales.DueDate, sales.ShipDate,
dimproduct.ProductKey as producttableskeys, dimproduct.ProductAlternateKey, 
dimproduct.ProductSubcategoryKey, dimproduct.WeightUnitMeasureCode, 
dimproduct.SizeUnitMeasureCode, dimproduct.EnglishProductName, dimproduct.SpanishProductName, 
dimproduct.FrenchProductName, dimproduct.StandardCost, 
dimproduct.FinishedGoodsFlag, dimproduct.Color, dimproduct.SafetyStockLevel, 
dimproduct.ReorderPoint, dimproduct.ListPrice, dimproduct.Size, dimproduct.SizeRange, 
dimproduct.Weight,dimproduct.DaysToManufacture, dimproduct.ProductLine, dimproduct.DealerPrice, 
dimproduct.Class, dimproduct.Style,dimproduct.ModelName, dimproduct.EnglishDescription, 
dimproduct.FrenchDescription,dimproduct.ChineseDescription,dimproduct.ArabicDescription, 
dimproduct.HebrewDescription, dimproduct.ThaiDescription,dimproduct.GermanDescription, 
dimproduct.JapaneseDescription, dimproduct.TurkishDescription, dimproduct.StartDate,dimproduct.EndDate, 
dimproduct.Status,
dimproductsubcategory.ProductSubcategoryKey as DimProductSubcategoryKey, dimproductsubcategory.ProductSubcategoryAlternateKey, 
dimproductsubcategory.EnglishProductSubcategoryName, dimproductsubcategory.SpanishProductSubcategoryName, dimproductsubcategory.FrenchProductSubcategoryName, 
dimproductsubcategory.ProductCategoryKey, 
dimproductcategory.productcategorykey as Dimproductcategorykey,dimproductcategory.ProductCategoryAlternateKey,dimproductcategory.EnglishProductCategoryName,
dimproductcategory.SpanishProductCategoryName,dimproductcategory.FrenchProductCategoryName
FROM  sales LEFT JOIN  dimproduct ON 
    sales.productkey = dimproduct.productkey
    left join
    dimproductsubcategory on
    dimproduct.productsubcategorykey = dimproductsubcategory.productsubcategorykey
    left join 
    dimproductcategory on
    dimproductcategory.productcategorykey = dimproductsubcategory.productcategorykey;
    
select* from merged_sales_dimproduct_dimproductsubcategory_dimproductcategory;
SELECT COUNT(*) FROM  merged_sales_dimproduct_dimproductsubcategory_dimproductcategory;

#Column Count
SELECT COUNT(*) AS total_columns
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME =  'merged_sales_dimproduct_dimproductsubcategory_dimproductcategory'
AND TABLE_SCHEMA = 'adv';

#Null Values Should Replace with NA
update merged_sales_dimproduct_dimproductsubcategory_dimproductcategory 
set FrenchProductCategoryName ="NA" where FrenchProductCategoryName is NULL;

update merged_sales_dimproduct_dimproductsubcategory_dimproductcategory 
set ProductName ="NA" where ProductName is NULL;

UPDATE merged_sales_dimproduct_dimproductsubcategory_dimproductcategory  
SET EnglishProductCategoryName = 'NA', 
    SpanishProductCategoryName = 'NA' 
WHERE EnglishProductCategoryName IS NULL 
   OR SpanishProductCategoryName IS NULL;


select * from  merged_sales_dimproduct_dimproductsubcategory_dimproductcategory;

desc merged_sales_dimproduct_dimproductsubcategory_dimproductcategory;

#Year wise sales 
SELECT YEAR(orderDatekey) AS sales_year,ROUND(SUM(UnitPrice * OrderQuantity), 0)AS total_sales
FROM merged_sales_dimproduct_dimproductsubcategory_dimproductcategory
GROUP BY YEAR(orderDatekey)
ORDER BY sales_year;

# Month Wise Sales
SELECT YEAR(OrderDatekey) AS sales_year,MONTH(OrderDatekey) AS sales_month,
ROUND(SUM(UnitPrice * OrderQuantity), 0) AS total_sales
FROM merged_sales_dimproduct_dimproductsubcategory_dimproductcategory
GROUP BY YEAR(OrderDatekey), MONTH(OrderDatekey)
ORDER BY sales_year, sales_month;

#Day Wise Sales
SELECT DATE(OrderDatekey) AS sales_date,ROUND(SUM(UnitPrice * OrderQuantity), 0) AS total_sales
FROM merged_sales_dimproduct_dimproductsubcategory_dimproductcategory
GROUP BY DATE(OrderDatekey)
ORDER BY sales_date;

#Weekend Sales  Sunday,Saturday
SELECT YEAR(OrderDatekey) AS sales_year,WEEK(OrderDatekey) AS sales_week,
ROUND(SUM(UnitPrice * OrderQuantity), 0) AS total_weekend_sales
FROM merged_sales_dimproduct_dimproductsubcategory_dimproductcategory
WHERE DAYOFWEEK(OrderDatekey) IN (1, 7) 
GROUP BY YEAR(OrderDatekey), WEEK(OrderDatekey)
ORDER BY sales_year, sales_week;

#Weekday sales
SELECT YEAR(OrderDatekey) AS sales_year,WEEK(OrderDatekey) AS sales_week,
ROUND(SUM(UnitPrice * OrderQuantity), 0) AS total_weekend_sales
FROM merged_sales_dimproduct_dimproductsubcategory_dimproductcategory
WHERE DAYOFWEEK(OrderDatekey) IN (2, 6) 
GROUP BY YEAR(OrderDatekey), WEEK(OrderDatekey)
ORDER BY sales_year, sales_week desc;

#Quarter Wise Sales
SELECT year(orderdatekey),quarter(OrderDatekey) AS sales_year,
(ROUND(SUM(UnitPrice * OrderQuantity), 0)) AS total_sales
FROM merged_sales_dimproduct_dimproductsubcategory_dimproductcategory
GROUP BY quarter(OrderDatekey),year(orderdatekey)ORDER BY sales_year asc;
#Total Qtr Wise Sales
SELECT quarter(OrderDatekey) AS sales_year,
(ROUND(SUM(UnitPrice * OrderQuantity), 0)) AS total_sales
FROM merged_sales_dimproduct_dimproductsubcategory_dimproductcategory
GROUP BY quarter(OrderDatekey)ORDER BY sales_year asc;

#Production Cost
ALTER TABLE merged_sales_dimproduct_dimproductsubcategory_dimproductcategory ADD COLUMN ProductionCost DECIMAL(10, 2);
UPDATE merged_sales_dimproduct_dimproductsubcategory_dimproductcategory
SET ProductionCost = ProductStandardCost * OrderQuantity;
select * from merged_sales_dimproduct_dimproductsubcategory_dimproductcategory;

#Profit
ALTER TABLE merged_sales_dimproduct_dimproductsubcategory_dimproductcategory ADD COLUMN Profit DECIMAL(10, 2);
UPDATE merged_sales_dimproduct_dimproductsubcategory_dimproductcategory
SET Profit = SalesAmount - ProductionCost;
Select * FROM merged_sales_dimproduct_dimproductsubcategory_dimproductcategory;

#Sales Amount
ALTER TABLE merged_sales_dimproduct_dimproductsubcategory_dimproductcategory
ADD COLUMN SalesAmount DECIMAL(10,2); 
UPDATE merged_sales_dimproduct_dimproductsubcategory_dimproductcategory SET SalesAmount = 
UnitPrice * OrderQuantity ;
select * from merged_sales_dimproduct_dimproductsubcategory_dimproductcategory ;

#Lookup  
DESC merged_sales_dimproduct_dimproductsubcategory_dimproductcategory;
ALTER TABLE merged_sales_dimproduct_dimproductsubcategory_dimproductcategory ADD COLUMN ProductName VARCHAR(255);
UPDATE merged_sales_dimproduct_dimproductsubcategory_dimproductcategory SET SalesAmount = 
UnitPrice * OrderQuantity;
UPDATE merged_sales_dimproduct_dimproductsubcategory_dimproductcategory AS s  
LEFT JOIN dimproduct AS p  
ON s.ProductKey = p.ProductKey  
SET s.ProductName = p.EnglishProductName  
WHERE s.ProductKey BETWEEN 1 AND 10000; 
ALTER TABLE dimproduct ADD INDEX (ProductKey);
ALTER TABLE merged_sales_dimproduct_dimproductsubcategory_dimproductcategory ADD INDEX (ProductKey);
ALTER TABLE merged_sales_dimproduct_dimproductsubcategory_dimproductcategory 
ADD COLUMN ProductKey INT;

Select * From merged_sales_dimproduct_dimproductsubcategory_dimproductcategory;
# Saturday And Sunday
SELECT 
    YEAR(OrderDatekey) AS sales_year,
    WEEK(OrderDatekey) AS sales_week,
    GROUP_CONCAT(DISTINCT CASE 
        WHEN DAYOFWEEK(OrderDatekey) = 1 THEN 'Sunday'
        WHEN DAYOFWEEK(OrderDatekey) = 7 THEN 'Saturday'
    END ORDER BY DAYOFWEEK(OrderDatekey) SEPARATOR ', ') AS weekend_days,
    ROUND(SUM(UnitPrice * OrderQuantity), 0) AS total_weekend_sales
FROM merged_sales_dimproduct_dimproductsubcategory_dimproductcategory
WHERE DAYOFWEEK(OrderDatekey) IN (1, 7) 
GROUP BY YEAR(OrderDatekey), WEEK(OrderDatekey)
ORDER BY sales_year, sales_week;













