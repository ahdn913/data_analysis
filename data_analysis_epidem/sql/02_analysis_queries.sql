-- sql/02_analysis_queries.sql
-- Queries de análise para o dashboard

-- Query 1: Top 10 países com mais casos acumulados
SELECT
    c.country,
    MAX(f.cumulative_cases) AS total_cases,
    MAX(f.cumulative_deaths) AS total_deaths
FROM fact_covid f
JOIN dim_country c ON f.country_code = c.country_code
GROUP BY c.country
ORDER BY total_cases DESC
LIMIT 10;

-- Query 2: Média móvel de 7 dias de novos casos no Brasil
WITH daily AS (
    SELECT
        date_reported,
        new_cases
    FROM fact_covid f
    JOIN dim_country c ON f.country_code = c.country_code
    WHERE c.country = 'Brazil'
)
SELECT
    date_reported,
    new_cases,
    AVG(new_cases) OVER (
        ORDER BY date_reported
        ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
    ) AS moving_avg_7d
FROM daily
ORDER BY date_reported;

-- Query 3: Casos por região da OMS
SELECT
    c.who_region,
    SUM(f.new_cases) AS total_new_cases
FROM fact_covid f
JOIN dim_country c ON f.country_code = c.country_code
GROUP BY c.who_region
ORDER BY total_new_cases DESC;

-- Query 4: Ranking de países por mortes em 2021
SELECT
    c.country,
    SUM(f.new_deaths) AS deaths_2021,
    RANK() OVER (ORDER BY SUM(f.new_deaths) DESC) AS rank
FROM fact_covid f
JOIN dim_country c ON f.country_code = c.country_code
WHERE EXTRACT(YEAR FROM f.date_reported) = 2021
GROUP BY c.country
ORDER BY deaths_2021 DESC
LIMIT 20;

-- Query 5: Taxa de crescimento percentual mensal no Brasil
WITH monthly AS (
    SELECT
        DATE_TRUNC('month', date_reported) AS month,
        SUM(new_cases) AS cases
    FROM fact_covid f
    JOIN dim_country c ON f.country_code = c.country_code
    WHERE c.country = 'Brazil'
    GROUP BY 1
)
SELECT
    month,
    cases,
    LAG(cases) OVER (ORDER BY month) AS prev_month,
    ROUND(
        (cases - LAG(cases) OVER (ORDER BY month))::numeric
        / NULLIF(LAG(cases) OVER (ORDER BY month), 0) * 100, 2
    ) AS growth_pct
FROM monthly
ORDER BY month;