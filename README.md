# Customer Shopping Behavior Analysis

A comprehensive data analysis project that explores customer shopping patterns, behaviors, and purchasing trends using Python, PostgreSQL, and Power BI.

## Project Overview

This project demonstrates an end-to-end data science pipeline:
- **Data Cleaning & Transformation** - Using Python and pandas to process raw customer data
- **Database Integration** - Loading cleaned data into PostgreSQL for efficient querying
- **SQL Analytics** - Writing complex queries to extract meaningful business insights
- **Data Visualization** - Creating interactive dashboards in Power BI to communicate findings

## Dataset

The dataset contains **3,900 customer records** with the following information:
- Customer demographics (ID, Age, Gender)
- Purchase details (Item, Category, Amount, Season)
- Product attributes (Size, Color, Review Rating)
- Customer behavior (Previous Purchases, Subscription Status, Frequency)
- Transaction details (Payment Method, Discount Applied, Shipping Type, Location)

## Technologies Used

- **Python 3.12** - Data processing and ETL
  - `pandas` - Data manipulation and analysis
  - `sqlalchemy` - Database connection and ORM
  - `psycopg2-binary` - PostgreSQL adapter
- **PostgreSQL 17** - Relational database management
- **pgAdmin 4** - Database administration and query interface
- **Power BI** - Data visualization and reporting

## Project Structure

```
├── customer_shopping_behavior.csv           # Raw dataset (3,900 records)
├── customer_shopping_behavior_analysis.py   # Python script for data cleaning and loading
├── customer_behavior_sql_queries.sql        # 10 business intelligence queries
└── README.md                                # Project documentation
```

## Setup Instructions

### Prerequisites
1. **Python 3.10+** with virtual environment
2. **PostgreSQL 17** installed and running
3. **pgAdmin 4** for database management

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd Customer-shopping-behavior-analysis-in-PowerBI
   ```

2. **Install PostgreSQL & pgAdmin**
   ```powershell
   winget install PostgreSQL.PostgreSQL.17
   winget install PostgreSQL.pgAdmin
   ```

3. **Activate virtual environment and install dependencies**
   ```powershell
   .venv\Scripts\Activate.ps1  # or use: & .venv\Scripts\python.exe
   pip install pandas sqlalchemy psycopg2-binary
   ```

4. **Create the database**
   ```sql
   CREATE DATABASE customer_behavior;
   ```

5. **Run the Python script to load data**
   ```powershell
   python customer_shopping_behavior_analysis.py
   ```

## Data Processing Steps

The Python script performs the following transformations:

1. **Missing Value Imputation** - Fills missing review ratings with category-wise median
2. **Column Standardization** - Converts column names to lowercase with underscores
3. **Feature Engineering**:
   - Creates `age_group` column with 4 segments (Young Adult, Adult, Middle-aged, Senior)
   - Adds `purchase_frequency_days` by mapping frequency text to numerical days
4. **Data Cleaning** - Removes duplicate `promo_code_used` column (identical to `discount_applied`)
5. **Database Loading** - Exports cleaned DataFrame to PostgreSQL table named `customer`

## SQL Analysis Queries

The project includes 10 pre-written SQL queries for business intelligence:

1. **Revenue by Gender** - Total revenue comparison between male and female customers
2. **Discount Effectiveness** - Customers who used discounts but still spent above average
3. **Top Products** - Top 5 products by average review rating
4. **Shipping Analysis** - Average purchase amounts by shipping type
5. **Subscription Impact** - Spending patterns of subscribers vs non-subscribers
6. **Discount Rate by Product** - Products with highest discount usage percentage
7. **Customer Segmentation** - New, Returning, and Loyal customer counts
8. **Category Insights** - Top 3 most purchased items per category (using window functions)
9. **Repeat Buyer Behavior** - Subscription rates among repeat buyers
10. **Age Group Revenue** - Revenue contribution by age segment

## Usage

### Running SQL Queries in pgAdmin

1. Open pgAdmin 4 and connect to your server:
   - Host: `localhost`
   - Port: `5432`
   - Username: `postgres`
   - Password: `postgres`
   - Database: `customer_behavior`

2. Navigate to the database and open Query Tool
3. Copy queries from `customer_behavior_sql_queries.sql`
4. Execute to view results

### Database Connection Details

```python
# Default configuration in the Python script
username = "postgres"
password = "postgres"
host = "localhost"
port = "5432"
database = "customer_behavior"
table_name = "customer"
```

## Key Insights & Findings

The analysis answers important business questions such as:
- Which demographic segments generate the most revenue?
- How effective are discount strategies?
- What products have the highest customer satisfaction?
- Do subscription customers spend more?
- What are the purchasing patterns across age groups?

## Future Enhancements

- [ ] Power BI dashboard development
- [ ] Advanced statistical analysis and predictive modeling
- [ ] Customer lifetime value (CLV) calculation
- [ ] Product recommendation system
- [ ] Seasonal trend analysis

## License

This project is created for educational and portfolio purposes.

## Author

Data analysis project demonstrating full-stack data science capabilities from ETL to visualization.

