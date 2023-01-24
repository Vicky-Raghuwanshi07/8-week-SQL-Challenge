-- 1. How many pizzas were ordered?

SELECT count(pizza_id) as orders
FROM #cleaned_customer_orders;


-- 2. How many unique customer orders were made? 

SELECT count(distinct order_id) as unique_orders
FROM #cleaned_customer_orders;


-- 3. How many successful orders were delivered by each runner?

SELECT 
    runner_id,
    count(order_id) as successful_orders
FROM #cleaned_runner_orders
WHERE cancellation is null
GROUP BY runner_id;


-- 4. How many of each type of pizza was delivered?

SELECT
	p.pizza_name,
	COUNT(c.order_id) as delivered
FROM 
	#cleaned_customer_orders c,
	#cleaned_runner_orders r,
	pizza_names p
WHERE
	c.order_id = r.order_id
	AND
	c.pizza_id = p.pizza_id
	AND
	r.cancellation is null
GROUP BY p.pizza_name;


-- 5.How many Vegetarian and Meatlovers were ordered by each customer?

SELECT
	customer_id,
	pizza_name,
	COUNT(c.order_id) as ordered
FROM 
	#cleaned_customer_orders c,
	pizza_names p
WHERE c.pizza_id = p.pizza_id
GROUP BY 
	customer_id,
	pizza_name
ORDER BY customer_id;
