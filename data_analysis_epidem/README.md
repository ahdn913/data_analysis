
## Requisitos

- PostgreSQL 14+
- Python 3.10+
- Power BI Desktop
- Bibliotecas: pandas, sqlalchemy, psycopg2

## Como executar

1. Baixe o CSV da OMS em https://covid19.who.int/data
2. Crie o banco: `CREATE DATABASE covid19;`
3. Rode `python scripts/load_data.py`
4. Rode `psql -d covid19 -f sql/01_create_tables.sql`
5. Abra o Power BI e conecte ao banco

## Análises

- Top 10 países com mais casos
- Média móvel de 7 dias no Brasil
- Casos por região da OMS
- Ranking de mortes em 2021
- Taxa de crescimento mensal

## Tecnologias

- SQL (PostgreSQL)
- Power BI
- DAX
- Python (pandas)

## Contato

**Adriano Neves**
[GitHub](https://github.com/ahdn913) | [LinkedIn]