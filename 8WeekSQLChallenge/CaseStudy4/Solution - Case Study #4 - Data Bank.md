# Case Study #4 - Data Bank

https://8weeksqlchallenge.com/case-study-4/

### Schema

https://github.com/eseylar/PortfolioProjects/blob/main/8WeekSQLChallenge/CaseStudy4/schema.sql

---

## A. Customer Nodes Exploration

### 1. How many unique nodes are there on the Data Bank system?

```sql
SELECT
	COUNT (DISTINCT (node_id))
FROM
	data_bank.customer_nodes;
```

| count |
| --- |
| 5 |

### 2. What is the number of nodes per region?

```sql
SELECT
	cus.region_id
	, r.region_name
	, COUNT (cus.node_id)
FROM
	data_bank.customer_nodes AS cus
JOIN
	data_bank.regions AS r
ON
	cus.region_id = r.region_id
GROUP BY
	cus.region_id
	, r.region_name
ORDER BY
	cus.region_id
```

| region_id | region_name | count |
| --- | --- | --- |
| 1 | Australia | 770 |
| 2 | America | 735 |
| 3 | Africa | 714 |
| 4 | Asia | 665 |
| 5 | Europe | 616 |

### 3. How many customers are allocated to each region?

```sql
SELECT
	cus.region_id
	, r.region_name
	, COUNT ( DISTINCT (cus.customer_id) )
FROM
	data_bank.customer_nodes AS cus
JOIN
	data_bank.regions AS r
ON
	cus.region_id = r.region_id
GROUP BY
	cus.region_id
	, r.region_name
ORDER BY
	cus.region_id ASC;
```

| region_id | region_name | count |
| --- | --- | --- |
| 1 | Australia | 110 |
| 2 | America | 105 |
| 3 | Africa | 102 |
| 4 | Asia | 95 |
| 5 | Europe | 88 |

### 4. How many days on average are customers reallocated to a different node?

```sql
SELECT
	AVG ( DATE_PART ('day', end_date::timestamp - start_date::timestamp) ) AS ave_length
FROM
	data_bank.customer_nodes
WHERE
	end_date != '9999-12-31';
```

| ave_length |
| --- |
| 14.634 |

### 5. What is the median, 80th and 95th percentile for this same reallocation days metric for each region?

```sql
SELECT
	cus.region_id
	, r.region_name
	, PERCENTILE_CONT(.5) WITHIN GROUP (ORDER BY DATE_PART ('day', cus.end_date::timestamp - cus.start_date::timestamp)) AS pctl_50
	, PERCENTILE_CONT(.8) WITHIN GROUP (ORDER BY DATE_PART ('day', cus.end_date::timestamp - cus.start_date::timestamp)) AS pctl_80
	, PERCENTILE_CONT(.95) WITHIN GROUP (ORDER BY DATE_PART ('day', cus.end_date::timestamp - cus.start_date::timestamp)) AS pctl_95
FROM
	data_bank.customer_nodes AS cus
JOIN
	data_bank.regions AS r
ON
	cus.region_id = r.region_id
WHERE
	end_date != '9999-12-31'
GROUP BY
	cus.region_id
	, r.region_name;
```

| region_id | region_name | pctl_50 | pctl_80 | pctl_95 |
| --- | --- | --- | --- | --- |
| 1 | Australia | 15 | 23 | 28 |
| 2 | America | 15 | 23 | 28 |
| 3 | Africa | 15 | 24 | 28 |
| 4 | Asia | 15 | 23 | 28 |
| 5 | Europe | 15 | 24 | 28 |

---

## **B. Customer Transactions**

### 1. What is the unique count and total amount for each transaction type?

```sql
SELECT
	txn_type
    , COUNT (*) AS unique_count
    , SUM (txn_amount) AS total_amount
FROM
    data_bank.customer_transactions
GROUP BY
	txn_type;
```

