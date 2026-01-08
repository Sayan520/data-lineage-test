

INSERT INTO stg_orders (
    order_id,
    customer_id,
    product_id,
    order_date,
    quantity,
    total_amount
)
SELECT
    src_orders.order_id,
    src_orders.customer_id,
    src_orders.product_id,
    src_orders.order_date,
    src_orders.quantity,
    src_orders.quantity * src_products.price
FROM src_orders
JOIN src_products
    ON src_orders.product_id = src_products.product_id;

MERGE INTO stg_orders
USING src_orders
ON stg_orders.order_id = src_orders.order_id
WHEN MATCHED THEN
UPDATE SET
    quantity = src_orders.quantity;

