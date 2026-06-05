WITH fashion_category AS (SELECT DISTINCT products.product_category_name, product_category_name_english FROM products
JOIN product_category_name
ON products.product_category_name=product_category_name.product_category_name
WHERE products.product_category_name LIKE'fashio%'),
fashion_product AS (SELECT product_id,product_category_name_english FROM products
JOIN fashion_category
ON fashion_category.product_category_name=products.product_category_name),
fashion_orders AS(SELECT customers.customer_id,customer_unique_id,customer_zip_code_prefix,customer_city,customer_state,
orders.order_id,order_status,order_purchase_timestamp,order_approved_at,order_delivered_carrier_date,
order_delivered_customer_date,order_estimated_delivery_date,order_item_id,product_id,seller_id,shipping_limit_date,
price,freight_value,review_id,review_score,review_comment_title,review_comment_message,review_creation_date,
review_answer_timestamp,price+freight_value AS grand_total
FROM customers
JOIN orders
ON customers.customer_id = orders.customer_id
JOIN order_items
ON orders.order_id=order_items.order_id
LEFT JOIN reviews
ON order_items.order_id=reviews.order_id
WHERE order_status='delivered'),
delivery AS (SELECT customer_unique_id,order_id,order_purchase_timestamp,order_delivered_customer_date,order_estimated_delivery_date,
EXTRACT (DAY FROM (order_delivered_customer_date-order_estimated_delivery_date)) AS delivery_delay,review_score,price,freight_value,freight_value/grand_total AS freight_ratio 
FROM fashion_orders),
reason AS (SELECT *,
CASE WHEN (delivery_delay>0) THEN 1
WHEN (delivery_delay<=0) THEN 0
ELSE null
END AS is_delayed,
CASE WHEN (review_score>=4) THEN 1
WHEN (review_score<4) THEN 0
ELSE null
END AS is_high_score,
LEAD(order_purchase_timestamp,1)OVER(PARTITION BY customer_unique_id 
ORDER BY order_purchase_timestamp) AS next_purchase,
EXTRACT(DAY FROM (MAX(order_purchase_timestamp)OVER()-order_purchase_timestamp)) AS passing_days,
ROW_NUMBER()OVER(PARTITION BY customer_unique_id
ORDER BY order_purchase_timestamp ASC)
FROM delivery)
SELECT customer_unique_id,order_id,delivery_delay,review_score,freight_ratio,price,freight_value,is_delayed,is_high_score,
CASE WHEN (next_purchase is not null) THEN 1
ELSE 0 END AS is_repurchased FROM reason
WHERE passing_days>30 AND row_number=1
