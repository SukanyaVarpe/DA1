CREATE DATABASE Project2;
USE project2;


-- KPI-1
RENAME TABLE `o.orders` to Orders;
RENAME TABLE `o.order_payments` to order_payments;
SELECT * FROM orders;
select * from order_payments;

SELECT
(SELECT ROUND(SUM(p.payment_value),0)
FROM orders o INNER JOIN order_payments p USING(order_id) 
WHERE o.Day="Weekend") AS weekend_count, 
(SELECT ROUND(sum(p.payment_value),0)
FROM orders o INNER JOIN order_payments p USING(order_id) 
WHERE o.Day="Weekday" ) AS weekday_count;


SELECT
CASE         
WHEN DAYOFWEEK(orders.order_purchase_timestamp) IN (1,7) THEN 'Weekend'
ELSE 'Weekday'    
END AS Week_Type,	
round(sum(order_payments.payment_value)) AS Total_Payment
FROM     
orders    
INNER JOIN 
order_payments 
ON orders.order_id = order_payments.order_id
GROUP BY     
Week_Type;


-- KPI 2

SELECT * FROM Order_reviews;
SELECT * FROM Order_payments;
SELECT order_reviews.review_score,order_payments.payment_type,
count(orders.order_id) AS Total_Order
FROM 
Orders
LEFT JOIN
order_reviews
ON
orderS.order_id=order_reviews.order_id
JOIN
order_payments
ON
orderS.order_id=order_payments.order_id
where order_reviews.review_score=5 AND order_payments.payment_type="Credit_card";

-- KPI 3

ALTER TABLE orders RENAME COLUMN `shipping days` to shipping_days;

SELECT ROUND(AVG(orders.shipping_days),0)
AS
avg_shipping_days, productS.product_category_name
FROM orders
LEFT
JOIN
order_items
ON
orders.order_id=order_items.order_id
JOIN
products
ON
order_items.product_id=products.product_id
GROUP BY products.product_category_name
HAVING products.product_category_name='pet_shop';


-- KPI 4

SELECT ROUND(AVG(order_items.price),0) AS Average_price,
ROUND(AVG(order_payments.payment_value),0) as Average_payment, 
customers.customer_city
FROM
order_items
LEFT JOIN
order_payments
ON
order_items.order_id = order_payments.order_id
JOIN
orders
ON
order_items.order_id = orders.order_id
JOIN
customers
ON
orders.customer_id=customers.customer_id
Where 
customers.customer_city="Sao Paulo"; 



-- KPI 5


SELECT order_reviews.review_score,
ROUND(AVG(orders.shipping_days),0) as Average_days
FROM
orders
LEFT JOIN
order_reviews
ON
orders.order_id = order_reviews.order_id
GROUP BY
order_reviews.review_score
HAVING order_reviews.review_score is NOT NULL
ORDER BY order_reviews.review_score;
