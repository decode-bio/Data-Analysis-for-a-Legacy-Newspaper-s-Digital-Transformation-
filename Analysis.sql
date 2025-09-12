-- Primary and secondary data analysis

-- Q1.Print Circulation Trends
/* What is the trend in copies printed, copies sold, and net circulation across all
cities from 2019 to 2024? How has this changed year-over-year?
*/

SELECT * FROM portfolio.fact_print_sales;

USE portfolio;

SELECT 
    CASE
        WHEN fact_print_sales.month_year LIKE '%19%' THEN '2019'
        WHEN fact_print_sales.month_year LIKE '%20%' THEN '2020'
        WHEN fact_print_sales.month_year LIKE '%21%' THEN '2021'
        WHEN fact_print_sales.month_year LIKE '%22%' THEN '2022'
        WHEN fact_print_sales.month_year LIKE '%23%' THEN '2023'
        ELSE '2024'
    END AS years,
    SUM(fact_print_sales.copies_sold) AS total_copies_sold,
    SUM(fact_print_sales.copies_returned) AS total_copies_returned,
    SUM(fact_print_sales.net_circulation) AS total_net_circulation
FROM
    portfolio.fact_print_sales
GROUP BY years
ORDER BY years;

/*
As copies_printed was not provided I am taking or assuming that copies sold is equals to the copies printed. So copies sold is higest in 2019 and after that decreasing continously 
till 2024. Similar trend is followed by copies returned. As fas as we talk about the net circulation, it is also decreasing year by year. To get the seriousness of copies returned 
and net circulation, it is important to convert them in percentage and then compare.
*/

-- Q2: Print Top performing cities
/*
Which cities contributed the highest to net circulation and copies sold in 2024?
Are these cities still profitable to operate in?
*/


SELECT 
    dim_city.city AS cities,
    SUM(fact_print_sales.net_circulation) AS total_net_circulation
FROM
    fact_print_sales
        JOIN
    dim_city ON fact_print_sales.city_id = dim_city.city_id
WHERE
    fact_print_sales.month_year LIKE '%24%'
GROUP BY cities
ORDER BY total_net_circulation DESC;

/* Jaipur have highest net circulation i.e approx 41.28 lakh copies followed by Varanasi i.e. 41.23 lakhs in 2024. 
The lowest circulation is observed in Lucknow which is 17.63 lakhs.
*/

-- Q3. Print waste analysis

/*
Which cities have the largest gap between copies printed and net circulation, and
how has that gap changed over time?
*/
SELECT 
    dim_city.city AS cities,
    SUM(fact_print_sales.copies_returned) AS copies_returned
FROM
    fact_print_sales
        JOIN
    dim_city ON fact_print_sales.city_id = dim_city.city_id
GROUP BY cities
ORDER BY copies_returned DESC;

-- The largest gap is between copies sold and net circulation is in Jaipur that is 16.76 lakhs copies returned from 2019 - 2024.

SELECT dim_city.city As cities,
    CASE
        WHEN fact_print_sales.month_year LIKE '%19%' THEN '2019'
        WHEN fact_print_sales.month_year LIKE '%20%' THEN '2020'
        WHEN fact_print_sales.month_year LIKE '%21%' THEN '2021'
        WHEN fact_print_sales.month_year LIKE '%22%' THEN '2022'
        WHEN fact_print_sales.month_year LIKE '%23%' THEN '2023'
        ELSE '2024'
    END AS years,
    SUM(fact_print_sales.copies_returned) AS total_copies_returned
    FROM fact_print_sales
    JOIN dim_city
    ON fact_print_sales.city_id = dim_city.city_id
GROUP BY cities,
CASE
WHEN fact_print_sales.month_year LIKE '%19%' THEN '2019'
        WHEN fact_print_sales.month_year LIKE '%20%' THEN '2020'
        WHEN fact_print_sales.month_year LIKE '%21%' THEN '2021'
        WHEN fact_print_sales.month_year LIKE '%22%' THEN '2022'
        WHEN fact_print_sales.month_year LIKE '%23%' THEN '2023'
        ELSE '2024'
    END
ORDER BY years;

-- Q 4: Ad Revenue Trends by Category
/*
How has ad revenue evolved across different ad categories between 2019 and
2024? Which categories have remained strong, and which have declined?
*/

SELECT 
    *
FROM
    fact_ad_revenue;

  
SELECT 
    fact_ad_revenue.ad_category,
    SUM(fact_ad_revenue.ad_revenue_INR) AS total_revenue
FROM
    fact_ad_revenue
