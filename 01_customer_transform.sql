INSERT INTO dim_customers (customer_id, full_name, email, country)
SELECT
    customer_id,
    CONCAT(first_name, ' ', last_name),
    LOWER(email),
    country
FROM src_customers
WHERE is_active = 1;

INSERT INTO dim_customers (customer_id, full_name, email, country)
SELECT
    src_customers.customer_id,
    CONCAT(src_customers.first_name, ' ', src_customers.last_name),
    LOWER(src_customers.email),
    src_customers.country
FROM src_customers
LEFT JOIN dim_customers
    ON src_customers.customer_id = dim_customers.customer_id
WHERE dim_customers.customer_id IS NULL;

MERGE INTO dim_customers
USING src_customers
ON dim_customers.customer_id = src_customers.customer_id
WHEN MATCHED
AND (
    dim_customers.email <> LOWER(src_customers.email)
    OR dim_customers.country <> src_customers.country
)
THEN UPDATE SET
    email = LOWER(src_customers.email),
    country = src_customers.country;

