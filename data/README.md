# Data Directory

## Structure

- `raw/`: Contains the original dataset downloaded from online sources
- `cleaned/`: Contains the cleaned and processed dataset ready for SQL Server import

## Dataset Information

This project uses the **Customer Shopping Dataset** for retail behavior analysis.

### Dataset Source
- **Source**: Kaggle - Customer Shopping Dataset
- **URL**: https://www.kaggle.com/datasets/iamsouravbanerjee/customer-shopping-trends-dataset
- **Alternative Source**: https://raw.githubusercontent.com/datasets/customer-shopping-trends/main/customer_shopping_data.csv

### Dataset Description
The dataset contains customer shopping behavior information including:
- Customer demographics (Age, Gender)
- Purchase information (Item Purchased, Category, Size, Color)
- Transaction details (Purchase Amount, Location, Season)
- Customer preferences (Subscription Status, Payment Method, Shipping Type)
- Ratings and reviews

### Columns
- `Customer ID`: Unique identifier for each customer
- `Age`: Customer age
- `Gender`: Customer gender
- `Item Purchased`: Name of the item purchased
- `Category`: Product category
- `Purchase Amount (USD)`: Transaction amount in USD
- `Location`: Purchase location/state
- `Size`: Product size
- `Color`: Product color
- `Season`: Season of purchase
- `Review Rating`: Customer rating (1-5)
- `Subscription Status`: Whether customer has subscription
- `Shipping Type`: Type of shipping selected
- `Discount Applied`: Whether discount was applied
- `Promo Code Used`: Whether promo code was used
- `Previous Purchases`: Number of previous purchases
- `Payment Method`: Payment method used
- `Frequency of Purchases`: Purchase frequency category

## How to Get the Data

1. Run the data download script:
   ```bash
   python scripts/01_download_data.py
   ```

2. Or manually download from the sources listed above and place in `data/raw/` folder

## Note
The actual data files are excluded from git repository via `.gitignore` to keep the repository size manageable.
