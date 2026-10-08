-- Intermediate model: aggregate delinquency history per customer
WITH base AS (
    SELECT * FROM {{ ref('stg_credit') }}
)

SELECT
    -- Total past-due events across all categories
    (days_30_59_late + days_60_89_late + times_90_late) AS total_past_due,
    -- Flag for high risk (2 or more past-due events)
    CASE
        WHEN (days_30_59_late + days_60_89_late + times_90_late) >= 2 THEN 1
        ELSE 0
    END AS is_high_risk,
    -- Original columns for detail and joins
    target_delinquency,
    age,
    monthly_income,
    days_30_59_late,
    days_60_89_late,
    times_90_late,
    debt_ratio,
    open_credit_lines
FROM base