GROUP BY fact_ad_revenue.ad_category
ORDER BY total_revenue DESC;

-- Over the year ad category A001 has earned highest revenue of 670 cr followed by category A003 with 660 cr.
-- lets see the categories over the time.

SELECT 
    CASE
        WHEN quarter_year LIKE '%2019%' THEN '2019'
        WHEN quarter_year LIKE '%2020%' THEN '2020'
        WHEN quarter_year LIKE '%2021%' THEN '2021'
        WHEN quarter_year LIKE '%2022%' THEN '2022'
        WHEN quarter_year LIKE '%2023%' THEN '2023'
        ELSE '2024'
    END AS ad_year,
    fact_ad_revenue.ad_category,
    SUM(fact_ad_revenue.ad_revenue_INR) AS total_ad_revenue
FROM
    fact_ad_revenue
GROUP BY ad_year , fact_ad_revenue.ad_category
ORDER BY ad_year , total_ad_revenue DESC;
  
SELECT 
    fact_ad_revenue.ad_category,
    SUM(CASE
        WHEN fact_ad_revenue.quarter_year LIKE '%2019%' THEN ad_revenue_INR
        ELSE 0
    END) AS ad_revenue_2019,
    SUM(CASE
        WHEN fact_ad_revenue.quarter_year LIKE '%2020%' THEN ad_revenue_INR
        ELSE 0
    END) AS ad_revenue_2020,
    SUM(CASE
        WHEN fact_ad_revenue.quarter_year LIKE '%2021%' THEN ad_revenue_INR
        ELSE 0
    END) AS ad_revenue_2021,
    SUM(CASE
        WHEN fact_ad_revenue.quarter_year LIKE '%2022%' THEN ad_revenue_INR
        ELSE 0
    END) AS ad_revenue_2022,
    SUM(CASE
        WHEN fact_ad_revenue.quarter_year LIKE '%2023%' THEN ad_revenue_INR
        ELSE 0
    END) AS ad_revenue_2023,
    SUM(CASE
        WHEN fact_ad_revenue.quarter_year LIKE '%2024%' THEN ad_revenue_INR
        ELSE 0
    END) AS ad_revenue_2024
FROM
    fact_ad_revenue
GROUP BY fact_ad_revenue.ad_category
ORDER BY fact_ad_revenue.ad_category;
  
-- Q 5: city_level ad revenue performance
/*
Which cities generated the most ad revenue, and how does that correlate with
their print circulation?
*/
SELECT 
    dim_city.city AS cities,
    SUM(fact_ad_revenue.ad_revenue_INR) AS total_revenue
FROM
    fact_ad_revenue
        JOIN
    fact_print_sales ON fact_ad_revenue.edition_id = fact_print_sales.edition_id
        JOIN
    dim_city ON fact_print_sales.city_id = dim_city.city_id
GROUP BY cities
ORDER BY total_revenue DESC;

-- The largest revenue is earned by city patna whihc is 17 billion INR. If we correlate it with the net circulation then patna is at third from the bottom position.

-- Q6.Digital Readiness vs. Performance
-- Which cities show high digital readiness (based on smartphone, internet, and
-- literacy rates) but had low digital pilot engagement?

SELECT * FROM fact_city_readiness;

SELECT 
    dim_city.city AS cities,
    (AVG(fact_city_readiness.smartphone_penitration) + AVG(fact_city_readiness.internet_penetration) + AVG(fact_city_readiness.literacy_rate)) / 3 AS Digi_readiness_score,
    (SUM(fact_digital_pilot.download_or_accesses) / SUM(fact_digital_pilot.user_reach)) * 100 AS activation_rate, AVG(fact_digital_pilot.avg_bounce_rate) As Bounce_rate
FROM
    fact_city_readiness
        JOIN
    dim_city ON fact_city_readiness.city_id = dim_city.city_id
        JOIN
    fact_digital_pilot ON fact_city_readiness.city_id = fact_digital_pilot.city_id
GROUP BY cities
ORDER BY Digi_readiness_score DESC, 
activation_rate ASC,
Bounce_rate ASC;

-- Kanpur is the city having the high Digi_readiness_score but low activation_rate ang high bounce rate. 
-- Ranchi having the lowest digital activation engagement.

-- Q7. Ad Revenue vs. Circulation ROI
-- Which cities had the highest ad revenue per net circulated copy? Is this ratio
-- improving or worsening over time

SELECT * FROM fact_ad_revenue;

SELECT 
    dim_city.city AS cities,
    (SUM(fact_ad_revenue.ad_revenue_INR) / SUM(fact_print_sales.net_circulation)) AS ad_revenue_per_net_cir_copy
