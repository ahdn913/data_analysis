# Superstore Sales Performance and Profitability Analysis

An end-to-end data analysis project using SQL, Power BI, DAX, Power Query, Python, and Excel to analyze sales performance and profitability.

## Overview

This project analyzes sales data from a retail chain to answer business questions such as: which categories are most profitable, which region has the highest profit margin, how discounts affect profitability, and how sales evolve over time. It demonstrates a complete analytics workflow: data ingestion with Python, dimensional modeling in PostgreSQL, advanced SQL queries with CTEs and window functions, an interactive Power BI dashboard with DAX measures, and complementary analysis in Excel.

## Project Structure

superstore-sales-analysis/
├── data/
│   └── raw/
│       └── Sample - Superstore.csv
├── scripts/
│   └── load_data.py
├── sql/
│   ├── 01_create_tables.sql
│   └── 02_analysis_queries.sql
├── powerbi/
│   └── superstore_dashboard.pbix
├── excel/
│   └── superstore_analysis.xlsx
└── README.md

## Data Source

- Superstore Sales Dataset (Kaggle)
- Link: https://www.kaggle.com/datasets/vivek468/superstore-dataset-final
- File: Sample - Superstore.csv
- Columns: Order ID, Order Date, Ship Date, Ship Mode, Customer ID, Segment, Region, Category, Sub-Category, Sales, Quantity, Discount, Profit

## Requirements

- PostgreSQL 14+
- Python 3.10+
- Power BI Desktop
- Python libraries: pandas, sqlalchemy, psycopg2

## How to Run

1. Download the CSV from Kaggle and place it in data/raw/

2. Create the database:

    sudo -u postgres psql
    CREATE DATABASE superstore;
    \q

3. Install Python dependencies:

    pip install pandas sqlalchemy psycopg2-binary

4. Load the data into PostgreSQL:

    python scripts/load_data.py

5. Create the dimensional model:

    psql -d superstore -f sql/01_create_tables.sql

6. Run the analysis queries:

    psql -d superstore -f sql/02_analysis_queries.sql

7. Open the Power BI file powerbi/superstore_dashboard.pbix and refresh the connection to PostgreSQL

8. Open the Excel file excel/superstore_analysis.xlsx for complementary analysis

## Data Model

The project uses a star schema with the following tables:

- dim_product: category, sub-category, product name
- dim_customer: customer name, segment
- dim_region: region, state, city
- dim_date: year, month, quarter, weekday
- fact_sales: sales, quantity, discount, profit

## Analyses

- Total profit by category
- Top 10 sub-categories by profit
- Profit margin by region
- Impact of discount on profit
- Monthly evolution of sales and profit

## Key Metrics and KPIs

- Total sales
- Total profit
- Profit margin
- Average ticket
- Discount rate
- Year-over-year growth

## Power BI Dashboard

1. Overview: KPIs, monthly evolution, filters
2. Category and Region Analysis: profit by category, margin by region, sales map
3. Discount Impact: margin by discount range, discount vs profit scatter, percentage of high-discount orders

## Technologies

- SQL (PostgreSQL)
- Power BI
- DAX
- Power Query
- Python (pandas, sqlalchemy)
- Git

## Insights

- Technology has the highest profit margin among categories
- Discounts above 20 percent frequently generate losses
- The East and West regions have better margins than Central and South
- Sales peak in November and December

## Author

Adriano Neves
GitHub: https://github.com/ahdn913
LinkedIn: https://linkedin.com/in/adriano-henrique-neves

## License

This project is licensed under the MIT License.