INSERT INTO customer_sales_summary (
    customer_id,
    total_orders,
    total_spent
)
SELECT
    dim_customers.customer_id,
    COUNT(fact_sales.order_id),
    SUM(fact_sales.total_amount)
FROM dim_customers
JOIN fact_sales
    ON dim_customers.customer_id = fact_sales.customer_id
GROUP BY dim_customers.customer_id;

INSERT INTO customer_sales_summary (
    customer_id,
    total_orders,
    total_spent
)
SELECT
    customer_id,
    COUNT(order_id),
    SUM(total_amount)
FROM fact_sales
GROUP BY customer_id
HAVING SUM(total_amount) > 10000;

MERGE INTO customer_sales_summary
USING (
    SELECT
        customer_id,
        COUNT(order_id) AS total_orders,
        SUM(total_amount) AS total_spent
    FROM fact_sales
    GROUP BY customer_id
)
ON customer_sales_summary.customer_id = customer_id
WHEN MATCHED THEN
UPDATE SET
    total_orders = total_orders,
    total_spent = total_spent;