| txn_type | unique_count | total_amount |
| --- | --- | --- |
| purchase | 1617 | 806537 |
| deposit | 2671 | 1359168 |
| withdrawal | 1580 | 793003 |

### 2. What is the average total historical deposit counts and amounts for all customers?

```sql
WITH cte AS
(
SELECT
	customer_id
    , COUNT (*) AS txn_count
    , SUM (txn_amount) AS txn_sum
FROM
    data_bank.customer_transactions
WHERE
	txn_type = 'deposit'
GROUP BY
	customer_id
)

SELECT
	ROUND ( AVG (txn_count) , 2) AS ave_count
    , ROUND ( AVG (txn_sum) , 2) AS ave_amount
FROM
	cte;
```

| ave_count | ave_amount |
| --- | --- |
| 5.34 | 2718.34 |

### 3. For each month - how many Data Bank customers make more than 1 deposit and either 1 purchase or 1 withdrawal in a single month?

```sql
WITH cte AS
(
SELECT
	customer_id
    , DATE_PART ('month', txn_date) AS month_
    , SUM (CASE WHEN txn_type = 'deposit' THEN 1 ELSE 0 END) AS deposit_sum
    , SUM (CASE WHEN txn_type = 'withdrawal' THEN 1 ELSE 0 END) AS withdrawal_sum
    , SUM (CASE WHEN txn_type = 'purchase' THEN 1 ELSE 0 END) AS purchase_sum
FROM
	data_bank.customer_transactions
GROUP BY
	customer_id
    , month_
ORDER BY
	customer_id
    , month_
)

SELECT
	month_
    , COUNT (*)
FROM
	cte
WHERE
	deposit_sum > 1
    	AND 
    (withdrawal_sum = 1 OR purchase_sum = 1)
GROUP BY
	month_
ORDER BY
	month_;
```

| month_ | count |
| --- | --- |
| 1 | 115 |
| 2 | 108 |
| 3 | 113 |
| 4 | 50 |

### 4. What is the closing balance for each customer at the end of the month?

```sql
--cte1: query the customer_id, the month of transaction, and use CASE to put amounts of despoit, withdrawal, and purchase on the same record
WITH cte1 AS
(
SELECT
	customer_id
    , DATE_PART ('month', txn_date) AS month_
    , CASE WHEN txn_type = 'deposit' THEN txn_amount ELSE 0 END AS deposit_sum
    , CASE WHEN txn_type = 'withdrawal' THEN txn_amount ELSE 0 END AS withdrawal_sum
    , CASE WHEN txn_type = 'purchase' THEN txn_amount ELSE 0 END AS purchase_sum
FROM
	data_bank.customer_transactions
GROUP BY
	customer_id
    , month_
    , txn_type
    , txn_amount
ORDER BY
	customer_id
    , month_
    , txn_type
    , txn_amount 
),

--cte2: sum up all despoit, withdrawl, and purchase transactions per month to create a monthly summary of total usage by transaction type
cte2 AS
(
SELECT
	customer_id
    , month_
	, SUM (deposit_sum) AS monthly_deposit
    , SUM (withdrawal_sum) AS monthly_withdrawal
    , SUM (purchase_sum) AS monthly_purchase
FROM
	cte1
GROUP BY
	customer_id
    , month_
),

--cte3: add despoits and subtract withdrawals and purchases to create a balance for each month
cte3 AS
(
SELECT
	customer_id
    , month_
    , ( monthly_deposit + (-1 * monthly_withdrawal) + (-1 * monthly_purchase) ) AS balance_by_month
FROM
	cte2
GROUP BY
	customer_id
    , month_
    , balance_by_month
ORDER BY
	customer_id
    , month_
),

--cte4: use LAG() to query the previous month's balance
cte4 AS
(
SELECT
	customer_id
    , month_
    , balance_by_month
    , LAG (balance_by_month, 1) OVER
    	(PARTITION BY customer_id) AS prev_month_balance
FROM
	cte3
)

--add the current month and the previous month's balance to create an aggreagate/rolling balance for each month (using a CASE to turn NULL values into 0 values)
SELECT
	customer_id
    , month_
    , (balance_by_month + 
      	(CASE WHEN prev_month_balance IS NULL THEN 0 ELSE prev_month_balance END)
      ) AS agg_monthly_balance
FROM
	cte4;
```

