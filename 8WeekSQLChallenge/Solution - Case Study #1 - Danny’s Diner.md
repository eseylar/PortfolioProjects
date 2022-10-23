# Case Study #1 - Danny’s Diner


/* -------------------- Case Study Questions -------------------- */

>-- 1. What is the total amount each customer spent at the restaurant?

>-- 2. How many days has each customer visited the restaurant?
	
>-- 3. What was the first item from the menu purchased by each customer?
	
>-- 4. What is the most purchased item on the menu and how many times was it purchased by all customers?
	
>-- 5. Which item was the most popular for each customer?
	
>-- 6. Which item was purchased first by the customer after they became a member?
	
>-- 7. Which item was purchased just before the customer became a member?
	
>-- 8. What is the total items and amount spent for each member before they became a member?
	
>-- 9.  If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
	
>-- 10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?


### **Schema (PostgreSQL v13)**

```sql
CREATE SCHEMA dannys_diner;
SET search_path = dannys_diner;

CREATE TABLE sales (
  "customer_id" VARCHAR(1),
  "order_date" DATE,
  "product_id" INTEGER
);

INSERT INTO sales
  ("customer_id", "order_date", "product_id")
VALUES
  ('A', '2021-01-01', '1'),
  ('A', '2021-01-01', '2'),
  ('A', '2021-01-07', '2'),
  ('A', '2021-01-10', '3'),
  ('A', '2021-01-11', '3'),
  ('A', '2021-01-11', '3'),
  ('B', '2021-01-01', '2'),
  ('B', '2021-01-02', '2'),
  ('B', '2021-01-04', '1'),
  ('B', '2021-01-11', '1'),
  ('B', '2021-01-16', '3'),
  ('B', '2021-02-01', '3'),
  ('C', '2021-01-01', '3'),
  ('C', '2021-01-01', '3'),
  ('C', '2021-01-07', '3');

CREATE TABLE menu (
  "product_id" INTEGER,
  "product_name" VARCHAR(5),
  "price" INTEGER
);

INSERT INTO menu
  ("product_id", "product_name", "price")
VALUES
  ('1', 'sushi', '10'),
  ('2', 'curry', '15'),
  ('3', 'ramen', '12');

CREATE TABLE members (
  "customer_id" VARCHAR(1),
  "join_date" DATE
);

INSERT INTO members
  ("customer_id", "join_date")
VALUES
  ('A', '2021-01-07'),
  ('B', '2021-01-09');

```

## Case Study Questions

### **1. What is the total amount each customer spent at the restaurant?**

```sql
-- 1. What is the total amount each customer spent at the restaurant?

SELECT
	dannys_diner.sales.customer_id 
	, SUM(dannys_diner.menu.price)
FROM
	dannys_diner.sales
LEFT JOIN
	dannys_diner.menu
ON
	dannys_diner.sales.product_id = dannys_diner.menu.product_id
GROUP BY
	dannys_diner.sales.customer_id
ORDER BY
	dannys_diner.sales.customer_id;
```

| customer_id | sum |
| --- | --- |
| A | 76 |

| C | 36 |

---

### **2. How many days has each customer visited the restaurant?**

```sql
-- 2. How many days has each customer visited the restaurant?

SELECT
	customer_id
  , COUNT( DISTINCT (order_date) )
FROM
	dannys_diner.sales
GROUP BY
	customer_id
ORDER BY
	customer_id;
```

| customer_id | count |
| --- | --- |
| A | 4 |
| B | 6 |
| C | 2 |

---

### **3. What was the first item from the menu purchased by each customer?**

```sql
-- 3. What was the first item from the menu purchased by each customer?

SELECT
	s.customer_id
  , m.product_name
FROM
	dannys_diner.sales AS s
LEFT JOIN
	dannys_diner.menu AS m
ON
	s.product_id = m.product_id
WHERE
	s.order_date = ANY
        (SELECT
            MIN (s.order_date) AS first_orddr
        FROM
            dannys_diner.sales AS s
        LEFT JOIN
            dannys_diner.menu AS m
        ON
            s.product_id = m.product_id
        GROUP BY
            s.customer_id);

--Customers A and C each ordered 2 items on their first day at Danny's Diner, so we cannot know which purchase was first with the dataset given.
```

| customer_id | product_name |
| --- | --- |
| A | sushi |
| A | curry |
| B | curry |
| C | ramen |
| C | ramen |

---

### **4. What is the most purchased item on the menu and how many times was it purchased by all customers?**

```sql
-- 4. What is the most purchased item on the menu and how many times was it purchased by all customers?

SELECT
	m.product_name
  , COUNT (s.product_id) AS num_sold
FROM
	dannys_diner.sales AS s
JOIN
	dannys_diner.menu AS m
ON
	m.product_id = s.product_id
GROUP BY
	m.product_name
ORDER BY
	num_sold DESC
LIMIT 1;
```

| product_name | num_sold |
| --- | --- |
| ramen | 8 |

