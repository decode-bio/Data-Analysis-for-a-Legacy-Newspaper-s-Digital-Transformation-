/*
After sucessfully importing our files, now we have to clean the data before proceeding with our analysis.
It is important that while cleaing our data we make sure to remove any duplicate values, inconsistent data, incomplete data etc. 
*/

-- 1. dim_ad_category
SELECT 
    *
FROM
    portfolio.dim_ad_category;
    
-- here we do not have any null values, but our letter cases are not uniform. So lets change all of them into the lowercase.

UPDATE portfolio.dim_ad_category
SET
    standard_ad_category = LOWER(standard_ad_category),
    category_group = LOWER(category_group),
    example_brands = LOWER(example_brands);
    
-- lets disable to safe mode for a while.

SET SQL_SAFE_UPDATES = 0;

-- update sucessfully after turning off the safe mode.

-- 2. dim_city

SELECT 
    *
FROM
    portfolio.dim_city;
-- there is no null values but the letter case of city and state are not uniform. So lets them update to lower case.

UPDATE portfolio.dim_city
SET
    city = LOWER(city),
    state = LOWER(state);
 -- due to a query all the names get replaced with first letter. hence performing the query to restore the values.
 -- All the values are cross checked carefully with the original table.
 
UPDATE portfolio.dim_city
SET
city=REPLACE(city, 'L', 'Lucknow'),
city=REPLACE(city, 'D', 'Delhi'),
city=REPLACE(city, 'B', 'Bhopal'),
city=REPLACE(city, 'P', 'Patna'),
city=REPLACE(city, 'J', 'Jaipur'),
city=REPLACE(city, 'M', 'Mumbai'),
city=REPLACE(city, 'R', 'Ranchi'),
city=REPLACE(city, 'K', 'Kanpur'),
city=REPLACE(city, 'A', 'Ahemdabad'),
city=REPLACE(city, 'V', 'Varanasi');

UPDATE portfolio.dim_city
SET
state=REPLACE(state, 'D', 'Delhi'),
state=REPLACE(state, 'B', 'Bihar'),
state=REPLACE(state, 'R', 'Rajasthan'),
state=REPLACE(state, 'J', 'Jharkhand'),
state=REPLACE(state, 'G', 'Gujarat');

UPDATE portfolio.dim_city
SET
state=REPLACE(state, 'U', 'Uttar Pradesh')
WHERE city='Lucknow' OR city='Varanasi';

UPDATE portfolio.dim_city
SET
state=REPLACE(state, 'Uttrakhand', 'U')
WHERE state='Uttrakhandttar Pradesh';

UPDATE portfolio.dim_city
SET
state=REPLACE(state, 'M', 'Madhya Pradesh')
WHERE city='Bhopal';

UPDATE portfolio.dim_city
SET
state=REPLACE(state, 'M', 'Maharashtra')
WHERE city='Mumbai';


-- 3. fact_ad_revenue

SELECT 
    *
FROM
    portfolio.fact_ad_revenue;
    

-- The column quarter_year & currency is not having uniformity. So lets update them.

UPDATE portfolio.fact_ad_revenue

SET 
  currency= 'INR'
WHERE currency='IN RUPEES';

-- i can observe that Q4 is written as 4th Qtr so lets chenge it first count them.

SELECT quarter_year
FROM portfolio.fact_ad_revenue
WHERE quarter_year LIKE '%4th Qtr%';

-- So there are total 180 values.

UPDATE portfolio.fact_ad_revenue
SET
quarter_year=REPLACE(quarter_year,'4th Qtr 2019', '2019-Q4'),
quarter_year=REPLACE(quarter_year,'4th Qtr 2020', '2020-Q4'),
quarter_year=REPLACE(quarter_year,'4th Qtr 2021', '2021-Q4'),
quarter_year=REPLACE(quarter_year,'4th Qtr 2022', '2022-Q4'),
quarter_year=REPLACE(quarter_year,'4th Qtr 2023', '2023-Q4'),
quarter_year=REPLACE(quarter_year,'4th Qtr 2024', '2024-Q4');

