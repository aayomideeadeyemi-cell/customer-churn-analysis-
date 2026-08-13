USE customer_churn;
LOAD DATA LOCAL INFILE 'C:/Users/DELL/Downloads/customer_churn_cleaned.csv'
INTO TABLE churn
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
SELECT Contract_Type,
  COUNT(*) AS total_customers,
  SUM(CASE WHEN Churn='Yes' THEN 1 ELSE 0 END) AS churned,
  ROUND(SUM(CASE WHEN Churn='Yes' THEN 1 ELSE 0 END)*100.0/COUNT(*), 1) AS churn_rate_pct
FROM churn
GROUP BY Contract_Type
ORDER BY churn_rate_pct DESC;
SELECT DISTINCT Churn, LENGTH(Churn) FROM churn;
UPDATE churn SET Churn = TRIM(TRAILING '"' FROM Churn);
SET SQL_SAFE_UPDATES = 0;
UPDATE churn SET Churn = TRIM(TRAILING '"' FROM Churn);
SELECT DISTINCT Churn, LENGTH(Churn) FROM churn;
SELECT Churn, HEX(Churn) FROM churn LIMIT 5;
UPDATE churn SET Churn = TRIM(TRAILING CHAR(13) FROM Churn);
SELECT DISTINCT Churn, LENGTH(Churn) FROM churn;
SELECT Contract_Type,
  COUNT(*) AS total_customers,
  SUM(CASE WHEN Churn='Yes' THEN 1 ELSE 0 END) AS churned,
  ROUND(SUM(CASE WHEN Churn='Yes' THEN 1 ELSE 0 END)*100.0/COUNT(*), 1) AS churn_rate_pct
FROM churn
GROUP BY Contract_Type
ORDER BY churn_rate_pct DESC;
SELECT Num_Support_Tickets,
  COUNT(*) AS total_customers,
  ROUND(SUM(CASE WHEN Churn='Yes' THEN 1 ELSE 0 END)*100.0/COUNT(*), 1) AS churn_rate_pct
FROM churn
GROUP BY Num_Support_Tickets
ORDER BY Num_Support_Tickets;
SELECT
  CASE
    WHEN Tenure_Months <= 6 THEN '0-6 months'
    WHEN Tenure_Months <= 24 THEN '7-24 months'
    WHEN Tenure_Months <= 48 THEN '25-48 months'
    ELSE '49+ months'
  END AS tenure_bucket,
  COUNT(*) AS total_customers,
  ROUND(SUM(CASE WHEN Churn='Yes' THEN 1 ELSE 0 END)*100.0/COUNT(*), 1) AS churn_rate_pct
FROM churn
GROUP BY tenure_bucket
ORDER BY MIN(Tenure_Months);