--Cek 10 head rows--
SELECT * FROM financial_dataset LIMIT 10

--Cek Number of rows--
SELECT COUNT(*) AS number_of_rows FROM financial_dataset

--Cek Number of columns--
SELECT COUNT(*) AS number_of_columns
FROM information_schema.columns
WHERE table_name = 'financial_dataset';

--Cek column name and type column--
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'financial_dataset';

--Describe the data--
SELECT 
  COUNT(amount) AS number_of_data,
  AVG(CAST(amount AS numeric)) AS mean,
  STDDEV(CAST(amount AS numeric)) AS standard_deviation,
  MIN(CAST(amount AS numeric)) AS minimum,
  PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY CAST(amount AS numeric)) AS q1,
  PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY CAST(amount AS numeric)) AS median,
  PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY CAST(amount AS numeric)) AS q3,
  MAX(CAST(amount AS numeric)) AS maksimum
FROM financial_dataset;

--Cek Missing Value--
SELECT 
  SUM(CASE WHEN step IS NULL THEN 1 ELSE 0 END) AS null_step,
  SUM(CASE WHEN type IS NULL THEN 1 ELSE 0 END) AS null_type,
  SUM(CASE WHEN amount IS NULL THEN 1 ELSE 0 END) AS null_amount,
  SUM(CASE WHEN nameOrig IS NULL THEN 1 ELSE 0 END) AS null_nameOrig,
  SUM(CASE WHEN oldbalanceOrg IS NULL THEN 1 ELSE 0 END) AS null_oldbalanceOrg,
  SUM(CASE WHEN newbalanceOrig IS NULL THEN 1 ELSE 0 END) AS null_newbalanceOrig,
  SUM(CASE WHEN nameDest IS NULL THEN 1 ELSE 0 END) AS null_nameDest,
  SUM(CASE WHEN oldbalanceDest IS NULL THEN 1 ELSE 0 END) AS null_oldbalanceDest,
  SUM(CASE WHEN newbalanceDest IS NULL THEN 1 ELSE 0 END) AS null_newbalanceDest,
  SUM(CASE WHEN isFraud IS NULL THEN 1 ELSE 0 END) AS null_isFraud,
  SUM(CASE WHEN isFlaggedFraud IS NULL THEN 1 ELSE 0 END) AS null_isFlaggedFraud
FROM financial_dataset;

--Cek Data Duplicated--
SELECT 
  step, type, amount, nameOrig, nameDest,
  COUNT(*) AS number_of_data
FROM financial_dataset
GROUP BY step, type, amount, nameOrig, nameDest
HAVING COUNT(*) > 1;

--Cek Count of type of transaction--
SELECT type, COUNT(*) AS number_of_transaction
FROM financial_dataset
GROUP BY type
ORDER BY number_of_transaction DESC;

--Total & Average Number of Transactions by type--
SELECT 
  type,
  SUM(CAST(amount AS numeric)) AS total_amount
FROM financial_dataset
GROUP BY type
ORDER BY total_amount DESC;

--Average of transaction by type--
SELECT
	type,
	AVG(CAST(amount AS numeric)) AS average_amount
FROM financial_dataset
GROUP BY type
ORDER BY average_amount DESC;

--Count fraud by type--
SELECT 
  type,
  COUNT(*) FILTER (WHERE CAST(isFraud AS INTEGER) = 1) AS count_of_fraud
FROM financial_dataset
GROUP BY type
ORDER BY count_of_fraud DESC;

--Percentage fraud by type--
SELECT
	type,
	 ROUND(
    100.0 * COUNT(*) FILTER (WHERE CAST(isFraud AS INTEGER) = 1) / COUNT(*), 
    2
  ) AS precentage_fraud
FROM financial_dataset
GROUP BY type
ORDER BY precentage_fraud DESC;

--Fraud loss by type--
SELECT
  type,
  SUM(CAST(amount AS NUMERIC)) FILTER (WHERE CAST(isFraud AS INTEGER) = 1) AS fraud_loss
FROM financial_dataset
GROUP BY type
ORDER BY fraud_loss;

--Sender Accounts Most Frequently Involved in Fraud--
SELECT 
  nameOrig,
  COUNT(*) AS number_of_fraud
FROM financial_dataset
WHERE CAST (isFraud AS INTEGER) = 1
GROUP BY nameOrig
ORDER BY number_of_fraud DESC
LIMIT 10;

--Count account fraud--
SELECT 
  COUNT(*) AS number_of_fraud
FROM financial_dataset
WHERE CAST (isFraud AS INTEGER) = 1

--Fraud value ratio--
SELECT
  100 * SUM(CAST(CASE WHEN CAST(isFraud AS INTEGER) = 1 THEN CAST(amount AS NUMERIC) ELSE 0 END AS NUMERIC)) 
      / SUM(CAST(amount AS NUMERIC)) AS fraud_amount_ratio
FROM financial_dataset;

--Fraud transaction ratio--
SELECT
  100.0 * SUM(CASE WHEN CAST(isFraud AS INTEGER) = 1 THEN 1 ELSE 0 END) 
       / COUNT(isFraud) AS fraud_ratio
FROM financial_dataset;

--Total fraud loss--
SELECT
  SUM(CASE WHEN CAST(isFraud AS INTEGER) = 1 THEN CAST(amount AS NUMERIC) ELSE 0 END) AS fraud_loss
FROM financial_dataset;

--Number of Fraud Cases by Step (Time)--
SELECT 
  CAST(step AS INTEGER) AS hour_to,
  COUNT(*) AS number_of_fraud
FROM financial_dataset
WHERE CAST(isFraud AS INTEGER) = 1
GROUP BY hour_to
ORDER BY hour_to;
