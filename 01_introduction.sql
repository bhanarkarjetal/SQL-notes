 CREATE DATABASE sql_wkday_20240228;
 
 USE sql_wkday_20240228

CREATE TABLE friends_details 
(
	first_name VARCHAR(40), --comma is used to separate one column name with the other
	last_name VARCHAR(40),
	email VARCHAR(100),
	phone CHAR(10), -- it can be saved as varchar because there is no need of doing any calculation with these nnumbers.
	[address] VARCHAR(100), --address is a special keyword in SQL.[] is used to use the keyword as a normal word
	dob DATE,
	salary INT -- no need to put comma as it is the last column
); --indentation is used ot make the code readable
-- inpecting the content of the table
EXEC sp_help friends_details;

--inserting data into the table
INSERT INTO friends_details
(
	first_name,
	last_name,
	email,
	phone,
	[address],
	dob,
	salary
) -- no need to put semicolon here
VALUES
(
	'Rohit', --text should be written in single quotes
	'Bhave',
	'rbhave@gmail.com',
	'1234567890',
	'Mumbai, Maharashtra',
	'1996-11-26', --date should be of the formate YYYY-MM-DD and should also be enclosed in single quotes
	25000 -- for numercial type of data, no need to insert single quotes
)

--check the inserted data in the above step
SELECT * FROM friends_details; -- * means getting all the columns from the table

--other ways of insterting data in the tables
	
INSERT INTO friends_details
-- no need to writethe column names all the time while inserting data
-- SQL expects to put the data in the given  column order and all the values need to be inserted
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
-- Msg 213, Level 16, State 1, Line 59
-- Column name or number of supplied values does not match table definition.
-- data entered does not match the number of columns in the table

-- to enter only specific number of columns we need to mention the column name where we have to insert data
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
-- we can insert null values even in the first row
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

DELETE FROM friends_details -- Deletes ALL the data from the table

-- insert data in a specific order
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
	('Pabitra','Madhurima','pmadhurima@gmail.com','9797979797',
		'Sambhalpur, Odisha', '1997-12-10', 15000), -- one row entered
	
	('Dibya', 'Choudhury', 'dchoudhury@gmail.com','9191919191',
		'Kolkata, WB', '1996-09-15', 17000),
	
	('Yamini', 'Patina','ypatina@gmail.com', '8787878787',
		'Bangalore, Karnataka', '1997-11-09', 19000); -- semi colon after final row

SELECT * FROM friends_details

-- to skip any particular column while inserting multiple rows, 
-- enter the name of rows in 'INSERT INTO friends_details' that you want to enter.
-- you can write the column names in random order. 
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
	('MAnisha', 'Choudhury','9191919191',
		'Kolkata, WB', '1996-09-15', 17000),
	
	('Yamini', 'Patina', '8787878787',
		'Bangalore, Karnataka', '1997-11-09', 19000);

-- limit the number of columns to see from the table
SELECT 
	first_name, 
	last_name, 
	[address],
	salary 
FROM friends_details
-- we can write the column names without indentation
-- indentation is given only to make the code more readable

-- limiting the number of rows
select * from friends_details
WHERE salary = 15000

-- limiting number of rows and columns
SELECT 
	first_name, 
	last_name, 
	[address],
	salary 
FROM friends_details
WHERE salary = 15000

-- select rows with particular column having null values
SELECT * 
from friends_details
WHERE 
	email IS NULL -- you can also write 'is null' in CAPS

select * from friends_details
where email IS NOT NULL

select * from friends_details
where last_name = 'Soni' -- put single quotes since it is a VARCHAR

SELECT * FROM friends_details
