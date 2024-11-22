-- Mentioning the name of database where we want to write the query
USE sql_wkday_20240228

-- SUBQUERIES: using output of one query as an input for another query
SELECT TOP 10 * FROM employees

-- fetch the employee getting highest salary
SELECT MAX(salary)
FROM employees --output: 319254


SELECT * 
FROM employees
WHERE salary = 319254

-- the above method is a two step process
-- single step process can be done using subquery by merging above two steps

SELECT *  -- outer query
FROM employees
WHERE salary = (
		SELECT MAX(salary) -- inner query
		FROM employees 
		)

-- the inner query can run on its own
-- the outer query is dependent on the inner query

-- SCALAR SUBQUERY: returns a single value

-- fetch the employee who earns the minium salary
SELECT *  -- outer query
FROM employees
WHERE salary = (
		SELECT MIN(salary) -- inner query
		FROM employees 
		)

-- find the employee from SD-REPORT department who earns the max salary
SELECT *  
FROM employees
WHERE salary = (
		SELECT MAX (salary) 
		FROM employees 
		WHERE employee_dept = 'SD-Report'
		)
AND employee_dept = 'SD-Report'

-- all the employees getting minimum salary from SD-Infra dept
SELECT * 
FROM employees
WHERE salary = (
		SELECT MIN (salary) 
		FROM employees 
		WHERE employee_dept = 'SD-Infra'
		)
AND employee_dept = 'SD-Infra'

-- fetch all the employees from entire organization who earns more than avg salary
SELECT *  -- outer query
FROM employees
WHERE salary > (
		SELECT AVG (salary) -- inner query
		FROM employees 
		)
ORDER BY salary DESC

-- find all the employees from the entire organization who earns between 50% and 100% of the max salary of SD-WEB
SELECT *  
FROM employees
WHERE salary BETWEEN (
			SELECT 0.5*MAX (salary)
			FROM employees 
			WHERE employee_dept = 'SD-WEB'
			)
		AND 
			(
			SELECT MAX (salary)
			FROM employees 
			WHERE employee_dept = 'SD-WEB'
			)
ORDER BY salary DESC


SELECT * , 89721 AS avg_sal 
FROM employees
WHERE salary > (
		SELECT AVG (salary) -- inner query
		FROM employees 
		)
ORDER BY salary DESC

-- we can add any column of our choice in the table
SELECT * , 
	(SELECT AVG (salary) 
	FROM employees ) 
FROM employees
WHERE salary > (
		SELECT AVG (salary) -- inner query
		FROM employees 
		)
ORDER BY salary DESC

-- find all the employees from the entire organization who earns 
--between 50% and 90% of the max salary of SD-WEB
SELECT * , (
		SELECT 0.5*MAX (salary) -- inner query
		FROM employees 
		WHERE employee_dept = 'SD-WEB'
		) AS fifty_pc_sal,
		(
		SELECT 0.9*MAX (salary) -- inner query
		FROM employees 
		WHERE employee_dept = 'SD-WEB'
		) AS ninety_pc_sal
FROM employees
WHERE salary BETWEEN (
		SELECT 0.5*MAX (salary) -- inner query
		FROM employees 
		WHERE employee_dept = 'SD-WEB'
		)
		AND 
		(
		SELECT 0.9*MAX (salary) -- inner query
		FROM employees 
		WHERE employee_dept = 'SD-WEB'
		)
ORDER BY salary DESC


-- CASE clause
-- if a person earns less than avg salary, classify him as 'Low-Sal'
-- if a person earns greater than or equal to avg salary, classify him as 'High-Sal'

SELECT *,
	CASE
		WHEN salary < (SELECT AVG (salary) FROM employees)
		THEN 'Low-Sal'
		ELSE 'High-Sal'
	END AS comment
FROM employees

-- if an employee get salary lower than 80% of the avg salary>> Low-Sal
-- if an employee get between 80 and 200 % of avg salary >> Avg-Sal
-- if an employee get salary > 200% of avg salary >> High-Sal

SELECT *,
	CASE
		WHEN salary < 0.8*(SELECT AVG (salary) FROM employees)
		THEN 'Low-Sal'
		WHEN salary BETWEEN 0.8*(SELECT AVG (salary) FROM employees)
				AND 2*(SELECT AVG (salary) FROM employees)
		THEN 'Avg_Sal'
		ELSE 'High-Sal'
	END AS comment
FROM employees

-- get all the employees who belong to the top two dept with most employees
SELECT TOP 2 employee_dept, COUNT(*) AS no_of_emp
FROM employees
GROUP BY employee_dept
ORDER BY no_of_emp DESC

--OR

SELECT TOP 2 employee_dept
FROM employees
GROUP BY employee_dept
ORDER BY COUNT(*)  DESC

SELECT * 
FROM employees
WHERE employee_dept IN ('SD-WEB','SD-REPORT')
ORDER BY employee_dept, 
	salary DESC

-- OR

SELECT * 
FROM employees
WHERE employee_dept -- one column but miltiple rows, therefore, we use IN command
	IN 	(
		SELECT TOP 2 employee_dept 
		FROM employees
		GROUP BY employee_dept
		ORDER BY COUNT(*)  DESC
		)

ORDER BY employee_dept, salary DESC

-- fetch all the employees in top 2 dept with highest avg pay
SELECT * 
FROM employees
WHERE employee_dept IN 
		(
		SELECT TOP 2 employee_dept 
		FROM employees
		GROUP BY employee_dept
		ORDER BY AVG(salary)  DESC
		)


-- max salary of every department
SELECT employee_dept, 
	MAX(salary) AS max_sal
FROM employees
GROUP BY employee_dept
ORDER BY max_sal DESC

-- fetch top 2 employee dept based on maximum salary
SELECT *
FROM employees
WHERE employee_dept IN
			(
			SELECT TOP 2 employee_dept
			FROM employees
			GROUP BY employee_dept
			ORDER BY MAX(salary) DESC
			)
