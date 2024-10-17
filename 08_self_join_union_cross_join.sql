
USE sql_wkday_20240228


INSERT INTO employee_information_tab VALUES (1, 'Hari Nath Nair', 'SD-Report', 15,  39594)
INSERT INTO employee_information_tab VALUES (2, 'Sandeepan Guna Nair', 'SD-DB', NULL,  35758)
INSERT INTO employee_information_tab VALUES (3, 'Murali Subodh Iyer', 'SD-Web', 15,  44208)
INSERT INTO employee_information_tab VALUES (4, 'Vaidhya Bhisth Shetty', 'SD-MOBILE', 12,  51087)
INSERT INTO employee_information_tab VALUES (5, 'Govind Guna Iyer', 'SD-DB', NULL,  34245)

INSERT INTO employee_information_tab VALUES (6, 'Lohith Nath Singh', 'SD-Web', 8,  47740)
INSERT INTO employee_information_tab VALUES (7, 'Vaidhya Kumar Pal', 'SD-Web', 8,  34346)
INSERT INTO employee_information_tab VALUES (8, 'Hari Guna Nair', 'SD-Web', 4,  45565)
INSERT INTO employee_information_tab VALUES (9, 'Om Guna Yadav', 'SD-Report', 4,  32309)
INSERT INTO employee_information_tab VALUES (10, 'Anubhav Nath Ahir', 'SD-Web', 8,  43256)
INSERT INTO employee_information_tab VALUES (11, 'Vaidhya Kumar Singh', 'SD-MOBILE', 12,  39690)
INSERT INTO employee_information_tab VALUES (12, 'Anubhav Subodh Gupta', 'SD-MOBILE', 12,  41611)

INSERT INTO employee_information_tab VALUES (13, 'Vaidhya Subodh Pal', 'SD-DB', 8,  38615)
INSERT INTO employee_information_tab VALUES (14, 'Govind Kumar Mudalirajan', 'SD-Report', NULL,  34181)
INSERT INTO employee_information_tab VALUES (15, 'Govind Guna Mukherjee', 'SD-Web', NULL,  49409)
INSERT INTO employee_information_tab VALUES (16, 'Kishor Nandh Nair', 'SD-Report', 4,  39531)
INSERT INTO employee_information_tab VALUES (17, 'Anubhav Bhisth Gupta', 'SD-MOBILE', 12,  30180)
INSERT INTO employee_information_tab VALUES (18, 'Vaidhya Nandh Singh', 'SD-Report', 8,  40466)
INSERT INTO employee_information_tab VALUES (19, 'Hari Kumar Kumaran', 'SD-Web', NULL,  32687)
INSERT INTO employee_information_tab VALUES (20, 'Hari Kumar Shetty', 'SD-Web', 15,  48051)
INSERT INTO employee_information_tab VALUES (21, 'Anubhav Nath Nair', 'SD-MOBILE', 15,  43516)

INSERT INTO employee_information_tab VALUES (22, 'Om Bhisth Mukherjee', 'SD-Report', 8,  46940)
INSERT INTO employee_information_tab VALUES (23, 'Om Nath Singh', 'SD-Web', NULL,  35956)
INSERT INTO employee_information_tab VALUES (24, 'Govind Bhisth Gupta', 'SD-Web', 4,  35355)
INSERT INTO employee_information_tab VALUES (25, 'Kishor Kumar Yadav', 'SD-DB', 12,  47456)
INSERT INTO employee_information_tab VALUES (26, 'Abhinav Gupt Pal', 'SD-MOBILE', 15,  35849)
INSERT INTO employee_information_tab VALUES (27, 'Krishna Nath Mudaliar', 'SD-DB', 8,  38412)
INSERT INTO employee_information_tab VALUES (28, 'Kishor Guna Singh', 'SD-DB', 8,  35731)
INSERT INTO employee_information_tab VALUES (29, 'Anubhav Guna Nair', 'SD-Web', 4,  36454)

