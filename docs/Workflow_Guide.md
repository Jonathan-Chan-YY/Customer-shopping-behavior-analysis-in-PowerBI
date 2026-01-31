# Complete Project Workflow Guide

## Overview
This guide provides a step-by-step walkthrough of the entire PowerBI data visualization project from start to finish.

## Workflow Diagram

```
┌─────────────────────┐
│  1. Data Source     │
│  (Online Dataset)   │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│  2. Data Download   │
│  (Python Script)    │
│  01_download_data   │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│  3. Data Cleaning   │
│  (Python Script)    │
│  02_clean_data      │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│  4. SQL Server      │
│  Database Setup     │
│  01_create_database │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│  5. Data Import     │
│  (Python/SQL)       │
│  03_import_to_sql   │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│  6. Create Views    │
│  (SQL Script)       │
│  03_create_views    │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│  7. PowerBI         │
│  Dashboard          │
│  (Visualization)    │
└─────────────────────┘
```

## Detailed Step-by-Step Instructions

### Phase 1: Environment Setup

#### Step 1.1: System Requirements
Verify you have installed:
- [ ] Python 3.8 or higher
- [ ] SQL Server 2016 or higher
- [ ] Power BI Desktop
- [ ] ODBC Driver 17 for SQL Server

#### Step 1.2: Project Setup
```bash
# Clone the repository
git clone https://github.com/Jonathan-Chan-YY/Customer-shopping-behavior-analysis-in-PowerBI.git
cd Customer-shopping-behavior-analysis-in-PowerBI

# Create and activate virtual environment (optional)
python -m venv venv
# Windows:
venv\Scripts\activate
# Linux/Mac:
source venv/bin/activate

# Install Python dependencies
pip install -r requirements.txt
```

**Verification:**
```bash
python --version
pip list
```

### Phase 2: Data Acquisition and Cleaning

#### Step 2.1: Download Dataset
```bash
python scripts/01_download_data.py
```

**What it does:**
- Attempts to download customer shopping dataset from online sources
- Falls back to generating realistic sample data if downloads fail
- Creates `data/raw/customer_shopping_data.csv`

**Expected output:**
```
✓ Sample dataset created successfully!
  - Rows: 3900
  - Columns: 18
  - File: data/raw/customer_shopping_data.csv
```

**Verify:**
```bash
# Check if file exists
ls -lh data/raw/customer_shopping_data.csv

# Preview first few lines
head -n 5 data/raw/customer_shopping_data.csv
```

#### Step 2.2: Clean and Process Data
```bash
python scripts/02_clean_data.py
```

**What it does:**
- Removes duplicates and handles missing values
- Validates data quality (age ranges, amounts, ratings)
- Creates derived columns (age groups, purchase categories, customer segments)
- Outputs to `data/cleaned/customer_shopping_cleaned.csv`

**Expected output:**
```
✓ Data cleaning complete!
  - Final shape: (3900, 22)
  - Records retained: 3900 (100.00%)
  - Missing values: 0
```

**Verify:**
```bash
# Check cleaned file
ls -lh data/cleaned/customer_shopping_cleaned.csv

# Count lines
wc -l data/cleaned/customer_shopping_cleaned.csv
```

### Phase 3: SQL Server Setup

#### Step 3.1: Start SQL Server
Ensure your SQL Server instance is running.

**Windows:**
- Open Services (services.msc)
- Find "SQL Server (MSSQLSERVER)" or your instance name
- Ensure it's running

**Verify Connection:**
```bash
# Using sqlcmd (if available)
sqlcmd -S localhost -E -Q "SELECT @@VERSION"
```

#### Step 3.2: Create Database Schema
Open SQL Server Management Studio (SSMS) or Azure Data Studio and:

```sql
-- Execute this file:
-- sql/01_create_database.sql
```

**What it does:**
- Creates `CustomerShoppingDB` database
- Creates `Shopping` schema
- Creates dimension tables:
  - DimCustomer (customer demographics)
  - DimProduct (product catalog)
  - DimSeason (seasonal data)
  - DimPayment (payment methods)
- Creates fact table:
  - FactPurchases (transaction data)
- Creates indexes for performance

**Expected output:**
```
Database CustomerShoppingDB created successfully.
Schema Shopping created successfully.
Table Shopping.DimCustomer created successfully.
Table Shopping.DimProduct created successfully.
...
```

**Verify:**
```sql
-- Check database exists
SELECT name FROM sys.databases WHERE name = 'CustomerShoppingDB';

-- Check tables
USE CustomerShoppingDB;
SELECT TABLE_SCHEMA, TABLE_NAME 
FROM INFORMATION_SCHEMA.TABLES 
WHERE TABLE_SCHEMA = 'Shopping';
```

