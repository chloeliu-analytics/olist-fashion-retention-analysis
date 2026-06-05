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
RFM as(SELECT customer_unique_id, MAX(order_purchase_timestamp)OVER(PARTITION BY customer_unique_id)AS recent_purchase_timestamp,
COUNT(order_id)OVER(PARTITION BY customer_unique_id)AS frequency,
SUM(price)OVER(PARTITION BY customer_unique_id)AS item_total_spending,
SUM(grand_total)OVER(PARTITION BY customer_unique_id)AS grand_total_spending,
MAX(order_purchase_timestamp)OVER() AS today
FROM fashion_orders)
SELECT DISTINCT customer_unique_id,EXTRACT(DAY FROM(today-recent_purchase_timestamp)) AS recency,frequency,
item_total_spending AS monetary
FROM RFM
