-- Before writing the solution first we need to transform it and clean it
-- Replacing NULL with empty string ' '

SELECT order_id, customer_id, pizza_id, 
  CASE 
    WHEN exclusions IS null OR exclusions LIKE 'null' THEN ' '
    ELSE exclusions
    END AS exclusions,
  CASE 
    WHEN extras IS NULL or extras LIKE 'null' THEN ' '
    ELSE extras 
    END AS extras, 
  order_time
INTO #customer_orders
FROM customer_orders;


SELECT order_id, runner_id,
  CASE 
    WHEN pickup_time LIKE 'null' THEN ' '
    ELSE pickup_time 
    END AS pickup_time,
  CASE 
    WHEN distance LIKE 'null' THEN ' '
    WHEN distance LIKE '%km' THEN TRIM('km' from distance) 
    ELSE distance END AS distance,
  CASE 
    WHEN duration LIKE 'null' THEN ' ' 
    WHEN duration LIKE '%mins' THEN TRIM('mins' from duration) 
    WHEN duration LIKE '%minute' THEN TRIM('minute' from duration)        
    WHEN duration LIKE '%minutes' THEN TRIM('minutes' from duration)       
    ELSE duration END AS duration,
  CASE 
    WHEN cancellation IS NULL or cancellation LIKE 'null' THEN ''
    ELSE cancellation END AS cancellation
INTO #runner_orders
FROM runner_orders;


-- 1. How many pizzas were ordered?

SELECT count(pizza_id) as orders
FROM #customer_orders;


-- 2. How many unique customer orders were made? 

SELECT count(distinct order_id) as unique_orders
FROM #customer_orders;


-- 3. How many successful orders were delivered by each runner?

SELECT runner_id, COUNT(order_id) AS successful_orders
FROM #runner_orders
WHERE distance != 0
GROUP BY runner_id;


-- 4. How many of each type of pizza was delivered?

SELECT p.pizza_name, COUNT(c.pizza_id) AS delivered_pizza_count
FROM #customer_orders AS c
JOIN #runner_orders AS r
 ON c.order_id = r.order_id
JOIN pizza_names AS p
 ON c.pizza_id = p.pizza_id
WHERE r.distance != 0
GROUP BY p.pizza_name;


-- 5.How many Vegetarian and Meatlovers were ordered by each customer?

SELECT c.customer_id, p.pizza_name, COUNT(p.pizza_name) AS order_count
FROM #customer_orders AS c
JOIN pizza_names AS p
 ON c.pizza_id= p.pizza_id
GROUP BY c.customer_id, p.pizza_name
ORDER BY c.customer_id;


-- 6. What was the maximum number of pizzas delivered in a single order?

WITH pizza_count_cte AS
(
 SELECT c.order_id, COUNT(c.pizza_id) AS pizza_per_order
 FROM #customer_orders AS c
 JOIN #runner_orders AS r
  ON c.order_id = r.order_id
 WHERE r.distance != 0
 GROUP BY c.order_id
)

SELECT MAX(pizza_per_order) AS pizza_count
FROM pizza_count_cte;


-- 7. For each customer, how many delivered pizzas had at least 1 change and how many had no changes?

SELECT c.customer_id,
 SUM(CASE 
  WHEN c.exclusions <> ' ' OR c.extras <> ' ' THEN 1
  ELSE 0
  END) AS at_least_1_change,
 SUM(CASE 
  WHEN c.exclusions = ' ' AND c.extras = ' ' THEN 1 
  ELSE 0
  END) AS no_change
FROM #customer_orders AS c
JOIN #runner_orders AS r
 ON c.order_id = r.order_id
WHERE r.distance != 0
GROUP BY c.customer_id
ORDER BY c.customer_id;


-- 8. How many pizzas were delivered that had both exclusions and extras?

SELECT  
 SUM(CASE
  WHEN exclusions IS NOT NULL AND extras IS NOT NULL THEN 1
  ELSE 0
  END) AS pizza_count_w_exclusions_extras
FROM #customer_orders AS c
JOIN #runner_orders AS r
 ON c.order_id = r.order_id
WHERE r.distance >= 1 
 AND exclusions <> ' ' 
 AND extras <> ' ';
 
 
