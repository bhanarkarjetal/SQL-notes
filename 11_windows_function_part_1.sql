-- WINDOWS function
-- common questions: how to remove duplicate records
-- find the employee who gets the 10th highest salary in their resp dept

-- ques: find the avg salary of the organisation
-- solution 1 : using subquery
SELECT *, (SELECT AVG(salary) FROM employees) AS avg_salary
FROM employees 

-- solution 2: using cross join
SELECT * FROM employees
CROSS JOIN	
(SELECT AVG(salary) AS avg_sal FROM employees ) AS a_sal

-- solution 3: using CTE and cross join
WITH
a_sal
AS
(
SELECT AVG(salary) AS avg_salary
FROM employees 
)
SELECT * FROM employees 
CROSS JOIN
a_sal


-- solution 4: using windows function
SELECT * ,
	AVG(salary) OVER() AS avg_sal -- find avg(column name) over(window)
FROM 
	employees

-- window function always does the aggregate function over the given window. 
-- in this case since there is empty bracker beside OVER, it means it will perform over the entire window
-- here, entire window means the entire table

-- find max salary in the salary section
SELECT *, 
	MAX(salary) OVER() AS max_sal
FROM 
	employees

-- other aggregate functions like max, min, sum, count, avg
SELECT *, 
	COUNT(employee_id) OVER() AS total_emp_count
FROM
	employees

-- by writing the where clause after the employees, the size of the window shrinks

-- find the employee as as fraction to the total salary paid to all the employees
GO
WITH
total_salary
AS
(
SELECT * 
	,SUM(salary) OVER() AS total_sal_paid
FROM employees
)
SELECT *, 
	salary*1.00/total_sal_paid AS frac_sal
FROM 
	total_salary
-- multiplying with 1.00 to convert the integer into decimal number

-- in the above example the entire table was treated as a single window

-- find the avg salary of each department in the table
SELECT * FROM employees
INNER JOIN
(
	SELECT employee_dept, AVG(salary) AS avg_sal
	FROM 
		employees
	GROUP BY
		employee_dept
) AS t_1
ON	t_1.employee_dept = employees.employee_dept

-- solution 2 : as common table expression
WITH
avg_dept_sal
AS
(
	SELECT employee_dept, AVG(salary) AS avg_sal
	FROM
		employees
	GROUP BY
		employee_dept
)

SELECT * FROM employees
INNER JOIN
	avg_dept_sal
ON
	employees.employee_dept = avg_dept_sal.employee_dept

-- solution 3 : using windows function
SELECT * , AVG(salary) OVER(PARTITION BY employee_dept) AS dept_avg_sal
FROM employees

-- in this case the window is partitioned based on the department name over employee_dept column

-- classify all employees whose salary > avg salary of their respective department
-- as high_sal, else low_sal
GO
WITH
avg_sal
AS
(
SELECT * , AVG(salary) OVER(PARTITION BY employee_dept) AS dept_avg_sal
FROM employees
)

SELECT *,
		 CASE
		WHEN
			salary > dept_avg_sal
		THEN 'HIGH_SAL'
		ELSE 'LOW_SAL' 
		END AS sal_class
FROM avg_sal


-- find unique employee departments
SELECT DISTINCT employee_dept FROM employees

-- find the employee in each department who earns the maximum salary
SELECT employee_id,
	employee_name	
	, employee_email
	,salary
	, dept_max_sal
FROM employees
INNER JOIN
(SELECT employee_dept, MAX(salary) AS dept_max_sal
FROM employees
GROUP BY employee_dept) AS max_sal
ON
employees.salary = max_sal.dept_max_sal

-- ROW NUMBER
SELECT * 
	, ROW_NUMBER() OVER(ORDER BY salary DESC) AS row_num_val
FROM
	employees

-- WHERE clause cannot be a part of windows function.
-- it can be used only with the SELECT clause or with subquery

SELECT * FROM 
(SELECT * 
	, ROW_NUMBER() OVER(ORDER BY salary DESC) AS row_num_val
FROM
	employees) AS emp_sal_rank
WHERE row_num_val =1

-- give row number values to employees of each department
SELECT *, ROW_NUMBER() OVER (PARTITION BY employee_dept
							ORDER BY salary DESC) AS row_num_val_dept
	FROM
		employees

-- find the employee with highest salary in each deprtment considering each employee is getting unique salary

SELECT * FROM
( SELECT *, ROW_NUMBER() OVER(PARTITION BY employee_dept 
							 ORDER BY salary DESC) AS rank_sal
FROM employees) as emp_dept_sal_rank
WHERE rank_sal = 1

-- row_number function fails when there are employees with same salary
-- it will give different row numbers to each one of them
-- so the top 10 employees with max salary will not be accurate

-- use ROW_NUMBERS() to identify duplicate records
INSERT INTO employees
VALUES
( (SELECT MAX(employee_id) FROM employees) + 1, 'Samar Kumar Karamkar',
'samar_kumar_karamkar@dummyemail.com', 'SD-Web', 320012)

WITH
emp_dept_rank
AS
(
SELECT * , ROW_NUMBER() OVER(PARTITION BY employee_name,
							employee_email,
							employee_dept,
							salary ORDER BY salary) AS emp_rank
FROM employees
)
SELECT * FROM emp_dept_rank
WHERE emp_rank > 1

-- to delete the duplicate records use DELETE clause instead of SELECT

WITH
emp_dept_rank
AS
(
SELECT * , ROW_NUMBER() OVER(PARTITION BY employee_name,
							employee_email,
							employee_dept,
							salary ORDER BY salary) AS emp_rank
FROM employees
)
DELETE FROM emp_dept_rank
WHERE emp_rank > 1


WITH
emp_dept_rank
AS
(
SELECT * , ROW_NUMBER() OVER(PARTITION BY employee_name,
							employee_email,
							employee_dept,
							salary ORDER BY salary) AS emp_rank
FROM employees
)
SELECT * FROM emp_dept_rank
ORDER BY employee_dept

-- RANK function: similar to row function but gives same rank to people with same salary
-- when the window is OVER salary, 
-- but SKIPS the numberby the ' numbero= of times' the rank is repeated
-- eg. 10th highest salary is given to three employees, then the next rank will be 13th
-- SYNTAX

WITH
emp_dept_rank
AS
(
SELECT * , RANK() OVER(ORDER BY salary) AS emp_rank
FROM employees
)
SELECT * FROM emp_dept_rank
ORDER BY employee_dept

-- To overcome this problem, we use DENSE_RANK
-- which gives rank to every employee based on their salary
-- eg. 10th highest salary is given to three employees,
-- then next highest salary will be ranked as 11th
-- SYNTAX
WITH
emp_dept_rank
AS
(
SELECT * , DENSE_RANK() OVER(PARTITION BY employee_dept ORDER BY salary DESC) AS emp_rank
FROM employees
)
SELECT * FROM emp_dept_rank
ORDER BY employee_dept

