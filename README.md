# olist-fashion-retention-analysis
Customer retention and churn analysis for Olist Fashion using SQL, Python, Tableau, K-Means, Logistic Regression, and NLP.

## Project Overview

This project analyzes customer retention challenges in Olist's fashion category. Although Olist showed strong year-over-year marketplace growth in 2018, only 3.61% of customers made a second purchase within 180 days.

The goal of this project is to identify customer segments, quantify churn drivers, and recommend segment-specific retention strategies.

## Business Questions

1. Who are Olist Fashion customers?
2. Why do customers fail to return?
3. Which operational factors influence repurchase behavior?
4. What retention strategies should Olist prioritize?

## Tools Used

- SQL
- Python
- Tableau
- K-Means Clustering
- Decision Tree
- Logistic Regression
- NLP / Keyword Analysis

## Key Findings

- Only 3.61% of customers repurchased within 180 days.
- K-Means clustering identified four customer personas: One-Timers, Newcomers, Repeat Customers, and High-Value VIPs.
- Decision Tree analysis revealed a key order-value split at $98.71.
- Value Segment customers are more sensitive to product price and shipping cost.
- Premium Segment customers are more sensitive to delivery delays.
- Delivery-related keywords appeared frequently in customer reviews, validating fulfillment experience as a key retention issue.

## Business Recommendations

- For value customers: test free shipping, bundled promotions, and first-repeat-purchase incentives.
- For premium customers: prioritize delivery reliability, VIP service recovery, and fulfillment transparency.
- Use fulfillment latency as an early-warning signal for retention risk.

## Project Files

- `Olist_Fashion_Retention_Analysis.pdf`: business-facing project report
- `sql/`: SQL scripts for data cleaning and feature engineering
- `python/`: Jupyter notebooks for segmentation, modeling, and NLP
- `tableau/`: Tableau workbook
- `outputs/`: figures
