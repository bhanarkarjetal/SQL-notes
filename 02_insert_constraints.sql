USE sql_wkday_20240228

DROP TABLE friends_details  -- deletes the table and its details from the database

DROP TABLE IF EXISTS friends -- deletes the table if it already exists else ignores

-- creating table with mandatory columns
CREATE TABLE friends
(
	first_name VARCHAR (100) NOT NULL, -- data cannot be null
	last_name VARCHAR (100) NOT NULL, -- data cannot be null
	email VARCHAR (100), -- data can be null
	gender CHAR (1) NOT NULL,
	phone CHAR(10) NOT NULL,
	[address] VARCHAR (100),
	dob DATE,
	salary INT
)

EXEC sp_help friends

INSERT INTO friends
VALUES 
(
	'Sumit',
	'Kumar',
	'skumar@gmail.com',
	'M',
	'9876543210',
	'Nagpur, Maharashtra',
	'1997-08-19',
	12000
)

INSERT INTO friends
VALUES 
(
	'Sumit',
	'Kumar',
	'skumar@gmail.com',
	NULL, -- will not execute the code, because gender value cannot be null
	'9876543210',
	'Nagpur, Maharashtra',
	'1997-08-19',
	12000
)

INSERT INTO friends
VALUES 
(
	'Karan',
	'Kumar',
	'kkumar@gmail.com',
	'M', 
	'9876543210',
	'Mumbai, Maharashtra',
	'1998-07-19',
	NULL
)

INSERT INTO friends
VALUES 
(
	'Karan',
	'Kumar',
	'kkumar@gmail.com',
	'M', 
	'9876543210',
	'Mumbai, Maharashtra',
	'1998-07-19',
	NULL
)

-- writing only the mandatory values
INSERT INTO friends
(
	first_name,
	last_name,
	gender,
	phone
)
VALUES
	('Priyanka', 'Poluri', 'F', '9898989898'),
	('Sayesha', 'Wankhede','F', '9898967676'),
	('Prachi', 'Bansod', 'F', '9678765456');

SELECT * FROM friends;
EXEC sp_help friends;

CREATE TABLE students
(
	first_name VARCHAR (40) NOT NULL,
	last_name VARCHAR (40) NOT NULL,
	course_name VARCHAR (40) NOT NULL,
	marks DECIMAL(6,2) NOT NULL,
)

INSERT INTO students
VALUES 
('Ashok','Kumar','B.E. (MECH)', 98);

-- DECIMAL (6,0): 6 is the precision value (total number of spaces including decimal)
--				: 2 is the scale value (number of spaces after decimal)

-- to identify every row uniquely by using PRIMARY KEY	
-- PRIMARY KEY is a column(s) which is unique to every row
-- PRIMARY KEY cannot be NULL

DROP TABLE IF EXISTS students

-- SYNTHETIC primary key
CREATE TABLE students
(
	student_id INT,
	first_name VARCHAR (40) NOT NULL,
	last_name VARCHAR (40) NOT NULL,
	course_name VARCHAR (40) NOT NULL,
	marks DECIMAL(6,2) NOT NULL,
	PRIMARY KEY (student_id) -- can have more than one column
);
-- you can also write primary key beside the name of column
--eg. student_id int PRIMARY KEY, (need not be in caps)

EXEC sp_help students

INSERT INTO students
VALUES 
(101,'Ashok','Kumar','B.E. (MECH)', 98);
-- cannot run the querry again, since duplicate values cannot be entered in the primary key

INSERT INTO students
VALUES 
(102,'Ashok','Kumar','B.E. (MECH)', 98);
-- will distinguish first ashok from the other by primary key

SELECT * FROM students

INSERT INTO students
VALUES 
(NULL,'Ashok','Kumar','B.E. (MECH)', 98);
-- will show an error as primary key cannot have a null value

-- UNIQUE KEY: cannot have duplicates but can have one null value
--			   second null value will become the duplicate of the first null value
--			   we can also put a constraint on UNIQUE KEY with NOT NULL command
-- PRIMARY KEY: cannot have duplicate or a null value

