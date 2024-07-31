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

## 6. Show all orders with order details for a particular customer in particular date range
SELECT r.r_name,r.r_id,count(*) AS loyal_customer
FROM
(SELECT  r_id,user_id, COUNT(*) AS  visits  FROM orders GROUP BY r_id,user_id HAVING visits >1) t
JOIN restaurants r
ON r.r_id=t.r_id
GROUP BY r.r_name,t.r_id;

### 7. Month over month revenue growth
SELECT month, ((revenue-previous)/previous)*100 
FROM
(WITH sales AS 
(SELECT MONTHNAME(date) AS month, sum(amount) AS revenue 
FROM orders
GROUP BY month order by month DESC)

SELECT month,revenue,LAG(revenue,1)  OVER (ORDER BY revenue) AS previous FROM sales) t;

## 8. Customer -> fav food
WITH temp AS
(
SELECT o.user_id,od.f_id,COUNT(*) AS freq FROM orders o 
JOIN order_details od 
ON o.order_id=od.order_id
GROUP BY o.user_id,od.f_id
)
SELECT DISTINCT  u.name,f.f_name,t1.freq FROM temp t1 
JOIN users u
ON u.user_id=t1.user_id
JOIN food f
ON f.f_id=t1.f_id
WHERE t1.freq=
(SELECT MAX(freq) FROM temp t2 WHERE t2.user_id=t1.user_id)
;


















































