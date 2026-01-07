INSERT INTO fact_sales (
    order_id, customer_id, product_id, order_date, total_amount
)
SELECT
    o.order_id,
    o.customer_id,
    o.product_id,
    o.order_date,
    o.total_amount
FROM stg_orders o;

INSERT INTO fact_sales (
    order_id, customer_id, product_id, order_date, total_amount
)
SELECT
    s.order_id,
    s.customer_id,
    s.product_id,
    s.order_date,
    s.total_amount
FROM stg_orders s
JOIN dim_products p
    ON s.product_id = p.product_id;

MERGE INTO fact_sales f
USING stg_orders s
ON f.order_id = s.order_id
WHEN MATCHED THEN
UPDATE SET
    f.total_amount = s.total_amount;
