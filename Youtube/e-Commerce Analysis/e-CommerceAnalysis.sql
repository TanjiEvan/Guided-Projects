create database ecommerce;
USE ecommerce;
SELECT * FROM customers;
########################## BASIC ###########################################################
## 1. List all unique cities where customers are located. ##
SELECT DISTINCT customer_city FROM customers ;

## 2. Count the number of orders placed in 2017. ##
SELECT * FROM ecommerce.orders;
SELECT 
    COUNT(*)
FROM
    orders
WHERE
    order_purchase_timestamp BETWEEN '2017-01-01' AND '2018-01-01';
    
## 3. Find the total sales per category. ##
SELECT * FROM ecommerce.products;
SELECT * FROM ecommerce.order_items;
SELECT * FROM ecommerce.payments;

SELECT products.product_category AS Category , sum(payments.payment_value) AS Sales
FROM products
JOIN order_items
ON products.product_id=order_items.product_id
JOIN payments
ON payments.order_id=order_items.order_id
GROUP BY product_category;

## 4. Calculate the percentage of orders that were paid in installments. ##
SELECT * FROM ecommerce.payments;

SELECT SUM(CASE WHEN payment_installments >=1 THEN 1 
ELSE 0 END) /count(payment_installments)*100 AS Percentage FROM payments;

## 5. Count the number of customers from each state. ##
SELECT * FROM ecommerce.customers;

SELECT COUNT(customers.customer_id) AS Customer_ID_Count , customer_state FROM customers
GROUP BY customer_state;

############################ Intermediate Queries ######################################

## 1. Calculate the number of orders per month in 2018. ##
SELECT order_id,order_purchase_timestamp FROM ecommerce.orders;

SELECT monthname(order_purchase_timestamp) as Months,count(order_id) AS Order_count
FROM orders WHERE year(order_purchase_timestamp) =2018
group by Months;

### 2. Find the average number of products per order, grouped by customer city.

with count_per_order as
(SELECT orders.order_id, orders.customer_id , count(order_items.order_id) as oc
FROM orders JOIN order_items 
ON orders.order_id = order_items.order_id
GROUP BY orders.order_id,orders.customer_id)

SELECT customers.customer_city, ROUND(AVG(count_per_order.oc),2)
FROM customers join count_per_order
ON customers.customer_id= count_per_order.customer_id
GROUP BY customers.customer_city;

### 3. Calculate the percentage of total revenue contributed by each product category. ###
SELECT UPPER(products.product_category) AS Category ,
ROUND(((sum(payments.payment_value))/(SELECT SUM(payment_value) FROM payments))*100,2) AS SALES_PERCENTAGE
FROM products
JOIN order_items
ON products.product_id=order_items.product_id
JOIN payments
ON payments.order_id=order_items.order_id
GROUP BY product_category ORDER BY SALES_PERCENTAGE DESC;

### 4. Identify the correlation between product price and the number of times a product has been purchased. ###
SELECT products.product_category,
COUNT(order_items.product_id),
ROUND(AVG(order_items.price),2)
FROM products JOIN order_items
ON products.product_id=order_items.product_id
GROUP BY product_category;






















