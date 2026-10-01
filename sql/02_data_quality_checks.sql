
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




-- 2. Identify Duplicate Records

-- Customers: Check exact duplicate records

SELECT
    customer_id,
    customer_name,
    email,
    city,
    signup_date,
    COUNT(*) AS occurrences
FROM raw.customers
GROUP BY
    customer_id,
    customer_name,
    email,
    city,
    signup_date
HAVING COUNT(*) > 1
ORDER BY customer_id;



-- Duplicate check: Products

SELECT
    product_id,
    product_name,
    category,
    price,
    COUNT(*) AS occurrences
FROM raw.products
GROUP BY
    product_id,
    product_name,
    category,
    price
HAVING COUNT(*) > 1;



-- Duplicate check: Orders

SELECT
    order_id,
    customer_id,
    order_date,
    status,
    discount_pct,
    order_amount,
    COUNT(*) AS occurrences
FROM raw.orders
GROUP BY
    order_id,
    customer_id,
    order_date,
    status,
    discount_pct,
    order_amount
HAVING COUNT(*) > 1;



-- Duplicate check: Order Items

SELECT
    order_item_id,
    order_id,
    product_id,
    quantity,
    unit_price,
    discount_pct,
    total_amount,
    COUNT(*) AS occurrences
FROM raw.order_items
GROUP BY
    order_item_id,
    order_id,
    product_id,
    quantity,
    unit_price,
    discount_pct,
    total_amount
HAVING COUNT(*) > 1;



-- Duplicate check: Payments

SELECT
    payment_id,
    order_id,
    payment_date,
    payment_method,
    payment_amount,
    payment_status,
    COUNT(*) AS occurrences
FROM raw.payments
GROUP BY
    payment_id,
    order_id,
    payment_date,
    payment_method,
    payment_amount,
    payment_status
HAVING COUNT(*) > 1;




-- 3. Identify Invalid Email Addresses

SELECT
    customer_id,
    customer_name,
    email
FROM raw.customers
WHERE email IS NOT NULL
  AND BTRIM(email) <> ''
  AND email !~ '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'
ORDER BY customer_id;



-- 4. Identify Whitespace Issues in All Tables

SELECT
    'customers' AS table_name,
    customer_id::TEXT AS record_id,
    column_name,
    '[' || value || ']' AS original_value
FROM raw.customers
CROSS JOIN LATERAL (
    VALUES
        ('customer_name', customer_name),
        ('email', email),
        ('city', city)
) AS t(column_name, value)
WHERE value IS NOT NULL
  AND value <> TRIM(value)

UNION ALL

SELECT
    'products',
    product_id::TEXT,
    column_name,
    '[' || value || ']'
FROM raw.products
CROSS JOIN LATERAL (
    VALUES
        ('product_name', product_name),
        ('category', category)
) AS t(column_name, value)
WHERE value IS NOT NULL
  AND value <> TRIM(value)

UNION ALL

SELECT
    'orders',
    order_id::TEXT,
    'status',
    '[' || status || ']'
FROM raw.orders
WHERE status IS NOT NULL
  AND status <> TRIM(status)

UNION ALL

SELECT
    'payments',
    payment_id::TEXT,
    column_name,
    '[' || value || ']'
FROM raw.payments
CROSS JOIN LATERAL (
    VALUES
        ('payment_method', payment_method),
        ('payment_status', payment_status)
) AS t(column_name, value)
WHERE value IS NOT NULL
  AND value <> TRIM(value)

ORDER BY table_name, record_id, column_name;



-- 5. Identify Inconsistent Customer Cities

SELECT
    city,
    COUNT(*) AS record_count
FROM raw.customers
GROUP BY city
ORDER BY city;



-- 6. Identify Inconsistent Product Categories

SELECT
    category,
    COUNT(*) AS record_count
FROM raw.products
GROUP BY category
ORDER BY category;



-- 7. Identify Inconsistent Order Statuses

SELECT
    status,
    COUNT(*) AS record_count
FROM raw.orders
GROUP BY status
ORDER BY status;



-- 8. Check Customer Signup Date Format

SELECT
    customer_id,
    customer_name,
    TO_CHAR(signup_date, 'YYYY-MM-DD') AS signup_date
FROM raw.customers
WHERE TO_CHAR(signup_date, 'YYYY-MM-DD') !~ '^\d{4}-\d{2}-\d{2}$';



-- 9. Identify Invalid Product Prices

SELECT
    product_id,
    product_name,
    category,
    price
FROM raw.products
WHERE price < 0
ORDER BY product_id;



-- 10. Identify Invalid Order Discount Percentages

SELECT
    order_id,
    discount_pct