### Phase 4: Data Import to SQL Server

#### Step 4.1: Import Cleaned Data
**Option A: Using Python Script (Recommended)**
```bash
python scripts/03_import_to_sql.py
```

Update server settings if needed:
```python
# In scripts/03_import_to_sql.py
SERVER = 'localhost'  # Change to your SQL Server name
DATABASE = 'CustomerShoppingDB'
```

**What it does:**
- Connects to SQL Server
- Imports CSV data into staging table
- Validates import

**Expected output:**
```
✓ Import complete! 3900 records in staging table
```

**Option B: Using SQL Script**
If Python import fails, use SQL Server import tools:

```sql
-- Execute: sql/02_import_data.sql
-- Follow instructions in the script for manual CSV import
```

#### Step 4.2: Transform and Load Data
If using Option B, the SQL script will:
- Load data from staging table
- Populate dimension tables
- Populate fact table with proper relationships

**Verify:**
```sql
USE CustomerShoppingDB;

-- Check record counts
SELECT 'DimCustomer' AS TableName, COUNT(*) AS RecordCount FROM Shopping.DimCustomer
UNION ALL
SELECT 'DimProduct', COUNT(*) FROM Shopping.DimProduct
UNION ALL
SELECT 'DimSeason', COUNT(*) FROM Shopping.DimSeason
UNION ALL
SELECT 'DimPayment', COUNT(*) FROM Shopping.DimPayment
UNION ALL
SELECT 'FactPurchases', COUNT(*) FROM Shopping.FactPurchases;
```

Expected results:
- DimCustomer: ~3900 records
- DimProduct: ~500-800 records
- DimSeason: 4 records
- DimPayment: ~20-30 records
- FactPurchases: 3900 records

### Phase 5: Create PowerBI Views

#### Step 5.1: Create Analytical Views
```sql
-- Execute: sql/03_create_views.sql
```

**What it does:**
Creates 9 optimized views for PowerBI:
1. vw_SalesOverview - Overall KPIs
2. vw_SalesByCategory - Category analysis
3. vw_SalesBySeason - Seasonal trends
4. vw_CustomerDemographics - Customer insights
5. vw_ProductPerformance - Product metrics
6. vw_PaymentShipping - Payment analysis
7. vw_DiscountImpact - Discount effectiveness
8. vw_CustomerSegmentation - Customer segments
9. vw_PurchaseDetails - Detailed transactions

**Verify:**
```sql
-- List all views
SELECT TABLE_NAME 
FROM INFORMATION_SCHEMA.VIEWS 
WHERE TABLE_SCHEMA = 'Shopping';

-- Test a view
SELECT TOP 10 * FROM Shopping.vw_SalesOverview;
SELECT TOP 10 * FROM Shopping.vw_SalesByCategory;
```

### Phase 6: PowerBI Dashboard

#### Step 6.1: Connect PowerBI to SQL Server
1. Open Power BI Desktop
2. Click **Get Data** > **SQL Server**
3. Enter connection details:
   - Server: `localhost` (or your server name)
   - Database: `CustomerShoppingDB`
4. Click **OK**
5. Select authentication method (Windows Auth recommended)

#### Step 6.2: Load Data Views
In Navigator, select these views:
- [x] Shopping.vw_SalesOverview
- [x] Shopping.vw_SalesByCategory
- [x] Shopping.vw_SalesBySeason
- [x] Shopping.vw_CustomerDemographics
- [x] Shopping.vw_ProductPerformance
- [x] Shopping.vw_PaymentShipping
- [x] Shopping.vw_DiscountImpact
- [x] Shopping.vw_CustomerSegmentation
- [x] Shopping.vw_PurchaseDetails

Click **Load**

#### Step 6.3: Create Dashboard Pages
Follow the detailed guide in `docs/PowerBI_Setup_Guide.md` to create:

**Page 1: Executive Summary**
- Total Revenue KPI card
- Total Transactions KPI card
- Revenue by Category donut chart
- Sales by Season column chart
- Top Products bar chart

**Page 2: Customer Analysis**
- Customer distribution by age/gender
- Geographic distribution map
- Purchase frequency pie chart
- High value customers table

**Page 3: Product Performance**
- Category performance matrix
- Product ratings scatter chart
- Color preferences chart

**Page 4: Sales Trends**
- Seasonal comparison
- Payment method analysis
- Shipping type performance
- Discount impact