FROM
    fact_ad_revenue
        JOIN
    fact_print_sales ON fact_ad_revenue.edition_id = fact_print_sales.edition_id
        JOIN
    dim_city ON fact_print_sales.city_id = dim_city.city_id
GROUP BY cities
ORDER BY ad_revenue_per_net_cir_copy DESC;

-- Lucknow is the city with highest ad revenue per net circulated copy.(Part)
-- Part 2 : How it is changing over the time.

-- For this part let us do some changes in original table and then calculate this otherwise it is becomeing too complicated.
-- added mew column to the fact_ad_revenue table that is ad_revenue_per_cir_copy

SELECT dim_city.city AS cities,
SUM(CASE WHEN fact_ad_revenue.quarter_year LIKE '%2019%' THEN fact_ad_revenue.ad_revenue_per_cir_copies ELSE 0 END)/COUNT(dim_city.city)  AS ratio_2019,
  SUM(CASE WHEN fact_ad_revenue.quarter_year LIKE '%2020%' THEN fact_ad_revenue.ad_revenue_per_cir_copies ELSE 0 END)/COUNT(dim_city.city) AS ratio_2020,
  SUM(CASE WHEN fact_ad_revenue.quarter_year LIKE '%2021%' THEN fact_ad_revenue.ad_revenue_per_cir_copies ELSE 0 END)/COUNT(dim_city.city) AS ratio_2021,
  SUM(CASE WHEN fact_ad_revenue.quarter_year LIKE '%2022%' THEN fact_ad_revenue.ad_revenue_per_cir_copies ELSE 0 END)/COUNT(dim_city.city) AS ratio_2022,
  SUM(CASE WHEN fact_ad_revenue.quarter_year LIKE '%2023%' THEN fact_ad_revenue.ad_revenue_per_cir_copies ELSE 0 END)/COUNT(dim_city.city) AS ratio_2023,
  SUM(CASE WHEN fact_ad_revenue.quarter_year LIKE '%2024%' THEN fact_ad_revenue.ad_revenue_per_cir_copies ELSE 0 END)/COUNT(dim_city.city) AS ratio_2024
  
FROM
    fact_ad_revenue
        JOIN
    fact_print_sales ON fact_ad_revenue.edition_id = fact_print_sales.edition_id
        JOIN
    dim_city ON fact_print_sales.city_id = dim_city.city_id
GROUP BY cities;

SELECT ad_revenue_per_cir_copies
FROM fact_ad_revenue;

-- Q8: Digital Relaunch City Prioritization
-- Based on digital readiness, pilot engagement, and print decline, which 3 cities should be
-- prioritized for Phase 1 of the digital relaunch?

SELECT
    dim_city.city AS cities,
    (AVG(fact_city_readiness.smartphone_penitration) + AVG(fact_city_readiness.internet_penetration) + AVG(fact_city_readiness.literacy_rate)) / 3 AS Digi_readiness_score,
    (SUM(fact_digital_pilot.download_or_accesses) / SUM(fact_digital_pilot.user_reach)) * 100 AS activation_rate,
    AVG(fact_digital_pilot.avg_bounce_rate) AS Bounce_rate,
    AVG(CASE WHEN fact_print_sales.month_year LIKE '%20%' THEN fact_print_sales.net_circulation END) AS circulation_2020,
    AVG(CASE WHEN fact_print_sales.month_year LIKE '%21%' THEN fact_print_sales.net_circulation END) AS circulation_2021,
    (AVG(CASE WHEN fact_print_sales.month_year LIKE '%20%' THEN fact_print_sales.net_circulation END) - AVG(CASE WHEN fact_print_sales.month_year LIKE '%21%' THEN fact_print_sales.net_circulation END)) / AVG(CASE WHEN fact_print_sales.month_year LIKE '%20%' THEN fact_print_sales.net_circulation END) * 100 AS per_decline
FROM
    dim_city
JOIN
    fact_city_readiness ON dim_city.city_id = fact_city_readiness.city_id
JOIN
    fact_digital_pilot ON dim_city.city_id = fact_digital_pilot.city_id
JOIN
    fact_print_sales ON dim_city.city_id = fact_print_sales.city_id
GROUP BY
    cities
ORDER BY
    Digi_readiness_score DESC,
    activation_rate DESC,
    Bounce_rate ASC;
    
    
-- the three cities based on the parameter and print decline shold get ready for relaunch of digital app are
--  1. Varanasi 2. Lucknow 3. Bhopal or Ahemdabad
