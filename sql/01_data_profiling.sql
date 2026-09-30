
-- Retail Sales Data Cleaning using PostgreSQL
-- Stage 1: Initial Data Profiling
-- Purpose: Understand the structure and size of raw tables

-- 1. Check row counts of all raw tables

SELECT 'customers' AS table_name, COUNT(*) AS total_rows
FROM raw.customers

UNION ALL

SELECT 'products', COUNT(*)
FROM raw.products

UNION ALL

SELECT 'orders', COUNT(*)
FROM raw.orders

UNION ALL

SELECT 'order_items', COUNT(*)
FROM raw.order_items

UNION ALL

SELECT 'payments', COUNT(*)
FROM raw.payments;


-- 2. Verify column names and data types

SELECT
    table_name,
    column_name,
    data_type,
    ordinal_position
FROM information_schema.columns
WHERE table_schema = 'raw'
ORDER BY table_name, ordinal_position;