**Page 5: Detailed Analysis**
- Full data table with slicers
- Interactive filtering

#### Step 6.4: Format and Polish
- Apply consistent theme
- Add titles and descriptions
- Configure cross-filtering
- Add navigation buttons
- Test interactivity

### Phase 7: Testing and Validation

#### Step 7.1: Validate Data Flow
```sql
-- Verify data consistency
USE CustomerShoppingDB;

-- Check for orphaned records
SELECT COUNT(*) AS OrphanedPurchases
FROM Shopping.FactPurchases f
LEFT JOIN Shopping.DimCustomer c ON f.CustomerKey = c.CustomerKey
WHERE c.CustomerKey IS NULL;

-- Should return 0
```

#### Step 7.2: Test PowerBI Dashboard
- [ ] All visuals load without errors
- [ ] KPIs show reasonable values
- [ ] Filters work across pages
- [ ] Charts are interactive
- [ ] No data quality issues visible

#### Step 7.3: Verify Key Metrics
Check these make sense:
- Total Revenue: Should be positive
- Average Order Value: Should be reasonable ($20-$100 range)
- Customer count: Should match source data (~3900)
- All percentages: Should sum to 100% where applicable

### Phase 8: Publish and Share

#### Step 8.1: Save PowerBI File
File > Save As > `Customer_Shopping_Dashboard.pbix`

#### Step 8.2: Publish to PowerBI Service (Optional)
1. Click **Publish** button
2. Sign in to PowerBI Service
3. Select workspace
4. Configure data refresh schedule

## Troubleshooting Guide

### Common Issues and Solutions

#### Issue 1: Python Package Installation Fails
**Solution:**
```bash
# Upgrade pip first
python -m pip install --upgrade pip

# Install packages individually
pip install pandas
pip install numpy
pip install pyodbc
pip install sqlalchemy
```

#### Issue 2: SQL Server Connection Failed
**Possible causes:**
1. SQL Server not running
2. Firewall blocking connection
3. TCP/IP not enabled

**Solution:**
```
1. Check SQL Server is running in Services
2. Open SQL Server Configuration Manager
3. Enable TCP/IP protocol
4. Restart SQL Server service
5. Check Windows Firewall settings
```

#### Issue 3: PowerBI Can't Connect
**Solution:**
1. Install ODBC Driver 17 for SQL Server
2. Use full server name: `COMPUTERNAME\INSTANCENAME`
3. For local: try `localhost`, `(local)`, or `.`
4. Verify SQL Server allows remote connections

#### Issue 4: Data Not Loading in PowerBI
**Solution:**
```sql
-- Verify views have data
SELECT COUNT(*) FROM Shopping.vw_SalesOverview;
SELECT TOP 5 * FROM Shopping.vw_PurchaseDetails;
```

#### Issue 5: Slow PowerBI Performance
**Solution:**
1. Reduce visuals per page (max 7-10)
2. Use aggregated views instead of detail table
3. Add indexes in SQL Server
4. Use Import mode instead of DirectQuery

## Performance Tips

### SQL Server
- Regularly update statistics
- Rebuild fragmented indexes
- Monitor query execution plans

### PowerBI
- Use star schema (already implemented)
- Minimize calculated columns
- Use measures instead of calculated columns
- Optimize DAX formulas

## Maintenance

### Weekly Tasks
- [ ] Refresh data if source changes
- [ ] Check dashboard for errors
- [ ] Monitor SQL Server performance

### Monthly Tasks
- [ ] Review and update data
- [ ] Add new insights based on user feedback
- [ ] Update documentation

## Success Criteria

Your project is complete when:
- [x] All Python scripts run without errors
- [x] SQL Server database is created and populated
- [x] All views return data
- [x] PowerBI connects successfully
- [x] Dashboard displays all visualizations
- [x] Dashboard is interactive and informative

## Next Steps

Once basic dashboard is working:
1. Add more sophisticated DAX measures
2. Implement drill-through pages
3. Add bookmarks for different views
4. Create mobile-optimized layouts
5. Add predictive analytics
6. Implement row-level security (if needed)

## Resources

- Project README: `README.md`
- PowerBI Guide: `docs/PowerBI_Setup_Guide.md`
- Data Documentation: `data/README.md`
- Python Scripts: `scripts/`
- SQL Scripts: `sql/`

## Support

If you encounter issues:
1. Review error messages carefully
2. Check this workflow guide
3. Verify each step was completed
4. Review documentation in `docs/` folder
5. Check SQL Server and PowerBI logs

---

**Congratulations!** You now have a complete end-to-end data visualization project demonstrating professional BI development practices.
