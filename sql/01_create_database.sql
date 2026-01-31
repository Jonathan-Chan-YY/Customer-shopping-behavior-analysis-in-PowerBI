-- =============================================
-- Customer Shopping Behavior Analysis Database
-- SQL Server Database Creation Script
-- =============================================

-- Create Database
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'CustomerShoppingDB')
BEGIN
    CREATE DATABASE CustomerShoppingDB;
    PRINT 'Database CustomerShoppingDB created successfully.';
END
ELSE
BEGIN
    PRINT 'Database CustomerShoppingDB already exists.';
END
GO

USE CustomerShoppingDB;
GO

-- =============================================
-- Create Schema
-- =============================================
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'Shopping')
BEGIN
    EXEC('CREATE SCHEMA Shopping');
    PRINT 'Schema Shopping created successfully.';
END
GO

-- =============================================
-- Create Customer Dimension Table
-- =============================================
IF OBJECT_ID('Shopping.DimCustomer', 'U') IS NOT NULL
    DROP TABLE Shopping.DimCustomer;
GO

CREATE TABLE Shopping.DimCustomer (
    CustomerKey INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT NOT NULL,
    Age INT NOT NULL,
    Gender VARCHAR(10) NOT NULL,
    AgeGroup VARCHAR(10),
    Location VARCHAR(50),
    SubscriptionStatus VARCHAR(10),
    PreviousPurchases INT,
    CONSTRAINT UQ_CustomerID UNIQUE (CustomerID)
);
GO

PRINT 'Table Shopping.DimCustomer created successfully.';
GO

-- =============================================
-- Create Product Dimension Table
-- =============================================
IF OBJECT_ID('Shopping.DimProduct', 'U') IS NOT NULL
    DROP TABLE Shopping.DimProduct;
GO

CREATE TABLE Shopping.DimProduct (
    ProductKey INT IDENTITY(1,1) PRIMARY KEY,
    ItemPurchased VARCHAR(100) NOT NULL,
    Category VARCHAR(50) NOT NULL,
    Size VARCHAR(10),
    Color VARCHAR(50)
);
GO

PRINT 'Table Shopping.DimProduct created successfully.';
GO

-- =============================================
-- Create Season Dimension Table
-- =============================================
IF OBJECT_ID('Shopping.DimSeason', 'U') IS NOT NULL
    DROP TABLE Shopping.DimSeason;
GO

CREATE TABLE Shopping.DimSeason (
    SeasonKey INT IDENTITY(1,1) PRIMARY KEY,
    Season VARCHAR(20) NOT NULL UNIQUE
);
GO

PRINT 'Table Shopping.DimSeason created successfully.';
GO

-- =============================================
-- Create Payment Method Dimension Table
-- =============================================
IF OBJECT_ID('Shopping.DimPayment', 'U') IS NOT NULL
    DROP TABLE Shopping.DimPayment;
GO

CREATE TABLE Shopping.DimPayment (
    PaymentKey INT IDENTITY(1,1) PRIMARY KEY,
    PaymentMethod VARCHAR(50) NOT NULL UNIQUE,
    ShippingType VARCHAR(50)
);
GO

PRINT 'Table Shopping.DimPayment created successfully.';
GO

-- =============================================
-- Create Purchases Fact Table
-- =============================================
IF OBJECT_ID('Shopping.FactPurchases', 'U') IS NOT NULL
    DROP TABLE Shopping.FactPurchases;
GO

CREATE TABLE Shopping.FactPurchases (
    PurchaseKey INT IDENTITY(1,1) PRIMARY KEY,
    CustomerKey INT NOT NULL,
    ProductKey INT NOT NULL,
    SeasonKey INT NOT NULL,
    PaymentKey INT NOT NULL,
    PurchaseAmountUSD DECIMAL(10,2) NOT NULL,
    ReviewRating DECIMAL(3,1),
    DiscountApplied BIT,
    PromoCodeUsed BIT,
    PurchaseCategory VARCHAR(20),
    HighValueCustomer BIT,
    FrequencyOfPurchases VARCHAR(20),
    CONSTRAINT FK_FactPurchases_Customer FOREIGN KEY (CustomerKey) 
        REFERENCES Shopping.DimCustomer(CustomerKey),
    CONSTRAINT FK_FactPurchases_Product FOREIGN KEY (ProductKey) 
        REFERENCES Shopping.DimProduct(ProductKey),
    CONSTRAINT FK_FactPurchases_Season FOREIGN KEY (SeasonKey) 
        REFERENCES Shopping.DimSeason(SeasonKey),
    CONSTRAINT FK_FactPurchases_Payment FOREIGN KEY (PaymentKey) 
        REFERENCES Shopping.DimPayment(PaymentKey)
);
GO

PRINT 'Table Shopping.FactPurchases created successfully.';
GO

-- =============================================
-- Create Indexes for Performance
-- =============================================
CREATE INDEX IX_FactPurchases_CustomerKey ON Shopping.FactPurchases(CustomerKey);
CREATE INDEX IX_FactPurchases_ProductKey ON Shopping.FactPurchases(ProductKey);
CREATE INDEX IX_FactPurchases_SeasonKey ON Shopping.FactPurchases(SeasonKey);
CREATE INDEX IX_FactPurchases_PaymentKey ON Shopping.FactPurchases(PaymentKey);
CREATE INDEX IX_FactPurchases_Amount ON Shopping.FactPurchases(PurchaseAmountUSD);
GO

PRINT 'Indexes created successfully.';
GO

-- =============================================
-- Summary
-- =============================================
PRINT '';
PRINT '=============================================';
PRINT 'Database Setup Complete!';
PRINT 'Database: CustomerShoppingDB';
PRINT 'Schema: Shopping';
PRINT 'Tables Created:';
PRINT '  - Shopping.DimCustomer (Customer Dimension)';
PRINT '  - Shopping.DimProduct (Product Dimension)';
PRINT '  - Shopping.DimSeason (Season Dimension)';
PRINT '  - Shopping.DimPayment (Payment Dimension)';
PRINT '  - Shopping.FactPurchases (Purchases Fact)';
PRINT '=============================================';
PRINT '';
PRINT 'Next Steps:';
PRINT '1. Review the schema structure';
PRINT '2. Run 02_import_data.sql to load data';
PRINT '3. Run 03_create_views.sql for PowerBI views';
PRINT '=============================================';
GO
