-- TABLE FUNCTION
-- who earn max salary in their respective department

DECLARE @max_sal_dept TABLE
	(
	department_name VARCHAR (40),
	max_salary DECIMAL (10,2)
	)

INSERT INTO @max_sal_dept
SELECT 
	employee_dept, MAX(salary) AS max_salary
FROM 
	employees
GROUP BY 
	employee_dept;

SELECT 
	employees.*
FROM
	employees
INNER JOIN 
	@max_sal_dept AS msd
ON 
	employees.employee_dept = msd.department_name 
AND 
	employees.salary = msd.max_salary

-- union of high-sal and low-sal employees based on average salary of the department
GO
DECLARE @avg_sal_dept TABLE
	(
	employee_id INT PRIMARY KEY
	, employee_name VARCHAR (100)
	, employee_dept VARCHAR (10)
	, salary DECIMAL (10,2)
	, avg_salary DECIMAL (10,2)
	, salary_classification VARCHAR (10)
	)

DECLARE @avg_salary DECIMAL(10,2)
SELECT 
	@avg_salary = AVG(salary*1.00) 
FROM 
	employees

INSERT INTO @avg_sal_dept
SELECT employee_id
	, employee_name
	, employee_dept	 
	, salary
	, @avg_salary AS avg_sal
	, 'High-sal' AS salary_class
FROM 
	employees
WHERE 
	salary > @avg_salary

INSERT INTO @avg_sal_dept
SELECT employee_id
	, employee_name
	, employee_dept	 
	, salary
	, @avg_salary AS avg_sal
	, 'Low-sal' AS salary_class
FROM 
	employees
WHERE 
	salary <= @avg_salary

SELECT * 
FROM 
	@avg_sal_dept
ORDER BY 
	salary

-----------------------------------------------------------------------------

-- TABLE FUNCTIONS: function output is a table
USE sql_wkday_20240228
GO
CREATE OR ALTER FUNCTION fn_abv_avg_sal_emp
	(
	@department_name VARCHAR(10)
	)
RETURNS TABLE
	AS
	RETURN
		SELECT *
			, (SELECT AVG(salary)*1.00 FROM 
				employees WHERE employee_dept = @department_name)
				AS avg_salary
		FROM
			employees
		WHERE
			salary > (SELECT AVG(salary)*1.00 FROM 
				employees WHERE employee_dept = @department_name)
		AND
			employee_dept = @department_name

SELECT * 
FROM 
	fn_abv_avg_sal_emp ('SD-DB')

DECLARE @emp_abv_sal TABLE
	(
	employee_id INT PRIMARY KEY
	, employee_name VARCHAR (100)
	, employee_email VARCHAR (100)
	, employee_dept VARCHAR (10)
	, salary DECIMAL (10,2)
	, dept_avg_sal DECIMAL (10,2)
	)

INSERT INTO @emp_abv_sal
SELECT * 
FROM 
	fn_abv_avg_sal_emp ('SD-DB')

--------------------------------------------------------------------------
-- find the top 10 employees whose salary 
-- is nearest to the average salary of the given department

GO
CREATE OR ALTER FUNCTION fn_get_emp_sal_near_avg_sal
	(
	@department_name VARCHAR (10)
	)
	RETURNS TABLE
	AS
		RETURN
		SELECT * 
		FROM
		(
		SELECT *, 
			DENSE_RANK () OVER (ORDER BY sal_diff ASC) AS sal_diff_rank
		FROM
			(
			SELECT *,
				ABS(salary - avg_sal) AS sal_diff	
			FROM
				(
				SELECT *,
					(
					SELECT AVG(salary) 
					FROM 
						employees
					WHERE 
						employee_dept = @department_name
					) AS avg_sal
				FROM 
					employees
				WHERE 
					employee_dept = @department_name
				) AS sub_q_1
			) AS sub_q_2
		) AS sub_q_3
		WHERE 
			sub_q_3.sal_diff_rank < = 10

SELECT * 
FROM 
	 fn_get_emp_sal_near_avg_sal('SD-DB')

-----------------------------------------------------------------------------
-- MULTI STATEMENT VALUED FUNCTION
GO
CREATE OR ALTER FUNCTION fn_classify_emps_dept
	(
	@department_name VARCHAR (20)
	)
RETURNS @t TABLE 
	(
	employee_id INT PRIMARY KEY
	,employee_name VARCHAR(100)
	,employee_dept_name VARCHAR(60)
	,salary INT
	,avg_sal_dept DECIMAL(10, 2)
	,salary_calssification VARCHAR (20)
	)


AS
	BEGIN
		INSERT INTO @t 
		SELECT 
			employee_id
			, employee_name
			, employee_dept
			, salary
			, avg_sal_dept.avg_sal			
			, 'High_sal' AS salary_classification
		FROM 
			employees
		CROSS JOIN
			(
			SELECT AVG(salary) AS avg_sal
			FROM employees 
			WHERE employee_dept = @department_name
			) AS avg_sal_dept
		WHERE 
			employee_dept = @department_name
		AND
			employees.salary > avg_sal_dept.avg_sal

		INSERT INTO @t 
		SELECT 
			employee_id
			, employee_name
			, employee_dept
			, salary
			, avg_sal_dept.avg_sal			
			, 'Low_sal' AS salary_classification
		FROM 
			employees
		CROSS JOIN
			(
			SELECT AVG(salary) AS avg_sal
			FROM employees 
			WHERE employee_dept = @department_name
			) AS avg_sal_dept
		WHERE 
			employee_dept = @department_name
		AND
			employees.salary <= avg_sal_dept.avg_sal


		RETURN
	END

SELECT * 
FROM 
	dbo.fn_classify_emps_dept('SD-WEB');

