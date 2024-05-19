
USE amazon;
SELECT * FROM amazon;

-- Feature Engineering --
/* Add a new column named timeofday to give insight of sales in the Morning, Afternoon and Evening. 
This will help answer the question on which part of the day most sales are made. */
ALTER TABLE amazon ADD COLUMN timeofday VARCHAR(10);
UPDATE amazon 
SET timeofday = 
    CASE 
        WHEN EXTRACT(HOUR FROM time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM time) < 18 THEN 'Afternoon'
        ELSE 'Evening'
    END;
    
-- Feature Engineering --    
/* Add a new column named dayname that contains the extracted days of the week on which the given transaction took place (Mon, Tue, Wed, Thur, Fri). 
This will help answer the question on which week of the day each branch is busiest. */
ALTER TABLE amazon ADD COLUMN dayname VARCHAR(10);
UPDATE amazon SET dayname = 
    CASE DAYOFWEEK(date)
        WHEN 1 THEN 'Sun'
        WHEN 2 THEN 'Mon'
        WHEN 3 THEN 'Tue'
        WHEN 4 THEN 'Wed'
        WHEN 5 THEN 'Thu'
        WHEN 6 THEN 'Fri'
        WHEN 7 THEN 'Sat'
    END;
 
-- Feature Engineering --  
/* Add a new column named monthname that contains the extracted months of the year on which the given transaction took place (Jan, Feb, Mar). 
Help determine which month of the year has the most sales and profit. */
ALTER TABLE amazon ADD COLUMN monthname VARCHAR(10);
UPDATE amazon SET monthname = 
    CASE MONTH(date)
        WHEN 1 THEN 'Jan'
        WHEN 2 THEN 'Feb'
        WHEN 3 THEN 'Mar'
        WHEN 4 THEN 'Apr'
        WHEN 5 THEN 'May'
        WHEN 6 THEN 'Jun'
        WHEN 7 THEN 'Jul'
        WHEN 8 THEN 'Aug'
        WHEN 9 THEN 'Sep'
        WHEN 10 THEN 'Oct'
        WHEN 11 THEN 'Nov'
        WHEN 12 THEN 'Dec'
    END;

-- Business Analysis:
-- What is the count of distinct cities in the dataset?
SELECT COUNT(DISTINCT city) AS distinct_city_count FROM amazon;

-- Business Analysis:
-- For each branch, what is the corresponding city?
SELECT branch, city FROM amazon GROUP BY branch, city;

-- Business Analysis:
-- What is the count of distinct product lines in the dataset?
SELECT COUNT(DISTINCT `Product line`) AS distinct_product_lines_count FROM amazon;

-- Business Analysis:
-- Which payment method occurs most frequently?
SELECT Payment, COUNT(*) AS frequency FROM amazon
GROUP BY Payment ORDER BY frequency DESC LIMIT 1;

-- Business Analysis:
-- Which product line has the highest sales?
SELECT `Product line`, SUM(`Unit price` * Quantity) AS total_sales FROM amazon
GROUP BY `Product line` ORDER BY total_sales DESC LIMIT 1;

-- Business Analysis:
-- How much revenue is generated each month?
SELECT 
    YEAR(Date) AS Year,
    monthname AS Month,
    SUM(`Unit price` * Quantity) AS Monthly_Revenue
FROM 
    amazon
GROUP BY 
    YEAR(Date),
    monthname
ORDER BY 
    YEAR(Date),
    monthname;


-- Business Analysis:
-- In which month did the cost of goods sold reach its peak?
SELECT 
    YEAR(Date) AS Year,
    monthname AS Month,
    SUM(cogs) AS Total_COGS
FROM 
    amazon
GROUP BY 
    YEAR(Date),
    monthname
ORDER BY 
    Total_COGS DESC
LIMIT 1;

-- Business Analysis:
-- Which product line generated the highest revenue?
SELECT 
    `Product line`,
    SUM(`Unit price` * Quantity) AS Total_Revenue
FROM 
    amazon
GROUP BY 
    `Product line`
ORDER BY 
    Total_Revenue DESC
LIMIT 1;

-- Business Analysis:
-- In which city was the highest revenue recorded?
SELECT 
    City,
    SUM(`Unit price` * Quantity) AS Total_Revenue
FROM 
    amazon
GROUP BY 
    City
ORDER BY 
    Total_Revenue DESC
LIMIT 1;

-- Business Analysis:
-- Which product line incurred the highest Value Added Tax?
SELECT 
    `Product line`,
    SUM(`Tax 5%`) AS Total_tax
FROM 
    amazon
GROUP BY 
    `Product line`
ORDER BY 
    Total_tax DESC
LIMIT 1;

-- Business Analysis:
-- For each product line, add a column indicating "Good" if its sales are above average, otherwise "Bad."
SELECT 
	`Product line`,
	AVG(`Unit price` * Quantity) AS Avg_Sales,
	CASE 
		WHEN SUM(`Unit price` * Quantity) > AVG(`Unit price` * Quantity) THEN 'Good'
		ELSE 'Bad'
	END AS Sales_Status
