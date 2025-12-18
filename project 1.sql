-- SQL Retail Sales Analysis - P1

-- Create TABLE
CREATE TABLE retail_sales
(
	transactions_id INT PRIMARY KEY ,
	sale_date DATE,
	sale_time TIME,
	customer_id INT,
	gender VARCHAR (15),
	age INT,
	category VARCHAR (15),
	quantiy INT ,
	price_per_unit FLOAT,
	cogs FLOAT,
	total_sale FLOAT

)



SELECT * FROM retail_sales
limit 10 


SELECT COUNT(*) FROM retail_sales


SELECT * FROM retail_sales
WHERE transactions_id IS NULL


SELECT * FROM retail_sales
WHERE sale_date IS NULL



SELECT * FROM retail_sales
WHERE sale_time IS NULL


SELECT * FROM retail_sales
WHERE customer_id IS NULL


SELECT * FROM retail_sales
WHERE gender IS NULL

-- Alter Table 
ALTER TABLE retail_sales
RENAME COLUMN quantiy TO quantity;

-- Data Cleaning

SELECT *
FROM retail_sales
WHERE
    transactions_id IS NULL
    OR sale_date IS NULL
    OR sale_time IS NULL
    OR gender IS NULL
    OR category IS NULL
    OR quantity IS NULL
    OR cogs IS NULL
--
DELETE FROM retail_sales
WHERE
    transactions_id IS NULL
    OR sale_date IS NULL
    OR sale_time IS NULL
    OR gender IS NULL
    OR category IS NULL
    OR quantity IS NULL
    OR cogs IS NULL

-- Data Exploration 

	-- How many sales we have?

SELECT 
	COUNT(*) AS total_sale
FROM 
	retail_sales


	-- How many unique customers do we have 

SELECT 
	COUNT(DISTINCT customer_id) AS number_of_customers
FROM retail_sales


	-- What are the category present 

SELECT
	DISTINCT category 
FROM 
	retail_sales

-- Data Analysis & Business Key Problems & Answers

-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

	


-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05


SELECT 
	* 
FROM 
	retail_sales
WHERE 
	sale_date = '2022-11-05'




-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022


SELECT 
	*
FROM 
	retail_sales
WHERE 
	category = 'Clothing' AND quantity > 10 AND sale_date BETWEEN'2022-11-01' AND '2022-11-30'




-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.


SELECT 
	category,
	SUM(total_sale) net_sale
FROM 
	retail_sales
GROUP BY 
	category




-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.


SELECT 
	ROUND (AVG(age),0)
FROM 
	retail_sales
WHERE 
	category = 'Beauty'




-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.


SELECT 
	*
FROM 
	retail_sales
WHERE 
	total_sale > 1000




-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

SELECT 
	gender,
	category,
	COUNT(transactions_id)
FROM 
	retail_sales
GROUP BY 
	gender,
	category




-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year

WITH monthly_avg_sales AS (
    SELECT
        EXTRACT(YEAR FROM sale_date) AS year,
        EXTRACT(MONTH FROM sale_date) AS month,
        AVG(total_sale) AS avg_monthly_sale
    FROM
        retail_sales
    GROUP BY
        EXTRACT(YEAR FROM sale_date),
        EXTRACT(MONTH FROM sale_date)
),
ranked_months AS (
    SELECT
        year,
        month,
        avg_monthly_sale,
        RANK() OVER (
            PARTITION BY year
            ORDER BY avg_monthly_sale DESC
        ) AS rank_in_year
    FROM
        monthly_avg_sales
)
SELECT
    year,
    month,
    avg_monthly_sale
FROM
    ranked_months
WHERE
    rank_in_year = 1
ORDER BY
    year;




-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 

	
WITH customer_sales AS (
    SELECT
        customer_id,
        SUM(total_sale) AS total_sales
    FROM
        retail_sales
    GROUP BY
        customer_id
)
SELECT
    customer_id,
    total_sales
FROM
    customer_sales
ORDER BY
    total_sales DESC
LIMIT 5;




-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.


SELECT
	category,
	count(DISTINCT(customer_id))
FROM 
	retail_sales
GROUP BY 
	category




-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

WITH shift_data AS (
    SELECT
        CASE
            WHEN sale_time <= '12:00:00' THEN 'Morning'
            WHEN sale_time > '12:00:00' AND sale_time <= '17:00:00' THEN 'Afternoon'
            ELSE 'Evening'
        END AS shift
    FROM
        retail_sales
)
SELECT
    shift,
    COUNT(shift) AS number_of_orders
FROM
    shift_data
GROUP BY
    shift
ORDER BY
    shift;

-- END OF PROJECT





	



	















