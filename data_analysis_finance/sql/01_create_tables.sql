-- sql/01_create_tables.sql
-- creating dimensional tables

CREATE TABLE IF NOT EXISTS dim_product (
    product_id VARCHAR(50) PRIMARY KEY,
    category VARCHAR(50),
    sub_category VARCHAR(50),
    product_name VARCHAR(200)
);

CREATE TABLE IF NOT EXISTS dim_customer (
    customer_id VARCHAR(50) PRIMARY KEY,
    customer_name VARCHAR(200),
    segment VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS dim_region (
    region_id SERIAL PRIMARY KEY,
    region VARCHAR(50),
    state VARCHAR(50),
    city VARCHAR(100),
    UNIQUE (region, state, city)
);

CREATE TABLE IF NOT EXISTS dim_date (
    date_id DATE PRIMARY KEY,
    year INTEGER,
    month INTEGER,
    quarter INTEGER,
    weekday VARCHAR(20)
);

CREATE TABLE IF NOT EXISTS fact_sales (
    order_id VARCHAR(50),
    order_date DATE,
    ship_date DATE,
    ship_mode VARCHAR(50),
    customer_id VARCHAR(50),
    product_id VARCHAR(50),
    region_id INTEGER,
    sales NUMERIC(10,2),
    quantity INTEGER,
    discount NUMERIC(5,2),
    profit NUMERIC(10,2),
    FOREIGN KEY (customer_id) REFERENCES dim_customer(customer_id),
    FOREIGN KEY (product_id) REFERENCES dim_product(product_id),
    FOREIGN KEY (region_id) REFERENCES dim_region(region_id)
);

TRUNCATE TABLE fact_sales;
TRUNCATE TABLE dim_product CASCADE;
TRUNCATE TABLE dim_customer CASCADE;
TRUNCATE TABLE dim_region CASCADE;
TRUNCATE TABLE dim_date CASCADE;

INSERT INTO dim_product (product_id, category, sub_category, product_name)
SELECT DISTINCT product_id, category, sub_category, product_name
FROM raw_superstore
ON CONFLICT (product_id) DO NOTHING;

INSERT INTO dim_customer (customer_id, customer_name, segment)
SELECT DISTINCT customer_id, customer_name, segment
FROM raw_superstore
ON CONFLICT (customer_id) DO NOTHING;

INSERT INTO dim_region (region, state, city)
SELECT DISTINCT region, state, city
FROM raw_superstore
ON CONFLICT (region, state, city) DO NOTHING;

INSERT INTO dim_date (date_id, year, month, quarter, weekday)
SELECT DISTINCT
    TO_DATE(order_date, 'MM/DD/YYYY'),
    EXTRACT(YEAR FROM TO_DATE(order_date, 'MM/DD/YYYY')),
    EXTRACT(MONTH FROM TO_DATE(order_date, 'MM/DD/YYYY')),
    EXTRACT(QUARTER FROM TO_DATE(order_date, 'MM/DD/YYYY')),
    TO_CHAR(TO_DATE(order_date, 'MM/DD/YYYY'), 'Day')
FROM raw_superstore
ON CONFLICT (date_id) DO NOTHING;

INSERT INTO fact_sales (
    order_id, order_date, ship_date, ship_mode,
    customer_id, product_id, region_id,
    sales, quantity, discount, profit
)
SELECT
    r.order_id,
    TO_DATE(r.order_date, 'MM/DD/YYYY'),
    TO_DATE(r.ship_date, 'MM/DD/YYYY'),
    r.ship_mode,
    r.customer_id,
    r.product_id,
    dr.region_id,
    r.sales,
    r.quantity,
    r.discount,
    r.profit
FROM raw_superstore r
JOIN dim_region dr
    ON r.region = dr.region
   AND r.state = dr.state
   AND r.city = dr.city;