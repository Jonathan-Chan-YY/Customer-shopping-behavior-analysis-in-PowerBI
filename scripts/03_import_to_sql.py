"""
Script to import cleaned data into SQL Server database
Requires: pyodbc or sqlalchemy
"""

import os
import pandas as pd
import sys

try:
    import pyodbc
    PYODBC_AVAILABLE = True
except ImportError:
    PYODBC_AVAILABLE = False

try:
    from sqlalchemy import create_engine
    SQLALCHEMY_AVAILABLE = True
except ImportError:
    SQLALCHEMY_AVAILABLE = False

# Define paths
SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
PROJECT_ROOT = os.path.dirname(SCRIPT_DIR)
CLEANED_DATA_DIR = os.path.join(PROJECT_ROOT, 'data', 'cleaned')
INPUT_FILE = os.path.join(CLEANED_DATA_DIR, 'customer_shopping_cleaned.csv')

# SQL Server connection parameters
# Update these values for your SQL Server instance
SERVER = 'localhost'  # or your server name/IP
DATABASE = 'CustomerShoppingDB'
USERNAME = ''  # Leave empty for Windows Authentication
PASSWORD = ''  # Leave empty for Windows Authentication

def get_connection_string(use_trusted=True):
    """Generate SQL Server connection string"""
    if use_trusted:
        # Windows Authentication
        return f'DRIVER={{ODBC Driver 17 for SQL Server}};SERVER={SERVER};DATABASE={DATABASE};Trusted_Connection=yes;'
    else:
        # SQL Server Authentication
        return f'DRIVER={{ODBC Driver 17 for SQL Server}};SERVER={SERVER};DATABASE={DATABASE};UID={USERNAME};PWD={PASSWORD}'

def import_with_pyodbc():
    """Import data using pyodbc"""
    print("Using pyodbc for data import...")
    
    # Load data
    print(f"Loading data from: {INPUT_FILE}")
    df = pd.read_csv(INPUT_FILE)
    print(f"Loaded {len(df)} records")
    
    # Connect to SQL Server
    conn_str = get_connection_string()
    print(f"Connecting to SQL Server...")
    
    try:
        conn = pyodbc.connect(conn_str)
        cursor = conn.cursor()
        print("✓ Connected successfully")
        
        # Check if staging table exists
        cursor.execute("""
            IF OBJECT_ID('Shopping.StagingData', 'U') IS NOT NULL
                TRUNCATE TABLE Shopping.StagingData
        """)
        conn.commit()
        
        # Insert data row by row
        print(f"Inserting {len(df)} records into Shopping.StagingData...")
        
        insert_query = """
        INSERT INTO Shopping.StagingData (
            CustomerID, Age, Gender, ItemPurchased, Category, PurchaseAmountUSD,
            Location, Size, Color, Season, ReviewRating, SubscriptionStatus,
            ShippingType, DiscountApplied, PromoCodeUsed, PreviousPurchases,
            PaymentMethod, FrequencyOfPurchases, AgeGroup, PurchaseCategory,
            HighValueCustomer, DiscountUsed
        ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        """
        
        batch_size = 100
        for i in range(0, len(df), batch_size):
            batch = df.iloc[i:i+batch_size]
            for _, row in batch.iterrows():
                cursor.execute(insert_query, (
                    int(row['Customer ID']),
                    int(row['Age']),
                    row['Gender'],
                    row['Item Purchased'],
                    row['Category'],
                    float(row['Purchase Amount (USD)']),
                    row['Location'],
                    row['Size'],
                    row['Color'],
                    row['Season'],
                    float(row['Review Rating']),
                    row['Subscription Status'],
                    row['Shipping Type'],
                    row['Discount Applied'],
                    row['Promo Code Used'],
                    int(row['Previous Purchases']),
                    row['Payment Method'],
                    row['Frequency of Purchases'],
                    row['Age Group'],
                    row['Purchase Category'],
                    int(row['High Value Customer']),
                    int(row['Discount Used'])
                ))
            conn.commit()
            print(f"  Progress: {min(i+batch_size, len(df))}/{len(df)} records")
        
        # Verify import
        cursor.execute("SELECT COUNT(*) FROM Shopping.StagingData")
        count = cursor.fetchone()[0]
        print(f"\n✓ Import complete! {count} records in staging table")
        
        cursor.close()
        conn.close()
        
        return True
        
    except Exception as e:
        print(f"✗ Error: {str(e)}")
        return False

