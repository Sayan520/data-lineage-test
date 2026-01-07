INSERT INTO fact_sales (
    order_id,
    customer_id,
    product_id,
    order_date,
    total_amount
)
SELECT
    order_id,
    customer_id,
    product_id,
    order_date,
    total_amount
FROM stg_orders;

INSERT INTO fact_sales (
    order_id,
    customer_id,
    product_id,
    order_date,
    total_amount
)
SELECT
    stg_orders.order_id,
    stg_orders.customer_id,
    stg_orders.product_id,
    stg_orders.order_date,
    stg_orders.total_amount
FROM stg_orders
JOIN dim_products
    ON stg_orders.product_id = dim_products.product_id;

MERGE INTO fact_sales
USING stg_orders
ON fact_sales.order_id = stg_orders.order_id
WHEN MATCHED THEN
UPDATE SET
    total_amount = stg_orders.total_amount;

