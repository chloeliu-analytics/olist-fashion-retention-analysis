WITH cte AS(SELECT customers.customer_unique_id,order_purchase_timestamp FROM customers
JOIN orders
ON customers.customer_id = orders.customer_id),
cte1 AS(SELECT customer_unique_id, order_purchase_timestamp,
LEAD(order_purchase_timestamp,1)OVER(PARTITION BY customer_unique_id 
ORDER BY order_purchase_timestamp) AS next_purchase,ROW_NUMBER()OVER(PARTITION BY customer_unique_id
ORDER BY order_purchase_timestamp ASC) FROM cte),
cte2 AS(SELECT customer_unique_id, EXTRACT(DAY FROM (next_purchase - order_purchase_timestamp)) AS difference
FROM cte1
WHERE next_purchase IS NOT NULL AND EXTRACT(DAY FROM (next_purchase - order_purchase_timestamp))<= 90
AND row_number = 1)
SELECT 1.0*COUNT (DISTINCT customer_unique_id )/(SELECT COUNT(DISTINCT customer_unique_id)FROM cte1 
WHERE row_number = 1 AND 
order_purchase_timestamp <= (SELECT MAX(order_purchase_timestamp) FROM orders) - INTERVAL '90 days')
AS three_month_repurchase_rate
FROM cte2