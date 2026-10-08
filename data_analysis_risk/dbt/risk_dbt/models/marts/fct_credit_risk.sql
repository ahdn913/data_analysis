-- Fact table: credit risk per customer
SELECT
    ROW_NUMBER() OVER (ORDER BY age, monthly_income) AS customer_id,
    target_delinquency,
    total_past_due,
    is_high_risk,
    debt_ratio,
    open_credit_lines,
    days_30_59_late,
    days_60_89_late,
    times_90_late
FROM {{ ref('int_delinquency') }}