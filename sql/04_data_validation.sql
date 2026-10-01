-- Retail Sales Data Cleaning using PostgreSQL
-- Stage 4: Final Data Validation
-- Purpose: Verify the cleaned data

-- 1. Final row count validation
SELECT 'customers' AS table_name,
       (SELECT COUNT(*) FROM raw.customers) AS raw_rows,
       (SELECT COUNT(*) FROM clean.customers) AS clean_rows
UNION ALL
SELECT 'products',
       (SELECT COUNT(*) FROM raw.products),
       (SELECT COUNT(*) FROM clean.products)
UNION ALL
SELECT 'orders',
       (SELECT COUNT(*) FROM raw.orders),
       (SELECT COUNT(*) FROM clean.orders)
UNION ALL
SELECT 'order_items',
       (SELECT COUNT(*) FROM raw.order_items),
       (SELECT COUNT(*) FROM clean.order_items)
UNION ALL
SELECT 'payments',
       (SELECT COUNT(*) FROM raw.payments),
       (SELECT COUNT(*) FROM clean.payments)
ORDER BY table_name;

-- 2. Final validation of clean.customers
SELECT
    COUNT(*) FILTER (
        WHERE customer_name IS NULL
           OR TRIM(customer_name) = ''
    ) AS missing_names,
    COUNT(*) FILTER (
        WHERE email IS NULL
           OR TRIM(email) = ''
    ) AS missing_emails,
    COUNT(*) FILTER (
        WHERE customer_name <> TRIM(customer_name)
           OR email <> TRIM(email)
           OR city <> TRIM(city)
    ) AS whitespace_issues
FROM clean.customers;

-- 3. Final validation of clean.products
SELECT
    COUNT(*) FILTER (
        WHERE category IN ('ELECTRONICS', 'SPORTS')
    ) AS inconsistent_categories,
    COUNT(*) FILTER (
        WHERE price < 0
    ) AS negative_prices
FROM clean.products;

-- 4. Final validation of clean.orders
SELECT
    COUNT(*) FILTER (
        WHERE status <> INITCAP(LOWER(TRIM(status)))
    ) AS inconsistent_statuses,
    COUNT(*) FILTER (
        WHERE order_date IS NOT NULL
          AND BTRIM(order_date) !~ '^\d{4}-\d{2}-\d{2}$'
    ) AS inconsistent_dates
FROM clean.orders;

-- 5. Final validation of clean.order_items
SELECT
    COUNT(*) FILTER (
        WHERE quantity < 0
    ) AS negative_quantities,
    COUNT(*) FILTER (
        WHERE discount_pct < 0
           OR discount_pct > 1
    ) AS invalid_discounts,
    COUNT(*) FILTER (
        WHERE ABS(
            total_amount -
            ROUND(quantity * unit_price * (1 - discount_pct), 2)
        ) > 0.01
    ) AS total_amount_mismatches
FROM clean.order_items;

-- 6. Final validation of clean.payments
SELECT
    COUNT(*) FILTER (
        WHERE payment_method IN (' NET BANKING ', 'debit card', 'upi')
    ) AS inconsistent_methods,
    COUNT(*) FILTER (
        WHERE payment_status IN (' PAID ', 'paid', 'refunded')
    ) AS inconsistent_statuses,
    COUNT(*) FILTER (
        WHERE payment_date IS NOT NULL
          AND BTRIM(payment_date) !~ '^\d{4}-\d{2}-\d{2}$'
    ) AS inconsistent_dates
FROM clean.payments;

