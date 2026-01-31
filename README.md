# Customer Shopping Behavior Analysis in PowerBI

A complete end-to-end data visualization project demonstrating the full workflow from data acquisition to interactive PowerBI dashboards for analyzing customer shopping behavior.

## 🎯 Project Overview

This project implements a complete Business Intelligence solution for customer shopping behavior analysis using:
- **Data Source**: Online customer shopping dataset
- **Data Processing**: Python for cleaning and preprocessing
- **Database**: SQL Server for data warehousing
- **Visualization**: PowerBI for interactive dashboards

## 📊 Project Workflow

```
Online Dataset → Python Cleaning → SQL Server → PowerBI Dashboard
```

### Detailed Pipeline
1. **Data Acquisition**: Download customer shopping dataset from online source
2. **Data Cleaning**: Python scripts to clean, validate, and enrich data
3. **Database Import**: Load cleaned data into SQL Server with star schema
4. **Data Views**: Create optimized views for PowerBI consumption
5. **Visualization**: Build interactive dashboards in PowerBI

## 🗂️ Project Structure

```
Customer-shopping-behavior-analysis-in-PowerBI/
├── data/
│   ├── raw/                    # Original downloaded datasets (gitignored)
│   ├── cleaned/                # Cleaned datasets ready for SQL (gitignored)
│   └── README.md              # Data documentation
├── scripts/
│   ├── 01_download_data.py    # Download dataset from online source
│   ├── 02_clean_data.py       # Clean and preprocess data
│   └── 03_import_to_sql.py    # Import data to SQL Server
├── sql/
│   ├── 01_create_database.sql # Create database and tables
│   ├── 02_import_data.sql     # Import and transform data
│   └── 03_create_views.sql    # Create PowerBI-optimized views
├── docs/
│   └── PowerBI_Setup_Guide.md # Comprehensive PowerBI setup guide
├── requirements.txt            # Python dependencies
├── .gitignore                 # Git ignore rules
└── README.md                  # This file
```

## 🚀 Getting Started

### Prerequisites

