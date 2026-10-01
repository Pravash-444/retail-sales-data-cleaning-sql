# Data Cleaning Methodology

## Overview
This document explains the methodology and key decisions followed in the Retail Sales Data Cleaning using PostgreSQL project.

## Data Cleaning Approach

The project follows a structured data cleaning process:

1. **Data Profiling:** Reviewed row counts, column names and data types of the raw tables.
2. **Data Quality Assessment:** Identified missing values, duplicates, inconsistent formats, invalid values and relationship issues.
3. **Data Cleaning:** Applied appropriate cleaning operations to separate tables in the `clean` schema while preserving the original data in the `raw` schema.
4. **Data Validation:** Verified the cleaned data using validation queries and checked database constraints.

## Cleaning Decisions

| Data Issue | Cleaning Approach |
|---|---|
| Duplicate customer records | Removed duplicate customer IDs |
| Missing customer names and emails | Replaced missing values with `Unknown` |
| Leading and trailing whitespace | Removed using `TRIM()` |
| Inconsistent category casing | Standardized category casing |
| Negative product prices | Converted to positive values |
| Inconsistent order statuses | Standardized casing and whitespace |
| Inconsistent date formats | Standardized date values |
| Negative order item quantities | Converted to positive values |
| Incorrect discount values | Corrected identified discount values |
| Incorrect item totals | Recalculated using quantity, unit price and discount |
| Inconsistent payment methods and statuses | Standardized casing and whitespace |

## Issues Intentionally Left Unchanged

- Three invalid customer email formats were retained because the correct email addresses could not be verified.
- Two missing payment method values were retained as `NULL` because the actual payment methods were unknown.

## Data Integrity

The cleaned tables were assigned primary keys, foreign keys and check constraints to enforce key relationships and business rules.

## Validation

Final validation was performed to check:

- Row counts between raw and clean tables
- Missing values and whitespace
- Duplicate records
- Invalid or inconsistent values
- Foreign key integrity
- Business rule violations
- Database constraints

The SQL scripts in the `sql/` folder contain the detailed queries used for profiling, quality checks, cleaning and validation.
