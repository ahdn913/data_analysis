-- Dimension table: customer profile with bands
SELECT
    ROW_NUMBER() OVER (ORDER BY age, monthly_income) AS customer_id,
    age_band,
    income_band,
    utilization_band,
    age,
    monthly_income,
    revolving_utilization
FROM {{ ref('int_customer_profile') }}