# OBJECTIVE
This project provides a comprehensive data-driven analysis for Bharat Herald, a legacy newspaper facing a critical decline in print circulation and ad revenue. The objective is to quantify the company's operational and financial challenges from 2019-2024 and to recommend a phased roadmap for digital transformation.
The analysis addresses key business questions to identify opportunities for recovery and guide strategic decisions in a post-COVID digital era.
The analysis was performed using **intermediate SQL techniques** to transform raw transaction data into actionable business intelligence.

# Data Source & Data Model
The analysis is based on six interconnected tables capturing data from 2019 to 2024. This relational data model was used to join and transform raw data into a cohesive analytical dataset.

```fact_print_sales```: Monthly print circulation performance (copies sold, net circulation, etc.).

```fact_ad_revenue```: Quarterly ad revenue by category and city.

```fact_digital_pilot```: Performance metrics from the 2021 e-paper pilot.

```fact_city_readiness```: Dynamic, time-based digital readiness scores (literacy, smartphone/internet penetration).

```dim_city & dim_ad_category```: Lookup tables for city and ad category information.

The tables are linked via foreign keys such as ```city_id```, ```ad_category```, and ```edition_id```.

The data was provided by **Codebasics** and consist of several tables containing operational and financial data for Bharat Herald from January 2019 to December 2024.

### ERD(ENTITY RELATIONSHIP DIAGRAM)
ERD is created to know the relationship and to check weather the keys are placed proplerly or not.
<img width="1121" height="813" alt="image" src="https://github.com/user-attachments/assets/6543f6c0-0575-4708-bb51-0ac919430e1a" />

## Key Business Questions Addressed
To guide the analysis, the following core business questions were answered:

* Print Circulation Trends: What is the trend in net circulation from 2019 to 2024?
* Ad Revenue Concentration: Identify ad categories that contributed over 50% of total yearly revenue.
* Print Efficiency Leaderboard: For 2024, rank cities by their print efficiency ratio (net_circulation / copies_printed).
* Internet Readiness Growth: For each city, compute the growth in internet penetration from Q1-2021 to Q4-2021.
* Consistent Multi-Year Decline: Find cities where both net circulation and ad revenue have decreased every year from 2019 through 2024.
* Ad Revenue vs. Circulation ROI: Which cities had the highest ad revenue per net circulated copy?
* Digital Relaunch City Prioritization: Based on a combined score of digital readiness, pilot engagement, and print decline, which 3 cities should be prioritized for the Phase 1 digital relaunch?

## SQL Skills Demonstrated
The project required a range of intermediate SQL skills to clean, analyze, and transform the data:

* Complex Multi-Table Joins: Used JOIN to combine fact and dimension tables to create a unified dataset for analysis.
* Advanced Aggregation: Employed SUM(), AVG(), COUNT(), and GROUP BY to compute core business metrics.
* Conditional Aggregation: Utilized CASE statements to perform pivot tables, filter data based on specific conditions, and calculate metrics for different years within a single query.
* Date: Here I have not converted YYYY-MM or MM - YY into date format as I want to use it as string later.

## Analysis & Key Findings
The final analysis provided a clear picture of the company's challenges and opportunities:

* In 2024, Jaipur had the highest circulation at approximately 41.28 lakh copies, while Varanasi was a close second with 41.23 lakh copies. Lucknow had the lowest circulation at 17.63 lakh copies.
* Over the period from 2019 to 2024, the difference between copies sold and net circulation was largest in Jaipur, with 16.76 lakh copies returned.
* Despite earning the largest revenue at 17 billion INR, Patna's net circulation ranks third from the bottom.
* While Kanpur has the highest Digital Readiness Score, it shows low engagement with a low Activation Rate and a high Bounce Rate. Additionally, Ranchi has the lowest digital engagement.
* **Digital Transformation Roadmap:** A comprehensive prioritization model revealed that Bhopal, Ahemdabad, and Lucknow are the ideal candidates for the Phase 1 digital relaunch. These cities demonstrated a strong combination of high digital readiness, proven pilot engagement, and a significant decline in print sales, indicating a strong market need for a digital alternative.
* **Print Decline Trends:** Print circulation has dropped by more than 50% between 2019 and 2024, with the sharpest declines occurring in metropolitan Tier 1 cities.
* **Ad Revenue Concentration:** While total ad revenue is declining, the FMCG and Real Estate ad categories consistently contributed over 50% of yearly revenue, indicating these are key relationships to protect.
  




