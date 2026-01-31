# PowerBI Setup and Dashboard Guide

## Overview
This guide walks you through connecting PowerBI to your SQL Server database and creating a comprehensive customer shopping behavior analysis dashboard.

## Prerequisites
- Power BI Desktop installed (download from [Microsoft](https://powerbi.microsoft.com/desktop/))
- SQL Server with CustomerShoppingDB database configured
- Data imported and views created in SQL Server

## Step 1: Connect PowerBI to SQL Server

### 1.1 Open Power BI Desktop
1. Launch Power BI Desktop
2. Click on **Get Data** on the Home ribbon
3. Select **SQL Server** from the database options

### 1.2 Configure Connection
1. **Server**: Enter your SQL Server name (e.g., `localhost` or `SERVERNAME\INSTANCE`)
2. **Database**: Enter `CustomerShoppingDB`
3. **Data Connectivity mode**: Select **Import** (recommended for this project)
4. Click **OK**

### 1.3 Select Data Sources
In the Navigator window, expand the `CustomerShoppingDB` database and select these views:

- ☑ Shopping.vw_SalesOverview
- ☑ Shopping.vw_SalesByCategory
- ☑ Shopping.vw_SalesBySeason
- ☑ Shopping.vw_CustomerDemographics
- ☑ Shopping.vw_ProductPerformance
- ☑ Shopping.vw_PaymentShipping
- ☑ Shopping.vw_DiscountImpact
- ☑ Shopping.vw_CustomerSegmentation
- ☑ Shopping.vw_PurchaseDetails

Click **Load** to import the data.

## Step 2: Create Relationships (if needed)

Power BI usually auto-detects relationships. Verify in the **Model** view:

1. Click the **Model** icon on the left sidebar
2. Check that relationships are established between tables
3. For this project, views are pre-aggregated, so minimal relationships are needed

## Step 3: Create Dashboard Pages

### Page 1: Executive Summary Dashboard

**Purpose**: High-level overview of key metrics

**Visuals to Add**:

1. **KPI Cards** (using vw_SalesOverview):
   - Total Revenue (Card visual)
   - Total Transactions (Card visual)
   - Average Order Value (Card visual)
   - Average Rating (Card visual)

2. **Revenue by Category** (using vw_SalesByCategory):
   - Donut Chart: Category vs TotalRevenue
   
3. **Sales by Season** (using vw_SalesBySeason):
   - Column Chart: Season vs TotalRevenue

4. **Top Products** (using vw_ProductPerformance):
   - Bar Chart: Top 10 ItemPurchased by TotalRevenue

### Page 2: Customer Analysis

**Purpose**: Deep dive into customer demographics and behavior

**Visuals to Add**:

1. **Customer Distribution by Age Group** (using vw_CustomerDemographics):
   - Stacked Bar Chart: AgeGroup vs CustomerCount, split by Gender

2. **Customer Geographic Distribution** (using vw_CustomerDemographics):
   - Map Visual: Location with bubble size = TotalSpent
   - Or Bar Chart: Top locations by CustomerCount

3. **Purchase Frequency Analysis** (using vw_CustomerSegmentation):
   - Pie Chart: FrequencyOfPurchases distribution

4. **High Value Customers** (using vw_CustomerSegmentation):
   - Table: Top 20 customers by TotalSpent
   - Columns: CustomerID, Age, Gender, Location, TotalSpent, AverageRating

### Page 3: Product Performance

**Purpose**: Analyze product categories and individual items

**Visuals to Add**:

1. **Category Performance Matrix** (using vw_SalesByCategory):
   - Table: Category, TransactionCount, TotalRevenue, AverageOrderValue, AverageRating

2. **Product Performance Heatmap** (using vw_ProductPerformance):
   - Matrix: ItemPurchased vs Category, values = UnitsSold

3. **Product Ratings** (using vw_ProductPerformance):
   - Scatter Chart: AveragePrice (X-axis) vs AverageRating (Y-axis)
   - Size: UnitsSold

4. **Product Color Preferences** (using vw_ProductPerformance):
   - Stacked Column Chart: Color vs UnitsSold, by Category

### Page 4: Sales Trends & Patterns

**Purpose**: Identify seasonal patterns and trends

**Visuals to Add**:

1. **Seasonal Revenue Comparison** (using vw_SalesBySeason):
   - Clustered Column Chart: Season vs TotalRevenue and TransactionCount

2. **Payment Method Analysis** (using vw_PaymentShipping):
   - Bar Chart: PaymentMethod vs TransactionCount
   
3. **Shipping Type Performance** (using vw_PaymentShipping):
   - Stacked Bar Chart: ShippingType vs TotalRevenue

4. **Discount Impact** (using vw_DiscountImpact):
   - Clustered Column Chart: DiscountStatus vs AverageOrderValue

### Page 5: Detailed Analysis

**Purpose**: Interactive detailed view for drill-down analysis

**Visuals to Add**:

1. **Complete Purchase Details** (using vw_PurchaseDetails):
   - Table visual with all columns
   - Enable sorting and filtering

2. **Slicers for Filtering**:
   - Season (from vw_PurchaseDetails)
   - Category (from vw_PurchaseDetails)
   - Gender (from vw_PurchaseDetails)
   - Age Group (from vw_PurchaseDetails)
   - Location (from vw_PurchaseDetails)

## Step 4: Apply Formatting

### Theme and Colors
1. Go to **View** tab > **Themes**
2. Select a professional theme or customize your own
3. Recommended color palette:
   - Primary: #0078D4 (Blue)
   - Secondary: #00BCF2 (Light Blue)
   - Accent: #FFB900 (Gold)
   - Negative: #D13438 (Red)
   - Positive: #107C10 (Green)

### Visual Formatting Tips
1. **Titles**: Make them descriptive and consistent
2. **Data Labels**: Enable for key metrics
3. **Tooltips**: Customize with additional context
4. **Gridlines**: Minimize for cleaner look
5. **Legends**: Position consistently across visuals

## Step 5: Add Interactivity

### Cross-Filtering
1. By default, visuals filter each other
2. Test by clicking on different data points
3. Adjust interaction settings if needed:
   - Select a visual
   - Go to **Format** > **Edit interactions**
   - Choose which visuals should be filtered

### Drill-Through Pages
1. Create a drill-through page for customer details
2. Right-click on CustomerID in any visual
3. Select "Drill through" to see detailed information

### Bookmarks (Optional)
1. Create different views of the same page
2. Use buttons to switch between views
3. Examples: "Show Revenue" vs "Show Transactions"

## Step 6: Add Measures (DAX)

Create calculated measures for advanced analytics:

### Total Revenue YTD (if you have date field)
```dax
Total Revenue YTD = 
TOTALYTD(
    SUM(vw_PurchaseDetails[PurchaseAmountUSD]),
    'Date'[Date]
)
```

### Customer Lifetime Value
```dax
Customer LTV = 
CALCULATE(
    SUM(vw_CustomerSegmentation[TotalSpent])
)
```

### Discount Effectiveness
```dax
Discount Impact % = 
DIVIDE(
    CALCULATE(SUM(vw_PurchaseDetails[PurchaseAmountUSD]), 
              vw_PurchaseDetails[DiscountApplied] = "Yes"),
    SUM(vw_PurchaseDetails[PurchaseAmountUSD]),
    0
) * 100
```

### Average Customer Rating
```dax
Avg Customer Rating = 
AVERAGE(vw_PurchaseDetails[ReviewRating])
```

## Step 7: Publish and Share

### Publish to Power BI Service
1. Click **Publish** on the Home ribbon
2. Sign in to your Power BI account
3. Select a workspace
4. Click **Open [Report Name] in Power BI**

### Share Dashboard
1. In Power BI Service, click **Share**
2. Enter email addresses
3. Set permissions (view/edit)
4. Click **Share**

### Schedule Refresh
1. Go to workspace settings
2. Click on dataset settings
3. Configure refresh schedule
4. Enter SQL Server credentials if prompted

## Dashboard Best Practices

### Layout
- Use a consistent grid system (16:9 aspect ratio)
- Group related visuals together
- Leave white space for readability
- Place most important KPIs at the top

### Color Usage
- Limit to 3-5 colors
- Use color to highlight insights
- Maintain consistency across pages
- Consider color-blind friendly palettes

### Performance
- Limit visuals per page (7-10 maximum)
- Use summarized views instead of raw data
- Remove unnecessary columns from data model
- Optimize DAX measures

### User Experience
- Add page navigation buttons
- Include a "How to Use" page
- Add descriptive titles and subtitles
- Test on different screen sizes

## Sample Dashboard Insights

Based on the customer shopping data, your dashboard should answer:

1. **What are our top-performing categories?**
2. **Which customer segments are most valuable?**
3. **How do seasons affect purchasing behavior?**
4. **What is the impact of discounts on sales?**
5. **Which products have the highest ratings?**
6. **What are the preferred payment and shipping methods?**
7. **How do demographics influence purchasing patterns?**
8. **Which locations generate the most revenue?**

## Troubleshooting

### Connection Issues
- Verify SQL Server is running
- Check firewall settings
- Ensure TCP/IP is enabled in SQL Server Configuration Manager
- Verify credentials have proper permissions

### Data Not Loading
- Check if views exist in SQL Server
- Verify data is populated in tables
- Run SQL queries manually to test views
- Check for locked tables or transactions

### Performance Issues
- Reduce number of visuals per page
- Use aggregated views instead of detail tables
- Implement incremental refresh
- Optimize SQL queries and add indexes

## Additional Resources

- [Power BI Documentation](https://docs.microsoft.com/power-bi/)
- [DAX Function Reference](https://dax.guide/)
- [Power BI Community](https://community.powerbi.com/)
- [SQL Server Integration](https://docs.microsoft.com/power-bi/connect-data/service-gateway-sql-tutorial)

## Support

For issues or questions about this project:
1. Check the README.md in the project root
2. Review SQL scripts in the `sql/` directory
3. Verify data cleaning in the `scripts/` directory
4. Consult PowerBI documentation for visual-specific help
