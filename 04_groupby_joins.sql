-- Mentioning the database name before starting to write the query 
USE sql_wkday_20240228

SELECT * 
FROM employees
ORDER BY employee_dept, -- by default in ascending order
	salary DESC --within employee_dept, order by salary in descending order

-- AGGREGATE function: min(), max(), sum(), avg(), count()
	
-- what is the maximum salary in the entire organisation
SELECT MAX (salary) AS max_salary -- giving column name as max_salary
FROM employees;

-- what is the minimum salary in the entire organisation
SELECT MIN(salary) AS min_salary
FROM employees

-- Calculating sum of salary of the employee table. 
SELECT SUM(salary) AS sum_salary
FROM employees
-- this will give a single column named sum_salary and single row with 'sum of salary' amount

-- what is the total number of rows in the table
SELECT COUNT(*) AS total_employees
FROM employees -- counts total number of rows from employees table

-- what is the difference between count(*) and coulumn (column_name)
DROP TABLE IF EXISTS dummy_person

CREATE TABLE dummy_person
(
	person_name VARCHAR(10),
	person_age INT,
	person_salary INT
)
INSERT INTO dummy_person
VALUES
	('Ramana', 20, 55000),
	('Harini', 4, 65000),
	('Deepak', NULL, NULL)

SELECT *
FROM dummy_person

SELECT COUNT(*) AS number_of_records
FROM dummy_person

SELECT COUNT(person_name) AS number_of_names 
FROM dummy_person

SELECT COUNT(person_age) AS count_person_age
FROM dummy_person

SELECT COUNT(person_salary) AS count_person_salary
FROM dummy_person

INSERT INTO dummy_person
VALUES
	(NULL, NULL,  NULL),
	(NULL, NULL,  NULL),
	(NULL, NULL,  NULL)

SELECT COUNT(*) AS number_of_records
FROM dummy_person

-- count * will return the number of rows, count(column_name) will give number of non-null values of the column
SELECT COUNT (*)
FROM employees

-- it is always recommended to use COUNT on primary keys to getthe total number of rows as primary key does not have NULL values
SELECT COUNT (employee_id) AS total_employees 
FROM employees

-- what is the highest salary in the SD_DB department
SELECT AVG(salary) AS avg_sal_SD_DB
FROM employees
WHERE employee_dept = 'SD-DB'

-- Get the avg salary of each department
-- GROUP BY function
SELECT employee_dept, 
	AVG(salary) AS dept_avg_salary -- finds avg salary of those dept
FROM employees-- from employee table
GROUP BY employee_dept -- groups the department

SELECT employee_dept, 
	MAX(salary) AS dept_max_salary -- finds avg salary of those dept
FROM employees-- from employee table
GROUP BY employee_dept -- groups the department

SELECT employee_dept, 
	COUNT(*) AS employee_Count
FROM employees
GROUP BY employee_dept

-- order by the employee count
SELECT employee_dept, 
	COUNT (*) AS employee_Count
FROM employees
GROUP BY employee_dept
ORDER BY employee_Count DESC


-- ORDER OF EXECUTION
-- get the name of depts where the number of employee is greater than 75
SELECT employee_dept, -- step 6
	MAX(salary) -- step 3
	AS max_salary -- step 4
FROM employees -- step 1
GROUP BY employee_dept -- step 2
ORDER BY max_salary DESC -- step 5


-- find the top two depts which hvae the highest avg salary
SELECT TOP 2 employee_dept,
	AVG(salary) AS avg_salary 
FROM employees 
GROUP BY employee_dept 
ORDER BY avg_salary 

--OR: when you dont need the avg salary column
SELECT TOP 2 employee_dept
FROM employees 
GROUP BY employee_dept 
ORDER BY AVG(salary) 

SELECT TOP 5 employee_name, 
	employee_dept, 
	salary 
FROM employees

SELECT employee_dept,
	MAX(salary) AS max_salary
FROM employees
GROUP BY employee_dept
HAVING MAX(salary) > 300000
ORDER BY max_salary DESC


-- FETCHING data from multiple tables
-- JOIN two tables having foreign key in common

select * from new_students4
select * from courses

-- INNER JOIN (getting matching reords from both the tables)
SELECT * 
FROM new_students4
INNER JOIN courses
ON courses.course = new_students4.course_id
-- course column for courses table and course_id column from new_students4 table
-- the first table mentioned in the query is the left table and the next table follows the right side

-- select particular columns from both the tables
SELECT new_students4.student_id,
	 new_students4.student_name,
	 new_students4.phone,
	 courses.course,
	 courses.hod
FROM new_students4
INNER JOIN courses
ON courses.course = new_students4.course_id


-- fetch ALL THE COURSES that the college provides
-- and matching number of students in each course
SELECT * 
FROM courses 
LEFT OUTER JOIN new_students4
ON courses.course = new_students4.course_id


-- fetching name of courses where no students have enrolled
SELECT courses.course, 
	courses.course
FROM courses 
LEFT OUTER JOIN new_students4
ON courses.course = new_students4.course_id
WHERE new_students4.student_id IS NULL
-- output: in this case there is no such row, hence empty column

SELECT * FROM courses 
INSERT INTO courses
VALUES 
	('CVL', 'Civil engineering','Raghvendra Kumar'),
	('MEC', 'MEchanical engineering', 'Nanjappa Moily')

SELECT courses.course, 
	courses.course
FROM courses 
LEFT OUTER JOIN new_students4
ON courses.course = new_students4.course_id
WHERE new_students4.student_id IS NULL

-- count the number of students
SELECT courses.course,
	courses.course_name, 
	COUNT(new_students4.student_id) AS num_of_students
FROM courses 
LEFT OUTER JOIN new_students4
ON courses.course = new_students4.course_id
GROUP BY courses.course, 
	courses.course_name


 SELECT courses.course, 
	courses.course_name, 
	COUNT(new_students4.student_id) AS num_of_students
FROM courses 
LEFT OUTER JOIN new_students4
ON courses.course = new_students4.course_id
GROUP BY courses.course, courses.course_name
 -- since there is a aggregate clause in SELECT command, GROUP BY clause in necessary
HAVING COUNT(new_students4.student_id) > 0;

-- from queries_generate_sales_employees query
SELECT TOP 10 * FROM orders
SELECT TOP 10 * FROM discounts
SELECT TOP 10 * FROM customers
SELECT TOP 10 * FROM salesman