-- so on observing Q1 and Q3 of different year are not uniform so lets replace them.

UPDATE portfolio.fact_ad_revenue
SET
quarter_year=REPLACE(quarter_year,'Q1-2019', '2019-Q1'),
quarter_year=REPLACE(quarter_year,'Q3-2019', '2019-Q3'),
quarter_year=REPLACE(quarter_year,'Q1-2020', '2020-Q1'),
quarter_year=REPLACE(quarter_year,'Q3-2020', '2020-Q3'),
quarter_year=REPLACE(quarter_year,'Q1-2021', '2021-Q1'),
quarter_year=REPLACE(quarter_year,'Q3-2021', '2021-Q3'),
quarter_year=REPLACE(quarter_year,'Q1-2022', '2022-Q1'),
quarter_year=REPLACE(quarter_year,'Q3-2022', '2022-Q3'),
quarter_year=REPLACE(quarter_year,'Q1-2023', '2023-Q1'),
quarter_year=REPLACE(quarter_year,'Q3-2023', '2023-Q3'),
quarter_year=REPLACE(quarter_year,'Q1-2024', '2024-Q1'),
quarter_year=REPLACE(quarter_year,'Q3-2024', '2024-Q3');

-- now lets make our ad_revenue column uniform.
SELECT MAX(LENGTH(ad_revenue))
FROM fact_ad_revenue;

ALTER TABLE portfolio.fact_ad_revenue
MODIFY COLUMN ad_revenue DECIMAL(9, 2);

-- The column ad_revenue having values in different currency. lets add new colum with revenue in INR only.
-- So here for cal I am taking the value of USD & EUR as the current currency conversion on standard market. Because it had not provided by the stakeholder.
-- As on 10 September 2025, 1 USD = 88.12 INR & 1 EUR = 103.22 INR.
-- Let me add new column name ad_revenue_INR and also keep the original column for reference.

ALTER TABLE portfolio.fact_ad_revenue
ADD ad_revenue_INR DECIMAL(12,2); -- for being at safe side taking 12

UPDATE portfolio.fact_ad_revenue 
SET 
    ad_revenue_INR = CASE
        WHEN currency = 'EUR' THEN ad_revenue * 103.22
        WHEN currency = 'USD' THEN ad_revenue * 88.12
        ELSE ad_revenue
    END;


-- 4. fact_city_readiness

SELECT 
    *
FROM
    portfolio.fact_city_readiness;

-- In this table, the column literacy_rate & smartphone_penitration and internet_penetration the values are not uniform i.e. upto two decimal places.
DESCRIBE portfolio.fact_city_readiness;

ALTER TABLE portfolio.fact_city_readiness
MODIFY COLUMN literacy_rate DECIMAL(4,2);

ALTER TABLE portfolio.fact_city_readiness
MODIFY COLUMN smartphone_penitration DECIMAL(4,2);

ALTER TABLE portfolio.fact_city_readiness
MODIFY COLUMN internet_penetration DECIMAL(4,2);

-- 5. fact_digital_plot

SELECT 
    *
FROM
    portfolio.fact_digital_pilot;

/*
After obserbing the table, there is changes required in the avg_bounce_rate as the data is not uniform, and cumulative_feeback colum have some missing values
*/

ALTER TABLE portfolio.fact_digital_pilot
MODIFY COLUMN avg_bounce_rate DECIMAL(4,2);

-- Now lets check for values not  Provided.

SELECT * FROM portfolio.fact_digital_pilot
WHERE cumulative_feedback_from_customer='';

-- AS here the value is not provided so we cannot ask stakeholder for the data, as this is a portfolio challenge, so lets replace the balck space with NULL
UPDATE portfolio.fact_digital_pilot
SET 
cumulative_feedback_from_customer=REPLACE(cumulative_feedback_from_customer,'', NULL)
WHERE cumulative_feedback_from_customer='';

