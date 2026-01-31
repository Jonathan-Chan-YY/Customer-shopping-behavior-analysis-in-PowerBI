-- =============================================
-- Data Import Script for Customer Shopping Database
-- This script imports data from the cleaned CSV file
-- =============================================

USE CustomerShoppingDB;
GO

-- =============================================
-- Create Staging Table
-- =============================================
IF OBJECT_ID('Shopping.StagingData', 'U') IS NOT NULL
    DROP TABLE Shopping.StagingData;
GO

CREATE TABLE Shopping.StagingData (
    CustomerID INT,
    Age INT,
    Gender VARCHAR(10),
    ItemPurchased VARCHAR(100),
    Category VARCHAR(50),
    PurchaseAmountUSD DECIMAL(10,2),
    Location VARCHAR(50),
    Size VARCHAR(10),
    Color VARCHAR(50),
    Season VARCHAR(20),
    ReviewRating DECIMAL(3,1),
    SubscriptionStatus VARCHAR(10),
    ShippingType VARCHAR(50),
    DiscountApplied VARCHAR(10),
    PromoCodeUsed VARCHAR(10),
    PreviousPurchases INT,
    PaymentMethod VARCHAR(50),
    FrequencyOfPurchases VARCHAR(20),
    AgeGroup VARCHAR(10),
    PurchaseCategory VARCHAR(20),
    HighValueCustomer INT,
    DiscountUsed INT
);
GO

PRINT 'Staging table created successfully.';
GO

-- =============================================
-- Import Data from CSV
-- =============================================
-- NOTE: Update the file path to match your environment
-- The file path should point to: data/cleaned/customer_shopping_cleaned.csv
-- 
-- For Windows: 'C:\path\to\project\data\cleaned\customer_shopping_cleaned.csv'
-- For Linux: '/path/to/project/data/cleaned/customer_shopping_cleaned.csv'
--
-- Example BULK INSERT command (uncomment and modify path):
/*
BULK INSERT Shopping.StagingData
FROM 'C:\YourPath\data\cleaned\customer_shopping_cleaned.csv'
WITH (
    FIRSTROW = 2,  -- Skip header row
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK,
    FORMAT = 'CSV'
);
GO
*/

PRINT '';
PRINT '=============================================';
PRINT 'MANUAL IMPORT REQUIRED';
PRINT '=============================================';
PRINT 'Please import the CSV file using one of these methods:';
PRINT '';
PRINT '1. SQL Server Management Studio (SSMS):';
PRINT '   - Right-click on CustomerShoppingDB';
PRINT '   - Tasks > Import Data';
PRINT '   - Select CSV file: data/cleaned/customer_shopping_cleaned.csv';
PRINT '   - Target table: Shopping.StagingData';
PRINT '';
PRINT '2. BULK INSERT command:';
PRINT '   - Uncomment and modify the BULK INSERT command above';
PRINT '   - Update the file path to match your environment';
PRINT '   - Execute this script';
PRINT '';
PRINT '3. Python script (recommended):';
PRINT '   - Run: python scripts/03_import_to_sql.py';
PRINT '   - This will automatically import the data';
PRINT '=============================================';
GO

-- =============================================
-- Populate Dimension Tables
-- =============================================

-- Populate DimSeason
PRINT 'Populating DimSeason...';
INSERT INTO Shopping.DimSeason (Season)
SELECT DISTINCT Season
FROM Shopping.StagingData
WHERE Season IS NOT NULL;
GO

-- Populate DimPayment
PRINT 'Populating DimPayment...';
INSERT INTO Shopping.DimPayment (PaymentMethod, ShippingType)
SELECT DISTINCT PaymentMethod, ShippingType
FROM Shopping.StagingData
WHERE PaymentMethod IS NOT NULL;
GO

-- Populate DimProduct
PRINT 'Populating DimProduct...';
INSERT INTO Shopping.DimProduct (ItemPurchased, Category, Size, Color)
SELECT DISTINCT ItemPurchased, Category, Size, Color
FROM Shopping.StagingData
WHERE ItemPurchased IS NOT NULL;
GO

-- Populate DimCustomer
PRINT 'Populating DimCustomer...';
INSERT INTO Shopping.DimCustomer (CustomerID, Age, Gender, AgeGroup, Location, SubscriptionStatus, PreviousPurchases)
SELECT DISTINCT 
    CustomerID,
    Age,
    Gender,
    AgeGroup,
    Location,
    SubscriptionStatus,
    PreviousPurchases
FROM Shopping.StagingData
WHERE CustomerID IS NOT NULL;
GO

-- =============================================
-- Populate Fact Table
-- =============================================
PRINT 'Populating FactPurchases...';
INSERT INTO Shopping.FactPurchases (
    CustomerKey,
    ProductKey,
    SeasonKey,
    PaymentKey,
    PurchaseAmountUSD,
    ReviewRating,
    DiscountApplied,
    PromoCodeUsed,
    PurchaseCategory,
    HighValueCustomer,
    FrequencyOfPurchases
)
SELECT 
    c.CustomerKey,
    p.ProductKey,
    s.SeasonKey,
    pm.PaymentKey,
    st.PurchaseAmountUSD,
    st.ReviewRating,
    CASE WHEN st.DiscountApplied = 'Yes' THEN 1 ELSE 0 END,
    CASE WHEN st.PromoCodeUsed = 'Yes' THEN 1 ELSE 0 END,
    st.PurchaseCategory,
    st.HighValueCustomer,
    st.FrequencyOfPurchases
FROM Shopping.StagingData st
INNER JOIN Shopping.DimCustomer c ON st.CustomerID = c.CustomerID
INNER JOIN Shopping.DimProduct p ON st.ItemPurchased = p.ItemPurchased 
    AND st.Category = p.Category
    AND ISNULL(st.Size, '') = ISNULL(p.Size, '')
    AND ISNULL(st.Color, '') = ISNULL(p.Color, '')
INNER JOIN Shopping.DimSeason s ON st.Season = s.Season
INNER JOIN Shopping.DimPayment pm ON st.PaymentMethod = pm.PaymentMethod
    AND ISNULL(st.ShippingType, '') = ISNULL(pm.ShippingType, '');
GO

-- =============================================
-- Data Validation
-- =============================================
PRINT '';
PRINT '=============================================';
PRINT 'Data Import Summary';
PRINT '=============================================';
PRINT 'Records in staging table: ' + CAST((SELECT COUNT(*) FROM Shopping.StagingData) AS VARCHAR(10));
PRINT 'DimCustomer records: ' + CAST((SELECT COUNT(*) FROM Shopping.DimCustomer) AS VARCHAR(10));
PRINT 'DimProduct records: ' + CAST((SELECT COUNT(*) FROM Shopping.DimProduct) AS VARCHAR(10));
PRINT 'DimSeason records: ' + CAST((SELECT COUNT(*) FROM Shopping.DimSeason) AS VARCHAR(10));
PRINT 'DimPayment records: ' + CAST((SELECT COUNT(*) FROM Shopping.DimPayment) AS VARCHAR(10));
PRINT 'FactPurchases records: ' + CAST((SELECT COUNT(*) FROM Shopping.FactPurchases) AS VARCHAR(10));
PRINT '=============================================';
GO

-- =============================================
-- Clean Up (Optional)
-- =============================================
-- Uncomment to drop staging table after successful import
-- DROP TABLE Shopping.StagingData;
-- GO

PRINT '';
PRINT 'Data import process complete!';
PRINT 'Next step: Run 03_create_views.sql to create PowerBI views';
GO
