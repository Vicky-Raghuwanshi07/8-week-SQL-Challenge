/* -----------------------------------
   Case Study Questions and Solutions
   -----------------------------------*/

-- 1. What is the total amount each customer spent at the restaurant?

SELECT 
	SUM(price) AS total_amount,
    members.customer_id 
FROM 
	dannys_diner.members AS members
JOIN 
	dannys_diner.sales AS sales
	ON 
	sales.customer_id=members.customer_id
JOIN 
	dannys_diner.menu AS menu
ON 	
	sales.product_id=menu.product_id
GROUP BY 
	members.customer_id;
    
    
-- 2. How many days has each customer visited the restaurant?

SELECT
	sales.customer_id,
    COUNT(DISTINCT(sales.order_date)) AS visited_days
FROM 
	dannys_diner.sales AS sales
GROUP BY
	sales.customer_id;

-- 3. What was the first item from the menu purchased by each customer?

WITH cust_orders_cte AS(
	SELECT
		customer_id,
		order_date,
		product_name,
		row_number() over (partition by customer_id 
		order by order_date) as rank
	FROM
		dannys_diner.sales s,
		dannys_diner.menu m
	WHERE m.product_id = s.product_id
)

SELECT 
	customer_id,
	product_name
FROM cust_orders_cte
WHERE rank = 1;


-- 4. What is the most purchased item on the menu and how many times was it purchased by all customers?

SELECT 
	top(1)
	product_name,
	count(s.product_id) as purchased
FROM
	dannys_diner.sales s,
	dannys_diner.menu m
WHERE m.product_id = s.product_id
GROUP BY product_name
ORDER BY purchased DESC;



-- 5. Which item was the most popular for each customer?
WITH fav_item_cte AS(
	SELECT
		customer_id,
		product_name,
		count(s.product_id) as ordered,
		dense_rank() over (partition by customer_id 
		order by count(s.product_id) desc) as rank
	FROM
		sales s,
		menu m
	WHERE m.product_id = s.product_id
	GROUP BY 
		customer_id,
		product_name
)

SELECT 
	customer_id,
	product_name,
	ordered
FROM fav_item_cte
WHERE rank = 1;


-- 6. Which item was purchased first by the customer after they became a member?

WITH memb_orders_cte AS(
	SELECT
		s.customer_id,
		order_date,
		join_date,
		product_id,
		row_number() over (partition by s.customer_id
		order by order_date) as rank
	FROM
		dannys_diner.sales s,
		dannys_diner.members m
	WHERE
		m.customer_id = s.customer_id
		AND
		order_date >= join_date
)

SELECT 
	customer_id,
	product_name,
	order_date, 
	join_date
FROM 
	memb_orders_cte mo,
	dannys_diner.menu m
WHERE 
	m.product_id = mo.product_id
	AND
	rank = 1;

-- 7. Which item was purchased just before the customer became a member?

-- 8. What is the total items and amount spent for each member before they became a member?

-- 9.  If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?

-- 10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?