- **Python 3.8+** with pip
- **SQL Server 2016+** (Express Edition works fine)
- **Power BI Desktop** ([Download here](https://powerbi.microsoft.com/desktop/))
- **ODBC Driver 17 for SQL Server** ([Download here](https://docs.microsoft.com/en-us/sql/connect/odbc/download-odbc-driver-for-sql-server))

### Installation Steps

#### 1. Clone the Repository

```bash
git clone https://github.com/Jonathan-Chan-YY/Customer-shopping-behavior-analysis-in-PowerBI.git
cd Customer-shopping-behavior-analysis-in-PowerBI
```

#### 2. Set Up Python Environment

```bash
# Create virtual environment (optional but recommended)
python -m venv venv

# Activate virtual environment
# On Windows:
venv\Scripts\activate
# On Linux/Mac:
source venv/bin/activate

# Install dependencies
pip install -r requirements.txt
```

#### 3. Download and Clean Data

```bash
# Download the dataset
python scripts/01_download_data.py

# Clean and preprocess the data
python scripts/02_clean_data.py
```

#### 4. Set Up SQL Server Database

Open SQL Server Management Studio (SSMS) or Azure Data Studio and run:

```sql
-- Step 1: Create database and schema
-- Execute: sql/01_create_database.sql

-- Step 2: Import data
-- Option A: Run Python script (recommended)
python scripts/03_import_to_sql.py

-- Option B: Use SQL script with manual import
-- Execute: sql/02_import_data.sql
-- Follow instructions in script for CSV import

-- Step 3: Create views for PowerBI
-- Execute: sql/03_create_views.sql
```

#### 5. Connect PowerBI

Follow the comprehensive guide in [docs/PowerBI_Setup_Guide.md](docs/PowerBI_Setup_Guide.md) to:
- Connect PowerBI to SQL Server
- Import data views
- Create visualizations
- Build interactive dashboards

## 📈 Dataset Information

### Source
The project uses a customer shopping trends dataset containing retail transaction data.

### Features
- **Customer Demographics**: Age, Gender, Location
- **Product Information**: Category, Item, Size, Color
- **Transaction Details**: Purchase Amount, Season, Date
- **Customer Behavior**: Previous Purchases, Frequency, Subscription Status
- **Engagement**: Review Ratings, Payment Method, Shipping Type
- **Promotions**: Discount Applied, Promo Code Usage

### Sample Size
Approximately 3,900+ customer transactions

## 🗄️ Database Schema

The SQL Server database uses a **Star Schema** design:

### Dimension Tables
- `DimCustomer`: Customer demographic information
- `DimProduct`: Product catalog details
- `DimSeason`: Season information
- `DimPayment`: Payment and shipping methods

### Fact Table
- `FactPurchases`: Transaction-level purchase data with foreign keys to dimensions

### PowerBI Views
9 optimized views for different analytical perspectives:
1. Sales Overview
2. Sales by Category
3. Sales by Season
4. Customer Demographics
5. Product Performance
6. Payment & Shipping Analysis
7. Discount Impact
8. Customer Segmentation
9. Complete Purchase Details

## 📊 Dashboard Components

### Key Metrics
- Total Revenue
- Total Transactions
- Average Order Value
- Customer Count
- Average Rating

### Visualizations
1. **Executive Dashboard**: High-level KPIs and trends
2. **Customer Analysis**: Demographics and segmentation
3. **Product Performance**: Category and item analysis
4. **Sales Patterns**: Seasonal and temporal trends
5. **Detailed View**: Drill-down capabilities

## 💡 Key Insights

The dashboard enables answering questions like:
- Which product categories generate the most revenue?
- What are the purchasing patterns across different seasons?
- How do customer demographics influence buying behavior?
- What is the impact of discounts and promotions?
- Which locations have the highest-value customers?
- What are the most popular payment and shipping methods?

## 🛠️ Technologies Used

- **Python**: Data acquisition and preprocessing
  - pandas: Data manipulation
  - numpy: Numerical operations
- **SQL Server**: Data warehousing and storage
  - T-SQL: Database operations
  - Views: Data aggregation
- **Power BI**: Data visualization and dashboarding
  - DAX: Custom measures
  - Power Query: Data transformation

## 📝 Scripts Documentation

### Python Scripts

#### `01_download_data.py`
- Downloads customer shopping dataset from online sources
- Falls back to generating sample data if download fails
- Creates `data/raw/customer_shopping_data.csv`

#### `02_clean_data.py`
- Removes duplicates and handles missing values
- Validates data quality (age ranges, amounts, ratings)
- Creates derived columns (age groups, purchase categories)
- Outputs to `data/cleaned/customer_shopping_cleaned.csv`

#### `03_import_to_sql.py`
- Imports cleaned CSV data to SQL Server
- Supports both pyodbc and SQLAlchemy
- Loads data into staging table for further processing

### SQL Scripts

#### `01_create_database.sql`
- Creates CustomerShoppingDB database
- Defines star schema with dimension and fact tables
- Sets up indexes for query performance

#### `02_import_data.sql`
- Imports data from staging table
- Populates dimension tables
- Loads fact table with proper foreign key relationships

#### `03_create_views.sql`
- Creates 9 analytical views
- Pre-aggregates data for PowerBI performance
- Optimized for common dashboard queries

## 🔧 Configuration

### SQL Server Connection

Update the connection settings in `scripts/03_import_to_sql.py`:

```python
SERVER = 'localhost'  # Your SQL Server name
DATABASE = 'CustomerShoppingDB'
USERNAME = ''  # For SQL Auth (leave empty for Windows Auth)
PASSWORD = ''  # For SQL Auth (leave empty for Windows Auth)
```

### PowerBI Connection

In PowerBI Desktop:
1. **Server**: Your SQL Server instance name
2. **Database**: CustomerShoppingDB
3. **Authentication**: Windows or SQL Server Authentication

## 🐛 Troubleshooting

### Common Issues

**Python Script Errors**
```bash
# Missing dependencies
pip install -r requirements.txt

# File not found
# Ensure you run scripts from project root directory
cd /path/to/Customer-shopping-behavior-analysis-in-PowerBI
python scripts/01_download_data.py
```

**SQL Server Connection Issues**
- Verify SQL Server is running
- Check Windows Firewall settings
- Enable TCP/IP in SQL Server Configuration Manager
- Verify user has proper database permissions

**PowerBI Connection Issues**
- Install ODBC Driver 17 for SQL Server
- Use server name with instance: `SERVERNAME\INSTANCE`
- For local SQL Server, try: `localhost`, `(local)`, or `.`

## 📚 Documentation

- [PowerBI Setup Guide](docs/PowerBI_Setup_Guide.md) - Detailed PowerBI configuration
- [Data Documentation](data/README.md) - Dataset information
- [SQL Schema](sql/01_create_database.sql) - Database structure

## 🤝 Contributing

Contributions are welcome! Areas for enhancement:
- Additional data sources
- More sophisticated data cleaning
- Advanced PowerBI visualizations
- Real-time data streaming
- Machine learning predictions

## 📄 License

This project is available for educational and portfolio purposes.

## 👨‍💻 Author

Jonathan Chan

## 🙏 Acknowledgments

- Customer shopping dataset providers
- Microsoft Power BI community
- SQL Server documentation
- Python data science community

## 📞 Support

For questions or issues:
1. Check the documentation in `/docs`
2. Review script comments for implementation details
3. Verify your environment meets prerequisites
4. Ensure all steps are followed in sequence

---

**Note**: This is an educational project demonstrating end-to-end BI development. The dataset and analyses are for learning purposes.