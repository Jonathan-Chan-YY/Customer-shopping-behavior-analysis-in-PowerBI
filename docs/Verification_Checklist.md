# Project Verification Checklist

Use this checklist to verify your PowerBI data visualization project is set up correctly.

## ✅ Phase 1: Environment Setup

- [ ] Python 3.8+ installed
  ```bash
  python --version
  ```
  Expected: Python 3.8.x or higher

- [ ] All Python packages installed
  ```bash
  pip list | grep -E "pandas|numpy|pyodbc|sqlalchemy"
  ```
  Expected: All 4 packages listed

- [ ] SQL Server running
  - Check Windows Services or `systemctl status mssql-server`
  
- [ ] Power BI Desktop installed
  - Version 2.0 or later recommended

- [ ] ODBC Driver 17 for SQL Server installed
  - Required for PowerBI connection

## ✅ Phase 2: Data Files

- [ ] Project directory structure exists
  ```bash
  ls -d data/ scripts/ sql/ docs/
  ```
  Expected: All 4 directories present

- [ ] Raw data file created
  ```bash
  ls -lh data/raw/customer_shopping_data.csv
  wc -l data/raw/customer_shopping_data.csv
  ```
  Expected: File exists, ~3901 lines (including header)

- [ ] Cleaned data file created
  ```bash
  ls -lh data/cleaned/customer_shopping_cleaned.csv
  wc -l data/cleaned/customer_shopping_cleaned.csv
  ```
  Expected: File exists, ~3901 lines (including header)

- [ ] Data quality verified
  - No duplicate records
  - No missing values in critical fields
  - Age range: 18-70
  - Purchase amounts: $20-$100
  - Review ratings: 2.5-5.0

## ✅ Phase 3: SQL Server Database

- [ ] Database created
  ```sql
  SELECT name FROM sys.databases WHERE name = 'CustomerShoppingDB';
  ```
  Expected: 1 row returned

- [ ] Schema created
  ```sql
  USE CustomerShoppingDB;
  SELECT name FROM sys.schemas WHERE name = 'Shopping';
  ```
  Expected: 1 row returned

- [ ] All tables created
  ```sql
  SELECT TABLE_NAME 
  FROM INFORMATION_SCHEMA.TABLES 
  WHERE TABLE_SCHEMA = 'Shopping' 
  AND TABLE_TYPE = 'BASE TABLE';
  ```
  Expected: 5 tables
  - DimCustomer
  - DimProduct
  - DimSeason
  - DimPayment
  - FactPurchases

- [ ] Tables populated with data
  ```sql
  SELECT 'DimCustomer' AS TableName, COUNT(*) AS Records FROM Shopping.DimCustomer
  UNION ALL
  SELECT 'DimProduct', COUNT(*) FROM Shopping.DimProduct
  UNION ALL
  SELECT 'DimSeason', COUNT(*) FROM Shopping.DimSeason
  UNION ALL
  SELECT 'DimPayment', COUNT(*) FROM Shopping.DimPayment
  UNION ALL
  SELECT 'FactPurchases', COUNT(*) FROM Shopping.FactPurchases;
  ```
  Expected record counts:
  - DimCustomer: ~3900
  - DimProduct: ~500-800
  - DimSeason: 4
  - DimPayment: ~20-30
  - FactPurchases: 3900

- [ ] Foreign key constraints active
  ```sql
  SELECT 
    fk.name AS ForeignKeyName,
    OBJECT_NAME(fk.parent_object_id) AS TableName,
    OBJECT_NAME(fk.referenced_object_id) AS ReferencedTable
  FROM sys.foreign_keys fk
  WHERE OBJECT_SCHEMA_NAME(fk.parent_object_id) = 'Shopping';
  ```
  Expected: 4 foreign keys in FactPurchases