-- 6. fact_print_sales

 SELECT * FROM portfolio.fact_print_sales;
 
 -- column language_type is not uniform, and column state having some charater between state names.
 
 UPDATE portfolio.fact_print_sales
 SET
 language_type=LOWER(language_type);
 
 UPDATE portfolio.fact_print_sales
 SET
 state=REPLACE(state, 'Uttar-Pradesh','Uttar Pradesh'),
 state=REPLACE(state, 'Madhya_Pradesh','Madhya Pradesh');
 
 UPDATE portfolio.fact_print_sales
 SET
 language_type=REPLACE(language_type, 'hindi', 'Hindi'),
 language_type=REPLACE(language_type, 'english', 'English'),
 state=REPLACE(state, 'gujarat','Gujarat'),
 state=REPLACE(state, 'bihar','Bihar'),
 state=REPLACE(state, 'maharashtra','Maharashtra');
 
 DESCRIBE portfolio.fact_print_sales;
 
 -- the colum month_year is separated by multiple charater i.e. '-' & '/'. so lets take a look how mnay values contains / is there in column.
 
 SELECT month_year
 FROM portfolio.fact_print_sales
 WHERE month_year LIKE '%/%';
 
 -- So there are 5 values, lets first replace the month in string form
 
 UPDATE portfolio.fact_print_sales
 SET
 month_year=REPLACE(month_year,'/','-');
 
 -- there are 5 values which are not unifrom. we need to change them.
 
 UPDATE portfolio.fact_print_sales
 SET
 month_year=REPLACE(month_year, '2019-05','May-19'),
 month_year=REPLACE(month_year, '2020-03','March-20'),
 month_year=REPLACE(month_year, '2020-08','Aug-20'),
 month_year=REPLACE(month_year, '2021-02','Feb-21'),
 month_year=REPLACE(month_year, '2021-05','May-21');
 
 -- Now as whole column is having uniform values we can convert it to month-year date type whenever required.
 
 -- as here only 5 values were there thats why I am going with longer method to replace them. Before making the above changes I have confirm the values properly.
 
 UPDATE portfolio.fact_print_sales
 SET
 state = REPLACE(state, 'Uttar pradesh','Uttar Pradesh');
 
 SELECT copies_sold
 FROM portfolio.fact_print_sales
 WHERE copies_sold LIKE '%â%';
 
 -- There are 66 values which contains the a symbol 'â‚¹ so lets remove this sybol from the respective field.
 
 UPDATE portfolio.fact_print_sales
 SET
 copies_sold=TRIM(LEADING 'â' FROM copies_sold);
 
 SELECT * from portfolio.fact_print_sales;
 -- Do not know why it is not taking the symbol as whole so removing them one by one.
 
 SELECT copies_sold
 FROM portfolio.fact_print_sales
 WHERE copies_sold LIKE '%‚¹%';
 
 UPDATE portfolio.fact_print_sales
 SET
 copies_sold=TRIM(LEADING '‚¹' FROM copies_sold);
 -- Now all 66 values are changed.
 
 /*
 Now all the files are sucessulfyy cleanned and ready to be perfomed the analysis.
 Before performing the analysis the cleanned datasets have been saved separatley into the cleanned folder.
 */
 
 -- for Q 7 part 2 we required a special colum so updating the table here. 
 ALTER TABLE fact_ad_revenue
 ADD COLUMN ad_revenue_per_cir_copies DECIMAL(5,2);
 
UPDATE fact_ad_revenue
JOIN fact_print_sales
  ON fact_ad_revenue.edition_id = fact_print_sales.edition_id
SET
  fact_ad_revenue.ad_revenue_per_cir_copies = fact_ad_revenue.ad_revenue_INR / fact_print_sales.net_circulation;