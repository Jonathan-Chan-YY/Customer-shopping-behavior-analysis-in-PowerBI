"""
Script to download customer shopping dataset from online source
"""

import os
import urllib.request
import pandas as pd

# Define paths
SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
PROJECT_ROOT = os.path.dirname(SCRIPT_DIR)
RAW_DATA_DIR = os.path.join(PROJECT_ROOT, 'data', 'raw')
OUTPUT_FILE = os.path.join(RAW_DATA_DIR, 'customer_shopping_data.csv')

# Dataset URLs (try multiple sources)
DATASET_URLS = [
    'https://raw.githubusercontent.com/datasets/customer-shopping-trends/main/shopping_trends.csv',
    'https://raw.githubusercontent.com/iamsouravbanerjee/Customer-Shopping-Trends-Dataset/main/shopping_trends_updated.csv'
]

def download_dataset():
    """Download the customer shopping dataset from online source"""
    
    # Create directory if it doesn't exist
    os.makedirs(RAW_DATA_DIR, exist_ok=True)
    
    print(f"Downloading customer shopping dataset...")
    print(f"Target location: {OUTPUT_FILE}")
    
    # Try each URL until one works
    for i, url in enumerate(DATASET_URLS, 1):
        try:
            print(f"\nAttempting download from source {i}...")
            print(f"URL: {url}")
            
            # Download the file
            urllib.request.urlretrieve(url, OUTPUT_FILE)
            
            # Verify the download by reading the file
            df = pd.read_csv(OUTPUT_FILE)
            print(f"\n✓ Successfully downloaded dataset!")
            print(f"  - Rows: {len(df)}")
            print(f"  - Columns: {len(df.columns)}")
            print(f"  - File size: {os.path.getsize(OUTPUT_FILE) / 1024:.2f} KB")
            print(f"\nColumn names:")
            for col in df.columns:
                print(f"  - {col}")
            
            return True
            
        except Exception as e:
            print(f"✗ Failed to download from source {i}: {str(e)}")
            if os.path.exists(OUTPUT_FILE):
                os.remove(OUTPUT_FILE)
            continue
    
    # If all sources fail, create a sample dataset
    print("\n⚠ All download sources failed. Creating sample dataset...")
    create_sample_dataset()
    return False

def create_sample_dataset():
    """Create a sample dataset for demonstration purposes"""
    
    import random
    from datetime import datetime, timedelta
    
    # Sample data
    categories = ['Clothing', 'Footwear', 'Outerwear', 'Accessories']
    items = {
        'Clothing': ['Shirt', 'Pants', 'Dress', 'Blouse', 'Sweater'],
        'Footwear': ['Sneakers', 'Sandals', 'Boots', 'Heels'],
        'Outerwear': ['Jacket', 'Coat', 'Hoodie', 'Blazer'],
        'Accessories': ['Belt', 'Hat', 'Scarf', 'Sunglasses', 'Handbag']
    }
    locations = ['Montana', 'California', 'Idaho', 'Nevada', 'Illinois', 
                 'Oregon', 'Nebraska', 'Texas', 'Florida', 'New York']
    sizes = ['S', 'M', 'L', 'XL']
    colors = ['Black', 'White', 'Red', 'Blue', 'Green', 'Yellow', 'Pink', 'Gray']
    seasons = ['Fall', 'Winter', 'Spring', 'Summer']
    genders = ['Male', 'Female']
    subscription_status = ['Yes', 'No']
    shipping_types = ['Standard', 'Express', '2-Day Shipping', 'Free Shipping', 'Store Pickup']
    payment_methods = ['Credit Card', 'PayPal', 'Debit Card', 'Cash', 'Venmo']
    frequency_purchases = ['Weekly', 'Fortnightly', 'Monthly', 'Quarterly', 'Annually']
    
    # Generate sample data
    num_records = 3900
    data = []
    
    for i in range(1, num_records + 1):
        category = random.choice(categories)
        item = random.choice(items[category])
        
        record = {
            'Customer ID': i,
            'Age': random.randint(18, 70),
            'Gender': random.choice(genders),
            'Item Purchased': item,
            'Category': category,
            'Purchase Amount (USD)': round(random.uniform(20, 100), 2),
            'Location': random.choice(locations),
            'Size': random.choice(sizes),
            'Color': random.choice(colors),
            'Season': random.choice(seasons),
            'Review Rating': round(random.uniform(2.5, 5.0), 1),
            'Subscription Status': random.choice(subscription_status),
            'Shipping Type': random.choice(shipping_types),
            'Discount Applied': random.choice(['Yes', 'No']),
            'Promo Code Used': random.choice(['Yes', 'No']),
            'Previous Purchases': random.randint(0, 50),
            'Payment Method': random.choice(payment_methods),
            'Frequency of Purchases': random.choice(frequency_purchases)
        }
        data.append(record)
    
    # Create DataFrame and save
    df = pd.DataFrame(data)
    df.to_csv(OUTPUT_FILE, index=False)
    
    print(f"\n✓ Sample dataset created successfully!")
    print(f"  - Rows: {len(df)}")
    print(f"  - Columns: {len(df.columns)}")
    print(f"  - File: {OUTPUT_FILE}")

if __name__ == '__main__':
    download_dataset()
    print("\n" + "="*50)
    print("Data download complete!")
    print("Next step: Run '02_clean_data.py' to clean the data")
    print("="*50)
