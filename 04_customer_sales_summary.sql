INSERT INTO customer_sales_summary (
    customer_id, total_orders, total_spent
)
SELECT
    c.customer_id,
    COUNT(f.order_id) AS total_orders,
    SUM(f.total_amount) AS total_spent
FROM dim_customers c
JOIN fact_sales f
    ON c.customer_id = f.customer_id
GROUP BY c.customer_id;

INSERT INTO customer_sales_summary (
    customer_id, total_orders, total_spent
)
SELECT
    f.customer_id,
    COUNT(f.order_id),
    SUM(f.total_amount)
FROM fact_sales f
GROUP BY f.customer_id
HAVING SUM(f.total_amount) > 10000;

MERGE INTO customer_sales_summary t
USING (
    SELECT
        customer_id,
        COUNT(order_id) AS total_orders,
        SUM(total_amount) AS total_spent
    FROM fact_sales
    GROUP BY customer_id
) s
ON t.customer_id = s.customer_id
WHEN MATCHED THEN
UPDATE SET
    t.total_orders = s.total_orders,
    t.total_spent = s.total_spent;
