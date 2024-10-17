-- USER DEFINED FUNCTION (UDF)
GO
CREATE OR ALTER FUNCTION fn_get_state_name
	(
		@address AS VARCHAR (100)
	)
RETURNS VARCHAR (100)
	AS
	BEGIN
		DECLARE @state_name AS VARCHAR (100)
		SELECT @state_name = TRIM(RIGHT(@address, 
		LEN(@address) - CHARINDEX(' ', @address))) 

		RETURN @state_name
	END

-- the above function returns a scalar value or a single value
-- hence these functions are called SCALAR valued function


SELECT *, [dbo].[fn_get_state_name](sales_location) AS state_name
FROM salesman

---------------------------------------------------------------------
GO
CREATE OR ALTER FUNCTION fn_get_city_name
	(
	@address AS VARCHAR (100)
	)
RETURNS VARCHAR (100)
	AS
		BEGIN
		DECLARE @city_name AS VARCHAR (100)
		SELECT @city_name = TRIM(LEFT(@address, CHARINDEX(',', @address) - 1))
		RETURN @city_name
	END

----------------------------------------------------------------------------
SELECT *, [dbo].[fn_get_city_name](sales_location) AS city_name
FROM salesman

SELECT *,
	dbo.fn_get_city_name (customers.customer_address),
	dbo.fn_get_state_name(customers.customer_address)
FROM
	customers

---------------------------------------------------------------------
SELECT *,
	DATENAME(DW, customer_dob) + ' ' +
	DATENAME(D, customer_dob) + ' ' +
	DATENAME(M, customer_dob) + ' ' +
	DATENAME(Y, customer_dob) AS detailed_dob

FROM customers

-- UDF
GO
CREATE OR ALTER FUNCTION fn_get_detailed_date
	(
	@date_value AS DATETIME
	)
	
	RETURNS NVARCHAR (100)

	AS
	   BEGIN
	   DECLARE @detailed_date_format VARCHAR(100)
	   SELECT @detailed_date_format = DATENAME(DW, @date_value) + ' ' +
									DATENAME(D, @date_value) +
									CASE
										WHEN DATENAME(D, @date_value) IN (1, 21, 31) THEN 'st'
										WHEN DATENAME(D, @date_value) IN (2,22) THEN 'nd'
										WHEN DATENAME(D, @date_value) IN (3, 23) THEN 'rd'
										ELSE 'th'
									END + 
									' ' +
									DATENAME(M, @date_value) + ' ' +
									DATENAME(Y, @date_value) 
		RETURN @detailed_date_format

	   END

SELECT *,
	[dbo].[fn_get_detailed_date](customer_dob) AS detailed_dob
FROM
	customers
---------------------------------------------------------------------

-- using nested if and elif condition
GO
CREATE OR ALTER FUNCTION fn_get_detailed_date
	(
	@date_value DATETIME
	)
	RETURNS NVARCHAR (100)
	AS
		BEGIN
			DECLARE @detailed_date_format VARCHAR (100),
					@suffix_val CHAR(2)
			SET @suffix_val = ''

			IF DATENAME(D,@date_value) IN (1, 21, 31)
				BEGIN
					SET @suffix_val = 'st'
				END
			ELSE IF DATENAME(D,@date_value) IN (2, 22)
				BEGIN
					SET @suffix_val = 'nd'
				END
			ELSE IF DATENAME(D,@date_value) IN (3, 23)
				BEGIN
					SET @suffix_val = 'rd'
				END
			ELSE
				BEGIN
					SET @suffix_val = 'th'
				END


		 SELECT @detailed_date_format = DATENAME(DW, @date_value) + ' ' +
									DATENAME(D, @date_value) +
									@suffix_val + ' ' +
									DATENAME(M, @date_value) + ' ' +
									DATENAME(Y, @date_value) 
		RETURN @detailed_date_format

	END

SELECT *,
	[dbo].[fn_get_detailed_date](customer_dob) AS detailed_dob
FROM
	customers

----------------------------------------------------------------------
DECLARE @avg_sal_dept TABLE
	( 
	department_name VARCHAR (40),
	average_salary DECIMAL(10,2)
	)

INSERT INTO	
	@avg_sal_dept
SELECT employees.employee_dept,
	AVG(employees.salary) AS avg_sal
FROM 
	employees
GROUP BY 
	employee_dept

SELECT employees.*,
	CASE
		WHEN salary > average_salary THEN 'HIGH SAL'
		ELSE 'LOW SAL'
	END AS salary_class
FROM
	@avg_sal_dept AS tab_1
INNER JOIN
	employees
ON
	employees.employee_dept = tab_1.department_name