def import_with_sqlalchemy():
    """Import data using sqlalchemy"""
    print("Using SQLAlchemy for data import...")
    
    # Load data
    print(f"Loading data from: {INPUT_FILE}")
    df = pd.read_csv(INPUT_FILE)
    print(f"Loaded {len(df)} records")
    
    # Create connection string for SQLAlchemy
    conn_str = f'mssql+pyodbc://@{SERVER}/{DATABASE}?driver=ODBC+Driver+17+for+SQL+Server&trusted_connection=yes'
    
    try:
        engine = create_engine(conn_str)
        print(f"Connecting to SQL Server...")
        
        # Rename columns to match SQL table
        df_import = df.rename(columns={
            'Customer ID': 'CustomerID',
            'Item Purchased': 'ItemPurchased',
            'Purchase Amount (USD)': 'PurchaseAmountUSD',
            'Review Rating': 'ReviewRating',
            'Subscription Status': 'SubscriptionStatus',
            'Shipping Type': 'ShippingType',
            'Discount Applied': 'DiscountApplied',
            'Promo Code Used': 'PromoCodeUsed',
            'Previous Purchases': 'PreviousPurchases',
            'Payment Method': 'PaymentMethod',
            'Frequency of Purchases': 'FrequencyOfPurchases',
            'Age Group': 'AgeGroup',
            'Purchase Category': 'PurchaseCategory',
            'High Value Customer': 'HighValueCustomer',
            'Discount Used': 'DiscountUsed'
        })
        
        # Import to staging table
        print(f"Importing {len(df_import)} records to Shopping.StagingData...")
        df_import.to_sql('StagingData', engine, schema='Shopping', 
                        if_exists='replace', index=False)
        
        print(f"✓ Import complete! {len(df_import)} records imported")
        return True
        
    except Exception as e:
        print(f"✗ Error: {str(e)}")
        return False

def main():
    """Main import function"""
    print("="*50)
    print("SQL SERVER DATA IMPORT")
    print("="*50)
    
    # Check if data file exists
    if not os.path.exists(INPUT_FILE):
        print(f"\n✗ Error: Cleaned data file not found!")
        print(f"   Expected: {INPUT_FILE}")
        print(f"\n   Please run '02_clean_data.py' first to generate the cleaned data.")
        return
    
    # Check available libraries
    print(f"\nChecking dependencies:")
    print(f"  - pyodbc: {'✓ Available' if PYODBC_AVAILABLE else '✗ Not available'}")
    print(f"  - sqlalchemy: {'✓ Available' if SQLALCHEMY_AVAILABLE else '✗ Not available'}")
    
    if not PYODBC_AVAILABLE and not SQLALCHEMY_AVAILABLE:
        print(f"\n✗ Error: Neither pyodbc nor sqlalchemy is installed!")
        print(f"   Please install one of them:")
        print(f"   pip install pyodbc")
        print(f"   or")
        print(f"   pip install sqlalchemy")
        return
    
    # Configuration reminder
    print(f"\n" + "="*50)
    print(f"SQL Server Configuration:")
    print(f"  - Server: {SERVER}")
    print(f"  - Database: {DATABASE}")
    print(f"  - Auth: {'Windows Authentication' if not USERNAME else 'SQL Server Auth'}")
    print(f"="*50)
    print(f"\n⚠ Make sure:")
    print(f"  1. SQL Server is running")
    print(f"  2. Database 'CustomerShoppingDB' exists")
    print(f"  3. Run '01_create_database.sql' first if not done")
    print(f"  4. Update SERVER variable in this script if needed")
    print(f"="*50)
    
    response = input(f"\nProceed with import? (y/n): ")
    if response.lower() != 'y':
        print("Import cancelled.")
        return
    
    # Attempt import
    print(f"\n")
    success = False
    
    if PYODBC_AVAILABLE:
        success = import_with_pyodbc()
    elif SQLALCHEMY_AVAILABLE:
        success = import_with_sqlalchemy()
    
    if success:
        print(f"\n" + "="*50)
        print("IMPORT SUCCESSFUL!")
        print("="*50)
        print(f"\nNext steps:")
        print(f"  1. Run '02_import_data.sql' to populate dimension and fact tables")
        print(f"  2. Run '03_create_views.sql' to create PowerBI views")
        print(f"  3. Connect PowerBI to SQL Server")
        print("="*50)
    else:
        print(f"\n" + "="*50)
        print("IMPORT FAILED!")
        print("="*50)
        print(f"\nAlternative methods:")
        print(f"  1. Use SQL Server Management Studio (SSMS)")
        print(f"  2. Use BULK INSERT command in '02_import_data.sql'")
        print(f"  3. Install missing dependencies:")
        print(f"     pip install pyodbc sqlalchemy")
        print("="*50)

if __name__ == '__main__':
    main()
