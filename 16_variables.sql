-- ADVANCE SQL programming concepts

-- variable
DECLARE @location VARCHAR (40) -- Defines the location
SET @location = 'Jamshedpur' -- sets the value of location

SELECT @location -- shows in the form of result
PRINT @location -- shows in the form of message

-- while executing the variable, you have to select from the variable definition


-- practical use of variable
-- to find the employees with lower or higher salary than avg salary of employees

SELECT AVG(salary) FROM employees -- 80134

DECLARE @avg_salary INT
SET @avg_salary = 80134

SELECT *
	, 'high_sal' AS salary_class
FROM
	employees
WHERE
	salary> @avg_salary

UNION

SELECT *
	, 'low_sal' AS salary_class
FROM 
	employees
WHERE
	salary <= @avg_salary 

ORDER BY salary

--------------------------------------------------
DECLARE @avg_salary INT
SET 
	@avg_salary = (SELECT AVG(salary) FROM employees)

SELECT *
	, 'high_sal' AS salary_class
FROM
	employees
WHERE
	salary> @avg_salary

UNION

SELECT *
	, 'low_sal' AS salary_class
FROM employees
WHERE
	salary <= @avg_salary 

ORDER BY salary

-----------------------------------------------------------
-- create two variables containing the value of department name 
-- and avg salary of that department, and use these two variables 
-- to classify all the employees as high_sal or low_sal

DECLARE @dept_name VARCHAR(40)
SET @dept_name = 'SD-WEB'
DECLARE @avg_sal INT
SET @avg_sal = (SELECT AVG(salary) FROM employees		
					WHERE employee_dept = 'SD-WEB')

SELECT *, 'HIGH SALARY' AS salary_class
FROM employees
WHERE
	employee_dept = @dept_name
AND
	salary > @avg_sal

UNION

SELECT *, 'LOW SALARY' AS salary_class
FROM employees
WHERE
	employee_dept = @dept_name
AND
	salary <= @avg_sal

PRINT 'Average salary of the department ' + @dept_name + '= ' + 
		CAST(@avg_sal AS VARCHAR(10))

-- will have to convert @avg_sal to string first before 
-- concatenating in above statement
-- only strings can concatenate with each other


------------------------------------------------------------------
GO
DECLARE @dept_name VARCHAR(40)
SET @dept_name = 'SD-DB'
DECLARE @avg_sal INT
SET @avg_sal = (SELECT AVG(salary) FROM employees
					WHERE employee_dept = @dept_name)

SELECT *
		, CASE
		 WHEN 
			salary > @avg_sal
		THEN 'HIGH SAL' 
		ELSE 'LOW SAL'
		 END AS salary_class
FROM 
	employees
WHERE
	employee_dept = @dept_name
ORDER BY salary ASC

----------------------------------------------------------------------
-- set the valueof a variable using SELECT statement

DECLARE @max_salary INT
DECLARE @min_Salary INT
DECLARE @avg_salary INT

SELECT 
	@max_salary = MAX(salary)
	, @min_salary = MIN(Salary)
	, @avg_salary = AVG(salary)

FROM
	employees

PRINT @max_salary
PRINT @min_salary
PRINT @avg_salary

--------------------------------------------------------------
GO
DECLARE @dept_name VARCHAR (40)
DECLARE @top_sal_emp_name VARCHAR(MAX)

SET @top_sal_emp_name = ' '

SELECT TOP 10 
	@top_sal_emp_name = @top_sal_emp_name + employees.employee_name + '|'
FROM
	employees
ORDER BY salary

PRINT @top_sal_emp_name

---------------------------------------------------------------
-- STORED PROCEDURE: a prepared SQL code that you can save, so the code
-- can be reused over and over again
-- SYNTAX
 GO
 CREATE OR ALTER PROC sp_get_emps_gt_avg_sal
 AS
 BEGIN
	SELECT * FROM employees
	WHERE
		salary > (SELECT AVG(salary) FROM employees)
 END

 EXEC sp_get_emps_gt_avg_sal

 --------------------------------------------------------------------
 -- altering the existing stored proc from 
 -- database>programmability>stored procedure
 GO
 CREATE OR ALTER   PROC [dbo].[sp_get_emps_gt_avg_sal]
 AS
 BEGIN
	SELECT * FROM employees
	WHERE
		salary > (SELECT AVG(salary) FROM employees)
	ORDER BY 
		employee_dept, salary 
 END

 --------------------------------------------------------------------
 GO
 CREATE OR ALTER   PROC [dbo].[sp_get_emps_gt_avg_sal]
 AS
 BEGIN
	DECLARE @avg_salary INT
	SELECT @avg_salary = AVG(salary) FROM employees

	SELECT *,
			@avg_salary AS average_salary,
			CASE
				WHEN salary > @avg_salary THEN 'High Sal'
				ELSE 'Low Sal'
			END AS salary_class
	FROM employees
	 
	ORDER BY 
		employee_dept, salary 
 END

  EXEC sp_get_emps_gt_avg_sal
