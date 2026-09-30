
-- Retail Sales Data Cleaning using PostgreSQL
-- Stage 2: Identify Data Quality Issues
-- 1. Identify Missing Values

SELECT 'customers' AS table_name, column_name,
       COUNT(*) FILTER (
           WHERE value IS NULL OR BTRIM(value) = ''
       ) AS missing_count
FROM raw.customers
CROSS JOIN LATERAL (
    VALUES
        ('customer_id', customer_id::TEXT),
        ('customer_name', customer_name),
        ('email', email),
        ('city', city),
        ('signup_date', signup_date::TEXT)
) AS c(column_name, value)
GROUP BY column_name

UNION ALL

SELECT 'products', column_name,
       COUNT(*) FILTER (
           WHERE value IS NULL OR BTRIM(value) = ''
       )
FROM raw.products
CROSS JOIN LATERAL (
    VALUES
        ('product_id', product_id::TEXT),
        ('product_name', product_name),
        ('category', category),
        ('price', price::TEXT)
) AS c(column_name, value)
GROUP BY column_name

UNION ALL

SELECT 'orders', column_name,
       COUNT(*) FILTER (
           WHERE value IS NULL OR BTRIM(value) = ''
       )
FROM raw.orders
CROSS JOIN LATERAL (
    VALUES
        ('order_id', order_id::TEXT),
        ('customer_id', customer_id::TEXT),
        ('order_date', order_date::TEXT),
        ('status', status),
        ('discount_pct', discount_pct::TEXT),
        ('order_amount', order_amount::TEXT)
) AS c(column_name, value)
GROUP BY column_name

UNION ALL

SELECT 'order_items', column_name,
       COUNT(*) FILTER (
           WHERE value IS NULL OR BTRIM(value) = ''
       )
FROM raw.order_items
CROSS JOIN LATERAL (
    VALUES
        ('order_item_id', order_item_id::TEXT),
        ('order_id', order_id::TEXT),
        ('product_id', product_id::TEXT),
        ('quantity', quantity::TEXT),
        ('unit_price', unit_price::TEXT),
        ('discount_pct', discount_pct::TEXT),
        ('total_amount', total_amount::TEXT)
) AS c(column_name, value)
GROUP BY column_name

UNION ALL

SELECT 'payments', column_name,
       COUNT(*) FILTER (
           WHERE value IS NULL OR BTRIM(value) = ''
       )
FROM raw.payments
CROSS JOIN LATERAL (
    VALUES
        ('payment_id', payment_id::TEXT),
        ('order_id', order_id::TEXT),
        ('payment_date', payment_date::TEXT),
        ('payment_method', payment_method),
        ('payment_amount', payment_amount::TEXT),
        ('payment_status', payment_status)
) AS c(column_name, value)
GROUP BY column_name

ORDER BY table_name, column_name;
