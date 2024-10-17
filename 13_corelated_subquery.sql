-- find the state(s) with the highest salesman

-- step 1: find the state name
WITH 
	salesman_state
AS
(
SELECT *,
	TRIM(RIGHT(sales_location, 
	LEN(sales_location) -  
	CHARINDEX(' ',sales_location))) AS state_name
	
FROM salesman
)

SELECT * 
FROM
	(
	SELECT *, 
		DENSE_RANK() OVER(ORDER BY salesman_count DESC) AS salesman_rank
	FROM
		(
		SELECT 
			state_name, 
			COUNT(*) AS salesman_count
		FROM salesman_state
		GROUP BY state_name
		) AS sub_q_1
	) AS sub_q_2
WHERE salesman_rank = 1

-- we are making subquery 2 because we cannot use WHERE clause inside the subquery
-- always name the subquery before executing
SELECT * FROM discounts

-- find the top 3 month-year with the highest sales after discount
GO
WITH
total_sales
AS
(
SELECT od.*, dc.disc_month,
	dc.disc_year,
	(od.quantity*od.item_price)*(100-dc.disc_perc)/100 AS total_price
FROM
	orders AS od
INNER JOIN
	discounts as dc
ON
	YEAR(od.purchase_date) = dc.disc_year
AND 
	MONTH(od.purchase_date) = dc.disc_month
--SELECT * FROM total_sales
)
SELECT * 
FROM
(
SELECT *,
	DENSE_RANK() OVER(ORDER BY total_month_year DESC) AS rank_total_sales
FROM
	(
	SELECT  disc_month, disc_year,
		SUM(total_price) AS total_month_year
	FROM total_sales
	GROUP BY disc_month, disc_year
	) AS sub_q_1
) AS sub_q_2
WHERE rank_total_sales <= 3


-- co-related subqueries

-- find the name of employee in each department with the highest salary
-- using a SUBQUERY

SELECT emp.*, max_sal  
FROM 
	employees as emp
INNER JOIN
(
	SELECT 
		employee_dept , MAX(salary) AS max_sal
	FROM 
		employees
	GROUP BY
		employee_dept
) AS sub_q_1
ON
	emp.employee_dept = sub_q_1.employee_dept
AND 
	emp.salary = sub_q_1.max_sal


-- CO-RELATED SUBQUERY
SELECT *
FROM
	employees AS outer_query
WHERE
	salary = (
				SELECT MAX(salary) FROM employees
				WHERE employee_dept = outer_query.employee_dept
			 )

-- use co-related subquery to find all the employees who earn 
-- more than the average salary in their respective department

SELECT * FROM employees AS outer_query
WHERE 
	salary > (
				SELECT AVG(salary) FROM employees AS avg_sal
				WHERE 
					employee_dept = outer_query.employee_dept
			)

-- classify each salary as high_sal and low_sal based on their salary wrt avg_salary
-- use correlated subquery
SELECT * ,
		(
		SELECT AVG(salary) 
		FROM employees AS avg_sal
		WHERE 
			employee_dept = outer_query.employee_dept
		) AS dept_avg_sal
		,CASE
			WHEN 
			outer_query.salary < (
									SELECT AVG(salary) 
									FROM employees AS avg_sal
									WHERE 
									employee_dept = outer_query.employee_dept
								)
		THEN 'low sal'
		ELSE 'high sal'
		END AS salary_class
	
FROM employees AS outer_query




