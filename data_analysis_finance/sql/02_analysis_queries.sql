-- Query 1: Total profit/category
SELECT
    p.category,
    SUM(f.sales) AS total_sales,
    SUM(f.profit) AS total_profit,
    ROUND(SUM(f.profit) / NULLIF(SUM(f.sales), 0) * 100, 2) AS margin_pct
FROM fact_sales f
JOIN dim_product p ON f.product_id = p.product_id
GROUP BY p.category
ORDER BY total_profit DESC;

-- Query 2: Top 10 sub-categories/profit
SELECT
    p.sub_category,
    SUM(f.sales) AS total_sales,
    SUM(f.profit) AS total_profit,
    RANK() OVER (ORDER BY SUM(f.profit) DESC) AS rank_profit
FROM fact_sales f
JOIN dim_product p ON f.product_id = p.product_id
GROUP BY p.sub_category
ORDER BY total_profit DESC
LIMIT 10;

-- Query 3: margin/region
SELECT
    r.region,
    SUM(f.sales) AS total_sales,
    SUM(f.profit) AS total_profit,
    ROUND(SUM(f.profit) / NULLIF(SUM(f.sales), 0) * 100, 2) AS margin_pct
FROM fact_sales f
JOIN dim_region r ON f.region_id = r.region_id
GROUP BY r.region
ORDER BY margin_pct DESC;

-- Query 4: Discount impact on profit
WITH discount_bucket AS (
    SELECT
        CASE
            WHEN discount = 0 THEN '0%'
            WHEN discount <= 0.1 THEN '1 a 10%'
            WHEN discount <= 0.2 THEN '11 a 20%'
            WHEN discount <= 0.3 THEN '21 a 30%'
            ELSE 'Acima de 30%'
        END AS faixa_desconto,
        profit,
        sales
    FROM fact_sales
)
SELECT
    faixa_desconto,
    COUNT(*) AS num_pedidos,
    ROUND(AVG(profit), 2) AS lucro_medio,
    ROUND(SUM(profit) / NULLIF(SUM(sales), 0) * 100, 2) AS margem_pct
FROM discount_bucket
GROUP BY faixa_desconto
ORDER BY margem_pct DESC;

-- Query 5: Monthly Sales and Profit Trends
WITH monthly AS (
    SELECT
        DATE_TRUNC('month', order_date) AS month,
        SUM(sales) AS total_sales,
        SUM(profit) AS total_profit
    FROM fact_sales
    GROUP BY 1
)
SELECT
    month,
    total_sales,
    total_profit,
    LAG(total_sales) OVER (ORDER BY month) AS prev_sales,
    ROUND(
        (total_sales - LAG(total_sales) OVER (ORDER BY month))::numeric
        / NULLIF(LAG(total_sales) OVER (ORDER BY month), 0) * 100, 2
    ) AS growth_pct
FROM monthly
ORDER BY month;