- [ ] Indexes created
  ```sql
  SELECT 
    OBJECT_NAME(i.object_id) AS TableName,
    i.name AS IndexName,
    i.type_desc
  FROM sys.indexes i
  WHERE OBJECT_SCHEMA_NAME(i.object_id) = 'Shopping';
  ```
  Expected: Multiple indexes on FactPurchases

## ✅ Phase 4: SQL Views

- [ ] All views created
  ```sql
  SELECT TABLE_NAME 
  FROM INFORMATION_SCHEMA.VIEWS 
  WHERE TABLE_SCHEMA = 'Shopping';
  ```
  Expected: 9 views
  1. vw_SalesOverview
  2. vw_SalesByCategory
  3. vw_SalesBySeason
  4. vw_CustomerDemographics
  5. vw_ProductPerformance
  6. vw_PaymentShipping
  7. vw_DiscountImpact
  8. vw_CustomerSegmentation
  9. vw_PurchaseDetails

- [ ] Views return data
  ```sql
  -- Test each view
  SELECT COUNT(*) FROM Shopping.vw_SalesOverview;          -- Should be 1
  SELECT COUNT(*) FROM Shopping.vw_SalesByCategory;        -- Should be 4
  SELECT COUNT(*) FROM Shopping.vw_SalesBySeason;          -- Should be 4
  SELECT COUNT(*) FROM Shopping.vw_CustomerDemographics;   -- Should be many
  SELECT COUNT(*) FROM Shopping.vw_ProductPerformance;     -- Should be many
  SELECT COUNT(*) FROM Shopping.vw_PaymentShipping;        -- Should be many
  SELECT COUNT(*) FROM Shopping.vw_DiscountImpact;         -- Should be 4
  SELECT COUNT(*) FROM Shopping.vw_CustomerSegmentation;   -- Should be ~3900
  SELECT COUNT(*) FROM Shopping.vw_PurchaseDetails;        -- Should be 3900
  ```

- [ ] Views have correct columns
  ```sql
  -- Sample check for one view
  SELECT COLUMN_NAME 
  FROM INFORMATION_SCHEMA.COLUMNS 
  WHERE TABLE_SCHEMA = 'Shopping' 
  AND TABLE_NAME = 'vw_SalesOverview';
  ```
  Expected columns: TotalTransactions, TotalCustomers, TotalRevenue, etc.

## ✅ Phase 5: Data Quality

- [ ] No NULL values in critical fields
  ```sql
  SELECT COUNT(*) AS NullCustomerKeys
  FROM Shopping.FactPurchases 
  WHERE CustomerKey IS NULL;
  ```
  Expected: 0

- [ ] Referential integrity maintained
  ```sql
  -- Check for orphaned records
  SELECT COUNT(*) AS Orphans
  FROM Shopping.FactPurchases f
  LEFT JOIN Shopping.DimCustomer c ON f.CustomerKey = c.CustomerKey
  WHERE c.CustomerKey IS NULL;
  ```
  Expected: 0

- [ ] Data ranges are valid
  ```sql
  SELECT 
    MIN(PurchaseAmountUSD) AS MinAmount,
    MAX(PurchaseAmountUSD) AS MaxAmount,
    MIN(ReviewRating) AS MinRating,
    MAX(ReviewRating) AS MaxRating
  FROM Shopping.FactPurchases;
  ```
  Expected:
  - MinAmount: ~$20
  - MaxAmount: ~$100
  - MinRating: 2.5
  - MaxRating: 5.0

- [ ] Aggregations make sense
  ```sql
  SELECT * FROM Shopping.vw_SalesOverview;
  ```
  Verify:
  - TotalRevenue is positive and reasonable
  - AverageOrderValue is between $20-$100
  - AverageRating is between 2.5-5.0

## ✅ Phase 6: PowerBI Connection

- [ ] PowerBI connects to SQL Server
  - Open Power BI Desktop
  - Get Data > SQL Server
  - Server: localhost (or your server name)
  - Database: CustomerShoppingDB
  - Connection successful

