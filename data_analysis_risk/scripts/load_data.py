# Libraries for data manipulation and DB connection
import pandas as pd
from sqlalchemy import create_engine, text
import os

# Connection string from environment variable, with local fallback
DATABASE_URL = os.environ.get(
    "DATABASE_URL",
    "postgresql://postgres:3141@localhost:5432/credit_risk"
)
engine = create_engine(DATABASE_URL)

# Read the raw CSV
df = pd.read_csv('data/raw/cs-training.csv')

# Standardize column names
df.columns = [c.lower().replace(' ', '_') for c in df.columns]

# Drop the unnamed index column if present
if 'unnamed:_0' in df.columns:
    df = df.drop(columns=['unnamed:_0'])

# Drop the table and its dependent views before reloading
with engine.begin() as conn:
    conn.execute(text("DROP TABLE IF EXISTS raw_credit CASCADE"))

# Write to PostgreSQL
df.to_sql('raw_credit', engine, if_exists='append', index=False)

print(f'Rows loaded: {len(df)}')