---

### **5. Which item was the most popular for each customer?**

```sql
-- 5. Which item was the most popular for each customer?

WITH sale_ranking AS

(
SELECT
   sales.customer_id
   , sales.product_id
 	 , menu.product_name
   , COUNT (sales.product_id) AS sale_count
   , DENSE_RANK () OVER
	    (PARTITION BY sales.customer_id
       ORDER BY COUNT (sales.product_id) DESC) AS rank
FROM
	dannys_diner.sales
JOIN
 	dannys_diner.menu
ON
 	menu.product_id = sales.product_id
GROUP BY
	sales.customer_id
  , sales.product_id
	, menu.product_name
)

SELECT
	sale_ranking.customer_id
  , sale_ranking.product_name
FROM
	sale_ranking
WHERE
	rank = 1;
```

| customer_id | product_name |
| --- | --- |
| A | ramen |
| B | ramen |
| B | sushi |
| B | curry |
| C | ramen |
---

### **6. Which item was purchased first by the customer after they became a member?**

```sql
-- 6. Which item was purchased first by the customer after they became a member?

WITH order_ranking_CTE AS
(SELECT
	sales.customer_id
  , sales.product_id
 	, menu.product_name
  , DENSE_RANK () OVER
	    (PARTITION BY sales.customer_id
	     ORDER BY sales.order_date ASC) AS rank
FROM
	dannys_diner.sales
JOIN
	dannys_diner.members
ON
   members.customer_id = sales.customer_id
JOIN
	dannys_diner.menu
ON
  sales.product_id = menu.product_id
WHERE
	sales.order_date >= members.join_date)

SELECT
	order_ranking_CTE.customer_id
  , order_ranking_CTE.product_name
FROM
	order_ranking_CTE
WHERE
	order_ranking_CTE.rank = 1;

```
| customer_id | product_name |
| --- | --- |
| A | curry |
| B | sushi |

---

### **7. Which item was purchased just before the customer became a member?**

```sql
-- 7. Which item was purchased just before the customer became a member?

WITH buy_date_rank AS

(
SELECT
	sales.customer_id
  , menu.product_name
  , sales.order_date
  , DENSE_RANK () OVER
    	(PARTITION BY sales.customer_id 
       ORDER BY sales.order_date DESC) as rank
  , members.join_date
FROM
	dannys_diner.sales
JOIN
	dannys_diner.members
ON
	members.customer_id = sales.customer_id
JOIN
	dannys_diner.menu
ON
	sales.product_id = menu.product_id
WHERE
	sales.order_date < members.join_date
)

SELECT
	buy_date_rank.customer_id
  , buy_date_rank.product_name
FROM
	buy_date_rank
WHERE
	rank = 1;
```

| customer_id | product_name |
| --- | --- |
| A | sushi |
| A | curry |
| B | sushi |

---

### **8. What is the total items and amount spent for each member before they became a member?**

```sql
-- 8. What is the total items and amount spent for each member before they became a member?

SELECT
	sales.customer_id
  , COUNT (sales.*) AS item_count
  , SUM (menu.price) AS item_sum
FROM
	dannys_diner.sales
JOIN
	dannys_diner.members
ON
	members.customer_id = sales.customer_id
JOIN
	dannys_diner.menu
ON
	sales.product_id = menu.product_id
WHERE
	sales.order_date < members.join_date
GROUP BY
	sales.customer_id;
```

| customer_id | item_count | item_sum |
| --- | --- | --- |
| B | 3 | 40 |
| A | 2 | 25 |

---

### **9. If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?**

```sql
-- 9.  If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?

WITH point_sys AS

(SELECT
	sales.customer_id
  , CASE
    	WHEN sales.product_id = 1 THEN 20 * menu.price
        ELSE 10 * menu.price
      END AS pnts
FROM
	dannys_diner.sales
JOIN
	dannys_diner.menu
ON
	sales.product_id = menu.product_id)

SELECT
	point_sys.customer_id
  , SUM (point_sys.pnts) AS points
FROM
	point_sys
GROUP BY
	point_sys.customer_id;
```

| customer_id | points |
| --- | --- |
| B | 940 |
| C | 360 |
| A | 860 |

---

### **10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?**


```sql
-- 10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?

WITH point_table AS
(
SELECT
	sales.customer_id
  	, sales.order_date
  	, members.join_date
    , CASE
        WHEN sales.order_date BETWEEN members.join_date AND (members.join_date + INTERVAL '6 day') THEN menu.price * 20
        ELSE
  			CASE
  				WHEN sales.product_id = 1 THEN 20 * menu.price
        		ELSE 10 * menu.price
  			END
    END AS points
FROM
	dannys_diner.sales
JOIN
	dannys_diner.members
ON
	members.customer_id = sales.customer_id
JOIN
	dannys_diner.menu
ON
	sales.product_id = menu.product_id
WHERE
  	members.join_date <= sales.order_date
)

SELECT
	point_table.customer_id

    , SUM (point_table.points) AS point_total
FROM
	point_table
WHERE
	point_table.order_date < '2021-02-01'
GROUP BY
	point_table.customer_id;

```

