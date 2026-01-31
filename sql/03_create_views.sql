-- =============================================
-- Create Views for PowerBI Dashboard
-- =============================================

USE CustomerShoppingDB;
GO

-- =============================================
-- View 1: Sales Overview
-- =============================================
IF OBJECT_ID('Shopping.vw_SalesOverview', 'V') IS NOT NULL
    DROP VIEW Shopping.vw_SalesOverview;
GO

CREATE VIEW Shopping.vw_SalesOverview
AS
SELECT 
    COUNT(DISTINCT f.PurchaseKey) AS TotalTransactions,
    COUNT(DISTINCT f.CustomerKey) AS TotalCustomers,
    SUM(f.PurchaseAmountUSD) AS TotalRevenue,
    AVG(f.PurchaseAmountUSD) AS AverageOrderValue,
    AVG(f.ReviewRating) AS AverageRating,
    SUM(CASE WHEN f.DiscountApplied = 1 THEN 1 ELSE 0 END) AS DiscountedTransactions,
    SUM(CASE WHEN f.HighValueCustomer = 1 THEN 1 ELSE 0 END) AS HighValueTransactions
FROM Shopping.FactPurchases f;
GO

PRINT 'View Shopping.vw_SalesOverview created successfully.';
GO

-- =============================================
-- View 2: Sales by Category
-- =============================================
IF OBJECT_ID('Shopping.vw_SalesByCategory', 'V') IS NOT NULL
    DROP VIEW Shopping.vw_SalesByCategory;
GO

CREATE VIEW Shopping.vw_SalesByCategory
AS
SELECT 
    p.Category,
    COUNT(f.PurchaseKey) AS TransactionCount,
    SUM(f.PurchaseAmountUSD) AS TotalRevenue,
    AVG(f.PurchaseAmountUSD) AS AverageOrderValue,
    AVG(f.ReviewRating) AS AverageRating,
    COUNT(DISTINCT f.CustomerKey) AS UniqueCustomers
FROM Shopping.FactPurchases f
INNER JOIN Shopping.DimProduct p ON f.ProductKey = p.ProductKey
GROUP BY p.Category;
GO

PRINT 'View Shopping.vw_SalesByCategory created successfully.';
GO

-- =============================================
-- View 3: Sales by Season
-- =============================================
IF OBJECT_ID('Shopping.vw_SalesBySeason', 'V') IS NOT NULL
    DROP VIEW Shopping.vw_SalesBySeason;
GO

CREATE VIEW Shopping.vw_SalesBySeason
AS
SELECT 
    s.Season,
    COUNT(f.PurchaseKey) AS TransactionCount,
    SUM(f.PurchaseAmountUSD) AS TotalRevenue,
    AVG(f.PurchaseAmountUSD) AS AverageOrderValue,
    COUNT(DISTINCT f.CustomerKey) AS UniqueCustomers
FROM Shopping.FactPurchases f
INNER JOIN Shopping.DimSeason s ON f.SeasonKey = s.SeasonKey
GROUP BY s.Season;
GO

PRINT 'View Shopping.vw_SalesBySeason created successfully.';
GO

-- =============================================
-- View 4: Customer Demographics
-- =============================================
IF OBJECT_ID('Shopping.vw_CustomerDemographics', 'V') IS NOT NULL
    DROP VIEW Shopping.vw_CustomerDemographics;
GO

CREATE VIEW Shopping.vw_CustomerDemographics
AS
SELECT 
    c.AgeGroup,
    c.Gender,
    c.Location,
    COUNT(DISTINCT c.CustomerKey) AS CustomerCount,
    COUNT(f.PurchaseKey) AS TotalPurchases,
    SUM(f.PurchaseAmountUSD) AS TotalSpent,
    AVG(f.PurchaseAmountUSD) AS AverageOrderValue,
    AVG(c.PreviousPurchases) AS AveragePreviousPurchases
FROM Shopping.DimCustomer c
LEFT JOIN Shopping.FactPurchases f ON c.CustomerKey = f.CustomerKey
GROUP BY c.AgeGroup, c.Gender, c.Location;
GO

PRINT 'View Shopping.vw_CustomerDemographics created successfully.';
GO

-- =============================================
-- View 5: Product Performance
-- =============================================
IF OBJECT_ID('Shopping.vw_ProductPerformance', 'V') IS NOT NULL
    DROP VIEW Shopping.vw_ProductPerformance;
GO

CREATE VIEW Shopping.vw_ProductPerformance
AS
SELECT 
    p.ItemPurchased,
    p.Category,
    p.Size,
    p.Color,
    COUNT(f.PurchaseKey) AS UnitsSold,
    SUM(f.PurchaseAmountUSD) AS TotalRevenue,
    AVG(f.PurchaseAmountUSD) AS AveragePrice,
    AVG(f.ReviewRating) AS AverageRating
FROM Shopping.DimProduct p
LEFT JOIN Shopping.FactPurchases f ON p.ProductKey = f.ProductKey
GROUP BY p.ItemPurchased, p.Category, p.Size, p.Color;
GO

PRINT 'View Shopping.vw_ProductPerformance created successfully.';
GO

-- =============================================
-- View 6: Payment and Shipping Analysis
-- =============================================
IF OBJECT_ID('Shopping.vw_PaymentShipping', 'V') IS NOT NULL
    DROP VIEW Shopping.vw_PaymentShipping;
GO

CREATE VIEW Shopping.vw_PaymentShipping
AS
SELECT 
    pm.PaymentMethod,
    pm.ShippingType,
    COUNT(f.PurchaseKey) AS TransactionCount,
    SUM(f.PurchaseAmountUSD) AS TotalRevenue,
    AVG(f.PurchaseAmountUSD) AS AverageOrderValue,
    AVG(f.ReviewRating) AS AverageRating