*******************(sample of entries - there are 1720 records in the full table)*******************

| customer_id | month_ | agg_monthly_balance |
| --- | --- | --- |
| 1 | 1 | 312 |
| 1 | 3 | -640 |
| 2 | 1 | 549 |
| 2 | 3 | 610 |
| 3 | 1 | 144 |
| 3 | 2 | -821 |
| 3 | 3 | -1366 |
| 3 | 4 | 92 |
| 4 | 1 | 848 |
| 4 | 3 | 655 |
| 5 | 1 | 954 |
| 5 | 3 | -1923 |
| 5 | 4 | -3367 |

### 5. What is the percentage of customers who increase their closing balance by more than 5%?

```sql
--cte1: query the customer_id, the month of transaction, and use CASE to put amounts of despoit, withdrawal, and purchase on the same record
WITH cte1 AS
(
SELECT
	customer_id
    , DATE_PART ('month', txn_date) AS month_
    , CASE WHEN txn_type = 'deposit' THEN txn_amount ELSE 0 END AS deposit_sum
    , CASE WHEN txn_type = 'withdrawal' THEN txn_amount ELSE 0 END AS withdrawal_sum
    , CASE WHEN txn_type = 'purchase' THEN txn_amount ELSE 0 END AS purchase_sum
FROM
	data_bank.customer_transactions
GROUP BY
	customer_id
    , month_
    , txn_type
    , txn_amount
ORDER BY
	customer_id
    , month_
    , txn_type
    , txn_amount 
),

--cte2: sum up all despoit, withdrawl, and purchase transactions per month to create a monthly summary of total usage by transaction type
cte2 AS
(
SELECT
	customer_id
    , month_
	, SUM (deposit_sum) AS monthly_deposit
    , SUM (withdrawal_sum) AS monthly_withdrawal
    , SUM (purchase_sum) AS monthly_purchase
FROM
	cte1
GROUP BY
	customer_id
    , month_
),

--cte3: add despoits and subtract withdrawals and purchases to create a balance for each month
cte3 AS
(
SELECT
	customer_id
    , month_
    , ( monthly_deposit + (-1 * monthly_withdrawal) + (-1 * monthly_purchase) ) AS balance_by_month
FROM
	cte2
GROUP BY
	customer_id
    , month_
    , balance_by_month
ORDER BY
	customer_id
    , month_
),

--cte4: use LAG() to query the previous month's balance
cte4 AS
(
SELECT
	customer_id
    , month_
    , balance_by_month
    , LAG (balance_by_month, 1) OVER
    	(PARTITION BY customer_id) AS prev_month_balance
FROM
	cte3
),

--cte5: subtract the current month balance from the previous month's balance to determine change in balance (using a CASE to turn NULL values into 0 values)
cte5 AS
(
SELECT
	customer_id
    , month_
    , prev_month_balance
    , balance_by_month
	, (balance_by_month - 
       	(CASE WHEN prev_month_balance IS NULL THEN 0 ELSE prev_month_balance END)
      ) AS balance_difference
FROM
	cte4
),

--cte6: divide the balance_difference (change in balance) from the previous month's balance to determine percent change
cte6 AS
(
SELECT
	customer_id
    , month_
    , prev_month_balance
    , balance_by_month
    , balance_difference
	, (balance_difference::numeric / prev_month_balance::numeric) * 100 AS pct_change
FROM
	cte5
)

--count the number of distinct customers who have ever increased their monthly balance by 5% or more
SELECT
	COUNT (DISTINCT (customer_id) )
FROM
	cte6
WHERE
	pct_change >= 5
```

| count |
| --- |
| 269 |
