-- first step is to create  Database. In this database, we will create tables and work on them. 
-- In my case, I have created a database named sql_wkday_20240228
CREATE DATABASE sql_wkday_20240228;
 
-- After creating a database, whenever we start our query, we need mention the USE statement along with database name 
USE sql_wkday_20240228

-- creating a new table with nae=me friends_details. the column names are created along with the datatype
-- SQL is not case-sensitive
CREATE TABLE friends_details 
(
	first_name VARCHAR(40), --comma is used to separate one column name from the other
	last_name VARCHAR(40),
	email VARCHAR(100),
	phone CHAR(10), 
	[address] VARCHAR(100), --address is a special keyword in SQL.[] is used to use the keyword as a normal word
	dob DATE,
	salary INT -- no need to put a comma as it is the last column
); 
-- indentation is used to make the code readable

-- inspecting the content of the table. This step shows all the details of the table. like, column names, the datatype of each column etc.
EXEC sp_help friends_details;

--inserting data into the table. 
INSERT INTO friends_details
(
	first_name,
	last_name,
	email,
	phone,
	[address],
	dob,
	salary
) -- no need to put a semicolon here
VALUES
(
	'Rohit', --text should be written in single quotes
	'Bhave',
	'rbhave@gmail.com',
	'1234567890',
	'Mumbai, Maharashtra',
	'1996-11-26', --date should be of the format YYYY-MM-DD and should also be enclosed in single quotes
	25000 -- For numerical type of data, no need to insert single quotes
)

--check the inserted data in the above step
SELECT * FROM friends_details; -- * means getting all the rows and columns from the table

--other ways of inserting data in the tables
	
INSERT INTO friends_details
-- no need to write column names all the time while inserting data
-- SQL expects to put the data in the given column order and all the values need to be inserted
VALUES
(
	'Atharva',
	'Relkar',
	'arelkar@gmail.com',
	'0987654321',
	'Akola, Maharashtra',
	'1996-09-16',
	27000
);

INSERT INTO friends_details
VALUES
(
	'Ved',
	'Soni',
	'vsoni@gmail.com',
	'0987654321',
	'Mumbai, Maharashtra',
	27000
);
-- This code will not run
-- ERROR: 
--	Msg 213, Level 16, State 1, Line 59
-- 	Column name or number of supplied values does not match table definition.
-- 	data entered does not match the number of columns in the table

-- To enter only a specific number of columns we need to mention the column names where we have to insert data
INSERT INTO friends_details
(
	first_name,
	last_name,
	email,
	phone,
	[address],
	salary
) 
VALUES
(
	'Ved',
	'Soni',
	'vsoni@gmail.com',
	'0987654321',
	'Mumbai, Maharashtra',
	27000
);

SELECT * FROM friends_details

INSERT INTO friends_details
(
	first_name,
	last_name,
	phone,
	[address],
	salary
) 
VALUES
(
	'Niket',
	'Shah',
	'0987654321',
	'Mumbai, Maharashtra',
	29000
);

-- inserting the null values
INSERT INTO friends_details
VALUES 
(
	'Priya',
	'Kandare',
	NULL, -- null value for email id
	'1234509876',
	'Jalgaon, Maharashtra',
	NULL,
	30000
)

-- Deleting data from the table
DELETE FROM friends_details -- Deletes ALL the data from the table

-- Insert data in a specific order
INSERT INTO friends_details
(
	salary,
	dob,
	first_name,
	last_name,
	email,
	[address],
	phone
)
VALUES
(
	15000,
	'1996-12-12',
	'Namisha',
	'Bhishikar',
	'nbhishikar@gmail.com',
	'Nagpur, Maharashtra',
	'9898989898'
)

-- adding multiple rows at once
INSERT INTO friends_details
VALUES 
	('Pabitra','Madhurima','pmadhurima@gmail.com', '9797979797',
		'Sambhalpur, Odisha', '1997-12-10', 15000), -- one row entered
	
	('Dibya', 'Choudhury', 'dchoudhury@gmail.com', '9191919191',
		'Kolkata, WB', '1996-09-15', 17000),
	
	('Yamini', 'Patina','ypatina@gmail.com', '8787878787',
		'Bangalore, Karnataka', '1997-11-09', 19000); -- semicolon after final row

SELECT * FROM friends_details

-- to skip any particular column while inserting multiple rows, 
-- Enter the name of columns that you want to enter in 'INSERT INTO friends_details'.
-- You can write the column names in random order. 
-- follow the same order while entering data in VALUES
INSERT INTO friends_details
(
	first_name,
	last_name,
	phone,
	[address],
	dob,
	salary
) 
VALUES
	('MAnisha', 'Choudhury', '9191919191',
		'Kolkata, WB', '1996-09-15', 17000),
	
	('Yamini', 'Patina', '8787878787',
		'Bangalore, Karnataka', '1997-11-09', 19000);

-- Limiting the number of columns to see from the table
SELECT 
	first_name, 
	last_name, 
	[address],
	salary 
FROM friends_details
-- We can write the column names without indentation
-- indentation is given only to make the code more readable

-- limiting the number of rows
select * from friends_details
WHERE salary = 15000

-- limiting the number of rows and columns
SELECT 
	first_name, 
	last_name, 
	[address],
	salary 
FROM friends_details
WHERE salary = 15000

-- Select rows with particular columns having null values
SELECT * 
from friends_details
WHERE 
	email IS NULL 

-- Since SQL is not case-sensitive, we can write in small or capital letters and still, we will get the desired results.
select * from friends_details
where email IS NOT NULL

select * from friends_details
where last_name = 'Soni' -- put single quotes since it is a VARCHAR

-- Selecting all the rows and columns from the table
SELECT * FROM friends_details
