-- top 3 sales (where stores are located) that has the highest sales after discount
GO
CREATE OR ALTER VIEW vw_top_3_sales_state
AS
WITH
	total_sales_a_disc
AS
	(
	SELECT RTRIM(RIGHT(SALES_LOCATION, 
			LEN(sales_location) - 
			CHARINDEX(' ', sales_location))) 
			AS sales_state
	   , SUM(orders.item_price*orders.quantity*
		(100 - COALESCE(disc_perc,0.00))/100) AS sales_a_discount
	FROM	
		orders
	LEFT OUTER JOIN	
		discounts	
	ON
		YEAR(orders.purchase_date) = discounts.disc_year
	AND
		MONTH(orders.purchase_date) = discounts.disc_month
	INNER JOIN
		salesman
	ON 
		orders.salesman_id = salesman.sales_id
	GROUP BY
		RTRIM(RIGHT(SALES_LOCATION, 
			LEN(sales_location) - 
			CHARINDEX(' ', sales_location))) 
	)
-- SELECT * FROM total_sales_a_disc
SELECT * 
FROM
	(
	SELECT *, 
		DENSE_RANK() OVER(ORDER BY sales_a_discount DESC) 
		AS rank_state
	FROM 
		total_sales_a_disc
	) AS sub_q_1
WHERE
	sub_q_1.rank_state <= 3


-- TOP 3 customers based on the highest total sales after discount

GO
CREATE OR ALTER VIEW vw_top_3_cus
AS
WITH 
	sales_cus
AS
	(
	SELECT  customers.customer_name
		, SUM (orders.item_price*orders.quantity*
			(100 - COALESCE(disc_perc,0.00))/100) AS sales_a_disc
	FROM 
		orders
	INNER JOIN
		customers
	ON
		orders.customer_id = customers.customer_id
	LEFT OUTER JOIN
		discounts
	ON
		YEAR(orders.purchase_date) = discounts.disc_year
	AND
		MONTH(orders.purchase_date) = discounts.disc_month
	GROUP BY	
		customers.customer_name
	) 

SELECT * 
FROM
	(
	SELECT *, 
		DENSE_RANK() OVER(ORDER BY sales_a_disc DESC) AS rank_cus
	FROM 
		sales_cus
	) AS sub_q_1
WHERE 
	sub_q_1.rank_cus <=3


-- top 3 salesman based on the highest total sales after discount
GO
CREATE OR ALTER VIEW vw_top_3_salesman
AS
WITH
	cus_sales
AS
	(
	SELECT 
		sales_name
		, SUM(orders.item_price*orders.quantity*
			(100 - COALESCE(disc_perc,0.00))/100) AS total_sales_a_disc
	FROM
		orders
	INNER JOIN
		salesman
	ON 
		orders.salesman_id = salesman.sales_id
	LEFT OUTER JOIN
		discounts	
	ON
		YEAR(orders.purchase_date) = discounts.disc_year
	AND
		MONTH(orders.purchase_date) = discounts.disc_month
	GROUP BY
		sales_name
	)	
-- SELECT * FROM cus_sales
SELECT *
FROM
	(
	SELECT *,
			DENSE_RANK() OVER(ORDER BY total_sales_a_disc DESC) 
			AS cus_rank
	FROM
		cus_sales
	) AS sub_q_1
	WHERE 
		sub_q_1.cus_rank <= 3


-- updating table
GO
DROP TABLE IF EXISTS dummy_records
CREATE TABLE dummy_records
(
friend_name VARCHAR(40)
, friend_age INT
)

INSERT INTO dummy_records
VALUES
('Abhijeet',32),
('Kiran', 32),
(NULL,NULL),
('Joy',32)

SELECT * FROM dummy_records

GO
CREATE OR ALTER VIEW vw_dummy_records
AS
SELECT * FROM dummy_records

SELECT * FROM dummy_records

-- inserting some data into dummy_recordd
INSERT INTO dummy_records
VALUES
('SHOUVIK',35)

-- deleting records from the table
DELETE FROM dummy_records
WHERE
	friend_name IS NULL


SELECT * FROM dummy_records

-- alter the table
-- adding a column in the dummy_records table
ALTER TABLE dummy_records
ADD friend_location VARCHAR(100)

-- update the table
UPDATE dummy_records
SET
	friend_location = 'Hyderabad'

SELECT * FROM vw_dummy_records
-- view does not update the column after creating the view TABLE


INSERT INTO dummy_records
VALUES
('Deepak',35,'Pune'),
('Joy', 32, 'Bangalore')

DELETE FROM dummy_records
WHERE 
	friend_name = 'Joy'
AND
	friend_location = 'Bangalore'

INSERT INTO dummy_records
VALUES
('Joy', 32, 'Bangalore')

-- to update the view table structure, we have to run the CREATE and ALTER view again
GO
CREATE OR ALTER VIEW vw_dummy_records
AS
SELECT * FROM dummy_records

SELECT * FROM vw_dummy_records

-- inserting data into view table
INSERT INTO vw_dummy_records
(
	friend_name,
	friend_age,
	friends_location
)
VALUES
(
	'Priyanka',
	30,
	'Bhubaneshwar'
)

SELECT * FROM vw_dummy_records

-- update in a view
UPDATE vw_dummy_records
SET
	friends_location = 'Kolkata'
WHERE
	friend_name = 'Kiran'

-- we are updating thevire and not the table dummy_records


ALTER TABLE dummy_records
DROP COLUMN friend_location

SELECT * FROM vw_dummy_records
-- Shows an error saying that view has more column than columns defined


-- putting checks in place to avoid changing the structure of the table
-- where the VIEW is dependent on the table

