# Quick Reference Card

## 🚀 Quick Start (3 Steps)

### 1. Setup Environment
```bash
pip install -r requirements.txt
```

### 2. Get and Clean Data
```bash
python scripts/01_download_data.py
python scripts/02_clean_data.py
```

### 3. Setup SQL Server
```sql
-- In SSMS, execute in order:
sql/01_create_database.sql
sql/02_import_data.sql  -- Or: python scripts/03_import_to_sql.py
sql/03_create_views.sql
```

## 📁 File Structure
```
├── scripts/          # Python automation scripts
├── sql/             # SQL Server setup scripts
├── docs/            # Documentation
├── data/            # Data files (gitignored)
└── requirements.txt # Python dependencies
```

## 🔧 Python Scripts

| Script | Purpose | Output |
|--------|---------|--------|
| `01_download_data.py` | Download/generate dataset | `data/raw/customer_shopping_data.csv` |
| `02_clean_data.py` | Clean and enrich data | `data/cleaned/customer_shopping_cleaned.csv` |
| `03_import_to_sql.py` | Import to SQL Server | Data in SQL staging table |

## 📊 SQL Scripts

| Script | Purpose |
|--------|---------|
| `01_create_database.sql` | Create database and tables (star schema) |
| `02_import_data.sql` | Load data into dimension and fact tables |
| `03_create_views.sql` | Create 9 PowerBI-optimized views |

## 🗃️ Database Schema

### Dimension Tables
- `DimCustomer` - Customer demographics (Age, Gender, Location)
- `DimProduct` - Product catalog (Item, Category, Size, Color)
- `DimSeason` - Season information (Spring, Summer, Fall, Winter)
- `DimPayment` - Payment methods and shipping types

### Fact Table
- `FactPurchases` - Transaction details with foreign keys

### PowerBI Views
1. `vw_SalesOverview` - High-level KPIs
2. `vw_SalesByCategory` - Category breakdown
3. `vw_SalesBySeason` - Seasonal analysis
4. `vw_CustomerDemographics` - Customer insights
5. `vw_ProductPerformance` - Product metrics
6. `vw_PaymentShipping` - Payment analysis
7. `vw_DiscountImpact` - Discount effectiveness
8. `vw_CustomerSegmentation` - Customer segments
9. `vw_PurchaseDetails` - Complete detail view

## 💻 Common Commands

### Python
```bash
# Install dependencies
pip install -r requirements.txt

# Run scripts in order
python scripts/01_download_data.py
python scripts/02_clean_data.py
python scripts/03_import_to_sql.py
```

### SQL Verification
```sql
-- Check database
USE CustomerShoppingDB;

-- Check tables
SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'Shopping';

-- Check record counts
SELECT COUNT(*) FROM Shopping.FactPurchases;
SELECT COUNT(*) FROM Shopping.DimCustomer;

-- Test views
SELECT * FROM Shopping.vw_SalesOverview;
SELECT TOP 10 * FROM Shopping.vw_PurchaseDetails;
```

## 🎨 PowerBI Connection

**Connection Settings:**
- Data Source: SQL Server
- Server: `localhost` or your server name
- Database: `CustomerShoppingDB`
- Mode: Import (recommended)

**Views to Load:**
Select all 9 views from `Shopping` schema

## 📈 Key Metrics

| Metric | Description |
|--------|-------------|
| Total Revenue | Sum of all purchase amounts |
| Total Transactions | Count of purchases |
| Average Order Value | Mean purchase amount |
| Customer Count | Unique customers |
| Average Rating | Mean review rating |

## 🐛 Quick Troubleshooting

| Issue | Solution |
|-------|----------|
| Module not found | Run `pip install -r requirements.txt` |
| SQL connection failed | Check SQL Server is running, enable TCP/IP |
| PowerBI can't connect | Install ODBC Driver 17, use correct server name |
| No data in views | Run SQL scripts in correct order |
| Slow performance | Reduce visuals per page, use Import mode |

## 📚 Documentation Links

- Complete Guide: `docs/Workflow_Guide.md`
- PowerBI Setup: `docs/PowerBI_Setup_Guide.md`
- Data Info: `data/README.md`
- Main README: `README.md`

## ⚙️ Configuration

### SQL Server Connection (in `scripts/03_import_to_sql.py`)
```python
SERVER = 'localhost'
DATABASE = 'CustomerShoppingDB'
USERNAME = ''  # Empty for Windows Auth
PASSWORD = ''  # Empty for Windows Auth
```

## 🎯 Success Checklist

- [ ] Python scripts run without errors
- [ ] Data files created in `data/` folders
- [ ] SQL Server database created
- [ ] All tables populated with data
- [ ] All 9 views return data
- [ ] PowerBI connects successfully
- [ ] Dashboard displays all visualizations

## 📞 Need Help?

1. Check error messages
2. Review `docs/Workflow_Guide.md` for detailed steps
3. Verify prerequisites are installed
4. Ensure steps completed in correct order

---

**Tip:** Bookmark this page for quick reference during development!
