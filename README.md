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
4. Clean and standardize the data using SQL.
5. Apply primary key, foreign key, and CHECK constraints.
6. Perform final data validation.
7. Export cleaned data and document the results.

## Repository Structure

* `data/raw/` — Original CSV files.
* `data/clean/` — Cleaned CSV files exported from PostgreSQL.
* `sql/` — SQL scripts for profiling, cleaning, and validation.
* `docs/` — Project documentation and cleaning summaries.
* `screenshots/` — Screenshots of queries and results.

## SQL Scripts

The project uses separate SQL scripts to organize the data profiling, quality assessment, cleaning, and validation process.

| File | Description |
|---|---|
| `01_data_profiling.sql` | Checks row counts, column names, and data types of raw tables. |
| `02_data_quality_checks.sql` | Identifies missing values, duplicates, inconsistent formats, invalid values, and relationship issues. |
| `03_data_cleaning.sql` | Creates clean tables, performs data cleaning and standardization, and applies database constraints. |
| `04_data_validation.sql` | Validates cleaned data quality, compares row counts, and checks the applied constraints. |

## Data Cleaning Results

The following table summarizes the number of records in each raw and clean table after the cleaning process.

| Table | Raw Records | Clean Records | Records Removed |
|---|---:|---:|---:|
| Customers | 306 | 301 | 5 |
| Products | 80 | 80 | 0 |
| Orders | 1,500 | 1,500 | 0 |
| Order Items | 2,995 | 2,995 | 0 |
| Payments | 1,500 | 1,500 | 0 |

Five duplicate customer records were removed. The other tables retained their original row counts, with data corrections and standardization performed where required.

The original data in the `raw` schema was preserved, while the cleaned data was maintained in the `clean` schema.

## Database Design

The project uses two PostgreSQL schemas:

* `raw` — Stores the original imported data.
* `clean` — Stores the cleaned data and validated tables.

The original data is preserved in the `raw` schema while cleaning operations are performed in the `clean` schema.

## Data Quality Issues and Cleaning Summary

The raw dataset was analyzed to identify data quality issues across the five tables. The following cleaning operations were performed using PostgreSQL.

| Table | Data Quality Issue | Cleaning Action |
|---|---|---|
| Customers | Duplicate customer records | Removed duplicate customer IDs |
| Customers | Missing customer names | Replaced with `Unknown` |
| Customers | Missing emails | Replaced with `Unknown` |
| Customers | Leading and trailing whitespace | Removed using `TRIM()` |
| Products | Inconsistent category casing | Standardized using `INITCAP()` and `LOWER()` |
| Products | Negative prices | Converted to positive values using `ABS()` |
| Orders | Inconsistent status formatting | Standardized status casing and whitespace |
| Orders | Inconsistent date formats | Converted to `YYYY-MM-DD` |
| Order Items | Negative quantities | Converted to positive values using `ABS()` |
| Order Items | Invalid discount percentages | Corrected identified values |
| Order Items | Incorrect total amounts | Recalculated using quantity, unit price, and discount |
| Payments | Inconsistent payment methods | Standardized casing and whitespace |
| Payments | Inconsistent payment statuses | Standardized casing and whitespace |
| Payments | Inconsistent date formats | Converted to `YYYY-MM-DD` |

## Issues Intentionally Left Unchanged

Some data quality issues were identified but intentionally retained to avoid making unsupported assumptions or changing potentially valid source information.

| Table | Issue | Decision |
|---|---|---|
| Customers | Three invalid email formats | Retained without correction because the actual email addresses could not be verified |
| Payments | Two missing payment methods | Retained as `NULL` because the correct payment methods were unknown |

These exceptions are documented rather than being automatically corrected without supporting information.

## Database Constraints

After cleaning the data, primary key, foreign key, and CHECK constraints were added to the tables in the `clean` schema to enforce data integrity.

### Primary Key Constraints

| Table | Primary Key |
|---|---|
| Customers | `customer_id` |
| Products | `product_id` |
| Orders | `order_id` |
| Order Items | `order_item_id` |
| Payments | `payment_id` |

### Foreign Key Constraints

| Table | Foreign Key | References |
|---|---|---|
| Orders | `customer_id` | `customers(customer_id)` |
| Order Items | `order_id` | `orders(order_id)` |
| Order Items | `product_id` | `products(product_id)` |
| Payments | `order_id` | `orders(order_id)` |

### CHECK Constraints

| Table | Constraint | Business Rule |
|---|---|---|
| Products | `chk_products_price` | Price must be greater than or equal to 0 |
| Orders | `chk_orders_discount` | Discount must be between 0 and 1 |
| Order Items | `chk_order_items_quantity` | Quantity must be greater than 0 |
| Order Items | `chk_order_items_unit_price` | Unit price must be greater than or equal to 0 |
| Order Items | `chk_order_items_discount` | Discount must be between 0 and 1 |

These constraints help prevent invalid records from being inserted or updated in the cleaned tables.

## Final Data Validation

After cleaning the data and applying database constraints, final validation queries were prepared in PostgreSQL to assess data quality and consistency in the `clean` schema.

The following checks were included:

| Table | Validation Check |
|---|---|
| All tables | Compare raw and clean row counts |
| Customers | Check missing names, missing emails, and whitespace issues |
| Products | Check inconsistent categories and negative prices |
| Orders | Check inconsistent statuses and date formats |
| Order Items | Check negative quantities, invalid discounts, and total amount mismatches |
| Payments | Check inconsistent payment methods, statuses, and date formats |
| All tables | Inspect existing primary key, foreign key, and CHECK constraints |

### Validation Approach

- Compare raw and clean row counts to identify changes made during cleaning.
- Verify that the targeted data quality issues have been addressed.
- Confirm that the required database constraints exist.
- Verify the existence and types of primary key, foreign key, and CHECK constraints using `information_schema.table_constraints`.

The two missing payment methods and three invalid customer email formats were intentionally retained, as their correct values could not be reliably determined from the available data.

## Expected Outcome

A documented and reproducible SQL-based data cleaning workflow that demonstrates data profiling, data quality assessment, cleaning, and validation skills.

## Author

Pravash Paul