INSERT INTO employee_information_tab VALUES (30, 'Murali Nath Singh', 'SD-DB', 12,  43509)


SELECT * FROM employee_information_tab
ORDER BY salary

SELECT * FROM employee_information_tab

-- Fetch the employee and the manager information 
-- as a single resultset

-- SELF JOIN: joining table with itself
SELECT 
	emp.employee_id AS employee_id
	, emp.emp_name AS employee_name
	, emp.dept_id AS employee_dept
	, emp.salary AS employee_salary
	, mgr.employee_id AS manager_id
	, mgr.emp_name AS manager_name
	, mgr.dept_id AS manager_dept
	, mgr.salary AS manager_salary
FROM
	employee_information_tab AS emp
INNER JOIN
	employee_information_tab AS mgr
ON 
	emp.manager_id = mgr.employee_id

-- find all the employees whose salary os greater than their manager's salary
SELECT 
	emp.employee_id AS employee_id
	, emp.emp_name AS employee_name
	, emp.dept_id AS employee_dept
	, emp.salary AS employee_salary
	, mgr.employee_id AS manager_id
	, mgr.emp_name AS manager_name
	, mgr.dept_id AS manager_dept
	, mgr.salary AS manager_salary
FROM
	employee_information_tab AS emp
INNER JOIN
	employee_information_tab AS mgr
ON 
	emp.manager_id = mgr.employee_id
AND
	emp.salary > mgr.salary

-- find all the employees who work in the same department as their managers
SELECT 
	emp.employee_id AS employee_id
	, emp.emp_name AS employee_name
	, emp.dept_id AS employee_dept
	, emp.salary AS employee_salary
	, mgr.employee_id AS manager_id
	, mgr.emp_name AS manager_name
	, mgr.dept_id AS manager_dept
	, mgr.salary AS manager_salary
FROM
	employee_information_tab AS emp
INNER JOIN
	employee_information_tab AS mgr
ON 
	emp.manager_id = mgr.employee_id
AND
	emp.dept_id = mgr.dept_id

-- find all the employees who work in the same department as their managers
-- and have salary greater than their managers

SELECT 
	emp.employee_id AS employee_id
	, emp.emp_name AS employee_name
	, emp.dept_id AS employee_dept
	, emp.salary AS employee_salary
	, mgr.employee_id AS manager_id
	, mgr.emp_name AS manager_name
	, mgr.dept_id AS manager_dept
	, mgr.salary AS manager_salary
FROM
	employee_information_tab AS emp
INNER JOIN
	employee_information_tab AS mgr
ON 
	emp.manager_id = mgr.employee_id
WHERE
	emp.salary > mgr.salary
AND
	emp.dept_id = mgr.dept_id


-- find all the employees whose salary is greater 
--than the average salary of all the managers

-- STEPS
	-- get the list of managers
	-- calculate avg salary of the managers
	-- use avg salary to compare salary of employees

SELECT DISTINCT manager_id FROM employee_information_tab 
-- gives disctinct values of the column


-- STEP 1: find all the managers from the table
SELECT * 
FROM
	employee_information_tab
WHERE
	employee_id IN (SELECT DISTINCT manager_id 
					FROM employee_information_tab )

-- STEP 2: find the average salary of the manager table (above table in step 1)
SELECT AVG(salary)
FROM
	employee_information_tab
WHERE
	employee_id IN (SELECT DISTINCT manager_id 
					FROM employee_information_tab )

-- STEP 3: compare the salares of all the employees
SELECT * 
FROM
	employee_information_tab
WHERE
	salary>
	(
	SELECT AVG(salary)
	FROM
		employee_information_tab
	WHERE
		employee_id IN (SELECT DISTINCT manager_id 
						FROM employee_information_tab )
	)

-- find all the employees who do not have direct reportees 
-- (employees who are not managers)
SELECT * 
FROM
	employee_information_tab
