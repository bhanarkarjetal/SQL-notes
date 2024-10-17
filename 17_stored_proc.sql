--to pass input parameters to a stored proc
-- take department name and number of employees from the user
GO
CREATE OR ALTER PROC sp_fetch_top_records_from_dept
	@department_name VARCHAR(50), @number_of_emps INT
AS
	BEGIN
		WITH emp_sal_rank
		AS
		(
		SELECT *, DENSE_RANK() OVER(ORDER BY salary DESC) AS salary_rank
		FROM
			employees
		WHERE 
			employee_dept = @department_name
		) 
		SELECT *
		FROM 
			emp_sal_rank
		WHERE
			salary_rank <= @number_of_emps
	END

EXEC sp_fetch_top_records_from_dept @department_name = 'SD-Web',
									@number_of_emps = 5

-- default parameters values
GO
CREATE OR ALTER PROC sp_fetch_top_records_from_dept
	@department_name VARCHAR(50), 
	@number_of_emps INT = 5 -- default value
AS
	BEGIN
		WITH emp_sal_rank
		AS
		(
		SELECT *, DENSE_RANK() OVER(ORDER BY salary DESC) AS salary_rank
		FROM
			employees
		WHERE 
			employee_dept = @department_name
		) 
		SELECT *
		FROM 
			emp_sal_rank
		WHERE
			salary_rank <= @number_of_emps
	END

EXEC sp_fetch_top_records_from_dept @department_name = 'SD-Web'

EXEC sp_fetch_top_records_from_dept @department_name = 'SD-Report',
									@number_of_emps = 3

GO
CREATE OR ALTER PROC sp_salary_class
	(@department_name VARCHAR(50),
	@avg_sal DECIMAL(10,2) )
		
AS
	BEGIN
		SELECT * ,
			@avg_sal AS threshold_sal,
			CASE
				WHEN 
					salary >= @avg_sal
				THEN 'High_sal'
				ELSE 'Low_sal'
			END AS class_salary
		FROM
			employees
		WHERE
			employee_dept = @department_name
	END

GO
DECLARE @dept_name VARCHAR (50)
SET @dept_name = 'SD-Web'
DECLARE @average_salary INT
SELECT 
	@average_salary = AVG(salary) 
FROM 
	employees
WHERE 
	employee_dept = @dept_name
SET @average_salary = @average_salary*1.20


EXEC sp_salary_class @department_name = @dept_name, @avg_sal = @average_salary

------------------------------------------------------------------------------
-- Stored proc that takes input parameter and returns one or more output parameters
GO
CREATE OR ALTER PROC sp_dept_stats
	(@department_name VARCHAR(50)
	, @max_salary INT OUTPUT
	, @min_salary INT OUTPUT
	, @avg_salary INT OUTPUT
	, @emp_count INT OUTPUT)
	AS
		BEGIN
		-- Declare local variables
		DECLARE @max_sal_local INT
		DECLARE @min_sal_local INT
		DECLARE @avg_sal_local INT
		DECLARE @emp_count_local INT

		SELECT 
			@max_sal_local = MAX(salary)
			, @min_sal_local = MIN(salary)
			, @avg_sal_local = AVG(salary)
			, @emp_count_local = COUNT(employee_id)

		FROM 
			employees
		WHERE
			employee_dept = @department_name

		-- unloading the values of local variables
		SET @max_salary = @max_sal_local
		SET @min_salary = @min_sal_local
		SET @avg_salary = @avg_sal_local
		SET @emp_count = @emp_count_local
		END

-- unloading the values into output parameters
DECLARE @max_s INT
DECLARE @min_s INT
DECLARE @avg_s INT
DECLARE @emp_cnt INT

EXEC 
		sp_dept_stats
				@department_name = 'SD-WEB'
				,@max_salary = @max_s OUTPUT
				,@min_salary = @min_s OUTPUT
				,@avg_salary = @avg_s OUTPUT
				,@emp_count =  @emp_cnt OUTPUT

SELECT @max_s, @min_s, @avg_s, @emp_cnt

SELECT *
FROM
	employees
WHERE
	employee_dept = 'SD-WEB'
AND
	salary = @max_s;

SELECT *
FROM
	employees
WHERE
	employee_dept = 'SD-WEB'
AND
	salary = @min_s

----------------------------------------------------------------------------
-- Get the average salary of all employees of a specified dept classified as LOW SALARY
-- Get the average salary of all the employees of a specified dept as HIGH SALARY