FROM 
	amazon
GROUP BY 
	`Product line`;

-- Business Analysis:
-- Identify the branch that exceeded the average number of products sold.
SELECT 
    Branch,
    SUM(Quantity) AS Total_Products_Sold
FROM 
    amazon
GROUP BY 
    Branch
HAVING 
    SUM(Quantity) > (SELECT AVG(Quantity) FROM amazon);

-- Business Analysis:
-- Which product line is most frequently associated with each gender?
SELECT gender, `Product line`,
	   COUNT(`Product line`) as Total_Count
FROM amazon
GROUP BY gender, `Product line`
ORDER BY Total_Count DESC;

-- Business Analysis:
-- Calculate the average rating for each product line.
SELECT 
    `Product line`,
    AVG(Rating) AS Average_Rating
FROM 
    amazon
GROUP BY 
    `Product line`;

-- Business Analysis:
-- Count the sales occurrences for each time of day on every weekday.
SELECT 
    timeofday AS Time_of_Day,
    dayname AS Weekday,
    COUNT(*) AS Sales_Count
FROM amazon
GROUP BY Weekday, Time_of_Day
ORDER BY Weekday, Time_of_Day;

-- Business Analysis:
-- Identify the customer type contributing the highest revenue.
SELECT 
    `Customer type`,
    SUM(`Unit price` * Quantity) AS Total_Revenue
FROM amazon
GROUP BY `Customer type`
ORDER BY Total_Revenue DESC
LIMIT 1;

-- Business Analysis:
-- Determine the city with the highest VAT percentage.
SELECT 
    City,
    SUM(`Tax 5%`) / SUM(Total) * 100 AS Tax_Percentage
FROM amazon
GROUP BY City
ORDER BY Tax_Percentage DESC;

-- Business Analysis:
-- Identify the customer type with the highest VAT payments.
SELECT 
    `Customer type`,
    SUM(`Tax 5%`) AS Total_Tax_Payments
FROM amazon
GROUP BY `Customer type`
ORDER BY Total_Tax_Payments DESC
LIMIT 1;

-- Business Analysis:
-- What is the count of distinct customer types in the dataset?
SELECT COUNT(DISTINCT `Customer type`) AS distinct_customer_types_count FROM amazon;

-- Business Analysis:
-- What is the count of distinct payment methods in the dataset?
SELECT COUNT(DISTINCT Payment) AS distinct_payment_methods_count FROM amazon;

-- Business Analysis:
-- Which customer type occurs most frequently?
SELECT 
    `Customer type`,
    COUNT(*) AS Frequency
FROM amazon
GROUP BY `Customer type`
ORDER BY Frequency DESC
LIMIT 1;

-- Business Analysis:
-- Identify the customer type with the highest purchase frequency.
SELECT 
    `Customer type`,
    COUNT(*) AS Purchase_Frequency
FROM amazon
GROUP BY `Customer type`
ORDER BY Purchase_Frequency DESC
LIMIT 1;

-- Business Analysis:
-- Determine the predominant gender among customers.
SELECT 
    Gender,
    COUNT(*) AS Gender_Count
FROM amazon
WHERE Gender IS NOT NULL
GROUP BY Gender
ORDER BY Gender_Count DESC
LIMIT 1;

-- Business Analysis:
-- Examine the distribution of genders within each branch.
SELECT 
    Branch,
    Gender,
    COUNT(*) AS Gender_Count
FROM amazon
WHERE Gender IS NOT NULL
GROUP BY Branch, Gender
ORDER BY Branch, Gender;

-- Business Analysis:
-- Identify the time of day when customers provide the most ratings.
SELECT 
    timeofday AS Time_of_Day,
    COUNT(*) AS Rating_Count
FROM amazon
WHERE Rating IS NOT NULL
GROUP BY timeofday
ORDER BY Rating_Count DESC
LIMIT 1;

-- Business Analysis:
-- Determine the time of day with the highest customer ratings for each branch.
SELECT 
    Branch,
    timeofday AS Time_of_Day,
    AVG(Rating) AS Average_Rating
FROM amazon
WHERE Rating IS NOT NULL
GROUP BY Branch, timeofday
ORDER BY Branch, Average_Rating DESC;

-- Business Analysis:
-- Identify the day of the week with the highest average ratings.
SELECT 
    DAYNAME(Date) AS Day_of_Week,
    AVG(Rating) AS Average_Rating
FROM amazon
WHERE Rating IS NOT NULL
GROUP BY Day_of_Week
ORDER BY Average_Rating DESC
LIMIT 1;

-- Business Analysis:
-- Determine the day of the week with the highest average ratings for each branch.
SELECT 
    Branch,
    DAYNAME(Date) AS Day_of_Week,
    AVG(Rating) AS Average_Rating
FROM amazon
WHERE Rating IS NOT NULL
GROUP BY Branch, Day_of_Week
ORDER BY Average_Rating DESC;





