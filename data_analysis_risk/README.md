# Credit Risk Analytics

An end-to-end data pipeline analyzing credit default risk using a modern data stack: PostgreSQL, dbt, Apache Airflow, Python, and (in progress) Databricks and Power BI.

## Overview

This project builds a complete data pipeline to analyze credit default risk. It answers business questions such as: what is the overall delinquency rate, which customer profiles have the highest risk, and how can the portfolio be segmented to reduce losses.

The pipeline goes from raw CSV ingestion to a dashboard, passing through cleaning, transformation, orchestration, and visualization.

## Architecture

| CSV Kaggle |->| Airflow |->| PostgreSQL |->| dbt |
| (source) | | (orchestrate)| | (transform) |

|
v

| Power BI |
| (dashboard) |

Flow:

1. Airflow triggers the pipeline daily.
2. Python reads the CSV, cleans it, and loads it into PostgreSQL (raw layer).
3. dbt transforms the data into layered models (staging, intermediate, marts).
4. Power BI consumes the marts and presents executive and operational dashboards.

## Tech Stack

- **PostgreSQL:** data warehouse
- **dbt:** transformation layer (staging, intermediate, marts)
- **Apache Airflow:** orchestration of the daily pipeline
- **Python:** ETL, cleaning, and report automation
- **GitHub Actions:** CI/CD for testing and validation (planned)

## Repository Structure

data_analysis_risk/
|-- airflow/
|       |-- dags/
|       |-- credit_pipeline_dag.py
|-- data/
|       |-- raw/
|       |-- cs-training.csv (gitignored)
|--dbt/
|       |-- risk_dbt/
|       |-- dbt_project.yml
|       |-- models/
|       |-- staging/
|               |-- sources.yml
|               |-- schema.yml
|               |-- stg_credit.sql
|       |-- intermediate/
|               |-- int_customer_profile.sql
|               |-- int_delinquency.sql
|       |-- marts/
|               |-- dim_customer.sql
|               |-- fct_credit_risk.sql
|               |-- mart_risk_by_segment.sql
|       |-- scripts/
|               |-- load_data.py
|-- .gitignore
|-- README.md

## Data Source

- **Dataset:** Give Me Some Credit (Kaggle)
- **Link:** https://www.kaggle.com/c/GiveMeSomeCredit
- **File:** `cs-training.csv`
- **Volume:** ~150,000 rows, 11 columns
- **Target:** `SeriousDlqin2yrs` (1 = defaulted, 0 = did not default)

Columns include: revolving utilization, age, past-due events, debt ratio, monthly income, open credit lines, real estate loans, dependents.

## Data Model (dbt)

The dbt project is organized in three layers:

- **Staging (`stg_credit`):** renames columns, filters invalid ages, applies basic typing.
- **Intermediate (`int_customer_profile`, `int_delinquency`):** builds income bands, age bands, utilization categories, delinquency aggregates.
- **Marts (`dim_customer`, `fct_credit_risk`, `mart_risk_by_segment`):** star schema (dimension + fact) and the aggregate mart with delinquency rate by segment.

## Requirements

- Python 3.10+
- PostgreSQL 14+
- dbt-core and dbt-postgres
- Apache Airflow 2.8+
- Power BI Desktop (for dashboard phase)

## How to Run

This project uses **two separate virtual environments** to avoid dependency conflicts:

- `data_venv` - for the Python ETL script (pandas + SQLAlchemy 2.x)
- `airflow_venv` - for Airflow (which requires SQLAlchemy < 2.0)

### 1. Clone the repository

```bash
git clone https://github.com/ahdn913/credit-risk-analytics.git
cd credit-risk-analytics
```

### 2. Create the database

```bash
sudo -u postgres psql -c "CREATE DATABASE credit_risk;"
```

### 3. Create the `data_venv`

```bash
python3 -m venv data_venv
source data_venv/bin/activate
pip install pandas sqlalchemy psycopg2-binary
deactivate
```

### 4. Download the CSV

Download `cs-training.csv` from Kaggle and place it in `data/raw/`.

### 5. Load the raw data

```bash
export DATABASE_URL="postgresql://postgres:YOUR_PASSWORD@localhost:5432/credit_risk"
./data_venv/bin/python scripts/load_data.py
```

### 6. Configure dbt

```bash
cd dbt/risk_dbt
dbt debug
dbt run
dbt test
```

### 7. Set up Airflow

```bash
python3 -m venv airflow_venv
source airflow_venv/bin/activate
pip install "apache-airflow==2.8.1" "sqlalchemy<2.0"
airflow db migrate
airflow users create --username admin --firstname Admin --lastname User --role Admin --email you@example.com
```

Copy the DAG from `airflow/dags/` to `~/airflow/dags/`, then start:

```bash
airflow webserver --port 8080   # terminal 1
airflow scheduler                # terminal 2
```

Access `http://localhost:8080` and trigger the `credit_pipeline` DAG.

## Pipeline Steps

| Task | Tool | Description |
|---|---|---|
| `extract` | Python | Loads the CSV into `raw_credit` in PostgreSQL |
| `dbt_run` | dbt | Builds staging, intermediate and marts models |
| `dbt_test` | dbt | Runs data quality tests |
| `generate_report` | Bash (placeholder) | Prints a timestamp |

## KPIs

- **Delinquency rate:** defaulted customers / total customers
- **Average ticket:** mean monthly income per customer
- **Average revolving utilization:** mean across all customers
- **High-risk customer count:** customers with 2+ past-due events
- **Delinquency by income band:** defaulted / total per band
- **Delinquency by age band:** defaulted / total per band

## Roadmap

- [x] Phase 1: Ingestion and cleaning (Python + PostgreSQL)
- [x] Phase 2: Transformation (dbt)
- [x] Phase 4: Orchestration (Airflow)
- [ ] Phase 3: Processing with Databricks (PySpark)
- [ ] Phase 5: Visualization (Power BI)
- [ ] Phase 6: CI/CD (GitHub Actions)

## Author

Adriano Neves
GitHub: https://github.com/ahdn913
LinkedIn: https://www.linkedin.com/in/adriano-henrique-neves/

## License

MIT