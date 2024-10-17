-- find a union of top 10 people whose salary is closest to the average
-- and top 10 people whose salary is farthest to the average of the entire organisation

SELECT AVG(salary) FROM employees

GO
WITH
	emp_avg_sal_diff
AS
(
SELECT *, 
	ABS(salary - (SELECT AVG(salary) FROM employees)) AS avg_sal_diff
	-- ABS gives absolute values of a number
FROM
	employees 
),

nearest_to_avg
AS
( 
SELECT TOP 10 *, 'NEAREST' AS salary_class
FROM
	emp_avg_sal_diff
ORDER BY avg_sal_diff ASC
),

farthest_from_avg
AS
(
SELECT TOP 10 *, 'Farthest' AS salary_class
FROM 
	emp_avg_sal_diff
ORDER BY avg_sal_diff DESC
)

select * from farthest_from_avg
UNION ALL
SELECT * FROM nearest_to_avg
ORDER BY avg_sal_diff

-- fetch the top 5 from each department whose salary is closest or farthest
-- from the average salary of respective department

SELECT employee_dept, AVG(salary) AS avg_sal_dept
FROM employees
GROUP BY employee_dept

-- use CTE to find 
-- 1. the total sales after discounts
-- 2. top 3 customers based on their total sales after discounts
-- 3. top 3 salesman based on total sales after discounts
-- 4. top 3 salesman who did the maximum number of sales
-- 5. bottom 3 salesman who did least number of sales

SELECT * FROM orders
SELECT * FROM salesman
SELECT * FROM customers
SELECT * FROM discounts

GO
WITH
	total_sales
AS
(
SELECT orders.*
	  , orders.quantity*orders.item_price AS price_b_disc
	  , COALESCE(discounts.disc_perc,0.00)/100 AS disc_perc
		  
FROM 
	orders
LEFT OUTER JOIN	
	discounts
ON	
	YEAR(orders.purchase_date) = discounts.disc_year
AND
	MONTH(orders.purchase_date) = discounts.disc_month
),
total_price_a_disc
AS
(
SELECT *, price_b_disc - 
			price_b_disc*disc_perc AS price_a_sales 
FROM total_sales
)

SELECT TOP 3 customers.customer_name, customers.customer_id
FROM total_price_a_disc
LEFT OUTER JOIN
	customers	
ON
	total_price_a_disc.customer_id = customers.customer_id
ORDER BY price_a_sales