# OBJECTIVE
The objective of this analysis is to analyze the crisis faced by a legacy newspaper organisation named called Bharat herald. As a data analyst, my task is to analyze the company's operational and financial data from 2019 to 2024 to understand why its print circulation and revenue have declined. The goal is to quantify what went wrong, identify potential for recovery, and recommend a phased roadmap for digital transformation to help the company survive and thrive in the digital age.

# DATA SOURCE
The data was provided by Codebasics and consist of several tables containing operational and financial data for Bharat Herald from January 2019 to December 2024.


# STEPS OF DATA ANALYSIS
## Data Import and ERD
First step is to importing all the data into the MY SQL bench.  Also before importing making sure that format of the all the tables are same that is in .csv.
** Tables name and Changes: **
* dim_ad_category
* dim_city
* fact_ad_revenue
* fact_city_readiness
* fact_digital_pilot
* fact_print_sales
### Changes
* Table dim_ad_category, dim_city and fact_print_sales was in .xlsv format so changed them into the .csv format.
* tables fact_digital_pilot & fact_city_readiness contains one extra columns, so while importing didnot take them into consideration.
* All the tables are sucessfully imported, after peoperly mentioning the primary key and Forign keys.

### ERD(ENTITY RELATIONSHIP DIAGRAM)
ERD is created to know the relationship and to check weather the keys are placed proplerly or not.
<img width="1121" height="813" alt="image" src="https://github.com/user-attachments/assets/6543f6c0-0575-4708-bb51-0ac919430e1a" />

## Data Cleaning 

