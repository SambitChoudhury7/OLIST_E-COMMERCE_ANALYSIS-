# Olist E-Commerce Analysis

## Overview

An end-to-end analysis of the Olist Brazilian e-commerce marketplace using Python, PostgreSQL, and Power BI.

The project analyzes 100K+ orders to understand sales performance, geographic demand, delivery efficiency, customer satisfaction, and payment behavior.

The analysis focuses on identifying business patterns that can help improve revenue performance, delivery operations, and customer experience.

## Tools

Python (data cleaning, type conversion, validation) → PostgreSQL (business analysis and KPI calculations) → Power BI (dashboard and visualization)

## Data

Olist public Brazilian E-Commerce Dataset: orders, customers, order items, payments, reviews, products, and sellers.

The original dataset is not included in this repository because of file-size limitations.

## Methodology

- Converted date columns to appropriate datetime formats in Python
- Performed data validation and exploratory data analysis
- Wrote SQL queries in PostgreSQL to answer business questions
- Analyzed revenue, order volume, delivery performance, reviews, and payment behavior
- Built a one-page Power BI dashboard to present the key findings


## Key Findings

### Revenue & Sales

- Top category by revenue: Health & Beauty — R$1,258,681.34
- Other top-revenue categories included Watches & Gifts, Bed Bath Table, Sports & Leisure, and Computers Accessories
- São Paulo generated the highest state revenue at approximately R$5.2M
- São Paulo also had the highest order volume, with 40,501 orders

### Geography

- São Paulo generated approximately R$5,202,955 in revenue and 40,501 orders
- Despite having the highest revenue and order volume, São Paulo has the lowest average revenue per order (R$125.12) among the top 5 states by order volume — suggesting untapped potential to increase spend per customer in this market rather than just acquiring new ones
- Other major revenue-generating states included Rio de Janeiro, Minas Gerais, Rio Grande do Sul, and Paraná

### Delivery Performance

- Average delivery time: 12.6 days
- Late delivery rate: 7.87%
- Slowest states by average delivery time: Roraima, Amapá, Amazonas, Alagoas, and Pará
- March 2018 recorded a notable late-delivery spike of approximately 21.36%

### Customer Experience

- Average review score for on-time deliveries: 4.29/5
- Average review score for late deliveries: 2.57/5
- Late deliveries were associated with substantially lower customer review scores in the dataset
- Office Furniture was among the lowest-rated categories when considering categories with sufficient review volume

### Payments

- Most used payment method: Credit Card, with 76,795 recorded payments
- Average payment value:
  - Credit Card: R$163.32
  - Boleto: R$145.03
  - Debit Card: R$142.57
  - Voucher: R$65.70

## Recommendations

- Investigate delivery logistics in Roraima, Amapá, Amazonas, Alagoas, and Pará, where delivery times are longest and likely dragging down satisfaction
- Explore why São Paulo customers spend less per order despite the highest volume — potential for upsell/cross-sell campaigns given the existing customer base
- Prioritize delivery speed improvements broadly, given the sharp review-score drop (4.29 → 2.57) tied to late deliveries

## Dashboard

The Power BI dashboard includes:

- Total Revenue
- Total Orders
- Average Order Value
- Average Delivery Days
- Late Delivery %
- Top 5 Categories by Revenue
- Top 5 States by Revenue
- Revenue Trend
- Late Delivery Trend
- Review Score: On Time vs Late
- Top 5 Slowest States by Delivery Time
- Underserved Markets (Avg Revenue per Order by State)

### Dashboard Preview


## Limitations

- The dataset has limited observations from the early part of 2016 and the later part of 2018, so analysis is concentrated on the period with sufficient data coverage.