- [ ] All views visible in Navigator
  - Expand CustomerShoppingDB
  - Expand Shopping schema
  - See all 9 views

- [ ] Views load successfully
  - Select all 9 views
  - Click Load
  - No errors during load
  - Data preview shows records

- [ ] Data model is correct
  - Switch to Model view
  - Check tables are loaded
  - Verify columns are correct types

## ✅ Phase 7: PowerBI Visuals

- [ ] Can create basic visual
  - Add a Card visual
  - Select TotalRevenue from vw_SalesOverview
  - Value displays correctly

- [ ] Can create chart
  - Add a Column Chart
  - Category vs TotalRevenue from vw_SalesByCategory
  - Chart renders correctly

- [ ] Filters work
  - Add a slicer for Season
  - Filter affects other visuals
  - Cross-filtering works

## ✅ Phase 8: Documentation

- [ ] README.md complete and accurate
- [ ] PowerBI_Setup_Guide.md created
- [ ] Workflow_Guide.md created
- [ ] Quick_Reference.md created
- [ ] data/README.md describes dataset
- [ ] All scripts have comments

## ✅ Phase 9: Project Files

- [ ] .gitignore configured correctly
  ```bash
  git status --ignored
  ```
  Expected: CSV files in data/ are ignored

- [ ] All necessary files committed
  ```bash
  git log --oneline -5
  ```
  Expected: Recent commit with all project files

- [ ] No unnecessary files committed
  - No __pycache__ directories
  - No .pyc files
  - No data CSV files (they should be gitignored)
  - No IDE-specific files (.vscode, .idea)

## ✅ Phase 10: Functionality Test

- [ ] End-to-end workflow test
  1. Start fresh (delete data files and database)
  2. Run: `python scripts/01_download_data.py`
  3. Run: `python scripts/02_clean_data.py`
  4. Execute: `sql/01_create_database.sql`
  5. Run: `python scripts/03_import_to_sql.py`
  6. Execute: `sql/02_import_data.sql`
  7. Execute: `sql/03_create_views.sql`
  8. Open PowerBI and connect
  9. Verify dashboard works

## 🎯 Final Verification

Project is complete when ALL checkboxes above are checked ✅

### Summary Statistics to Verify

Run this query for a final sanity check:
```sql
USE CustomerShoppingDB;

DECLARE @Results TABLE (
    Metric VARCHAR(100),
    Value VARCHAR(100)
);

INSERT INTO @Results
SELECT 'Total Transactions', CAST(COUNT(*) AS VARCHAR) FROM Shopping.FactPurchases
UNION ALL
SELECT 'Unique Customers', CAST(COUNT(DISTINCT CustomerKey) AS VARCHAR) FROM Shopping.FactPurchases
UNION ALL
SELECT 'Total Revenue', '$' + CAST(CAST(SUM(PurchaseAmountUSD) AS DECIMAL(10,2)) AS VARCHAR) FROM Shopping.FactPurchases
UNION ALL
SELECT 'Avg Order Value', '$' + CAST(CAST(AVG(PurchaseAmountUSD) AS DECIMAL(10,2)) AS VARCHAR) FROM Shopping.FactPurchases
UNION ALL
SELECT 'Product Count', CAST(COUNT(*) AS VARCHAR) FROM Shopping.DimProduct
UNION ALL
SELECT 'Customer Count', CAST(COUNT(*) AS VARCHAR) FROM Shopping.DimCustomer;

SELECT * FROM @Results;
```

Expected output:
- Total Transactions: 3900
- Unique Customers: ~3900
- Total Revenue: ~$235,000
- Avg Order Value: ~$60
- Product Count: 500-800
- Customer Count: ~3900

## 📝 Notes

- Save this checklist and run through it after setup
- Use it for troubleshooting if issues arise
- Update it if you add new features
- Share with team members for validation

---

**Status**: _Fill in completion date:_ _______________

**Verified by**: _________________

**Issues found**: _________________

**Resolution**: _________________
