-- Mentioning the database name before starting to write the query
USE sql_wkday_20240228

SELECT TOP 10 * FROM orders 

EXEC sp_help orders
-- contains foreign key with reference to customer table as customer_id
-- and with reference to salesman table as salesman_id

-- to create a summary report where we can view the order details the customer in the order and the salesman involved

-- step 1: partial summary report >> to see the customer and the orders table

SELECT * FROM orders
INNER JOIN customers 
ON customers.customer_id = orders.customer_id

-- why would an inner join in this scenario be equal to left outer join?
-- because of foreign key relation between orders and customers table
SELECT * 
FROM orders
LEFT OUTER JOIN customers 
ON customers.customer_id = orders.customer_id

-- JOINING two or more tables using more than one JOIN condition
SELECT * FROM orders
INNER JOIN customers 
ON customers.customer_id = orders.customer_id
INNER JOIN salesman
ON orders.salesman_id = salesman.sales_id


SELECT 
	orders.order_id
	,orders.customer_id
	,orders.salesman_id
	,orders.item_price
	,orders.quantity
	,orders.quantity*orders.item_price AS price_b_discount
	,orders.purchase_date
	,customers.customer_name
	,customers.customer_phone
	,customers.customer_address
	,salesman.sales_name
	,salesman.sales_location
FROM orders
INNER JOIN customers 
ON customers.customer_id = orders.customer_id
INNER JOIN salesman
ON orders.salesman_id = salesman.sales_id
-- The sequence of columns of the table will be: orders > customers > salesman

SELECT TOP 10 * FROM discounts

-- join discounts table with the orders table

SELECT TOP 10 * FROM orders

EXEC sp_help orders
-- data type of purchase_date is DATE, there are special actions to perform on DATE data type
-- programmability >> functions >> system functions >> date and time function

SELECT * , 
	YEAR(purchase_date) as purchase_year-- WILL GIVE YEAR PART OF THE DATE 
	,MONTH(purchase_date) AS purchase_month -- in INT data type
	,DATENAME(YYYY, purchase_date) -- gives varchar data type
	,DATENAME(M, purchase_date) -- gives VARCHAR as month name
	,DATEPART(YYYY, purchase_date) -- in VARCHAR data type
	,DATEPART (M, purchase_date) -- in VARCHAR data type
FROM orders

EXEC sp_help discounts

SELECT * 
FROM discounts 
RIGHT OUTER JOIN orders
ON discounts.disc_year = YEAR(orders.purchase_date)
AND discounts.disc_month = MONTH(orders.purchase_date)
 
SELECT 
	orders.order_id
	,orders.customer_id
	,orders.salesman_id
	,orders.item_price
	,orders.quantity
	,orders.quantity*orders.item_price AS price_b_discount
	,orders.purchase_date
	,customers.customer_name
	,customers.customer_phone
	,customers.customer_address
	,salesman.sales_name
	,salesman.sales_location
	,discounts.disc_perc
	,orders.quantity*orders.item_price - 
		orders.quantity*orders.item_price*discounts.disc_perc/100
		AS price_a_discount
FROM customers
INNER JOIN orders 
ON customers.customer_id = orders.customer_id
INNER JOIN salesman
ON orders.salesman_id = salesman.sales_id
LEFT OUTER JOINdiscounts
ON discounts.disc_year = YEAR(orders.purchase_date)
AND discounts.disc_month = MONTH(orders.purchase_date)

-- COALESCE (A,B): if A = NULL,then it will be replaced by value B, if it is not null, then it will return the same A value
SELECT COALESCE(100,0) -- will give 100
SELECT COALESCE (NULL,10) -- will replace NULL with 10


SELECT orders.order_id
	,orders.customer_id
	,orders.salesman_id
	,orders.item_price
	,orders.quantity
	,orders.quantity*orders.item_price AS price_b_discount
	,orders.purchase_date
	,customers.customer_name
	,customers.customer_phone
	,customers.customer_address
	,salesman.sales_name
	,salesman.sales_location
	,discounts.disc_perc
	,orders.quantity*orders.item_price - 
		orders.quantity*orders.item_price*COALESCE(discounts.disc_perc,0.00)/100
		AS price_a_discount
FROM customers
INNER JOIN orders 
ON customers.customer_id = orders.customer_id
INNER JOIN salesman
ON orders.salesman_id = salesman.sales_id
LEFT OUTER JOIN discounts
ON discounts.disc_year = YEAR(orders.purchase_date)
AND discounts.disc_month = MONTH(orders.purchase_date)

--CEILING command
SELECT CEILING(100.1)