FROM raw.orders
WHERE discount_pct < 0
   OR discount_pct > 1
ORDER BY order_id;


-- 11. Identify Invalid Order Item Quantities

SELECT
    order_item_id,
    order_id,
    product_id,
    quantity
FROM raw.order_items
WHERE quantity <= 0
ORDER BY order_item_id;

-- Investigate whether stored totals support
-- converting negative quantities to positive

SELECT
    order_item_id,
    quantity,
    unit_price,
    discount_pct,
    total_amount AS stored_total_amount,
    ROUND(
        ABS(quantity) * unit_price * (1 - discount_pct), 2
    ) AS calculated_total_amount
FROM clean.order_items
WHERE order_item_id IN (1, 2, 3)
ORDER BY order_item_id;


-- 12. Identify Invalid Order Item Unit Prices

SELECT
    order_item_id,
    order_id,
    product_id,
    unit_price
FROM raw.order_items
WHERE unit_price <= 0
ORDER BY order_item_id;



-- 13. Identify Invalid Order Item Discount Percentages

SELECT
    order_item_id,
    order_id,
    discount_pct
FROM raw.order_items
WHERE discount_pct < 0
   OR discount_pct > 1
ORDER BY order_item_id;

-- Compare stored totals with calculations
-- using the existing and suspected corrected discounts

SELECT
    order_item_id,
    quantity,
    unit_price,
    discount_pct,
    total_amount AS stored_total_amount,
    ROUND(
        quantity * unit_price * (1 - discount_pct), 2
    ) AS calculated_at_existing_discount,
    ROUND(
        quantity * unit_price * (1 - 0.20), 2
    ) AS calculated_at_0_20
FROM clean.order_items
WHERE order_item_id IN (5, 10, 18)
ORDER BY order_item_id;



-- 14. Identify Invalid Order Amounts

SELECT
    order_id,
    order_amount
FROM raw.orders
WHERE order_amount < 0
ORDER BY order_id;

-- 15. Identify Order Item Calculation Mismatches

SELECT
    order_item_id,
    order_id,
    quantity,
    unit_price,
    discount_pct,
    total_amount,
    ROUND(quantity * unit_price * (1 - discount_pct), 2)
        AS expected_total_amount
FROM raw.order_items
WHERE ABS(
    total_amount -
    ROUND(quantity * unit_price * (1 - discount_pct), 2)
) > 0.01
ORDER BY order_item_id;

-- Identify and compare mismatched stored totals

SELECT
    order_item_id,
    quantity,
    unit_price,
    discount_pct,
    total_amount AS stored_total_amount,
    ROUND(
        quantity * unit_price * (1 - discount_pct), 2
    ) AS calculated_total_amount
FROM clean.order_items
WHERE order_item_id IN (4, 6, 7)
ORDER BY order_item_id;



-- 16. Check Orders Linked to Non-existent Customers

SELECT
    o.order_id,
    o.customer_id
FROM raw.orders o
WHERE NOT EXISTS (
    SELECT 1
    FROM raw.customers c
    WHERE c.customer_id = o.customer_id
);



-- 17. Check Order Items Linked to Non-existent Orders

SELECT
    oi.order_item_id,
    oi.order_id
FROM raw.order_items oi
WHERE NOT EXISTS (
    SELECT 1
    FROM raw.orders o
    WHERE o.order_id = oi.order_id
);



-- 18. Check Order Items Linked to Non-existent Products

SELECT
    oi.order_item_id,
    oi.product_id
FROM raw.order_items oi
WHERE NOT EXISTS (
    SELECT 1
    FROM raw.products p
    WHERE p.product_id = oi.product_id
);



-- 19. Identify Inconsistent Order Date Formats

SELECT
    order_id,
    order_date
FROM raw.orders
WHERE order_date IS NOT NULL
  AND BTRIM(order_date) !~ '^\d{4}-\d{2}-\d{2}$'
ORDER BY order_id;


-- 20. Identify Inconsistent Payment Date Formats

SELECT
    payment_id,
    payment_date
FROM raw.payments
WHERE payment_date IS NOT NULL
  AND BTRIM(payment_date) !~ '^\d{4}-\d{2}-\d{2}$'
ORDER BY payment_id;



-- 21. Identify Inconsistent Payment Methods

SELECT
    payment_method,
    COUNT(*) AS record_count
FROM raw.payments
GROUP BY payment_method
ORDER BY payment_method;



-- 22. Identify Inconsistent Payment Statuses

SELECT
    payment_status,
    COUNT(*) AS record_count
FROM raw.payments
GROUP BY payment_status
ORDER BY payment_status;

