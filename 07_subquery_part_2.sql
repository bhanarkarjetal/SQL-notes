USE sql_wkday_20240228

-- SUBQUERY RETURNING MULTIPLE RoWS AND MULTIPLE COLUMNS

-- fetch employees who earn the maximum salary in the respective department

SELECT employee_dept, MAX(salary) AS max_sal
FROM employees
GROUP BY employee_dept


SELECT * 
FROM employees
WHERE employee_dept = 'SD-DB'
AND salary = 319254

-- inner joining the above two tables will give the employee details
-- earning maximum salary in respectve departments

SELECT * 
FROM (
		SELECT employee_dept, MAX(salary) AS max_sal
		FROM employees
		GROUP BY employee_dept
	 ) AS table_1

INNER JOIN	employees
ON 
	table_1.employee_dept = employees.employee_dept
AND 
	table_1.max_sal = employees.salary

-- to get columns only from the employees table, use SELECT employees.*

SELECT employees.* 
FROM 
	(
	SELECT employee_dept, MAX(salary) AS max_sal
	FROM employees
	GROUP BY employee_dept
	) AS table_1

INNER JOIN employees
ON 
	table_1.employee_dept = employees.employee_dept
AND	
	table_1.max_sal = employees.salary

-- fetch employees who earn the minimum salary in the respective department

SELECT employees.*
FROM employees
INNER JOIN
	(
	SELECT employee_dept, MIN(salary) as min_sal
	FROM employees
	GROUP BY employee_dept
	) AS table_1
ON 
	table_1.employee_dept = employees.employee_dept
AND
	table_1.min_sal = employees.salary

-- fetch all the employees who earn more than the average salary of their respective departments

SELECT emp.*, t_1.avg_sal
FROM
	employees AS emp
INNER JOIN
	(
	SELECT 
		employee_dept, AVG(salary) as avg_sal
	FROM
		employees
	GROUP BY 
		employee_dept
	) AS t_1
ON
	t_1.employee_dept = emp.employee_dept
AND
	emp.salary > t_1.avg_sal
ORDER BY
	emp.employee_dept, emp.salary DESC

-- fetch all the employees who earn between 150% of the avg salary
-- and the max salary of their respective department

SELECT emp.*, t_1.lower_limit,t_1.upper_limit
FROM
	employees AS emp
INNER JOIN
	(
	SELECT employee_dept, 1.5*AVG(salary) AS lower_limit
			, MAX(salary) AS upper_limit
	FROM employees
	GROUP BY employee_dept
	) AS t_1
ON 
	t_1.employee_dept = emp.employee_dept
AND 
	emp.salary BETWEEN t_1.lower_limit AND t_1.upper_limit

-- classify employees and high_sal and low_sal
-- if sal is lower than avg sal, then low_sal
-- else, high_sal

SELECT emp.*, avg_sal,
		CASE
			WHEN emp.salary > t_1.avg_sal
			THEN 'High_sal'
			ELSE 'Low_sal'
		END as Sal_comment
FROM
	employees AS emp
INNER JOIN	(
			SELECT employee_dept
				, AVG(salary) as avg_sal
			FROM employees
			GROUP BY employee_dept
			) as t_1	
ON 
	emp.employee_dept = t_1.employee_dept

ORDER BY	
	employee_dept,
	salary DESC


-- fetch the count of low_sal and high_sal employees of each department

-- LOW SALARY
SELECT employee_dept, COUNT(*) AS low_sal_emp_count,
	AVG(t_2.avg_sal) AS avg_salary
FROM
(SELECT 
	emp.employee_dept, t_1.avg_sal,
	CASE
		WHEN emp.salary > t_1.avg_sal
		THEN 'High_sal'
		ELSE 'Low_sal'
	END AS comment
FROM employees AS emp
INNER JOIN
	(
	SELECT employee_dept
			, AVG(salary) as avg_sal
	FROM employees
	GROUP BY employee_dept
	) as t_1
ON 
	emp.employee_dept = t_1.employee_dept
) as t_2
WHERE t_2.comment = 'Low_sal'

GROUP BY employee_dept 


-- HIGH SALARY
SELECT employee_dept, COUNT(*) AS high_sal_emp_count,
	AVG(t_2.salary) AS avg_salary
FROM
(SELECT 
	emp.employee_dept, emp.salary,
	CASE
	WHEN
		emp.salary > t_1.avg_sal
	THEN 
		'High_sal'
	ELSE	
		'Low_sal'
	END AS comment
FROM
	employees AS emp
INNER JOIN
	(
	SELECT 
		employee_dept
		, AVG(salary) as avg_sal
	FROM
		employees
	GROUP BY 
		employee_dept
	) as t_1
ON 
	emp.employee_dept = t_1.employee_dept
) as t_2
WHERE t_2.comment = 'High_sal'

GROUP BY employee_dept 


-- find total sales after discount
SELECT * FROM customers
SELECT * FROM orders
SELECT * FROM discounts
SELECT * FROM salesman	

-- ORDERS: quantity, item price, purchase date
-- DISCOUNTS: disc_year, disc_month, disc_perc

SELECT 
	YEAR(orders.purchase_date) AS purchase_year,
	AVG(orders.quantity*orders.item_price - 
	orders.quantity*orders.item_price*
	COALESCE(discounts.disc_perc/100,0.00))
	AS  avg_price_after_disc
FROM
	orders 
LEFT OUTER JOIN
	discounts
ON 
	YEAR(orders.purchase_date) = discounts.disc_year
AND
	MONTH(orders.purchase_date) = discounts.disc_month
GROUP BY
	YEAR(orders.purchase_date)
ORDER BY purchase_year
 


 -- Populate the employee_information_tab (which we will use it in future) 
USE sql_wkday_20240228;
DROP TABLE IF EXISTS employee_information_tab;
CREATE TABLE  employee_information_tab
(
employee_id INT PRIMARY KEY,
emp_name VARCHAR(100) NOT NULL,
dept_id VARCHAR(10),
manager_id INT,
salary INT)
;