DROP TABLE IF EXISTS friends_table;
CREATE TABLE friends_table
(
	first_name VARCHAR (40) NOT NULL,
	last_name VARCHAR (40) NOT NULL,
	email VARCHAR (100) UNIQUE,
	gender CHAR (1) NOT NULL,
	phone CHAR (10) PRIMARY KEY,
	[address] VARCHAR(100),
	dob DATE,
	salary INT
)
EXEC sp_help friends_table


INSERT INTO friends_table
VALUES
(
	'Rajiv',
	'Kumar',
	'skumar@gmail.com',
	'M',
	'8889988888',
	'Jamshedpur, Jharkhand',
	'1987-07-12',
	13000
)
-- will show an error because unique key is getting repeated

INSERT INTO friends_table
VALUES
(
	'Rajiv',
	'Kumar',
	null,
	'M',
	'8888888998',
	'Jamshedpur, Jharkhand',
	'1987-07-12',
	13000
)
SELECT * FROM friends_table

INSERT INTO friends_table
VALUES
(
	'Saroj',
	'Bhisht',
	'sbhisht@gmail.com',
	'F',
	'8888998998',
	'Jamshedpur, Jharkhand',
	'1987-07-12',
	13000
)

-- DEFAULT Constraint
CREATE TABLE store
(
	product_id INT PRIMARY KEY,
	product_name VARCHAR (100) NOT NULL,
	units INT NOT NULL,
	price DECIMAL (7,2) NOT NULL,
	discount INT DEFAULT 10,
);

EXEC sp_help store

INSERT INTO store
(
	product_id,
	product_name,
	units,
	price
)
VALUES
(
	1000,
	'Lenovo T145',
	100,
	85000
)
-- the table will by default have a value of 10 in discount column

SELECT * FROM store

INSERT INTO store
(
	product_id,
	product_name,
	units,
	price,
	discount
)
VALUES
(
	1009,
	'Apple ipad',
	100,
	85000,
	20
)
-- here the discount value was given by the user

-- assigning null value to default
INSERT INTO store
(
	product_id,
	product_name,
	units,
	price,
	discount
)
VALUES
(
	1007,
	'Apple ipad',
	100,
	95000,
	null
)
-- you can also assign not null command beside default command

-- FOREIGN KEY constraint: column refers to take values given in the primary key of the reference table
DROP TABLE IF EXISTS courses
CREATE TABLE courses
(
	course CHAR(3) PRIMARY KEY,
	course_name VARCHAR (100) NOT NULL,
	hod VARCHAR (100) NOT NULL,
);
INSERT INTO courses
VALUES 
('CSE', 'Computer science and engineering', 'Vinod Dham'),
('EEE', 'Electrical engineering', 'H.C. Verma'),
('ECE', 'Electronics and communication engineering', 'D.K. Reddy');

SELECT * FROM courses

DROP TABLE IF EXISTS new_students
CREATE TABLE new_students
(
	student_id INT PRIMARY KEY,
	student_name VARCHAR (100) NOT NULL,
	phone CHAR (10) NOT NULL UNIQUE,
	course_id CHAR (3) NOT NULL,
	FOREIGN KEY (course_id) REFERENCES courses(course)
); -- foreign key column and reference table column can have same names

INSERT INTO new_students
VALUES 
(1000,'Rakesh Kumar','8989898989','CSE')

INSERT INTO new_students
VALUES 
(1001,'Priya Kumar','8989800989','CVL')
-- will not execute the code as CVL is not in the course id of courses table

INSERT INTO new_students
VALUES 
(1003,'Kishor Shah','8009898989','EEE'),
(1004,'Nimesh Shetty','8009898089','ECE'),
(1005,'Karan Gupta','8009898966','EEE');

SELECT * FROM new_students

DROP TABLE IF EXISTS ec_activity
CREATE TABLE ec_activity
(
	activity_id CHAR (5) PRIMARY KEY,
	activity_name VARCHAR (40)
);

INSERT INTO ec_activity
VALUES
	('BKTBL', 'Basketball'),
	('CRICK','Cricket');

