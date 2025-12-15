-- Insert product dimension
INSERT INTO dim_products (product_id, product_name, category)
SELECT DISTINCT
    p.product_id,
    p.product_name,
    p.category
FROM src_products p;

-- Insert order staging with joins
INSERT INTO stg_orders (
    order_id, customer_id, product_id, order_date, quantity, total_amount
)
SELECT
    o.order_id,
    o.customer_id,
    o.product_id,
    o.order_date,
    o.quantity,
    o.quantity * p.price AS total_amount
FROM src_orders o
JOIN src_products p
    ON o.product_id = p.product_id;

-- Merge to update changed quantities or amounts
MERGE INTO stg_orders t
USING src_orders s
ON t.order_id = s.order_id
WHEN MATCHED THEN
UPDATE SET
    t.quantity = s.quantity;