-- 1. Create clean tables with the same structure as raw tables

CREATE TABLE clean.customers
(LIKE raw.customers);

CREATE TABLE clean.products
(LIKE raw.products);

CREATE TABLE clean.orders
(LIKE raw.orders);

CREATE TABLE clean.order_items
(LIKE raw.order_items);

CREATE TABLE clean.payments
(LIKE raw.payments);


-- 2. Copy raw records into clean tables

INSERT INTO clean.customers
SELECT * FROM raw.customers;

INSERT INTO clean.products
SELECT * FROM raw.products;

INSERT INTO clean.orders
SELECT * FROM raw.orders;

INSERT INTO clean.order_items
SELECT * FROM raw.order_items;

INSERT INTO clean.payments
SELECT * FROM raw.payments;


-- 3. Remove duplicate customer IDs

DELETE FROM clean.customers a
USING clean.customers b
WHERE a.customer_id = b.customer_id
  AND a.ctid > b.ctid;


-- 4. Validate duplicate removal

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT customer_id) AS unique_customers
FROM clean.customers;


-- 5. Replace missing customer names with 'Unknown'

UPDATE clean.customers
SET customer_name = 'Unknown'
WHERE customer_name IS NULL
   OR BTRIM(customer_name) = '';


-- 6. Validate missing customer names

SELECT COUNT(*) AS missing_customer_names
FROM clean.customers
WHERE customer_name IS NULL
   OR BTRIM(customer_name) = '';


-- 7. Replace missing customer emails with 'Unknown'

UPDATE clean.customers
SET email = 'Unknown'
WHERE email IS NULL
   OR BTRIM(email) = '';


-- 8. Validate missing customer emails

SELECT COUNT(*) AS missing_customer_emails
FROM clean.customers
WHERE email IS NULL
   OR BTRIM(email) = '';


-- 9. Remove leading and trailing spaces from customer details

UPDATE clean.customers
SET
    customer_name = BTRIM(customer_name),
    email = BTRIM(email),
    city = BTRIM(city);


-- 10. Validate whitespace removal

SELECT *
FROM clean.customers
WHERE customer_name <> BTRIM(customer_name)
   OR email <> BTRIM(email)
   OR city <> BTRIM(city);



-- 11. Standardize product categories

UPDATE clean.products
SET category = INITCAP(LOWER(TRIM(category)));


-- 12. Validate product categories

SELECT
    category,
    COUNT(*) AS total_products
FROM clean.products
GROUP BY category
ORDER BY category;


-- 13. Convert negative product prices to positive values

UPDATE clean.products
SET price = ABS(price)
WHERE price < 0;


-- 14. Validate negative product prices

SELECT *
FROM clean.products
WHERE price < 0;



-- 15. Standardize order statuses

UPDATE clean.orders
SET status = INITCAP(LOWER(TRIM(status)));


-- 16. Validate order statuses

SELECT
    status,
    COUNT(*) AS total_orders
FROM clean.orders
GROUP BY status
ORDER BY status;


-- 17. Standardize inconsistent order date formats

UPDATE clean.orders
SET order_date = CASE
    WHEN order_id = 1005
        THEN TO_CHAR(TO_DATE(order_date, 'DD-MM-YYYY'), 'YYYY-MM-DD')
    WHEN order_id = 1025
        THEN TO_CHAR(TO_DATE(order_date, 'MM/DD/YYYY'), 'YYYY-MM-DD')
    WHEN order_id = 1045
        THEN TO_CHAR(TO_DATE(order_date, 'DD/MM/YYYY'), 'YYYY-MM-DD')
END
WHERE order_id IN (1005, 1025, 1045);




-- 18. Validate order date formats

SELECT
    COUNT(*) FILTER (
        WHERE order_date IS NOT NULL
          AND BTRIM(order_date) !~ '^\d{4}-\d{2}-\d{2}$'
    ) AS inconsistent_dates
FROM clean.orders;


-- 19. Convert negative quantities to positive values

UPDATE clean.order_items
SET quantity = ABS(quantity)
WHERE quantity < 0;


-- 20. Validate negative quantities

SELECT *
FROM clean.order_items
WHERE quantity <= 0;



-- 21. Correct invalid discount percentages

UPDATE clean.order_items
SET discount_pct = 0.20
WHERE order_item_id IN (5, 10, 18)
  AND discount_pct = 2.00;


-- 22. Validate discount percentages

SELECT *
FROM clean.order_items
WHERE discount_pct < 0
   OR discount_pct > 1;



-- 23. Recalculate mismatched order item totals
UPDATE clean.order_items
SET total_amount = ROUND(
    quantity * unit_price * (1 - discount_pct), 2
)
WHERE order_item_id IN (4, 6, 7);

