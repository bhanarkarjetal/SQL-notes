GO
DECLARE employee_cursor CURSOR
FOR
	SELECT 
		employee_id
		, employee_name
		, employee_dept
		, salary
	FROM
		employees
	WHERE 
		employee_dept = 'SD-Web'
	ORDER BY salary DESC

OPEN employee_cursor
FETCH NEXT FROM employee_cursor
WHILE
	@@FETCH_STATUS = 0
	BEGIN
		FETCH NEXT FROM employee_cursor
	END
CLOSE employee_cursor
DEALLOCATE employee_cursor

-------------------------------------------------------------------------
-- SAVING IT IN VARIABLES
GO
DECLARE @employee_id INT 
DECLARE @employee_name VARCHAR (100)
DECLARE @employee_department_name VARCHAR (10)
DECLARE @employee_salary INT 

DECLARE @average_salary INT
SELECT 
	@average_salary = AVG(salary) 
FROM 
	employees
WHERE 
	employee_dept = 'SD-Web'

DECLARE employee_cursor CURSOR
FOR
	SELECT 
		employee_id
		, employee_name
		, employee_dept
		, salary
		, @average_salary
	FROM
		employees

OPEN employee_cursor

FETCH NEXT FROM employee_cursor
	INTO 
		@employee_id
		, @employee_name
		, @employee_department_name
		, @employee_salary
		, @average_salary

WHILE 
	@@FETCH_STATUS = 0
	BEGIN
		PRINT 
		CAST (@employee_id AS VARCHAR(3)) + 
		' ' + @employee_name +
		' ' + @employee_department_name +
		' ' + CAST(@employee_salary AS VARCHAR (10)) + 
		' ' + CASE	
				WHEN @employee_salary > @average_salary THEN 'High_sal'
				ELSE 'Low_Sal'
			  END 

		FETCH NEXT FROM employee_cursor
		INTO 
			@employee_id
			, @employee_name
			, @employee_department_name
			, @employee_salary
			, @average_salary
	END

CLOSE employee_cursor
DEALLOCATE employee_cursor

-------------------------------------------------------------------------------
-- use stored proc with cursor
GO
CREATE OR ALTER PROC sp_get_employee_salary_status_msg
	(
	@employee_id INT
	, @employee_name VARCHAR (40)
	, @employee_dept VARCHAR (10)
	, @employee_salary INT
	, @salary_status_message VARCHAR (400) OUTPUT
	)
AS
	BEGIN
	DECLARE @avg_sal DECIMAL(10,2)
	DECLARE @sal_stats_message VARCHAR (200)
	DECLARE @final_message VARCHAR (400)

	SELECT 
		@avg_sal = AVG(salary) FROM employees 
	WHERE 
		employee_dept = @employee_dept

	IF @employee_Salary > @avg_sal
	
		BEGIN
			SET @sal_stats_message = 'Salary of ' + @employee_name + ' is greater than 
								the average salary of the department'
		END
	ELSE
		BEGIN
			SET @sal_stats_message = 'Salary of ' + @employee_name + ' is lower than or equal to the average salary of the department'
		END

SET @final_message =  'Employee id = ' 
					+ CAST(@employee_id AS CHAR(3)) + ' '+
					'Name = ' + @employee_name + ' '+
					'Department = ' + @employee_dept + ' ' +
					'Salary = '+ 
					CAST(@employee_salary AS VARCHAR(10)) 
					+ ' '+
					'Average sal of department = ' +
					CAST(@avg_sal AS VARCHAR(10))
					+ ' ' + @sal_stats_message

SET @salary_status_message = @final_message

END

GO
DECLARE @employee_id INT
DECLARE @employee_name VARCHAR(100)
DECLARE @employee_department_name VARCHAR(30)
DECLARE @employee_salary INT
DECLARE @average_salary DECIMAL(10, 2)
DECLARE @emp_salary_status_msg AS VARCHAR(400)
 
DECLARE employee_cursor CURSOR
	FOR
		SELECT employee_id
				,employee_name
				,employee_dept
				,salary
		FROM
			employees
		WHERE
			employee_dept = 'SD-Web'
		ORDER BY
			salary DESC

OPEN employee_cursor

		FETCH NEXT FROM employee_cursor
			INTO	
				@employee_id
				,@employee_name
				,@employee_department_name
				,@employee_salary
				

		WHILE @@FETCH_STATUS = 0
			
		BEGIN

			EXEC sp_get_employee_salary_status_msg 
				@employee_id = @employee_id
				,@employee_name = @employee_name
				,@employee_dept = @employee_department_name
				,@employee_salary = @employee_salary
				,@salary_status_message  = @emp_salary_status_msg OUTPUT

			PRINT @emp_salary_status_msg
			
			FETCH NEXT FROM employee_cursor
				INTO	
					@employee_id
					,@employee_name
					,@employee_department_name
					,@employee_salary
					
			END

CLOSE employee_cursor
DEALLOCATE employee_cursor