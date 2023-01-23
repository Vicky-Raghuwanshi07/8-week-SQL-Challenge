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