SELECT orders.order_id
	,orders.customer_id
	,orders.salesman_id
	,orders.item_price
	,orders.quantity
	,orders.quantity*orders.item_price AS price_b_discount
	,orders.purchase_date
	,customers.customer_name
	,customers.customer_phone
	,customers.customer_address
	,salesman.sales_name
	,salesman.sales_location
	,discounts.disc_perc
	,CEILING(orders.quantity*orders.item_price - 
		orders.quantity*orders.item_price*COALESCE(discounts.disc_perc,0.00)/100)
		AS price_a_discount
FROM customers
INNER JOIN orders 
ON customers.customer_id = orders.customer_id
INNER JOIN salesman
ON orders.salesman_id = salesman.sales_id
LEFT OUTER JOIN discounts
ON discounts.disc_year = YEAR(orders.purchase_date)
AND discounts.disc_month = MONTH(orders.purchase_date)

-- calculate the total sales after discount for each year
SELECT YEAR(orders.purchase_date) AS purchase_year
	,SUM(orders.quantity*orders.item_price - 
		orders.quantity*orders.item_price*
		COALESCE(discounts.disc_perc,0.00)/100)
		AS price_a_discount 
FROM orders
LEFT OUTER JOIN discounts
ON discounts.disc_year = YEAR(orders.purchase_date)
AND discounts.disc_month = MONTH(orders.purchase_date)
GROUP BY YEAR(orders.purchase_date)
ORDER BY price_a_discount DESC

-- find the salesman who has acheived total highest sales after discount
SELECT orders.salesman_id
	,salesman.sales_name
	,SUM(orders.quantity*orders.item_price - 
		orders.quantity*orders.item_price*
		COALESCE(discounts.disc_perc,0.00)/100)
			AS price_a_discount 
FROM orders
LEFT OUTER JOIN discounts
ON discounts.disc_year = YEAR(orders.purchase_date)
AND discounts.disc_month = MONTH(orders.purchase_date)
INNER JOIN salesman
ON orders.salesman_id = salesman.sales_id
GROUP BY orders.salesman_id,
	salesman.sales_name
ORDER BY price_a_discount DESC

-- TABLE ALIASES: table order AS od
SELECT od.salesman_id
	,sm.sales_name
	,SUM(od.quantity*od.item_price - 
		od.quantity*od.item_price*
		COALESCE(ds.disc_perc,0.00)/100)
		AS price_a_discount 
FROM orders AS od
LEFT OUTER JOIN discounts AS ds
ON ds.disc_year = YEAR(od.purchase_date)
AND ds.disc_month = MONTH(od.purchase_date)
INNER JOIN salesman AS sm
ON od.salesman_id = sm.sales_id
GROUP BY od.salesman_id,
	sm.sales_name
ORDER BY price_a_discount DESC


-- get the list of all the salesman who did not perform any sales
SELECT *
FROM salesman
LEFT OUTER JOIN orders
ON salesman.sales_id = orders.salesman_id
WHERE orders.order_id IS NULL

-- Find the top 5 customer based on the total price after discount
SELECT TOP 5
	customers.customer_name
	,SUM(orders.quantity*orders.item_price - 
		orders.quantity*orders.item_price*
		COALESCE(discounts.disc_perc,0.00)/100)
		AS price_a_discount 
FROM orders
LEFT OUTER JOIN customers
ON orders.customer_id = customers.customer_id
LEFT OUTER JOIN discounts
ON discounts.disc_year = YEAR(orders.purchase_date)
AND discounts.disc_month = MONTH(orders.purchase_date)
GROUP BY customers.customer_name
ORDER BY price_a_discount DESC

-- Find the top 2 location based on the total price after discount
SELECT TOP 2 customers.customer_address
	,SUM(orders.quantity*orders.item_price - 
		orders.quantity*orders.item_price*
		COALESCE(discounts.disc_perc,0.00)/100)
		AS price_a_discount 
FROM orders
LEFT OUTER JOIN customers
ON orders.customer_id = customers.customer_id
LEFT OUTER JOIN discounts
ON discounts.disc_year = YEAR(orders.purchase_date)
AND discounts.disc_month = MONTH(orders.purchase_date)
GROUP BY customers.customer_address
ORDER BY price_a_discount DESC


-- find the bottom 2 locations based on the total price after discount
SELECT TOP 2 customers.customer_address
	,SUM(orders.quantity*orders.item_price - 
		orders.quantity*orders.item_price*
		COALESCE(discounts.disc_perc,0.00)/100)
		AS price_a_discount 
FROM orders
LEFT OUTER JOIN customers
ON orders.customer_id = customers.customer_id
LEFT OUTER JOIN discounts
ON discounts.disc_year = YEAR(orders.purchase_date)
AND discounts.disc_month = MONTH(orders.purchase_date)
GROUP BY customers.customer_address
ORDER BY price_a_discount 
