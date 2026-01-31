# Customer Shopping Behavior Analysis

import pandas as pd

df = pd.read_csv('customer_shopping_behavior.csv')

print("First 5 rows of the dataset:")
print(df.head())
print()


print("Dataset Info:")
df.info()
print()

print("Summary Statistics:")
print(df.describe(include='all'))
print()

print("Missing values check:")
print(df.isnull().sum())
print()

df['Review Rating'] = df.groupby('Category')['Review Rating'].transform(lambda x: x.fillna(x.median()))

print("Missing values after imputation:")
print(df.isnull().sum())
print()

df.columns = df.columns.str.lower()
df.columns = df.columns.str.replace(' ','_')
df = df.rename(columns={'purchase_amount_(usd)':'purchase_amount'})

print("Renamed columns:")
print(df.columns)
print()

labels = ['Young Adult', 'Adult', 'Middle-aged', 'Senior']
df['age_group'] = pd.qcut(df['age'], q=4, labels = labels)

print("Age and Age Group (first 10 rows):")
print(df[['age','age_group']].head(10))
print()

frequency_mapping = {
    'Fortnightly': 14,
    'Weekly': 7,
    'Monthly': 30,
    'Quarterly': 90,
    'Bi-Weekly': 14,
    'Annually': 365,
    'Every 3 Months': 90
}

df['purchase_frequency_days'] = df['frequency_of_purchases'].map(frequency_mapping)

print("Purchase Frequency (first 10 rows):")
print(df[['purchase_frequency_days','frequency_of_purchases']].head(10))
print()

print("Discount Applied and Promo Code Used (first 10 rows):")
print(df[['discount_applied','promo_code_used']].head(10))
print()

print("Are discount_applied and promo_code_used columns identical?")
print((df['discount_applied'] == df['promo_code_used']).all())
print()

df = df.drop('promo_code_used', axis=1)

print("Final columns:")
print(df.columns)
print()


# ============================================
# Connecting Python script to PostgreSQL
# ============================================
# Note: psycopg2-binary and sqlalchemy are already installed in your virtual environment

from sqlalchemy import create_engine

# Step 1: Connect to PostgreSQL
# Replace placeholders with your actual details
username = "postgres"      # default user
password = "postgres" # the password you set during installation
host = "localhost"         # if running locally
port = "5432"              # default PostgreSQL port
database = "customer_behavior"    # the database you created in pgAdmin

engine = create_engine(f"postgresql+psycopg2://{username}:{password}@{host}:{port}/{database}")

# Step 2: Load DataFrame into PostgreSQL
table_name = "customer"   # choose any table name
df.to_sql(table_name, engine, if_exists="replace", index=False)

print(f"Data successfully loaded into table '{table_name}' in database '{database}'.")