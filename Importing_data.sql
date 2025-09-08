/*
This File is generated to analyse the dataset for the Legacy Newspaper
that is loosing the readers post covid.
Lets first create a database and import our tables
*/

CREATE DATABASE Portfolio;

USE Portfolio; -- to specifying the database in use

CREATE TABLE dim_ad_category(ad_category VARCHAR(20) PRIMARY KEY, 
standard_ad_category VARCHAR(20),
category_group VARCHAR(30),
example_brands VARCHAR(40));
DROP TABLE dim_ad_category;
SELECT * FROM dim_ad_category;

CREATE TABLE dim_city(
city_id VARCHAR(8) PRIMARY KEY, 
city VARCHAR(20), 
state VARCHAR(30), 
tier VARCHAR(30));
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         
SELECT * FROM dim_city;

CREATE TABLE fact_ad_revenue(
edition_id VARCHAR(15), 
ad_category VARCHAR(20),
quarter_year VARCHAR(20),
ad_revenue FLOAT,
currency VARCHAR(20),
comments VARCHAR(50),
FOREIGN KEY (ad_category) REFERENCES dim_ad_category(ad_category));
DROP TABLE fact_ad_revenue;
SELECT * FROM fact_ad_revenue;

CREATE TABLE fact_city_readiness(
city_id VARCHAR(8),
quarter_year VARCHAR(20),
literacy_rate FLOAT,
smartphone_penitration FLOAT,
internet_penetration FLOAT,
FOREIGN KEY (city_id) REFERENCES dim_city(city_id));

SELECT * FROM fact_city_readiness;

CREATE TABLE fact_digital_plot(
platform VARCHAR(50),
launch_month VARCHAR(10),
ad_category VARCHAR(10),
dev_cost INT,
marketing_cost INT,
user_reach INT,
download_or_accesses INT,
avg_bounce_rate FLOAT,
cumulative_feedback_from_customer VARCHAR(100),
city_id VARCHAR(20),
FOREIGN KEY (ad_category) REFERENCES dim_ad_category(ad_category),
FOREIGN KEY (city_id) REFERENCES dim_city(city_id));


SELECT * FROM fact_digital_plot;

CREATE TABLE fact_print_sales(
edition_id VARCHAR(10),
city_id VARCHAR(20),
language_type VARCHAR(20),
state VARCHAR(40),
month_year VARCHAR(10),
copies_sold VARCHAR(15), -- As some of the values contain a symbol
copies_returned INT,
net_circulation INT,
FOREIGN KEY (city_id) REFERENCES dim_city(city_id));

SELECT * FROM fact_print_sales;