DROP TABLE IF EXISTS newstudents2

CREATE TABLE new_students2
(
	student_id INT PRIMARY KEY,
	student_name VARCHAR (100) NOT NULL,
	phone CHAR (10) NOT NULL UNIQUE,
	course_id CHAR (3) NOT NULL,
	activity_id CHAR (5) NOT NULL,
	FOREIGN KEY (course_id) REFERENCES courses(course),
	FOREIGN KEY (activity_id) REFERENCES ec_activity(activity_id)
); 

INSERT INTO new_students2
VALUES
('10001','Namisha Bhishikar','9890341026','CSE','BKTBL'),
('10002','Namashri Bhishikar','9890341926','EEE','CRICK')


SELECT * FROM new_students2

-- you cannot drop the parent table if it is in reference of the child table
-- to drop the parent table, you will first have to drop the child table
-- and then drop the parent table.

--CHECK command
CREATE TABLE new_students3
(
	student_id INT PRIMARY KEY,
	student_name VARCHAR (100) NOT NULL,
	gender CHAR (1) NOT NULL CHECK (gender IN ('M','F')), 
	-- can also be written as (gender = 'F' OR gender = 'M')
	-- check command can also take the NULL value
	-- so it is imp to put NOT NULL command in case you want only two values
	phone CHAR (10) NOT NULL UNIQUE,
	course_id CHAR (3) NOT NULL,
	activity_id CHAR (5) NOT NULL,
	FOREIGN KEY (course_id) REFERENCES courses(course),
	FOREIGN KEY (activity_id) REFERENCES ec_activity(activity_id)
); 
INSERT INTO new_students3
VALUES
('10001','Namisha Bhishikar','F','9890341026','CSE','BKTBL'),
('10002','Namashri Bhishikar','F','9890341926','EEE','CRICK')

INSERT INTO new_students3
VALUES
('10004','Pranil Shripad','N','9887654026','CSE','BKTBL')
-- will not execute the code since GENDER column conflicts with the CHECK value

SELECT * FROM new_students3
EXEC sp_help new_students3

-- to create autogenerated synthetic key
DROP TABLE IF EXISTS new_students4
CREATE TABLE new_students4
(
	student_id INT PRIMARY KEY IDENTITY (1001,1),
	-- identity command says that the value should start from 1 and increment next value by 1.
	-- the initital number can be of our choice
	student_name VARCHAR (100) NOT NULL,
	gender CHAR (1) NOT NULL CHECK (gender IN ('M','F')), 
	phone CHAR (10) NOT NULL UNIQUE,
	course_id CHAR (3) NOT NULL,
	activity_id CHAR (5) NOT NULL,
	FOREIGN KEY (course_id) REFERENCES courses(course),
	FOREIGN KEY (activity_id) REFERENCES ec_activity(activity_id)
); 

-- you dont need to give the student_id, SQL will itself generate it
-- you have to give the column name specifically

INSERT INTO new_students4
(student_name, gender, phone, course_id, activity_id)

VALUES
('Namisha Bhishikar','F','9090341026','CSE','BKTBL'),
('Namashri Bhishikar','F','9890387926','EEE','CRICK'),
('Pranil Shripad','M','9876543210','ECE','CRICK')

INSERT INTO new_students4
(student_name, gender, phone, course_id, activity_id)

VALUES
('Pratik Bhishikar','M','8090341026','CSE','BKTBL'),
('Nikhil Bhishikar','M','8890387926','EEE','CRICK'),
('Parth Shripad','M','8876543210','ECE','CRICK')

SELECT * FROM new_students4

INSERT INTO new_students4
(student_name, gender, phone, course_id, activity_id)

VALUES
('Atharva Bhishikar','M','9990341026','CSE','BKTBL'),
('Samit Bhishikar','M','8090387926','EEE','CRICK'),
('Kusum Shripad','F','8870543210','ECE','CRICK')

-- CONCATANATE
SELECT *, CONCAT (course_id,student_id) AS roll_number
FROM new_students4