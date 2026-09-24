CREATE TABLE customers (
    customer_id VARCHAR(50),
    customer_unique_id VARCHAR(50),
    customer_zip_code_prefix INT,
    customer_city VARCHAR(100),
    customer_state VARCHAR(10)
);

CREATE TABLE orders (
    order_id VARCHAR(50),
    customer_id VARCHAR(50),
    order_status VARCHAR(30),
    order_purchase_timestamp TIMESTAMP,
    order_approved_at TIMESTAMP,
    order_delivered_carrier_date TIMESTAMP,
    order_delivered_customer_date TIMESTAMP,
    order_estimated_delivery_date TIMESTAMP
);

CREATE TABLE order_items (
    order_id VARCHAR(50),
    order_item_id INT,
    product_id VARCHAR(50),
    seller_id VARCHAR(50),
    shipping_limit_date TIMESTAMP,
    price NUMERIC(12,2),
    freight_value NUMERIC(12,2)
);

CREATE TABLE payments (
    order_id VARCHAR(50),
    payment_sequential INT,
    payment_type VARCHAR(30),
    payment_installments INT,
    payment_value NUMERIC(12,2)
);

CREATE TABLE reviews (
    review_id VARCHAR(50),
    order_id VARCHAR(50),
    review_score INT,
    review_comment_title TEXT,
    review_comment_message TEXT,
    review_creation_date TIMESTAMP,
    review_answer_timestamp TIMESTAMP
);

CREATE TABLE products (
    product_id VARCHAR(50),
    product_category_name VARCHAR(100),
    product_name_lenght INT,
    product_description_lenght INT,
    product_photos_qty INT,
    product_weight_g NUMERIC,
    product_length_cm NUMERIC,
    product_height_cm NUMERIC,
    product_width_cm NUMERIC
);

CREATE TABLE sellers (
    seller_id VARCHAR(50),
    seller_zip_code_prefix INT,
    seller_city VARCHAR(100),
    seller_state VARCHAR(10)
);

CREATE TABLE category_translation (
    product_category_name VARCHAR(100),
    product_category_name_english VARCHAR(100)
);

select * from customers
select * from products
select * from category_translation
select * from order_items
select * from orders
select * from sellers
select * from reviews
select * from payments

------------------------------------------------------------------------------------
---  WHICH PRODUCT CATEGORIES GENERATE THE MOST REVENUE  ----
------------------------------------------------------------------------------------
SELECT ct.product_category_name_english as category, sum(oi.price) as total_revenue
from order_items oi
join products p on oi.product_id=p.product_id
join category_translation ct on p.product_category_name=ct.product_category_name
group by ct.product_category_name_english
order by total_revenue desc
limit 5

------------------------------------------------------------------------------------
---  WHICH PRODUCT CATEGORIES HAVE THE MOST ORDERS  ----
------------------------------------------------------------------------------------
SELECT ct.product_category_name_english as category, COUNT(Distinct oi.order_id) as total_orders
from order_items oi
join products p on oi.product_id=p.product_id
join category_translation ct on p.product_category_name=ct.product_category_name
group by ct.product_category_name_english
order by total_orders desc
limit 5

------------------------------------------------------------------------------------
---  HOW DOES REVENUE CHANGE OVER TIME  ----
------------------------------------------------------------------------------------
SELECT DATE_TRUNC('month', o.order_purchase_timestamp) as month,
sum(oi.price) as revenue 
from orders o
join order_items oi on o.order_id = oi.order_id
group by month
order by month

------------------------------------------------------------------------------------
---  WHICH STATES GENERATE THE MOST REVENUE  ----
------------------------------------------------------------------------------------
select c.customer_state, sum(oi.price) as revenue
from customers c 
join orders o on c.customer_id=o.customer_id
join order_items oi on o.order_id=oi.order_id
group by c.customer_state
order by revenue desc
limit 5 

------------------------------------------------------------------------------------
---  STATES WITH HIGH DEMAND BUT WEAK SALES PENETRATION ---
------------------------------------------------------------------------------------
select c.customer_state, sum(oi.price) as revenue, COUNT(DISTINCT o.order_id) as total_orders,
round(sum(oi.price)/ COUNT(DISTINCT o.order_id),2) as revenue_per_order
from orders o 
join customers c on o.customer_id = c.customer_id
join order_items oi on o.order_id=oi.order_id
where o.order_status='delivered'
group by c.customer_state
order by revenue_per_order asc
limit 5

