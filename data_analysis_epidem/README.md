COVID-19 Global Analysis with SQL and Power BI

An end-to-end data analysis project using WHO COVID-19 data, from raw CSV ingestion to an interactive Power BI dashboard with advanced SQL modeling.

Overview

This project analyzes the evolution of COVID-19 worldwide using public data from the World Health Organization (WHO). It demonstrates a complete analytics workflow: data ingestion with Python, dimensional modeling in PostgreSQL, advanced SQL queries with CTEs and window functions, and an interactive Power BI dashboard with DAX measures.

The project answers questions such as: which countries had the highest number of cases, how did the 7-day moving average evolve in Brazil, which WHO region concentrated the most cases, and what was the monthly growth rate over time.

Data Source

    WHO COVID-19 Global Data: https://covid19.who.int/data

    File: WHO-COVID-19-global-data.csv

    Columns: Date_reported, Country_code, Country, WHO_region, New_cases, Cumulative_cases, New_deaths, Cumulative_deaths

Requirements

    PostgreSQL 14+

    Python 3.10+

    Power BI Desktop

    Python libraries: pandas, sqlalchemy, psycopg2

How to Run

    Download the WHO CSV from https://covid19.who.int/data and place it in data_analysis_epidem/data/raw/

    Create the database:

    sudo -u postgres psql
    CREATE DATABASE covid19;
    \q

    Install Python dependencies:

    pip install pandas sqlalchemy psycopg2-binary

    Load the data into PostgreSQL:

    python data_analysis_epidem/scripts/load_data.py

    Create the dimensional model and load the fact and dimension tables:

    psql -d covid19 -f data_analysis_epidem/sql/01_create_tables.sql

    Run the analysis queries:

    psql -d covid19 -f data_analysis_epidem/sql/02_analysis_queries.sql

    Open the Power BI file data_analysis_epidem/powerbi/data_analysis_epidem.pbix and refresh the connection to the PostgreSQL database.

Data Model

The project uses a star schema with the following tables:

    dim_country: dimension with country code, country name, and WHO region

    fact_covid: fact table with daily cases, cumulative cases, daily deaths, and cumulative deaths per country

    raw_covid: raw table loaded directly from the CSV

Analyses

    Top 10 countries by cumulative cases

    7-day moving average of new cases in Brazil

    Total cases by WHO region

    Ranking of countries by deaths in 2021

    Monthly growth rate of cases in Brazil

Key Metrics and KPIs

    Total cases

    Total deaths

    Mortality rate

    7-day moving average

    Monthly growth rate

    Cases by WHO region

Power BI Dashboard

The dashboard is organized into three pages:

    Global Overview: KPI cards, world map, and filters

    Country Comparison: ranking of countries, regional bar chart, and summary table

    Brazil Time Analysis: moving average, monthly growth, and mortality rate compared to the global average

Technologies

    SQL (PostgreSQL)

    Power BI

    DAX

    Python (pandas, sqlalchemy)

    Git

Author

Adriano Neves
GitHub: https://github.com/ahdn913
LinkedIn: https://linkedin.com/in/adriano-henrique-neves

License

This project is licensed under the MIT License.
