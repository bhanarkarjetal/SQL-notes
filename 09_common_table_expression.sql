-- COMMON TABLE EXPRESSION (CTE)

-- fetch the employees who earn the maximum salary in their respective department

SELECT
	emp.*
FROM
(
SELECT employee_dept, MAX(salary) as max_sal
FROM 
	employees
GROUP BY 
	employee_dept
) AS dept_max_sal
INNER JOIN
employees AS emp
ON 
	dept_max_sal.employee_dept = emp.employee_dept
AND
	dept_max_sal.max_sal = emp.salary
	
-- Steps to create a common table expression
-- STEP 1>> Create a common table

-----------------------------------------
WITH -- CTE starts with this syntax
	dept_max_sal
	AS
	(
		SELECT employee_dept, MAX(salary) as max_sal
		FROM 
			employees
		GROUP BY 
			employee_dept
	) 
SELECT * FROM dept_max_sal -- a common table is created with a name dept_max_sal
-----------------------------------------
-- the above query is called as batch
-- we cannot run the common table with running batch along with it
-- CTE makes the code easier to read and execute without writing the subquery again and again

GO
WITH -- CTE starts with this syntax
	dept_max_sal
	AS
	(
		SELECT employee_dept, MAX(salary) as max_sal
		FROM 
			employees
		GROUP BY 
			employee_dept
	) 
SELECT * 
FROM 
	dept_max_sal 
INNER JOIN	
	employees	
ON
	dept_max_sal.max_sal = employees.salary
AND
	dept_max_sal.employee_dept = employees.employee_dept


-- find the employees earning minimum salary in their respective department

WITH -- CTE starts with this syntax
	dept_min_sal
	AS
	(
		SELECT employee_dept, MIN(salary) as min_sal
		FROM 
			employees
		GROUP BY 
			employee_dept
	) 
SELECT employees.* 
FROM 
	dept_min_sal 
INNER JOIN	
	employees	
ON
	dept_min_sal.min_sal = employees.salary
AND
	dept_min_sal.employee_dept = employees.employee_dept

-- find all the employees who earn more than the avg salary of their respective department
WITH
	dept_avg_sal
	AS
	(
		SELECT employee_dept, AVG(salary) as avg_sal
		FROM 
			employees
		GROUP BY 
			employee_dept
	) 
SELECT employees.*, dept_avg_sal.avg_sal
FROM 
	dept_avg_sal 
INNER JOIN	
	employees	
ON
	dept_avg_sal.avg_sal < employees.salary
AND
	dept_avg_sal.employee_dept = employees.employee_dept

-- any employee who get lower than 80% of the avg salary is classified as low_sal
-- who get between 80-150% as avg_sal
-- who get above 150% as high_sal

WITH
	dept_avg_sal
	AS
	(
		SELECT employee_dept, AVG(salary) as avg_sal
		FROM 
			employees
		GROUP BY 
			employee_dept
	) 
	
SELECT employees.*, dept_avg_sal.avg_sal,
		CASE
		WHEN
			employees.salary < 0.8* dept_avg_sal.avg_sal
		THEN 'low_sal'
		WHEN	
			employees.salary BETWEEN 0.8*dept_avg_sal.avg_sal
				AND 1.5*dept_avg_sal.avg_sal
		THEN 'avg_sal'
		ELSE 'high_sal' 
		END as classify_sal
			
FROM 
	dept_avg_sal 
INNER JOIN	
	employees	
ON
	dept_avg_sal.employee_dept = employees.employee_dept


-- employees getting salary less than the avg salary should be classified as low_sal
-- and employees getting salary greater than avg salary as high_sal using UNION
WITH
	dept_avg_sal
	AS
	(
		SELECT employee_dept, AVG(salary) as avg_sal
		FROM 
			employees
		GROUP BY 
			employee_dept
	) 
	
SELECT employees.*, dept_avg_sal.avg_sal, 'low_sal' AS salary_class
FROM 
	dept_avg_sal 
INNER JOIN	
	employees	
ON
	dept_avg_sal.avg_sal > employees.salary
AND
	dept_avg_sal.employee_dept = employees.employee_dept

UNION

SELECT employees.*, dept_avg_sal.avg_sal, 'high_sal' AS salary_class
FROM 
	dept_avg_sal 
INNER JOIN	
	employees	
ON
	dept_avg_sal.avg_sal < employees.salary
AND
	dept_avg_sal.employee_dept = employees.employee_dept

-- find avg salary of high_sal people and avg sal of low_sal people of their respective department

WITH
	dept_avg_sal
AS
	(
	SELECT employee_dept, AVG(salary) AS avg_sal
	FROM
		employees
	GROUP BY
		employee_dept
	),
-- creating another common table expression using previous CTE
emp_class_tab
AS
(
SELECT employees.*, dept_avg_sal.avg_sal, 'low_sal' AS salary_class
FROM 
	dept_avg_sal 
INNER JOIN	
	employees	
ON
	dept_avg_sal.avg_sal > employees.salary
AND
	dept_avg_sal.employee_dept = employees.employee_dept

UNION

SELECT employees.*, dept_avg_sal.avg_sal, 'high_sal' AS salary_class
FROM 
	dept_avg_sal 
INNER JOIN	
	employees	
ON
	dept_avg_sal.avg_sal < employees.salary
AND
	dept_avg_sal.employee_dept = employees.employee_dept
)

SELECT salary_class, employee_dept, AVG(salary) AS avg_sal
-- you dont have to mention the table name while writing table's column name of CTE
FROM
	emp_class_tab
GROUP BY
	salary_class, employee_dept

-- get all the employees from SD-DB dept who earns more than the avg salary of SD-DB dept
GO
WITH
	dept_avg_sal
AS
	(
	SELECT employee_dept, AVG(salary) AS avg_sal
	FROM
		employees
	GROUP BY
		employee_dept
	)
SELECT * FROM dept_avg_sal
INNER JOIN
employees
ON
	employees.employee_dept = 'SD-DB'
AND
	employees.salary> dept_avg_sal.avg_sal
 
 -- Get the top 10 employees from the above table based on their salary

 WITH
	dept_avg_sal
AS
	(
	SELECT employee_dept, AVG(salary) AS avg_sal
	FROM
		employees
	GROUP BY
		employee_dept
	),

db_above_avg_sal
AS
(
SELECT employees.*, dept_avg_sal.avg_sal
FROM 
	dept_avg_sal
INNER JOIN
	employees
ON
	employees.employee_dept = 'SD-DB'
AND
	employees.salary > dept_avg_sal.avg_sal
)

SELECT top 10 * FROM db_above_avg_sal

