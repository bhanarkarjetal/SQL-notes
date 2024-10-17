USE sql_wkday_20240228

-- you can excute the table in one querry and use it in other querry in the SAME database
-- FETCHING data from the table
SELECT * FROM employees

-- fetching all the records (rows) where the employee_dept == SD-DB
SELECT * FROM employees
WHERE employee_dept = 'SD-DB' 

-- fetching all the records (rows) where the salary > 50000
SELECT * FROM employees
WHERE salary > 50000

--fetch all records where employee word=ks in SD-DB dept and salary of the employee
-- should be greater than 50000
SELECT * FROM employees
WHERE employee_dept = 'SD-DB' 
AND salary > 50000

-- AND operator
--- condition1 AND condition2
--- TRUE and TRUE == TRUE then record will be displayed
--- TRUE and FALSE == FALSE, record will not be dsiplayed
--- FALSE and TRUE == FALSE, record will not be displayed
--- FLASE and FALSE == FALSE, record will not be displayed

-- fetch employee_dept = SD-DB or SD-WEB
SELECT * FROM employees
WHERE employee_dept = 'SD-DB' 
OR employee_dept = 'SD-WEB' 

-- OR operator
--- condition1 AND condition2
--- TRUE or TRUE == TRUE then record will be displayed
--- TRUE or FALSE == TRUE, record will be dsiplayed
--- FALSE or TRUE == TRUE, record will  be displayed
--- FLASE or FALSE == FALSE, record will not be displayed

-- NOT operator
-- fetch employee_dept is not SD-WEB 
SELECT * FROM employees
WHERE NOT employee_dept = 'SD-WEB' --OR employee_dept != 'SD-WEB'

--fetch employees whose employee_id is 200,250,275,300,375, 325, 350
SELECT * FROM employees
WHERE 
employee_id = 200
OR employee_id = 250
OR employee_id = 275
OR employee_id = 300
OR employee_id = 325
OR employee_id = 350
OR employee_id = 375

-- OR
SELECT * 
FROM 
	employees
WHERE
	employee_id IN (200,225,250,275,300)
	
SELECT *
FROM 
	employees
WHERE 
	employee_dept IN ('SD-DB', 'SD-WEB')

-- get employee whose substring has KUMAR in employee_id
SELECT *
FROM 
	employees
WHERE 
	employee_name LIKE '%Kumar%'
-- % is known as wild card character
-- % means 0 or more character
-- in this case there can be 0 or more character in the start or end of KUMAR

SELECT *
FROM 
	employees
WHERE 
	employee_name LIKE '%Arjun%'

-- fetch records with first name as ARJUN
SELECT *
FROM 
	employees
WHERE 
	employee_name LIKE 'Arjun%'

-- fetch records with LAST name as KUMAR
SELECT *
FROM 
	employees
WHERE 
	employee_name LIKE '%Kumar'

-- fetch employee name having three characters
SELECT *
FROM 
	employees
WHERE 
	employee_name LIKE '___%' -- three underscore

-- fetch employee last name having three characters
SELECT *
FROM 
	employees
WHERE 
	employee_name LIKE '% ___' -- three underscore

-- fetch employee middle name having three characters
SELECT *
FROM 
	employees
WHERE 
	employee_name LIKE '% ___ %' -- three underscore

-- fetch employees in SD-__ has two characters
SELECT *
FROM 
	employees
WHERE 
	employee_dept LIKE 'SD-__' 
AND
	salary > 100000

SELECT * FROM employees

-- by ORDER 
-- by default in ascending order
SELECT * FROM employees
ORDER BY employee_dept

SELECT * FROM employees
ORDER BY salary DESC -- in descending order

-- fetch list of all employees
--- having 4 lettered middle name
--- words in either SD-DB or SD-WEB department
--- order the resuly in descending salary

SELECT * FROM employees
WHERE
	employee_name LIKE '% ____ %'
AND 
	employee_dept IN ('SD-DB', 'SD-WEB')
ORDER BY salary DESC

--Solution 2
-- you can also put all the conDitions in brackets
SELECT * FROM employees
WHERE
	(employee_name LIKE '% ____ %') 
AND 
(	employee_dept = 'SD-DB'
	OR employee_dept = 'SD-WEB'
)
ORDER BY salary DESC

-- BETWEEN command
-- get records where salary is between 81119 and 150000
SELECT * FROM employees
WHERE
	(employee_name LIKE '% ____ %') 
AND 
(	employee_dept = 'SD-DB'
	OR employee_dept = 'SD-WEB'
)
AND 
(	salary BETWEEN 81119 AND 150000)
ORDER BY salary DESC

SELECT * FROM employees
WHERE 
	salary BETWEEN 66933 AND 113205 --includes both the numbers
ORDER BY 
	salary DESC

-- BETWEEN command works in the following way
SELECT * FROM employees
WHERE salary >= 66933 and salary <= 113205
ORDER BY salary DESC

-- Get all the employees whose employee_id is between 200 and 300
SELECT * FROM employees
WHERE employee_id BETWEEN 200 AND 300