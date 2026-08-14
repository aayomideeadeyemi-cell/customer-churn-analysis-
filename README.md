# Customer Churn Analysis

Excel + SQL analysis identifying the key drivers of customer churn for a subscription-based service, and translating the findings into concrete retention recommendations.

Note on the data: this project uses a synthetic practice dataset built to resemble a real customer churn scenario. It is not real client data, labeled here for transparency.

# Business Problem

Leadership wants to understand why customers are leaving. Specifically:

Which customer segments and behaviors are most associated with churn?
Is there anything actionable the business can do to reduce it?

# Deliverable: a cleaned dataset, verified findings, and 2–3 concrete recommendations leadership can act on.

# Data

881 customer records with the following fields: CustomerID, Age, Gender, Tenure_Months, Contract_Type, Internet_Service, Payment_Method, Monthly_Charges, Total_Charges, Tech_Support, Online_Security, Num_Support_Tickets, Churn.

# Data Cleaning

The raw data required several rounds of cleaning before it could be trusted for analysis. Full detail is in the Cleaning_Log sheet of the workbook- summary below:

# Issue	Fix
Header row corrupted (a single-column sort had displaced the CustomerID header to the last row, breaking the ID-to-record mapping)	Restored the header; assigned fresh surrogate IDs since the original mapping could not be reliably reconstructed
Inconsistent Contract_Type labels (Month-To-Month and Monthly used interchangeably)	Merged into a single category
5 negative Total_Charges values	Confirmed as a sign error (absolute value matched Monthly_Charges × Tenure_Months exactly in all 5 cases) and corrected to positive
17 missing Monthly_Charges values (paired with Total_Charges = $0.00 despite active tenure)	Imputed from the average rate of customers with the same Contract_Type + Internet_Service combination; Total_Charges recalculated to match
Scattered missing values in Internet_Service, Payment_Method, Tech_Support	Filled as "Unknown" rather than dropped or guessed
12 rows with Total_Charges = $0.00	Verified as legitimate, all 12 are brand-new customers with Tenure_Months = 0, not a data error

# Result: 881 clean rows, 0 duplicates, 0 missing values, 0 impossible values.

All cleaning and analysis findings were cross-verified in MySQL against the cleaned Excel data — see customer_churn_analysis.sql.

# Key Findings
# 1. Contract type is the dominant churn driver
Contract Type	Customers	Churn Rate
Month-To-Month	454	72.9%
Two Year	200	8.5%
One Year	227	7.0%

Month-to-Month customers churn at roughly 9–10x the rate of customers on an annual contract — by far the largest single effect in the data.

# 2. Support ticket volume shows a threshold effect
Support Tickets	Customers	Churn Rate
0	252	36.1%
1	324	38.3%
2	196	39.8%
3	78	64.1%
4	26	61.5%

Churn holds steady in the mid-30s for customers with 0–2 tickets, then nearly doubles once a customer files a 3rd ticket.

# 3. Tenure follows a U-shaped churn pattern
Tenure	Customers	Churn Rate
0–6 months	77	66.2%
7–24 months	204	33.8%
25–48 months	294	35.4%
49+ months	306	45.8%

Risk is highest for brand-new customers still deciding whether to stay, dips through the middle of the relationship, and climbs again for long-tenured customers.

# Other observations: Tech_Support and Monthly_Charges show moderate secondary effects. Online_Security was not predictive of churn.

# Recommendations
Convert Month-to-Month customers onto annual contracts. This is the single highest-leverage lever available  even a modest incentive to commit to a 1-year term could meaningfully cut churn, given the ~65-point gap in churn rate.
Flag accounts at their 3rd support ticket for proactive retention outreach, rather than waiting for a churn signal after the fact this is a clear, measurable early-warning threshold.
Strengthen onboarding in the first 6 months, and introduce loyalty/renewal touchpoints for customers approaching the 49-month mark, to address both ends of the U-shaped tenure curve.
# Tools Used
Excel, data cleaning, Power Query–style manual cleaning, PivotTable exploration
MySQL, verification queries confirming all three churn drivers independently of Excel
Files
customer_churn_analysis.xlsx — Cleaned_Data, Cleaning_Log, and Findings & Recommendations sheets
customer_churn_analysis.sql — table creation, data load, and verification queries
