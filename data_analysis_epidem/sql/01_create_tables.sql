-- sql/01_create_tables.sql
-- Criação das tabelas dimensionais

-- Dimensão de países
CREATE TABLE IF NOT EXISTS dim_country (
    country_code VARCHAR(10) PRIMARY KEY,
    country VARCHAR(150),
    who_region VARCHAR(50)
);

-- Fato de COVID-19
CREATE TABLE IF NOT EXISTS fact_covid (
    date_reported DATE,
    country_code VARCHAR(10),
    new_cases INTEGER,
    cumulative_cases BIGINT,
    new_deaths INTEGER,
    cumulative_deaths BIGINT,
    FOREIGN KEY (country_code) REFERENCES dim_country(country_code)
);

-- Limpar tabelas antes de popular (re-execução segura)
TRUNCATE TABLE fact_covid;
TRUNCATE TABLE dim_country CASCADE;

-- Popular a dimensão (ignorando country_code NULL ou vazio)
INSERT INTO dim_country (country_code, country, who_region)
SELECT DISTINCT country_code, country, who_region
FROM raw_covid
WHERE country_code IS NOT NULL
  AND country_code <> ''
ON CONFLICT (country_code) DO NOTHING;

-- Popular o fato (cast de date_reported para DATE, ignorando country_code NULL)
INSERT INTO fact_covid (
    date_reported,
    country_code,
    new_cases,
    cumulative_cases,
    new_deaths,
    cumulative_deaths
)
SELECT
    date_reported::date,
    country_code,
    new_cases,
    cumulative_cases,
    new_deaths,
    cumulative_deaths
FROM raw_covid
WHERE country_code IS NOT NULL
  AND country_code <> '';