ALTER TABLE dummy_records
ADD friend_location VARCHAR(100)

GO
CREATE OR ALTER VIEW vw_dummy_records_new WITH SCHEMABINDING
AS
SELECT friend_name
		,friend_age
		,friend_location
FROM [dbo].[dummy_records] -- names must be in two-part format

-- When creating a view with schemabinding
-- we have to specify all the columns explicitly
-- we cannot give a * to specify columns

SELECT * FROM vw_dummy_records_new
WHERE friend_age>=35

-- alter the table from which the schemabindingview is created 
-- and drop an underlying column

-- altering the view table (cannot do that)
ALTER TABLE dummy_records
ADD friend_location VARCHAR(100)

-- error: Column names in each table must be unique. 
-- Column name 'friend_location' in table 'dummy_records' 
-- is specified more than once.

-- update the table
UPDATE dummy_records
SET
	friend_location = 'Bangalore'

SELECT * FROM vw_dummy_records

-- adding new columns to the underlying table is allowed

ALTER TABLE dummy_records
ADD friend_occupation VARCHAR(100)

UPDATE dummy_records
SET 
friend_occupation = 'Software developer'

SELECT * FROM dummy_records

SELECT * FROM dbo.vw_dummy_records
-- new column will not appear
-- schema binding will prevent from altering the structure of those columns 
-- on which the VIEW is dependent

ALTER TABLE dummy_records
ALTER COLUMN friend_name VARCHAR (100)


-------------------------------------------------
CREATE TABLE kids_new
(
	kid_id INT PRIMARY KEY
	, kid_name VARCHAR(10) NOT NULL
	, sport_id INT NOT NULL
)

INSERT INTO kids_new
VALUES
(1, 'Jiten', 1)
,(2, 'Lekha', 1)
,(3, 'Naman', 1);

CREATE OR ALTER VIEW vw_kids WITH SCHEMABINDING
AS
SELECT kid_name, sport_id 
FROM dbo.kids_new

SELECT * FROM vw_kids


-- if a view is creeated from a single table,
-- we can use the view to insert, update and delete


INSERT INTO vw_kids
( 
	kid_name
	, sport_id
)
VALUES
(
	'Raunak'
	, 1
)

-- Cannot insert the value NULL into column 'kid_id', table 'sql_wkday_20240228.dbo.kids_new';0
-- column does not allow nulls. INSERT fails.
-- The view is not made up of the primary key hence the VIEW
-- cannot be used to insert new records into the underlying table

UPDATE vw_kids
SET 
	sport_id = 2
WHERE
	sport_id = 1

SELECT * FROM kids_new

UPDATE vw_kids
SET kid_name = 'Jiten Shah'
WHERE 
kid_name = 'Jiten'

-- WITH CHECK option
CREATE OR ALTER VIEW vw_sd_report WITH SCHEMABINDING
AS
SELECT employee_id
	, employee_name
	, employee_email
	, employee_dept
	, salary
FROM dbo.employees
WHERE employee_dept = 'SD-Report'

SELECT * FROM vw_sd_report

-- insert into view table
INSERT INTO vw_sd_report
VALUES
(601,'Divya Kumari Selvi',
'divyaselvi@dummyemail.com' ,
'SD-Report', 100000);

-- searching for a candidate with name divya
SELECT *
FROM
vw_sd_report
WHERE
employee_name LIKE 'Divya%';


INSERT INTO vw_sd_report
VALUES
(602,'Kavya Kumari Rao',
'raokabya@dummyemail.com' ,
'SD-WEB', 100000);

SELECT *
FROM
vw_sd_report
WHERE
employee_name LIKE 'Kavya%';

-- the view table will only show record for sd_report dept,
-- but the entry of kavya is in sd_web sp it doesnt show in view table
-- however, it will show in the employee table

SELECT *
FROM
employees
WHERE
employee_name LIKE 'Kavya%';

-- this record will be updated in the underlying table employees
-- to preventt his wrong entry, we use the check option

CREATE OR ALTER VIEW vw_sd_report WITH SCHEMABINDING
AS
SELECT employee_id
	, employee_name
	, employee_email
	, employee_dept
	, salary
FROM dbo.employees
WHERE employee_dept = 'SD-Report'
WITH CHECK OPTION

INSERT INTO vw_sd_report
(
			employee_id
		, employee_name
		, employee_email
		, employee_dept
		, salary
)
VALUES
(604
	,'Bhaskar Kumar Rao'
	,'raobhaskar@dummyemail.com'
	,'SD-DB'
	,100000);

CREATE OR ALTER VIEW vw_sd_report WITH SCHEMABINDING
AS
SELECT 
	employee_id
	, employee_name
	, employee_email
	, employee_dept
	, salary
FROM
	dbo.employees
WHERE 
	employee_dept = 'SD-Report'
AND
	salary<75000
	WITH CHECK OPTION

-- we can buse VIEW to insert data into a table when the view
-- is created from one table

INSERT INTO vw_sd_report
(
	employee_id
	, employee_name
	, employee_email
	, employee_dept
	, salary
)
VALUES
(
	608
	, 'Gowtam Hari Nair'
	, 'gowtamnair_dummymail.com'
	, 'SD_Report'
	, 70000
)

SELECT * FROM vw_sd_report

INSERT INTO vw_sd_report
(
	employee_id
	, employee_name
	, employee_email
	, employee_dept
	, salary
)
VALUES
(
	619
	, 'Deepa S Nair'
	, 'deepanair_dummymail.com'
	, 'SD-Report' -- this is confirming with the WITH CHECK OPTION
	, 80000 -- this is not confirming with WITH CHECK OPTION
)