WHERE
	employee_id NOT IN 
		(SELECT DISTINCT manager_id 
		FROM 
			employee_information_tab
		WHERE manager_id IS NOT NULL)

-- UNION and UNION ALL
SELECT * FROM employees

SELECT 
	employee_name
	, employee_dept
	, salary
FROM employees
WHERE
	employee_dept = 'SD-WEB'

-- UNION: concatenate two tables and gives a combine table
-- RULES: no duplicates in the output
--		: number of columns in both the tables should be same
--		: datatype of columns from each resultset should be same
SELECT 
	employee_name
	, employee_dept
	, salary
FROM employees
WHERE
	employee_dept = 'SD-WEB'

UNION

SELECT 
	employee_name
	, employee_dept
	, salary
FROM employees
WHERE
	employee_dept = 'SD-REPORT'

-- UNION ALL : allows duplicate values
SELECT 'SQL' AS progamming_name, 'FUN' as language_name
UNION ALL 
SELECT 'SQL' AS first_name, 'FUN' as last_name
-- it will retain the column name of first table


-- find the top 10 eployees with the highest salaries in the entire organization
-- and the top 10 employees of SD-WEB departement who earns the highest salary in SD_WEB dept
SELECT * 
FROM
(
SELECT TOP 10 *
FROM 
	employees
ORDER BY salary DESC
) AS top_emp_company

UNION ALL
(
SELECT TOP 10 *
FROM 
	employees
WHERE
	employee_dept = 'SD-WEB'
--ORDER BY salary DESC
)

-- Find all the employees whose salary is greater than the average salary of the entire company
SELECT * , 
	(SELECT AVG(salary) FROM employees) as avg_sal,
		'High_sal' AS salary_classification

FROM 
	employees
WHERE 
salary > (SELECT AVG(salary) FROM employees)



-- Find all the employees whose salary is less than the average salary of the entire company
SELECT * , 
	(SELECT AVG(salary) FROM employees) AS avg_sal, 
	'Low_sal' AS salary_classification
FROM 
	employees
WHERE 
salary <= (SELECT AVG(salary) FROM employees)


-- UNION of two

SELECT * , 
	(SELECT AVG(salary) FROM employees) as avg_sal,
		'High_sal' AS salary_classification

FROM 
	employees
WHERE 
salary > (SELECT AVG(salary) FROM employees)

UNION

SELECT * , 
	(SELECT AVG(salary) FROM employees) AS avg_sal, 
	'Low_sal' AS salary_classification
FROM 
	employees
WHERE 
salary <= (SELECT AVG(salary) FROM employees)

-- SUBQUERY can also be a part of select command


-- find the average salary of high_sal employees
SELECT AVG(salary) FROM
(
SELECT * , 
	(SELECT AVG(salary) FROM employees) as avg_sal,
		'High_sal' AS salary_classification

FROM 
	employees
WHERE 
salary > (SELECT AVG(salary) FROM employees)
) AS table_1

-- CROSS JOIN
-- CROSS JOINS?

DROP TABLE IF EXISTS sports;
CREATE TABLE sports
(
	sport_id INT PRIMARY KEY IDENTITY(1,1)
	,sport_name VARCHAR(100) NOT NULL
);

DROP TABLE IF EXISTS kids
CREATE TABLE kids
(
	kid_id INT PRIMARY KEY IDENTITY(1,1)
	,kid_name VARCHAR(100)
	,sport_id INT NOT NULL
	,FOREIGN KEY(sport_id) REFERENCES sports(sport_id)
);

INSERT INTO sports
(sport_name)
VALUES
('Cricket')
,('Hockey')
,('Badminton')
,('Football')
,('Table Tennis');


INSERT INTO kids
(kid_name, sport_id)
VALUES
('Ramana', 1),
('Nikhila', 3),
('Pradeep', 4);

SELECT * FROM sports;
SELECT * FROM kids;

--- CROSS JOIN is also known as CARTESIAN join
--- CROSS JOIN: joins each row of table 1 with each row of table 2