select c.customer_state, COUNT(DISTINCT o.order_id) as total_orders
from customers c 
join orders o on c.customer_id = o.customer_id
where o.order_status='delivered'
group by c.customer_state
order by total_orders desc
limit 5

------------------------------------------------------------------------------------
--- AVG DELIVERY TIME ---
------------------------------------------------------------------------------------
select avg(order_delivered_customer_date-order_purchase_timestamp) as avg_delivery_time
from orders
where order_status='delivered' and order_delivered_customer_date is not null

------------------------------------------------------------------------------------
--- WHICH STATES HAVE THE LONGEST DELIVERY TIMES ---
------------------------------------------------------------------------------------
select c.customer_state, avg(o.order_delivered_customer_date-o.order_purchase_timestamp) as avg_delivery_time
from customers c
join orders o on c.customer_id=o.customer_id
where order_status='delivered' and order_delivered_customer_date is not null
group by c.customer_state
order by avg_delivery_time desc
limit 5

------------------------------------------------------------------------------------
--- % OF ORDERS DELIVERED LATE ---
------------------------------------------------------------------------------------
select ROUND(100 * count(*)/ (SELECT COUNT(*) from orders
where order_status='delivered' and order_delivered_customer_date is not null),2) AS late_order_percentage
from orders
where order_status='delivered' and order_delivered_customer_date is not null
and order_delivered_customer_date > order_estimated_delivery_date

------------------------------------------------------------------------------------
---ARE LATE DELIVERIES INCREASING? ---
------------------------------------------------------------------------------------
WITH delivery_data as(
select date_trunc('month', order_purchase_timestamp) as month,
CASE 
WHEN order_delivered_customer_date > order_estimated_delivery_date
THEN 1
ELSE 0
END AS is_late
from orders
where order_status='delivered' and order_delivered_customer_date is not null
)
Select month, ROUND(100*avg(is_late),2) as late_delivery_percentage
from delivery_data
group by month
order by month

------------------------------------------------------------------------------------
--- DOES LATE DELIVERY AFFECT REVIEW SCORE ---
------------------------------------------------------------------------------------
SELECT ROUND(AVG(REVIEW_SCORE),2) FROM REVIEWS

WITH delivery_reviews AS (
SELECT
CASE
WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date
THEN 'Late'
ELSE 'On Time'
END AS delivery_status, r.review_score
FROM orders o
JOIN reviews r ON o.order_id = r.order_id
WHERE o.order_status = 'delivered' AND o.order_delivered_customer_date IS NOT NULL
)
SELECT delivery_status, ROUND(AVG(review_score), 2) AS avg_review_score
FROM delivery_reviews
GROUP BY delivery_status;

------------------------------------------------------------------------------------
--- WHICH PRODUCT CATEGORIES HAVE THE LOWEST REVIEW SCORES ---
------------------------------------------------------------------------------------
SELECT ct.product_category_name_english as category, round(avg(r.review_score),2) as avg_rev_score
from reviews r
join order_items oi on r.order_id = oi.order_id
join products p on oi.product_id=p.product_id
join category_translation ct on p.product_category_name = ct.product_category_name
group by ct.product_category_name_english
order by avg_rev_score asc
limit 5

-- now out of products with atleast 50 ratings --

SELECT ct.product_category_name_english as category, round(avg(r.review_score),2) as avg_rev_score
from reviews r
join order_items oi on r.order_id = oi.order_id
join products p on oi.product_id=p.product_id
join category_translation ct on p.product_category_name = ct.product_category_name
group by ct.product_category_name_english
having count(*)>=50
order by avg_rev_score asc
limit 5

------------------------------------------------------------------------------------
--- WHICH SELLERS GENERATE THE MOST REVENUE ---
------------------------------------------------------------------------------------
SELECT seller_id  , sum(price) as total_revenue
from order_items
group by seller_id
order by total_revenue desc
limit 10

------------------------------------------------------------------------------------
--- WHICH PAYMENT METHOD IS MOST COMMONLY USED? ---
------------------------------------------------------------------------------------
select payment_type , count(*) as total_payments
from payments
group by payment_type 
order by total_payments desc

------------------------------------------------------------------------------------
--- AVG PAYMENT VALUE PER PAYMENT METHOD ---
------------------------------------------------------------------------------------
select payment_type , ROUND(AVG(payment_value),2) as avg_payment_value
from payments
group by payment_type 
order by avg_payment_value desc