-- 24. Validate order item total calculations
SELECT
    order_item_id,
    quantity,
    unit_price,
    discount_pct,
    total_amount,
    ROUND(quantity * unit_price * (1 - discount_pct), 2) AS expected_total_amount
FROM clean.order_items
WHERE ABS(
    total_amount - ROUND(quantity * unit_price * (1 - discount_pct), 2)
) > 0.01;



-- 25. Standardize payment methods
UPDATE clean.payments
SET payment_method = INITCAP(LOWER(TRIM(payment_method)))
WHERE payment_method IS NOT NULL;

-- 26. Validate payment methods
SELECT
    payment_method,
    COUNT(*) AS total_records
FROM clean.payments
GROUP BY payment_method
ORDER BY payment_method;

-- 27. Standardize payment statuses
UPDATE clean.payments
SET payment_status = INITCAP(LOWER(TRIM(payment_status)))
WHERE payment_status IS NOT NULL;

-- 28. Validate payment statuses
SELECT
    payment_status,
    COUNT(*) AS total_records
FROM clean.payments
GROUP BY payment_status
ORDER BY payment_status;

-- 29. Standardize inconsistent payment dates

UPDATE clean.payments
SET payment_date = CASE
    WHEN payment_id = 11006
        THEN TO_CHAR(TO_DATE(payment_date, 'DD-MM-YYYY'), 'YYYY-MM-DD')
    WHEN payment_id = 11026
        THEN TO_CHAR(TO_DATE(payment_date, 'MM/DD/YYYY'), 'YYYY-MM-DD')
    WHEN payment_id = 11046
        THEN TO_CHAR(TO_DATE(payment_date, 'DD/MM/YYYY'), 'YYYY-MM-DD')
END
WHERE payment_id IN (11006, 11026, 11046);

-- 30. Validate payment date formats
SELECT payment_id, payment_date
FROM clean.payments
WHERE payment_date !~ '^\d{4}-\d{2}-\d{2}$';

-- 31. Compare raw and clean table row counts
SELECT
    'customers' AS table_name,
    (SELECT COUNT(*) FROM raw.customers) AS raw_rows,
    (SELECT COUNT(*) FROM clean.customers) AS clean_rows
UNION ALL
SELECT
    'products',
    (SELECT COUNT(*) FROM raw.products),
    (SELECT COUNT(*) FROM clean.products)
UNION ALL
SELECT
    'orders',
    (SELECT COUNT(*) FROM raw.orders),
    (SELECT COUNT(*) FROM clean.orders)
UNION ALL
SELECT
    'order_items',
    (SELECT COUNT(*) FROM raw.order_items),
    (SELECT COUNT(*) FROM clean.order_items)
UNION ALL
SELECT
    'payments',
    (SELECT COUNT(*) FROM raw.payments),
    (SELECT COUNT(*) FROM clean.payments);


-- 33. Add primary key constraints
ALTER TABLE clean.customers
ADD CONSTRAINT pk_customers PRIMARY KEY (customer_id);

ALTER TABLE clean.products
ADD CONSTRAINT pk_products PRIMARY KEY (product_id);

ALTER TABLE clean.orders
ADD CONSTRAINT pk_orders PRIMARY KEY (order_id);

ALTER TABLE clean.order_items
ADD CONSTRAINT pk_order_items PRIMARY KEY (order_item_id);

ALTER TABLE clean.payments
ADD CONSTRAINT pk_payments PRIMARY KEY (payment_id);


-- 34. Add foreign key constraints

ALTER TABLE clean.orders
ADD CONSTRAINT fk_orders_customers
FOREIGN KEY (customer_id)
REFERENCES clean.customers (customer_id);

ALTER TABLE clean.order_items
ADD CONSTRAINT fk_order_items_orders
FOREIGN KEY (order_id)
REFERENCES clean.orders (order_id);

ALTER TABLE clean.order_items
ADD CONSTRAINT fk_order_items_products
FOREIGN KEY (product_id)
REFERENCES clean.products (product_id);

ALTER TABLE clean.payments
ADD CONSTRAINT fk_payments_orders
FOREIGN KEY (order_id)
REFERENCES clean.orders (order_id);

-- 35. Add CHECK constraints

ALTER TABLE clean.products
ADD CONSTRAINT chk_products_price
CHECK (price >= 0);

ALTER TABLE clean.orders
ADD CONSTRAINT chk_orders_discount
CHECK (discount_pct BETWEEN 0 AND 1);

ALTER TABLE clean.order_items
ADD CONSTRAINT chk_order_items_quantity
CHECK (quantity > 0);

ALTER TABLE clean.order_items
ADD CONSTRAINT chk_order_items_unit_price
CHECK (unit_price >= 0);

ALTER TABLE clean.order_items
ADD CONSTRAINT chk_order_items_discount
CHECK (discount_pct BETWEEN 0 AND 1);
