FROM Shopping.DimPayment pm
LEFT JOIN Shopping.FactPurchases f ON pm.PaymentKey = f.PaymentKey
GROUP BY pm.PaymentMethod, pm.ShippingType;
GO

PRINT 'View Shopping.vw_PaymentShipping created successfully.';
GO

-- =============================================
-- View 7: Discount Impact Analysis
-- =============================================
IF OBJECT_ID('Shopping.vw_DiscountImpact', 'V') IS NOT NULL
    DROP VIEW Shopping.vw_DiscountImpact;
GO

CREATE VIEW Shopping.vw_DiscountImpact
AS
SELECT 
    CASE WHEN f.DiscountApplied = 1 THEN 'Discount Applied' ELSE 'No Discount' END AS DiscountStatus,
    CASE WHEN f.PromoCodeUsed = 1 THEN 'Promo Used' ELSE 'No Promo' END AS PromoStatus,
    COUNT(f.PurchaseKey) AS TransactionCount,
    SUM(f.PurchaseAmountUSD) AS TotalRevenue,
    AVG(f.PurchaseAmountUSD) AS AverageOrderValue,
    AVG(f.ReviewRating) AS AverageRating
FROM Shopping.FactPurchases f
GROUP BY f.DiscountApplied, f.PromoCodeUsed;
GO

PRINT 'View Shopping.vw_DiscountImpact created successfully.';
GO

-- =============================================
-- View 8: Customer Segmentation
-- =============================================
IF OBJECT_ID('Shopping.vw_CustomerSegmentation', 'V') IS NOT NULL
    DROP VIEW Shopping.vw_CustomerSegmentation;
GO

CREATE VIEW Shopping.vw_CustomerSegmentation
AS
SELECT 
    c.CustomerID,
    c.Age,
    c.Gender,
    c.AgeGroup,
    c.Location,
    c.SubscriptionStatus,
    c.PreviousPurchases,
    COUNT(f.PurchaseKey) AS CurrentPurchases,
    SUM(f.PurchaseAmountUSD) AS TotalSpent,
    AVG(f.ReviewRating) AS AverageRating,
    MAX(CASE WHEN f.HighValueCustomer = 1 THEN 'Yes' ELSE 'No' END) AS HighValueCustomer,
    f.FrequencyOfPurchases
FROM Shopping.DimCustomer c
LEFT JOIN Shopping.FactPurchases f ON c.CustomerKey = f.CustomerKey
GROUP BY c.CustomerID, c.Age, c.Gender, c.AgeGroup, c.Location, 
         c.SubscriptionStatus, c.PreviousPurchases, f.FrequencyOfPurchases;
GO

PRINT 'View Shopping.vw_CustomerSegmentation created successfully.';
GO

-- =============================================
-- View 9: Complete Purchase Details
-- =============================================
IF OBJECT_ID('Shopping.vw_PurchaseDetails', 'V') IS NOT NULL
    DROP VIEW Shopping.vw_PurchaseDetails;
GO

CREATE VIEW Shopping.vw_PurchaseDetails
AS
SELECT 
    f.PurchaseKey,
    c.CustomerID,
    c.Age,
    c.Gender,
    c.AgeGroup,
    c.Location,
    c.SubscriptionStatus,
    p.ItemPurchased,
    p.Category,
    p.Size,
    p.Color,
    s.Season,
    pm.PaymentMethod,
    pm.ShippingType,
    f.PurchaseAmountUSD,
    f.PurchaseCategory,
    f.ReviewRating,
    CASE WHEN f.DiscountApplied = 1 THEN 'Yes' ELSE 'No' END AS DiscountApplied,
    CASE WHEN f.PromoCodeUsed = 1 THEN 'Yes' ELSE 'No' END AS PromoCodeUsed,
    CASE WHEN f.HighValueCustomer = 1 THEN 'Yes' ELSE 'No' END AS HighValueCustomer,
    f.FrequencyOfPurchases,
    c.PreviousPurchases
FROM Shopping.FactPurchases f
INNER JOIN Shopping.DimCustomer c ON f.CustomerKey = c.CustomerKey
INNER JOIN Shopping.DimProduct p ON f.ProductKey = p.ProductKey
INNER JOIN Shopping.DimSeason s ON f.SeasonKey = s.SeasonKey
INNER JOIN Shopping.DimPayment pm ON f.PaymentKey = pm.PaymentKey;
GO

PRINT 'View Shopping.vw_PurchaseDetails created successfully.';
GO

-- =============================================
-- Summary
-- =============================================
PRINT '';
PRINT '=============================================';
PRINT 'Views Created Successfully!';
PRINT '=============================================';
PRINT 'The following views are now available for PowerBI:';
PRINT '';
PRINT '1. vw_SalesOverview - Overall sales metrics';
PRINT '2. vw_SalesByCategory - Sales breakdown by product category';
PRINT '3. vw_SalesBySeason - Seasonal sales analysis';
PRINT '4. vw_CustomerDemographics - Customer demographic insights';
PRINT '5. vw_ProductPerformance - Product-level performance metrics';
PRINT '6. vw_PaymentShipping - Payment and shipping analysis';
PRINT '7. vw_DiscountImpact - Discount effectiveness analysis';
PRINT '8. vw_CustomerSegmentation - Customer segmentation data';
PRINT '9. vw_PurchaseDetails - Complete purchase information';
PRINT '';
PRINT '=============================================';
PRINT 'Next Steps:';
PRINT '1. Connect PowerBI to SQL Server';
PRINT '2. Import these views into PowerBI';
PRINT '3. Create visualizations and dashboards';
PRINT 'Refer to: docs/PowerBI_Setup_Guide.md';
PRINT '=============================================';
GO
