create database ecommerce;
USE ecommerce;
SELECT * FROM customers;

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
























