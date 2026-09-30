# Retail Sales Data Cleaning using PostgreSQL

## Project Overview

This project focuses on data profiling, data cleaning, and data validation using PostgreSQL and SQL.

The project simulates a real-world data analytics scenario in which raw data is received in CSV format, imported into PostgreSQL, and cleaned to improve data quality and consistency.

## Objectives

* Import raw CSV files into PostgreSQL.
* Identify data quality issues using SQL.
* Clean and standardize inconsistent data.
* Validate cleaned data using SQL queries.
* Apply database constraints to maintain data integrity.
* Document the data cleaning process and findings.

## Tools & Technologies

* PostgreSQL
* SQL
* GitHub
* CSV

## Dataset

The project includes the following tables:

* Customers
* Products
* Orders
* Order Items
* Payments

## Project Workflow

1. Import original CSV files into PostgreSQL.
2. Perform initial data profiling.
3. Identify data quality issues.
4. Clean the data using SQL.
5. Validate the cleaned data.
6. Apply database constraints.
7. Export cleaned data and document the results.

## Repository Structure

* `data/raw/` — Original CSV files.
* `data/clean/` — Cleaned CSV files exported from PostgreSQL.
* `sql/` — SQL scripts for profiling, cleaning, and validation.
* `docs/` — Project documentation and cleaning summaries.
* `screenshots/` — Screenshots of queries and results.

## Database Design

The project uses two PostgreSQL schemas:

* `raw` — Stores the original imported data.
* `clean` — Stores the cleaned data and validated tables.

The original data is preserved in the `raw` schema while cleaning operations are performed in the `clean` schema.

## Expected Outcome

A documented and reproducible SQL-based data cleaning workflow that demonstrates data profiling, data quality assessment, cleaning, and validation skills.

## Author

Pravash Paul
