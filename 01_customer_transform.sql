-- Insert transformed customer data into customer dimension
INSERT INTO dim_customers (customer_id, full_name, email, country)
SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS full_name,
    LOWER(c.email) AS email,
    c.country
FROM src_customers c
WHERE c.is_active = 1;

-- Insert new customers only (avoid duplicates)
INSERT INTO dim_customers (customer_id, full_name, email, country)
SELECT 
    s.customer_id,
    CONCAT(s.first_name, ' ', s.last_name),
    LOWER(s.email),
    s.country
FROM src_customers s
LEFT JOIN dim_customers d
    ON s.customer_id = d.customer_id
WHERE d.customer_id IS NULL;

-- Merge update for changed email or country
MERGE INTO dim_customers d
USING src_customers s
ON d.customer_id = s.customer_id
WHEN MATCHED AND 
     (d.email <> LOWER(s.email) OR d.country <> s.country)
THEN UPDATE SET
    d.email = LOWER(s.email),
    d.country = s.country;