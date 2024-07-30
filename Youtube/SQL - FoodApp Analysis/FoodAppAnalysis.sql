CREATE database foodappdata;
USE foodappdata;

## 1. Find Customers who have never ordered ##

SELECT * FROM users;
SELECT * FROM orders;

SELECT DISTINCT name 
FROM users 
WHERE user_id NOT IN (SELECT user_id FROM orders);

## 2. Avg Price Per Dish 

SELECT food.f_id, food.f_name, AVG(menu.price) AS avg_price
FROM menu
JOIN food ON food.f_id = menu.f_id
GROUP BY food.f_id, food.f_name
ORDER BY avg_price DESC;

## 3. Find top restaurants in terms of number of orders for a given month 

SELECT * FROM foodappdata.orders;
SELECT *,MONTHNAME(date) FROM orders;

SELECT 
    r.r_name,
    COUNT(*) AS order_count,
    MONTHNAME(date) AS month_name
FROM
    orders o
JOIN restaurants r ON o.r_id=r.r_id
WHERE
    MONTH(date) = 7 
GROUP BY
    r_name, MONTHNAME(date)
ORDER BY order_count desc;

## 4. Restaurants with monthly sales grater than x
SELECT r_id,amount FROM orders 
WHERE MONTHNAME(date) = 'JUNE';

SELECT r.r_name,  SUM(amount) AS Revenue 
FROM orders o 
JOIN restaurants r ON r.r_id=o.r_id
WHERE MONTHNAME(date) LIKE 'JUNE'
GROUP BY r.r_name
HAVING Revenue > 800
ORDER BY Revenue DESC;

## 5. Show All orders with order details for a particualr customer in a particular date range

SELECT name FROM users WHERE name="Ankit";

SELECT DISTINCT o.order_id,r.r_name AS Restaurant,f.f_name AS Food_Name FROM orders o
JOIN restaurants r 
ON r.r_id=o.r_id
JOIN order_details od
ON o.order_id= od.order_id
JOIN food f
ON od.f_id=f.f_id
WHERE user_id=(SELECT DISTINCT user_id FROM users WHERE name="Ankit")
AND date > '2022-06-10' AND date < '2022-07-10';



















