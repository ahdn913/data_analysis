# scripts/load_data.py
# Este script carrega o CSV da OMS para o PostgreSQL

import pandas as pd
from sqlalchemy import create_engine

# Conexão com o banco
engine = create_engine('postgresql://postgres:3141@localhost:5432/covid19')

# Ler o CSV
df = pd.read_csv('data/raw/WHO-COVID-19-global-data.csv')

# Renomear colunas para minúsculo (facilita no SQL)
df.columns = [c.lower() for c in df.columns]

# remover linhas sem country_code
df = df.dropna(subset=["country_code"])

# converter data para o tipo correto
df["date_reported"] = pd.to_datetime(df["date_reported"]).dt.date

# Carregar no banco
from sqlalchemy import Date
df.to_sql(
    "raw_covid",
    engine,
    if_exists="replace",
    index=False,
    dtype={"date_reported": Date}
)

print(f'Carregadas {len(df)} linhas.')