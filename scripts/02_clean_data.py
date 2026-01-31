"""
Script to clean and preprocess customer shopping data
"""

import os
import pandas as pd
import numpy as np
from datetime import datetime

# Define paths
SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
PROJECT_ROOT = os.path.dirname(SCRIPT_DIR)
RAW_DATA_DIR = os.path.join(PROJECT_ROOT, 'data', 'raw')
CLEANED_DATA_DIR = os.path.join(PROJECT_ROOT, 'data', 'cleaned')
INPUT_FILE = os.path.join(RAW_DATA_DIR, 'customer_shopping_data.csv')
OUTPUT_FILE = os.path.join(CLEANED_DATA_DIR, 'customer_shopping_cleaned.csv')

def clean_data():
    """Clean and preprocess the customer shopping dataset"""
    
    print("="*50)
    print("CUSTOMER SHOPPING DATA CLEANING")
    print("="*50)
    
    # Create output directory if it doesn't exist
    os.makedirs(CLEANED_DATA_DIR, exist_ok=True)
    
    # Load the raw data
    print(f"\n1. Loading raw data from: {INPUT_FILE}")
    try:
        df = pd.read_csv(INPUT_FILE)
        print(f"   ✓ Loaded {len(df)} records with {len(df.columns)} columns")
    except FileNotFoundError:
        print(f"   ✗ Error: File not found!")
        print(f"   Please run '01_download_data.py' first to download the dataset.")
        return
    
    # Display initial data info
    print(f"\n2. Initial data overview:")
    print(f"   - Shape: {df.shape}")
    print(f"   - Memory usage: {df.memory_usage(deep=True).sum() / 1024:.2f} KB")
    
    # Check for missing values
    print(f"\n3. Checking for missing values:")
    missing_counts = df.isnull().sum()
    if missing_counts.sum() > 0:
        print("   Missing values found:")
        for col, count in missing_counts[missing_counts > 0].items():
            print(f"   - {col}: {count} ({count/len(df)*100:.2f}%)")
    else:
        print("   ✓ No missing values found")
    
    # Data cleaning steps
    print(f"\n4. Cleaning data:")
    
    # Remove duplicates
    initial_rows = len(df)
    df = df.drop_duplicates()
    duplicates_removed = initial_rows - len(df)
    if duplicates_removed > 0:
        print(f"   ✓ Removed {duplicates_removed} duplicate records")
    else:
        print(f"   ✓ No duplicates found")
    
    # Clean column names - standardize
    df.columns = df.columns.str.strip()
    print(f"   ✓ Standardized column names")
    
    # Handle potential data type issues
    # Ensure numeric columns are properly typed
    numeric_columns = ['Age', 'Purchase Amount (USD)', 'Review Rating', 'Previous Purchases']
    for col in numeric_columns:
        if col in df.columns:
            df[col] = pd.to_numeric(df[col], errors='coerce')
    
    # Handle missing values in numeric columns
    for col in numeric_columns:
        if col in df.columns and df[col].isnull().sum() > 0:
            median_val = df[col].median()
            df[col].fillna(median_val, inplace=True)
            print(f"   ✓ Filled {col} missing values with median: {median_val}")
    
    # Remove any rows with all null values
    df = df.dropna(how='all')
    
    # Validate age range (18-100)
    if 'Age' in df.columns:
        invalid_age = df[(df['Age'] < 18) | (df['Age'] > 100)]
        if len(invalid_age) > 0:
            df = df[(df['Age'] >= 18) & (df['Age'] <= 100)]
            print(f"   ✓ Removed {len(invalid_age)} records with invalid age")
    
    # Validate purchase amount (positive values)
    if 'Purchase Amount (USD)' in df.columns:
        invalid_amount = df[df['Purchase Amount (USD)'] <= 0]
        if len(invalid_amount) > 0:
            df = df[df['Purchase Amount (USD)'] > 0]
            print(f"   ✓ Removed {len(invalid_amount)} records with invalid purchase amount")
    
    # Validate review rating (1-5 range)
    if 'Review Rating' in df.columns:
        invalid_rating = df[(df['Review Rating'] < 1) | (df['Review Rating'] > 5)]
        if len(invalid_rating) > 0:
            df = df[(df['Review Rating'] >= 1) & (df['Review Rating'] <= 5)]
            print(f"   ✓ Removed {len(invalid_rating)} records with invalid rating")
    
    # Clean string columns - remove extra whitespace
    string_columns = df.select_dtypes(include=['object']).columns
    for col in string_columns:
        df[col] = df[col].str.strip() if df[col].dtype == 'object' else df[col]
    print(f"   ✓ Cleaned string columns")
    
    # Add derived columns for analysis
    print(f"\n5. Adding derived columns:")
    
    # Age group
    if 'Age' in df.columns:
        df['Age Group'] = pd.cut(df['Age'], 
                                 bins=[0, 25, 35, 45, 55, 100],
                                 labels=['18-25', '26-35', '36-45', '46-55', '56+'])
        print(f"   ✓ Added 'Age Group' column")
    
    # Purchase amount category
    if 'Purchase Amount (USD)' in df.columns:
        df['Purchase Category'] = pd.cut(df['Purchase Amount (USD)'],
                                         bins=[0, 30, 50, 70, 100],
                                         labels=['Low', 'Medium', 'High', 'Premium'])
        print(f"   ✓ Added 'Purchase Category' column")
    
    # High value customer indicator
    if 'Purchase Amount (USD)' in df.columns and 'Previous Purchases' in df.columns:
        df['High Value Customer'] = ((df['Purchase Amount (USD)'] > 60) | 
                                      (df['Previous Purchases'] > 20)).astype(int)
        print(f"   ✓ Added 'High Value Customer' indicator")
    
    # Discount effectiveness
    if 'Discount Applied' in df.columns and 'Purchase Amount (USD)' in df.columns:
        df['Discount Used'] = df['Discount Applied'].map({'Yes': 1, 'No': 0})
        print(f"   ✓ Added 'Discount Used' numeric indicator")
    
    # Data quality report
    print(f"\n6. Final data quality:")
    print(f"   - Final shape: {df.shape}")
    print(f"   - Records retained: {len(df)} ({len(df)/initial_rows*100:.2f}%)")
    print(f"   - Missing values: {df.isnull().sum().sum()}")
    
    # Save cleaned data
    print(f"\n7. Saving cleaned data:")
    df.to_csv(OUTPUT_FILE, index=False)
    print(f"   ✓ Saved to: {OUTPUT_FILE}")
    print(f"   ✓ File size: {os.path.getsize(OUTPUT_FILE) / 1024:.2f} KB")
    
    # Display summary statistics
    print(f"\n8. Summary Statistics:")
    if 'Purchase Amount (USD)' in df.columns:
        print(f"   Purchase Amount:")
        print(f"     - Mean: ${df['Purchase Amount (USD)'].mean():.2f}")
        print(f"     - Median: ${df['Purchase Amount (USD)'].median():.2f}")
        print(f"     - Min: ${df['Purchase Amount (USD)'].min():.2f}")
        print(f"     - Max: ${df['Purchase Amount (USD)'].max():.2f}")
    
    if 'Age' in df.columns:
        print(f"   Age:")
        print(f"     - Mean: {df['Age'].mean():.1f} years")
        print(f"     - Median: {df['Age'].median():.1f} years")
    
    if 'Review Rating' in df.columns:
        print(f"   Review Rating:")
        print(f"     - Mean: {df['Review Rating'].mean():.2f}")
        print(f"     - Distribution:")
        rating_dist = df['Review Rating'].value_counts().sort_index()
        for rating, count in rating_dist.items():
            print(f"       {rating}: {count} ({count/len(df)*100:.1f}%)")
    
    print(f"\n" + "="*50)
    print("Data cleaning complete!")
    print("Next step: Run SQL scripts to import into SQL Server")
    print("="*50)
    
    return df

if __name__ == '__main__':
    clean_data()