| customer_id | point_total |
| --- | --- |
| B | 320 |
| A | 1020 |

## Bonus Questions

### **Join All The Things**

```sql
--The following questions are related creating basic data tables that Danny and his team can use to quickly derive insights without needing to join the underlying tables using SQL.

--Recreate the below table output using the available data:

SELECT
	sales.customer_id
    , sales.order_date
    , menu.product_name
    , menu.price
    , CASE
    	WHEN members.join_date > sales.order_date THEN 'N'
        WHEN members.join_date IS NULL THEN 'N'
        ELSE 'Y'
      END as member
FROM
	dannys_diner.sales
FULL JOIN
	dannys_diner.members
ON
	members.customer_id = sales.customer_id
JOIN
	dannys_diner.menu
ON
	sales.product_id = menu.product_id
ORDER BY
	sales.customer_id
    , sales.order_date
    , menu.product_name;
```

| customer_id | order_date | product_name | price | member |
| --- | --- | --- | --- | --- |
| A | 2021-01-01T00:00:00.000Z | curry | 15 | N |
| A | 2021-01-01T00:00:00.000Z | sushi | 10 | N |
| A | 2021-01-07T00:00:00.000Z | curry | 15 | Y |
| A | 2021-01-10T00:00:00.000Z | ramen | 12 | Y |
| A | 2021-01-11T00:00:00.000Z | ramen | 12 | Y |
| A | 2021-01-11T00:00:00.000Z | ramen | 12 | Y |
| B | 2021-01-01T00:00:00.000Z | curry | 15 | N |
| B | 2021-01-02T00:00:00.000Z | curry | 15 | N |
| B | 2021-01-04T00:00:00.000Z | sushi | 10 | N |
| B | 2021-01-11T00:00:00.000Z | sushi | 10 | Y |
| B | 2021-01-16T00:00:00.000Z | ramen | 12 | Y |
| B | 2021-02-01T00:00:00.000Z | ramen | 12 | Y |
| C | 2021-01-01T00:00:00.000Z | ramen | 12 | N |
| C | 2021-01-01T00:00:00.000Z | ramen | 12 | N |
| C | 2021-01-07T00:00:00.000Z | ramen | 12 | N |

---

### **Rank All The Things**

```sql
--Danny also requires further information about the ranking of customer products, but he purposely does not need the ranking for non-member purchases so he expects null ranking values for the records when customers are not yet part of the loyalty program. Recreate the table below.

WITH cte1 AS

(SELECT
	sales.customer_id
    , sales.order_date
    , menu.product_name
    , menu.price
    , CASE
    	WHEN members.join_date > sales.order_date THEN 'N'
        WHEN members.join_date IS NULL THEN 'N'
        ELSE 'Y'
      END as member
FROM
	dannys_diner.sales
FULL JOIN
	dannys_diner.members
ON
	members.customer_id = sales.customer_id
JOIN
	dannys_diner.menu
ON
	sales.product_id = menu.product_id
ORDER BY
	sales.customer_id
    , sales.order_date
    , menu.product_name)

SELECT
	*
    , CASE
    	WHEN cte1.member = 'N' THEN NULL
        ELSE DENSE_RANK () OVER
          (PARTITION BY cte1.customer_id, cte1.member ORDER BY cte1.order_date ASC)
       END AS ranking
FROM cte1;
```

| customer_id | order_date | product_name | price | member | ranking |
| --- | --- | --- | --- | --- | --- |
| A | 2021-01-01T00:00:00.000Z | curry | 15 | N | NULL |
| A | 2021-01-01T00:00:00.000Z | sushi | 10 | N | NULL |
| A | 2021-01-07T00:00:00.000Z | curry | 15 | Y | 1 |
| A | 2021-01-10T00:00:00.000Z | ramen | 12 | Y | 2 |
| A | 2021-01-11T00:00:00.000Z | ramen | 12 | Y | 3 |
| A | 2021-01-11T00:00:00.000Z | ramen | 12 | Y | 3 |
| B | 2021-01-01T00:00:00.000Z | curry | 15 | N | NULL |
| B | 2021-01-02T00:00:00.000Z | curry | 15 | N | NULL |
| B | 2021-01-04T00:00:00.000Z | sushi | 10 | N | NULL |
| B | 2021-01-11T00:00:00.000Z | sushi | 10 | Y | 1 |
| B | 2021-01-16T00:00:00.000Z | ramen | 12 | Y | 2 |
| B | 2021-02-01T00:00:00.000Z | ramen | 12 | Y | 3 |
| C | 2021-01-01T00:00:00.000Z | ramen | 12 | N | NULL |
| C | 2021-01-01T00:00:00.000Z | ramen | 12 | N | NULL |
| C | 2021-01-07T00:00:00.000Z | ramen | 12 | N | NULL |
