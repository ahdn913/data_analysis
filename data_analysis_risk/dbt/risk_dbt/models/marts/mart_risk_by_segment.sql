-- Mart: delinquency rate aggregated by income and age bands
WITH base AS (
    SELECT
        c.income_band,
        c.age_band,
        f.target_delinquency
    FROM {{ ref('fct_credit_risk') }} f
    JOIN {{ ref('dim_customer') }} c
        ON f.customer_id = c.customer_id
)

SELECT
    income_band,
    age_band,
    COUNT(*) AS total_customers,
    SUM(target_delinquency) AS delinquent_customers,
    ROUND(
        SUM(target_delinquency)::numeric / COUNT(*) * 100, 2
    ) AS delinquency_rate_pct
FROM base
GROUP BY income_band, age_band
ORDER BY delinquency_rate_pct DESC