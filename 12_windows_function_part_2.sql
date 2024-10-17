-- find total sales after discount by state
SELECT TOP 10 * FROM customers

-- we have to separate the city and the state from customer address
-- eg. Bokaro, Jharkhand
-- STEP 1: get the position of the space
-- STEP 2: get all the characters to the right of the space =  state

-- CHARINDEX: gives the index of the character in the string
SELECT CHARINDEX('FUN', 'SQL IS FUN') 
-- it is not case sensitive

SELECT CHARINDEX(' ', 'SQL IS FUN') 
-- gives the index of first space in the string

-- find the state and the city name of the customer address
SELECT customer_address, CHARINDEX(' ', customer_address) FROM customers

-- finding state of the customer_address
SELECT customer_address, 
		RTRIM(RIGHT(customer_address, 
		LEN(customer_address) - 
		CHARINDEX(' ', customer_address))) AS state_name
FROM customers

-- RIGHT: gives all the character from the right by the number mentioned
-- TRIM: removes spaces from the start and in the end of the string
-- RTRIM: removes spaces in the end (right side of the string)
-- LTRIM: removes spaces in the start (left side of the string)
-- LEN: gives total length of the string
-- REPLACE: replaces certain character by the given character in the string

-- finding city of the customer_address
SELECT customer_address, 
		LTRIM(LEFT(customer_address, 
		CHARINDEX(',', customer_address)-1))
FROM customers

-- we can also remove ',' by using replace function
SELECT customer_address, 
		LTRIM(REPLACE(LEFT(customer_address, 
		CHARINDEX(',', customer_address)),',','')) 
		AS city_name
FROM customers

-- combining state_name and city_name
-- find the top 3 states where the highest sales were made before discount
GO
WITH
address_details
AS
(
SELECT *, 
		RTRIM(RIGHT(customer_address, 
		LEN(customer_address) - 
		CHARINDEX(' ', customer_address))) 
		AS state_name,
		LTRIM(REPLACE(LEFT(customer_address, 
		CHARINDEX(',', customer_address)),',','')) 
		AS city_name
FROM customers
),
total_sales_state
AS
(
SELECT ad.state_name
		, SUM(od.quantity*od.item_price) AS price_by_state
FROM
address_details AS ad
INNER JOIN
orders as od
ON 
od.customer_id = ad.customer_id
GROUP BY ad.state_name
)
SELECT * FROM
(
SELECT *, DENSE_RANK() OVER(ORDER BY price_by_state DESC) AS state_rank
FROM total_sales_state
) AS sub_q_1
WHERE sub_q_1.state_rank <= 3

-- always give name to the table in subquery



