-- Staging model: clean and rename raw credit data
WITH raw AS (
    SELECT * FROM {{ source('credit', 'raw_credit') }}
)

SELECT
    seriousdlqin2yrs AS target_delinquency,
    revolvingutilizationofunsecuredlines AS revolving_utilization,
    age,
    "numberoftime30-59dayspastduenotworse" AS days_30_59_late,
    debtratio AS debt_ratio,
    monthlyincome AS monthly_income,
    numberofopencreditlinesandloans AS open_credit_lines,
    numberoftimes90dayslate AS times_90_late,
    numberrealestateloansorlines AS real_estate_loans,
    "numberoftime60-89dayspastduenotworse" AS days_60_89_late,
    numberofdependents AS dependents
FROM raw
WHERE age >= 18