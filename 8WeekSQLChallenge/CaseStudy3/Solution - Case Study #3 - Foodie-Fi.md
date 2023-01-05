# Case Study #3 - Foodie-Fi

[https://8weeksqlchallenge.com/case-study-3/](https://8weeksqlchallenge.com/case-study-3/)

### **Schema**
https://github.com/eseylar/PortfolioProjects/blob/main/8WeekSQLChallenge/CaseStudy3/schema.sql

---

### **A. Customer Journey**

"Based off the 8 sample customers provided in the sample from the subscriptions table, write a brief description about each customer’s onboarding journey."

Below are query and results used to formulate this response.

Customer 1: Joined on a free trial on Aug. 1 2020, and chose to continue with a basic monthly plan starting Aug. 8

Customer 2: Joined on a free trial on Sept. 20 2020, and chose to upgrade to the pro annual plan starting Sept. 27

Customer 11: Joined on a free trial on Nov. 19 2020, and chose to cancel at the end of the free trial on Nov. 26

Customer 13: Joined on a free trial on Dec. 15 2020, and chose to continue with a basic monthly plan starting on Dec. 22. Then, they upgraded to a pro motnhly plan on Mar. 29 2021.

Customer 15: Joined on a free trial on Mar. 17 2020, and continued with the default pro monthly plan at the end of the free trial on Mar. 24 2020. Then, they canceled their account on Apr. 29 2020. 

Customer 16: Joined on a free trial on May 31 2020, and chose to continue with a basic monthly plan starting on June 7. Then, they upgraded to a pro annual plan on Oct. 21 2020.

Customer 18: Joined on a free trial on July 6 2020, and continued with the default pro monthly plan at the end of the free trial on July 13.

Customer 19: Joined on a free trial on June 22 2020, and continued with the default pro monthly plan at the end of the free trial on June 29. Then, they upgraded to a pro annual plan on Aug. 29 2020.

```sql
SELECT
	s.customer_id
  , p.plan_name
  , s.start_date
FROM 
	foodie_fi.plans AS p
JOIN
	foodie_fi.subscriptions AS s
ON
	s.plan_id = p.plan_id
WHERE
	s.customer_id IN (1, 2, 11, 13, 15, 16, 18, 19)
ORDER BY
	s.customer_id
    , s.start_date
```

| customer_id | plan_name | start_date |
| --- | --- | --- |
| 1 | trial | 2020-08-01T00:00:00.000Z |
| 1 | basic monthly | 2020-08-08T00:00:00.000Z |
| 2 | trial | 2020-09-20T00:00:00.000Z |
| 2 | pro annual | 2020-09-27T00:00:00.000Z |
| 11 | trial | 2020-11-19T00:00:00.000Z |
| 11 | churn | 2020-11-26T00:00:00.000Z |
| 13 | trial | 2020-12-15T00:00:00.000Z |
| 13 | basic monthly | 2020-12-22T00:00:00.000Z |
| 13 | pro monthly | 2021-03-29T00:00:00.000Z |
| 15 | trial | 2020-03-17T00:00:00.000Z |
| 15 | pro monthly | 2020-03-24T00:00:00.000Z |
| 15 | churn | 2020-04-29T00:00:00.000Z |
| 16 | trial | 2020-05-31T00:00:00.000Z |
| 16 | basic monthly | 2020-06-07T00:00:00.000Z |
| 16 | pro annual | 2020-10-21T00:00:00.000Z |
| 18 | trial | 2020-07-06T00:00:00.000Z |
| 18 | pro monthly | 2020-07-13T00:00:00.000Z |
| 19 | trial | 2020-06-22T00:00:00.000Z |
| 19 | pro monthly | 2020-06-29T00:00:00.000Z |
| 19 | pro annual | 2020-08-29T00:00:00.000Z |

---

### B. Data Analysis Questions

### 1. How many customers has Foodie-Fi ever had?

```sql
SELECT 
  COUNT (
    DISTINCT (customer_id)
  ) AS count_customers 
FROM 
  foodie_fi.subscriptions;

```

| count_customers |
| --- |
| 1000 |

### 2. What is the monthly distribution of `trial` plan `start_date` values for our dataset?

```sql
SELECT 
  DATE_PART('month', start_date) AS month_num --extract numnber of month
  , TO_CHAR (start_date, 'Month') AS month --extract string name of month
  , COUNT (*) 
FROM 
  foodie_fi.subscriptions 
WHERE 
  plan_id = 0 --plan id used for trials
GROUP BY 
  DATE_PART('month', start_date), 
  TO_CHAR (start_date, 'Month');

```

| month_num | month | count |
| --- | --- | --- |
| 1 | January | 88 |
| 2 | February | 68 |
| 3 | March | 94 |
| 4 | April | 81 |
| 5 | May | 88 |
| 6 | June | 79 |
| 7 | July | 89 |
| 8 | August | 88 |
| 9 | September | 87 |
| 10 | October | 79 |
| 11 | November | 75 |
| 12 | December | 84 |

### 3. What plan `start_date` values occur after the year 2020 for our dataset? Show the breakdown by count of events for each `plan_name`

```sql
SELECT
	p.plan_name
  , COUNT (*)
FROM 
	foodie_fi.plans AS p
JOIN
	foodie_fi.subscriptions AS s
ON
	s.plan_id = p.plan_id
WHERE
	start_date >= '2021-01-01'
GROUP BY
	p.plan_name
  , p.plan_id
ORDER BY
	p.plan_id;
```

| plan_name | count |
| --- | --- |
| basic monthly | 8 |
| pro monthly | 60 |
| pro annual | 63 |
| churn | 71 |

### 4. What is the customer count and percentage of customers who have churned rounded to 1 decimal place?

```sql
SELECT
	COUNT (*) AS count_churn
  , ROUND(100 * COUNT(*)::NUMERIC / 
	   (SELECT COUNT ( DISTINCT ( customer_id ) ) 
	   FROM foodie_fi.subscriptions ) , 1 ) AS churn_percentage
FROM
	foodie_fi.subscriptions
WHERE
	plan_id = 4
```

| count_churn | churn_percentage |
| --- | --- |
| 307 | 30.7 |

### 5. How many customers have churned straight after their initial free trial - what percentage is this rounded to the nearest whole number?

```sql
WITH cte AS
(
SELECT
	DISTINCT (customer_id)
  , plan_id
  , LEAD (plan_id, 1) OVER
    	(PARTITION BY customer_id ORDER BY plan_id) as lead
FROM
	foodie_fi.subscriptions
)

SELECT
	COUNT (cte.customer_id)
  , ROUND(100 * COUNT(*)::NUMERIC / 
	   (SELECT COUNT ( DISTINCT ( subscriptions.customer_id ) ) 
	   FROM foodie_fi.subscriptions ) , 0 ) AS churn_percentage
FROM
	cte
WHERE
	cte.plan_id = 0
  AND cte.lead = 4
```

| count | churn_percentage |
| --- | --- |
| 92 | 9 |

### 6. What is the number and percentage of customer plans after their initial free trial?

```sql
WITH cte AS
(
SELECT
	DISTINCT (customer_id)
  , plan_id
  , LEAD (plan_id, 1) OVER
    	(PARTITION BY customer_id ORDER BY plan_id) as lead
FROM
	foodie_fi.subscriptions
)

SELECT
	DISTINCT (lead)
    , COUNT (lead)
    , ROUND(100 * COUNT(lead)::NUMERIC / 
	   (SELECT COUNT ( DISTINCT ( subscriptions.customer_id ) ) 
	   FROM foodie_fi.subscriptions ) , 1 ) AS percentage
FROM
	cte
WHERE
	plan_id = 0
GROUP BY
	lead
```

| lead | count | percentage |
| --- | --- | --- |
| 1 | 546 | 54.6 |
| 2 | 325 | 32.5 |
| 3 | 37 | 3.7 |
| 4 | 92 | 9.2 |

### 7. What is the customer count and percentage breakdown of all 5 `plan_name` values at `2020-12-31`?

```sql
--cte1: query all distinct users, using a LEAD() to indicate what their next plan change is. Limiting to plans that begin on or after the indicated date.
with cte1 AS
(
SELECT
		customer_id AS users
    , plan_id
    , start_date
    , LEAD (plan_id, 1) OVER
    	(PARTITION BY customer_id ORDER BY plan_id) AS lead
FROM
	foodie_fi.subscriptions
WHERE
	start_date <= '2020-12-13'
),

--cte2: using cte1 and limiting to only records where the next plan (as established by the LEAD() in cte1) IS NULL. This means that the user has not established a future plan, meaning this is their current plan. Further, cte2 groups entries by plan_id and establishes a count of how many users had that plan_id on the established date.
cte2 AS
(
SELECT
  plan_id
  , COUNT (users) AS user_count
FROM
  cte1
WHERE
  lead IS NULL
GROUP BY
  plan_id
)

--SELECTiing the plan_id, the count of users, and the percentage of users on that plan (using a nested query in the select statement)
SELECT
		plan_id
    , user_count
    , ROUND (
				100 * (user_count /
		    	(SELECT
							SUM (user_count)
					FROM
			  			cte2)), 
			1) AS percent_users
FROM
	cte2
```

| plan_id | user_count | percent_users |
| --- | --- | --- |
| 0 | 23 | 2.4 |
| 1 | 217 | 22.7 |
| 2 | 306 | 32.0 |
| 3 | 183 | 19.1 |
| 4 | 227 | 23.7 |

### 8. How many customers have upgraded to an annual plan in 2020?

```sql
--cte: query all customer records in the year 2020 that included a plan 3 (annual plan) plan_id field. 
WITH cte AS
(
SELECT
	customer_id
  , plan_id
FROM
	foodie_fi.subscriptions
WHERE
	start_date BETWEEN '1-1-2020' AND '12-31-2020'
  AND plan_id = 3
) 

SELECT
	COUNT (*) AS upgrade_count
FROM
	cte
```

| upgrade_count |
| --- |
| 195 |

### 9. How many days on average does it take for a customer to switch an annual plan from the day they join Foodie-Fi?

```sql
--cte1: find the date users upgraded to the annual subscription
WITH cte1 AS
(
SELECT
	customer_id
    , plan_id
  	, start_date AS annual_start
FROM
	foodie_fi.subscriptions
WHERE
  	plan_id = 3
),

--cte2: find the date users joined the service
cte2 AS
(
SELECT
	customer_id
    , plan_id
  	, start_date AS join_start
FROM
	foodie_fi.subscriptions
WHERE
  	plan_id = 0
),

--cte3: JOIN on customer_id so service start date and annual upgrade date are on the same table
cte3 AS
(
SELECT
	cte2.*
    , cte1.annual_start
FROM
	cte1
JOIN
	cte2
ON
	cte1.customer_id = cte2.customer_id
)

--using the DATE_PART() function to calculate the difference between start and upgrade date, then CASTing() the difference AS numeric, then AVGing() out that value, and finally ROUNDing() that value to a whole number
SELECT
   	ROUND(
	    	AVG( 
     		 CAST( 
       			DATE_PART('day', annual_start::timestamp - join_start::timestamp) 
	       AS numeric)
				    )
		      ) AS ave_upgrade_days
FROM
	cte3
```

| ave_upgrade_days |
| --- |
| 105 |

### 10. Can you further breakdown this average value into 30 day periods (i.e. 0-30 days, 31-60 days etc)

```sql
--cte1: find the date users upgraded to the annual subscription
WITH cte1 AS
(
SELECT
	customer_id
    , plan_id
  	, start_date AS annual_start
FROM
	foodie_fi.subscriptions
WHERE
  	plan_id = 3
),

--cte2: find the date users joined the service
cte2 AS
(
SELECT
	customer_id
    , plan_id
  	, start_date AS join_start
FROM
	foodie_fi.subscriptions
WHERE
  	plan_id = 0
),
   
--cte3: JOIN on customer_id so service start date and annual upgrade date are on the same table
cte3 AS
(
SELECT
	cte2.*
    , cte1.annual_start
FROM
	cte1
JOIN
	cte2
ON
	cte1.customer_id = cte2.customer_id
),

--cte4: calculte the number of days between joining the service and upgrading to the annual plan
cte4 AS
(  
SELECT
   	customer_id
    ,DATE_PART('day', annual_start::timestamp - join_start::timestamp) 
  		AS date_diff
FROM
	cte3
),

--cte5: using the FLOOR() function, establish bins of 30 days to create a histogram of the length of time it took users to upgrade to the annual plan
cte5 AS
(
SELECT
	FLOOR(date_diff/30) * 30 AS date_floor
    , COUNT(*) AS num_upgrades
FROM
	cte4
GROUP BY
	date_floor
)

-- using CONCAT() to add the range of days for each bin, as opposed to just the lowest value on the bin (essentially, making it more readable and human friendly)
SELECT
	CONCAT (date_floor, ' - ', date_floor + 29) AS date_breakdown
    , num_upgrades
FROM
	cte5
```

| date_breakdown | num_upgrades |
| --- | --- |
| 0 - 29 | 48 |
| 30 - 59 | 25 |
| 60 - 89 | 33 |
| 90 - 119 | 35 |
| 120 - 149 | 43 |
| 150 - 179 | 35 |
| 180 - 209 | 27 |
| 210 - 239 | 4 |
| 240 - 269 | 5 |
| 270 - 299 | 1 |
| 300 - 329 | 1 |
| 330 - 359 | 1 |

### 11. How many customers downgraded from a pro monthly to a basic monthly plan in 2020?

```sql
--query all records customer_id, plan_id, start_date for that plan, and the previous plan using LAG(). Filter only for records occurring in 2020.
WITH cte AS
(
SELECT
	customer_id
    , plan_id
    , LAG (plan_id, 1) OVER
    	(PARTITION BY customer_id ORDER BY plan_id) as prev_plan
    , start_date
FROM
	foodie_fi.subscriptions
WHERE
	start_date BETWEEN '1-1-2020' AND '12-31-2020'
)

--COUNT() the number of records from the cte that show a user who is on the basic monthly plan after leaving the pro monthly plan
SELECT
	COUNT(*)
FROM
	cte
WHERE
	plan_id = 1 --plan is currently basic monthly
    AND prev_plan = 2 --previoius plan was pro monthly
```

| count |
| --- |
| 0 |
