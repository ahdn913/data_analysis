-- Intermediate model: enrich customer data with bands and categories
WITH base AS (
    SELECT * FROM {{ ref('stg_credit') }}
)

SELECT
    -- Create income bands
    CASE
        WHEN monthly_income IS NULL THEN 'Unknown'
        WHEN monthly_income < 2000 THEN 'Very Low'
        WHEN monthly_income < 5000 THEN 'Low'
        WHEN monthly_income < 10000 THEN 'Medium'
        WHEN monthly_income < 20000 THEN 'High'
        ELSE 'Very High'
    END AS income_band,
    -- Create age bands
    CASE
        WHEN age < 30 THEN '18-29'
        WHEN age < 45 THEN '30-44'
        WHEN age < 60 THEN '45-59'
        ELSE '60+'
    END AS age_band,
    -- Revolving utilization categories
    CASE
        WHEN revolving_utilization < 0.3 THEN 'Low'
        WHEN revolving_utilization < 0.7 THEN 'Medium'
        ELSE 'High'
    END AS utilization_band,
    -- Keep original numeric columns for aggregation
    monthly_income,
    age,
    revolving_utilization,
    target_delinquency,
    debt_ratio,
    days_30_59_late,
    times_90_late,
    days_60_89_late
FROM base