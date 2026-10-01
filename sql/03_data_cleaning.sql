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