GO
CREATE OR ALTER PROC sp_avg_sal_emp_class
				(
					@department_name AS VARCHAR(40)
					,@avg_low_sal AS DECIMAL(10, 2) OUTPUT
					,@avg_high_sal AS DECIMAL(10, 2) OUTPUT
				)
	AS

		BEGIN
			-- First calculate the AVG salary of the department
			-- because we wil use the AVG SAL to classify 
			-- every emp as High or Low sal
			DECLARE @avg_sal AS DECIMAL(10, 2)
			SELECT @avg_sal = AVG(salary)
			FROM
				employees
			WHERE
				employee_dept = @department_name
			PRINT @avg_sal --- code works till here

			DECLARE @avg_low_sal_local AS DECIMAL(10, 2)
			DECLARE @avg_high_sal_local AS DECIMAL(10, 2);

			WITH emp_sal_class
			AS
			(
			SELECT *
					, CASE
						WHEN salary > @avg_sal THEN 'High Salary'
						ELSE 'Low Salary'
					  END AS salary_class
			FROM
				employees
			WHERE
				employee_dept = @department_name
			)

			-- USE the CTE created above to find the average salary of each sal class
			
			SELECT @avg_low_sal_local = AVG(salary)
			FROM
			emp_sal_class
			WHERE
				salary_class = 'Low Salary' ;


		 WITH emp_sal_class_new
			AS
			(
			SELECT *
					, CASE
						WHEN salary > @avg_sal THEN 'High Salary'
						ELSE 'Low Salary'
					  END AS salary_class
			FROM
				employees
			WHERE
				employee_dept = @department_name
			)

			SELECT @avg_high_sal_local = AVG(salary)
			FROM
			emp_sal_class_new
			WHERE
				salary_class = 'High Salary'

			SET @avg_low_sal = @avg_low_sal_local
			SET @avg_high_sal = @avg_high_sal_local
		END

DECLARE @avg_h_sal AS DECIMAL(10, 2)
DECLARE @avg_l_sal AS DECIMAL(10, 2)


EXEC sp_avg_sal_emp_class @department_name = 'SD-WEB'
							,@avg_low_sal = @avg_l_sal OUTPUT
							,@avg_high_sal = @avg_h_sal  OUTPUT

SELECT @avg_l_sal , @avg_h_sal

---------------------------------------------------------------------------------
-- USING TEMP TABLE: it is a temporary table used to store data temprarily
-- it gets destroyed once the query is closed
GO
CREATE OR ALTER PROC sp_avg_sal_emp_class
				(
					@department_name AS VARCHAR(40)
					,@avg_low_sal AS DECIMAL(10, 2) OUTPUT
					,@avg_high_sal AS DECIMAL(10, 2) OUTPUT
				)
	AS

		BEGIN
			-- First calculate the AVG salary of the department
			-- because we wil use the AVG SAL to classify every emp as High or Low sal
			DECLARE @avg_sal AS DECIMAL(10, 2)
			SELECT @avg_sal = AVG(salary)
			FROM
				employees
			WHERE
				employee_dept = @department_name
			PRINT @avg_sal --- code works till here

			DECLARE @avg_low_sal_local AS DECIMAL(10, 2)
			DECLARE @avg_high_sal_local AS DECIMAL(10, 2);

			SELECT *
					, CASE
						WHEN salary > @avg_sal THEN 'High Salary'
						ELSE 'Low Salary'
					  END AS salary_class
						
							INTO #temp_table
			FROM
				employees
			WHERE
				employee_dept = @department_name
			

			
			SELECT @avg_low_sal_local = AVG(salary)
			FROM
			#temp_table
			WHERE
				salary_class = 'Low Salary';


			SELECT @avg_high_sal_local = AVG(salary)
			FROM
			#temp_table
			WHERE
				salary_class = 'High Salary'

			SET @avg_low_sal = @avg_low_sal_local
			SET @avg_high_sal = @avg_high_sal_local
		END

DECLARE @avg_h_sal AS DECIMAL(10, 2)
DECLARE @avg_l_sal AS DECIMAL(10, 2)


EXEC sp_avg_sal_emp_class @department_name = 'SD-WEB'
							,@avg_low_sal = @avg_l_sal OUTPUT
							,@avg_high_sal = @avg_h_sal  OUTPUT

SELECT @avg_l_sal , @avg_h_sal


