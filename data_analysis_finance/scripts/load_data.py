import pandas as pd
from sqlalchemy import create_engine

engine = create_engine('postgresql://postgres:3141@localhost:5432/superstore')

df = pd.read_csv('data/raw/sample_superstore.csv', encoding='latin-1')
df.columns = [c.lower().replace(' ', '_').replace('-', '_') for c in df.columns]

df.to_sql('raw_superstore', engine, if_exists='replace', index=False)
print(f'Carregadas {len(df)} linhas.')