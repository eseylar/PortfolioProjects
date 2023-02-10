# Niche Top Colleges 2023 (SQL Data Exploration)

### SQL Exploration

Questions for exploration

- Which states have the most of the 250 top colleges? Top 100 colleges?
    - Are there any states with schools in the top 250 but ***not*** the top 100?
- Which regions have the most of the 250 top colleges? Top 100 colleges?
- Average SAT score by buckets of ranking (1-10, 11-20, 21-30, etc.)
- Average price by region
- Average price by buckets of ranking
- Average price by acceptance rate buckets
- Average SAT by acceptance rate buckets
- Which schools have the highest average SAT scores? What are their rankings?

### Exploration Queries and Results

```sql
/* Which states have the most of the 250 top colleges? */

SELECT  
  state
  , COUNT (*) AS num
FROM 
  `adept-turbine-353215.top_colleges.top_250_colleges`
GROUP BY
  state
ORDER BY 
  num DESC
```

States with 10 or more top colleges in the top 250:

| state | num |
| --- | --- |
| CA | 25 |
| NY | 23 |
| MA | 18 |
| PA | 17 |
| FL | 12 |
| TX | 11 |
| IL | 10 |
| OH | 10 |

```sql
/* Which states have the most of the 100 top colleges? */

SELECT  
  state
  , COUNT (*) AS num
FROM 
  `adept-turbine-353215.top_colleges.top_250_colleges`
WHERE
  rank <= 100
GROUP BY
  state
ORDER BY 
  num DESC
```

States with 5 or more top colleges in the top 100:

| state | num |
| --- | --- |
| CA | 13 |
| MA | 12 |
| PA | 10 |
| NY | 10 |
| TX | 5 |
| NC | 5 |
| VA | 5 |

---

```sql
/* States that appear in the top 250 list, but **not** in the top 100 list */

WITH cte as 
(
SELECT  
  state
  , COUNT (*) AS num
FROM 
  `adept-turbine-353215.top_colleges.top_250_colleges`
WHERE
  rank <= 100
GROUP BY
  state
)

SELECT  
  state
  , COUNT (*) AS num
FROM 
  `adept-turbine-353215.top_colleges.top_250_colleges`
WHERE
  state NOT IN (SELECT state FROM cte)
GROUP BY
  state
ORDER BY
  num DESC
```

| state |
| --- |
| AL |
| AR |
| AZ |
| DE |
| KS |
| KY |
| MS |
| NE |
| NM |
| OK |
| OR |
| SC |
| SD |
| WV |
| WY |

---

```sql
/* How do the top 250 colleges distribute across the regions of the USA? */

SELECT  
  region
  , COUNT (*) AS num
FROM 
  `adept-turbine-353215.top_colleges.top_250_colleges`
GROUP BY
  region
ORDER BY
  num DESC
```

| region | num |
| --- | --- |
| Southeast | 56 |
| Mid East | 51 |
| Great Lakes | 34 |
| Far West | 33 |
| New England | 31 |
| Plains | 20 |
| Southwest | 17 |
| Rocky Mountains | 8 |

```sql
/* How do the top 100 colleges distribute across the regions of the USA? */

SELECT  
  region
  , COUNT (*) AS num
FROM 
  `adept-turbine-353215.top_colleges.top_250_colleges`
WHERE
   rank <= 100
GROUP BY
  region
ORDER BY
  num DESC
```

| region | num |
| --- | --- |
| Mid East | 25 |
| New England | 20 |
| Southeast | 19 |
| Far West | 14 |
| Great Lakes | 10 |
| Plains | 5 |
| Southwest | 5 |
| Rocky Mountains | 2 |

```sql
/* How do the top 25 colleges distribute across the regions of the USA? */

SELECT  
  region
  , COUNT (*) AS num
FROM 
  `adept-turbine-353215.top_colleges.top_250_colleges`
WHERE
   rank <= 25
GROUP BY
  region
ORDER BY
  num DESC
```

| region | num |
| --- | --- |
| Mid East | 7 |
| Far West | 5 |
| New England | 5 |
| Great Lakes | 4 |
| Southeast | 2 |
| Plains | 1 |
| Southwest | 1 |

---

```sql
/* Average price of school, grouped by buckets of 10 ranked schools */

WITH cte AS
(
SELECT
  ROUND( AVG(price), 2 ) as ave_price_by_group
  , CAST ( (FLOOR(rank/10)*10) AS INT ) AS rank_floor
FROM 
  `adept-turbine-353215.top_colleges.top_250_colleges`
GROUP BY
  rank_floor
ORDER BY
  rank_floor
)

SELECT
  CASE 
      WHEN rank_floor = 0 THEN CONCAT (cte.rank_floor + 1 , '-', cte.rank_floor + 9)
      WHEN rank_floor BETWEEN 10 AND 249 THEN CONCAT (cte.rank_floor , '-', cte.rank_floor + 9) 
      WHEN rank_floor = 250 THEN CONCAT (cte.rank_floor)
    END AS rank_buckets
    , cte.ave_price_by_group
FROM
  cte
```

| rank_buckets | ave_price_by_group |
| --- | --- |
| 1-9 | 21627.89 |
| 10-19 | 28666.6 |
| 20-29 | 25266.0 |
| 30-39 | 26946.11 |
| 40-49 | 21525.5 |
| 50-59 | 25436.6 |
| 60-69 | 26027.5 |
| 70-79 | 23014.9 |
| 80-89 | 27181.1 |
| 90-99 | 26054.2 |
| 100-109 | 31789.6 |
| 110-119 | 24631.7 |
| 120-129 | 24019.9 |
| 130-139 | 23391.9 |
| 140-149 | 29173.9 |
| 150-159 | 28049.6 |
| 160-169 | 21704.1 |
| 170-179 | 29958.9 |
| 180-189 | 20797.6 |
| 190-199 | 25251.6 |
| 200-209 | 32253.7 |
| 210-219 | 22338.6 |
| 220-229 | 20665.7 |
| 230-239 | 23455.5 |
| 240-249 | 25122.3 |
| 250 | 3897.0 |

```sql
/* Examining trends in price as ranking buckets of 10 */

WITH cte AS
(
SELECT
  ROUND( AVG(price), 2 ) as ave_price_by_group
  , CAST ( (FLOOR(rank/10)*10) AS INT ) AS rank_floor
FROM 
  `adept-turbine-353215.top_colleges.top_250_colleges`
GROUP BY
  rank_floor
ORDER BY
  rank_floor
),

cte2 AS 
(
SELECT
  cte.rank_floor
  , cte.ave_price_by_group
  , LAG(cte.ave_price_by_group, 1) OVER
      (ORDER BY cte.rank_floor) AS lag_price
FROM
  cte
ORDER BY
  cte.rank_floor ASC
)

SELECT
  cte2.rank_floor
  , cte2.ave_price_by_group
  , CASE
      WHEN cte2.lag_price < cte2.ave_price_by_group THEN '+'
      WHEN cte2.lag_price = cte2.ave_price_by_group THEN '='
      WHEN cte2.lag_price > cte2.ave_price_by_group THEN '—'
      WHEN cte2.lag_price IS NULL THEN NULL 
      ELSE NULL 
    END AS price_trend
FROM
  cte2
```

| rank_floor | ave_price_by_group | price_trend |
| --- | --- | --- |
| 0 | 21627.89 | null |
| 10 | 28666.6 | + |
| 20 | 25266.0 | — |
| 30 | 26946.11 | + |
| 40 | 21525.5 | — |
| 50 | 25436.6 | + |
| 60 | 26027.5 | + |
| 70 | 23014.9 | — |
| 80 | 27181.1 | + |
| 90 | 26054.2 | — |
| 100 | 31789.6 | + |
| 110 | 24631.7 | — |
| 120 | 24019.9 | — |
| 130 | 23391.9 | — |
| 140 | 29173.9 | + |
| 150 | 28049.6 | — |
| 160 | 21704.1 | — |
| 170 | 29958.9 | + |
| 180 | 20797.6 | — |
| 190 | 25251.6 | + |
| 200 | 32253.7 | + |
| 210 | 22338.6 | — |
| 220 | 20665.7 | — |
| 230 | 23455.5 | + |
| 240 | 25122.3 | + |
| 250 | 3897.0 | — |

No obvious trends appear. What happens if we change the buckets?

```sql
/* Examining trends in price as ranking buckets of 20 */

WITH cte AS
(
SELECT
  ROUND( AVG(price), 2 ) as ave_price_by_group
  , CAST ( (FLOOR(rank/20)*20) AS INT ) AS rank_floor
FROM 
  `adept-turbine-353215.top_colleges.top_250_colleges`
GROUP BY
  rank_floor
ORDER BY
  rank_floor
),

cte2 AS 
(
SELECT
  cte.rank_floor
  , cte.ave_price_by_group
  , LAG(cte.ave_price_by_group, 1) OVER
      (ORDER BY cte.rank_floor) AS lag_price
FROM
  cte
ORDER BY
  cte.rank_floor ASC
)

SELECT
  cte2.rank_floor
  , cte2.ave_price_by_group
  , CASE
      WHEN cte2.lag_price < cte2.ave_price_by_group THEN '+'
      WHEN cte2.lag_price = cte2.ave_price_by_group THEN '='
      WHEN cte2.lag_price > cte2.ave_price_by_group THEN '—'
      WHEN cte2.lag_price IS NULL THEN NULL 
      ELSE NULL 
    END AS price_trend
FROM
  cte2

/*
  CASE 
      WHEN cte2.rank_floor = 0 THEN CONCAT (cte2.rank_floor + 1 , '-', cte2.rank_floor + 9)
      WHEN cte2.rank_floor BETWEEN 10 AND 249 THEN CONCAT (cte2.rank_floor , '-', cte2.rank_floor + 9) 
      WHEN cte2.rank_floor = 250 THEN CONCAT (cte2.rank_floor)
  END AS rank_buckets
*/
```

| rank_floor | ave_price_by_group | price_trend |
| --- | --- | --- |
| 0 | 25332.47 | null |
| 20 | 26061.84 | + |
| 40 | 23481.05 | — |
| 60 | 24521.2 | + |
| 80 | 26617.65 | + |
| 100 | 28210.65 | + |
| 120 | 23705.9 | — |
| 140 | 28611.75 | + |
| 160 | 25831.5 | — |
| 180 | 23024.6 | — |
| 200 | 27296.15 | + |
| 220 | 22060.6 | — |
| 240 | 23192.73 | + |

No significant trends emerge, but there does appear to be a slight pyramid shape of average price rising from school #1 to school #100, then decreasing from #100 to #250

---

```sql
/* Average price by region for the top 250 schools, with school count by region and average ranking by region */

SELECT
  region
  , ROUND ( AVG(price), 2) AS ave_region_price
	, COUNT (*) AS school_count
	, ROUND ( AVG(rank) ) AS ave_region_rank
FROM
  `adept-turbine-353215.top_colleges.top_250_colleges`
GROUP BY
  region
ORDER BY
  ave_region_price
```

| region | ave_region_price | school_count | ave_region_rank |
| --- | --- | --- | --- |
| Rocky Mountains | 18455.13 | 8 | 149.0 |
| Southeast | 21230.73 | 56 | 140.0 |
| Southwest | 21587.88 | 17 | 134.0 |
| Plains | 23458.95 | 20 | 146.0 |
| Great Lakes | 26822.15 | 34 | 144.0 |
| Mid East | 27402.24 | 51 | 118.0 |
| Far West | 28709.24 | 33 | 115.0 |
| New England | 28923.48 | 31 | 79.0 |

There are several interesting facets to note here. 

While there appears to be no clear trend relating to average price and number of schools in the top 250, the Rocky Mountain region has significantly fewer schools than any other region and is the leave expensive region on average. This might indicate something about “quality” of education correlating with price, though the average price is not much less than the Southeast (the next cheapest region), which has the *****most***** schools in the top 250. This is, perhaps, something worthy of further analysis.

Next, the `ave_region_rank` column is in near perfect alignment with the `ave_region_price` column. For the `ave_region_rank` column, a smaller average indicates higher prestige (closer to number 1 means a “higher” ranking). This suggests that price is quite correlated with ranking: the better the schools in a region (the “higher” they are on the list; closer to number 1), the more expensive schools in the region will cost. 

What happens to these trends when the data are drilled down to the top 100 schools?

```sql
/* 
SELECT
  region
  , ROUND ( AVG(price), 2) AS ave_region_price
  , COUNT (*) AS school_count
  , ROUND ( AVG(rank) ) AS ave_region_rank
FROM
  `adept-turbine-353215.top_colleges.top_250_colleges`
WHERE
  rank <= 100
GROUP BY
  region
ORDER BY
  ave_region_price
```

| region | ave_region_price | school_count | ave_region_rank |
| --- | --- | --- | --- |
| Rocky Mountains | 20412.5 | 2 | 97.0 |
| Southeast | 21828.11 | 19 | 49.0 |
| Far West | 22435.5 | 14 | 47.0 |
| Great Lakes | 24833.0 | 10 | 50.0 |
| New England | 25518.25 | 20 | 41.0 |
| Southwest | 25719.6 | 5 | 62.0 |
| Mid East | 28587.46 | 25 | 53.0 |
| Plains | 28697.0 | 5 | 68.0 |

When limited to the top 100 schools, Rocky Mountains and Southeast remain the two cheapest regions. But interestingly, where Far West and New England were the two most expensive regions in the top 250, they move to the middle of the pack in the top 100. The Plains region does the opposite — it moves from mid-range to most expensive in the top 100. 

Naturally, when the query is limited to schools higher on the list, `school_count` and `ave_region_rank` decrease across the board. But how do `ave_region_price` and the relative ranking of `school_count` and `ave_region_rank` change? 

```sql
/* Top 250 with ranking for price, count, and school rank */

WITH cte AS 
(
SELECT
  region
  , ROUND ( AVG(price), 2) AS ave_region_price
  , COUNT (*) AS school_count
  , ROUND ( AVG(rank) ) AS ave_region_rank
FROM
  `adept-turbine-353215.top_colleges.top_250_colleges`
GROUP BY
  region
)

SELECT
  region
  , ave_region_price
  , DENSE_RANK () OVER
      (ORDER BY ave_region_price ASC) AS price_rank
  , school_count
  , DENSE_RANK () OVER
      (ORDER BY school_count DESC) AS school_count_rank
  , ave_region_rank
  , DENSE_RANK () OVER
      (ORDER BY ave_region_rank ASC) AS region_rank_rank
FROM
  cte
ORDER BY
  region

/* Top 100 with ranking for price, count, and school rank */

WITH cte AS 
(
SELECT
  region
  , ROUND ( AVG(price), 2) AS ave_region_price
  , COUNT (*) AS school_count
  , ROUND ( AVG(rank) ) AS ave_region_rank
FROM
  `adept-turbine-353215.top_colleges.top_250_colleges`
WHERE
  rank <= 100
GROUP BY
  region
)

SELECT
  region
  , ave_region_price
  , DENSE_RANK () OVER
      (ORDER BY ave_region_price ASC) AS price_rank
  , school_count
  , DENSE_RANK () OVER
      (ORDER BY school_count DESC) AS school_count_rank
  , ave_region_rank
  , DENSE_RANK () OVER
      (ORDER BY ave_region_rank ASC) AS region_rank_rank
FROM
  cte
ORDER BY
  region
```

**Top 250 schools**

|   region | ave_region_price | price_rank | school_count | school_count_rank | ave_region_rank | region_rank_rank |
| --- | --- | --- | --- | --- | --- | --- |
| Far West | 28709.24 | 7 | 33 | 4 | 115.0 | 2 |
| Great Lakes | 26822.15 | 5 | 34 | 3 | 144.0 | 6 |
| Mid East | 27402.24 | 6 | 51 | 2 | 118.0 | 3 |
| New England | 28923.48 | 8 | 31 | 5 | 79.0 | 1 |
| Plains | 23458.95 | 4 | 20 | 6 | 146.0 | 7 |
| Rocky Mountains | 18455.13 | 1 | 8 | 8 | 149.0 | 8 |
| Southeast | 21230.73 | 2 | 56 | 1 | 140.0 | 5 |
| Southwest | 21587.88 | 3 | 17 | 7 | 134.0 | 4 |

**Top 100 schools**

|   region | ave_region_price | price_rank | school_count | school_count_rank | ave_region_rank | region_rank_rank |
| --- | --- | --- | --- | --- | --- | --- |
| Far West | 22435.5 | 3 | 14 | 4 | 47.0 | 2 |
| Great Lakes | 24833.0 | 4 | 10 | 5 | 50.0 | 4 |
| Mid East | 28587.46 | 7 | 25 | 1 | 53.0 | 5 |
| New England | 25518.25 | 5 | 20 | 2 | 41.0 | 1 |
| Plains | 28697.0 | 8 | 5 | 6 | 68.0 | 7 |
| Rocky Mountains | 20412.5 | 1 | 2 | 7 | 97.0 | 8 |
| Southeast | 21828.11 | 2 | 19 | 3 | 49.0 | 3 |
| Southwest | 25719.6 | 6 | 5 | 6 | 62.0 | 6 |

---

```sql
/* What schools have the highest upper SAT range? */

SELECT
  *
FROM
  `adept-turbine-353215.top_colleges.top_250_colleges`
ORDER BY
  SAT_high DESC
LIMIT
  13 --rows 5-13 have the same upper SAT limit (1570), so all are included in this query
```

| rank | name | city_state | city | state | acceptance_rate | price | SAT_range | SAT_low | SAT_high | region |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | Massachusetts Institute of Technology | Cambridge, MA | Cambridge | MA | 7 | 19998.0 | 1510-1580 | 1510 | 1580 | New England |
| 7 | California Institute of Technology | Pasadena, CA | Pasadena | CA | 7 | 26591.0 | 1530-1580 | 1530 | 1580 | Far West |
| 4 | Yale University | New Haven, CT | New Haven | CT | 7 | 17511.0 | 1460-1580 | 1460 | 1580 | New England |
| 3 | Harvard University | Cambridge, MA | Cambridge | MA | 5 | 18037.0 | 1460-1580 | 1460 | 1580 | New England |
| 16 | University of Chicago | Chicago, IL | Chicago | IL | 7 | 36584.0 | 1500-1570 | 1500 | 1570 | Great Lakes |
| 8 | Duke University | Durham, NC | Durham | NC | 8 | 26932.0 | 1470-1570 | 1470 | 1570 | Southeast |
| 5 | Princeton University | Princeton, NJ | Princeton | NJ | 6 | 18685.0 | 1450-1570 | 1450 | 1570 | Mid East |
| 11 | University of Pennsylvania | Philadelphia, PA | Philadelphia | PA | 9 | 24167.0 | 1460-1570 | 1460 | 1570 | Mid East |
| 18 | Harvey Mudd College | Claremont, CA | Claremont | CA | 18 | 37192.0 | 1490-1570 | 1490 | 1570 | Far West |
| 2 | Stanford University | Stanford, CA | Stanford | CA | 5 | 20023.0 | 1420-1570 | 1420 | 1570 | Far West |
| 6 | Rice University | Houston, TX | Houston | TX | 11 | 19215.0 | 1460-1570 | 1460 | 1570 | Southwest |
| 13 | Vanderbilt University | Nashville, TN | Nashville | TN | 12 | 25804.0 | 1470-1570 | 1470 | 1570 | Southeast |
| 12 | Columbia University | New York, NY | New York | NY | 7 | 22126.0 | 1460-1570 | 1460 | 1570 | Mid East |

```sql
/* What schools have the highest average SAT? */

SELECT
  ( (SAT_high + SAT_low) /2 ) AS ave_SAT
  , *
FROM
  `adept-turbine-353215.top_colleges.top_250_colleges`
ORDER BY
  ( (SAT_high + SAT_low) /2 ) DESC
LIMIT
  13 --schools number 10-13 have the same average SAT score
```

|   ave_SAT |   rank |   name |   city_state |   city | state | acceptance_rate |   price |   SAT_range |   SAT_low |   SAT_high |   region |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 1555.0 | 7 | California Institute of Technology | Pasadena, CA | Pasadena | CA | 7 | 26591.0 | 1530-1580 | 1530 | 1580 | Far West |
| 1545.0 | 1 | Massachusetts Institute of Technology | Cambridge, MA | Cambridge | MA | 7 | 19998.0 | 1510-1580 | 1510 | 1580 | New England |
| 1535.0 | 16 | University of Chicago | Chicago, IL | Chicago | IL | 7 | 36584.0 | 1500-1570 | 1500 | 1570 | Great Lakes |
| 1530.0 | 18 | Harvey Mudd College | Claremont, CA | Claremont | CA | 18 | 37192.0 | 1490-1570 | 1490 | 1570 | Far West |
| 1520.0 | 4 | Yale University | New Haven, CT | New Haven | CT | 7 | 17511.0 | 1460-1580 | 1460 | 1580 | New England |
| 1520.0 | 13 | Vanderbilt University | Nashville, TN | Nashville | TN | 12 | 25804.0 | 1470-1570 | 1470 | 1570 | Southeast |
| 1520.0 | 8 | Duke University | Durham, NC | Durham | NC | 8 | 26932.0 | 1470-1570 | 1470 | 1570 | Southeast |
| 1520.0 | 3 | Harvard University | Cambridge, MA | Cambridge | MA | 5 | 18037.0 | 1460-1580 | 1460 | 1580 | New England |
| 1520.0 | 15 | Washington University in St. Louis | Saint Louis, MO | Saint Louis | MO | 16 | 27233.0 | 1480-1560 | 1480 | 1560 | Plains |
| 1515.0 | 21 | Johns Hopkins University | Baltimore, MD | Baltimore | MD | 11 | 25241.0 | 1470-1560 | 1470 | 1560 | Mid East |
| 1515.0 | 6 | Rice University | Houston, TX | Houston | TX | 11 | 19215.0 | 1460-1570 | 1460 | 1570 | Southwest |
| 1515.0 | 11 | University of Pennsylvania | Philadelphia, PA | Philadelphia | PA | 9 | 24167.0 | 1460-1570 | 1460 | 1570 | Mid East |
| 1515.0 | 12 | Columbia University | New York, NY | New York | NY | 7 | 22126.0 | 1460-1570 | 1460 | 1570 | Mid East |

Although SAT is often attributed as significant attribute pertaining to college entry, the top schools are not always those the highest SAT scores. To be clear, all the top ranking schools do have relatively high SAT scores (the difference being only around 10-20 SAT points), it is notable that high SAT score and ranking are not a direct relationship; the correlation, however, is apparent. 

The list becomes even more interesting when we SELECT for the average of high and lower limit ( (low + high) / 2 ). Schools from even lower down the ranking, like Harvey Mudd (no. 18) and Johns Hopkins (no. 21), enter the list of highest average SAT. This suggests that a school like Princeton (no. 5), which appears on the top SAT upper limit but not the SAT average list, accepts more students with lower SAT scores than other schools in the top 10/top 5. This provides some insight into the admissions process: while this querying reveals that SAT score is still an important factor for many top schools, there are clearly other factors at play. (One might imagine factors such as extracurricular records, legacy status, etc. as being relevant to admissions. Only a dataset with more information could provide the answers to this.)

---

```sql
/* What schools have the lowest acceptance rate? */

SELECT
  *
FROM
  `adept-turbine-353215.top_colleges.top_250_colleges`
ORDER BY
  acceptance_rate ASC
LIMIT
  22 -- rows 20-22 have the same acceptance rate (11%)
```

| rank | name | city_state | city | state | acceptance_rate | price | SAT_range | SAT_low | SAT_high | region |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 2 | Stanford University | Stanford, CA | Stanford | CA | 5 | 20023.0 | 1420-1570 | 1420 | 1570 | Far West |
| 3 | Harvard University | Cambridge, MA | Cambridge | MA | 5 | 18037.0 | 1460-1580 | 1460 | 1580 | New England |
| 5 | Princeton University | Princeton, NJ | Princeton | NJ | 6 | 18685.0 | 1450-1570 | 1450 | 1570 | Mid East |
| 7 | California Institute of Technology | Pasadena, CA | Pasadena | CA | 7 | 26591.0 | 1530-1580 | 1530 | 1580 | Far West |
| 16 | University of Chicago | Chicago, IL | Chicago | IL | 7 | 36584.0 | 1500-1570 | 1500 | 1570 | Great Lakes |
| 4 | Yale University | New Haven, CT | New Haven | CT | 7 | 17511.0 | 1460-1580 | 1460 | 1580 | New England |
| 12 | Columbia University | New York, NY | New York | NY | 7 | 22126.0 | 1460-1570 | 1460 | 1570 | Mid East |
| 1 | Massachusetts Institute of Technology | Cambridge, MA | Cambridge | MA | 7 | 19998.0 | 1510-1580 | 1510 | 1580 | New England |
| 9 | Brown University | Providence, RI | Providence | RI | 8 | 27659.0 | 1440-1560 | 1440 | 1560 | New England |
| 8 | Duke University | Durham, NC | Durham | NC | 8 | 26932.0 | 1470-1570 | 1470 | 1570 | Southeast |
| 30 | Bowdoin College | Brunswick, ME | Brunswick | ME | 9 | 25622.0 | 1360-1510 | 1360 | 1510 | New England |
| 20 | Pomona College | Claremont, CA | Claremont | CA | 9 | 30392.0 | 1390-1540 | 1390 | 1540 | Far West |
| 31 | Swarthmore College | Swarthmore, PA | Swarthmore | PA | 9 | 20360.0 | 1390-1540 | 1390 | 1540 | Mid East |
| 11 | University of Pennsylvania | Philadelphia, PA | Philadelphia | PA | 9 | 24167.0 | 1460-1570 | 1460 | 1570 | Mid East |
| 10 | Dartmouth College | Hanover, NH | Hanover | NH | 9 | 24525.0 | 1440-1560 | 1440 | 1560 | New England |
| 35 | United States Military Academy at West Point | West  Point, NY | West  Point | NY | 9 | null | 1210-1440 | 1210 | 1440 | Mid East |
| 14 | Northwestern University | Evanston, IL | Evanston | IL | 9 | 28344.0 | 1430-1550 | 1430 | 1550 | Great Lakes |
| 67 | Colby College | Waterville, ME | Waterville | ME | 10 | 18552.0 | 1380-1520 | 1380 | 1520 | New England |
| 23 | Cornell University | Ithaca, NY | Ithaca | NY | 11 | 27522.0 | 1400-1540 | 1400 | 1540 | Mid East |
| 6 | Rice University | Houston, TX | Houston | TX | 11 | 19215.0 | 1460-1570 | 1460 | 1570 | Southwest |
| 21 | Johns Hopkins University | Baltimore, MD | Baltimore | MD | 11 | 25241.0 | 1470-1560 | 1470 | 1560 | Mid East |
| 60 | Tulane University | New Orleans, LA | New Orleans | LA | 11 | 47413.0 | 1340-1500 | 1340 | 1500 | Southeast |

To be clear, all schools SELECTed by this query are highly selective schools. According to [CollegeData](https://www.collegedata.com/resources/the-facts-on-fit/understanding-college-selectivity), the average four-year school in the US accepts around 66% of applicants; only about 50 admit fewer than 30% of applicants. In this way, the difference between a school that admits 5% of students and one that accepts double that amount, 10% of students, is a pretty marginal difference; both schools are highly selective in terms of all collegiate acceptances in the US. 

Still, all the top 10 ranked schools do appear in the list of 20 most selective (read: lowest acceptance rate) colleges. There is an obvious correlation between ranking and selectivity. A major question arises that this dataset cannot answer: does selectivity breed quality, or does quality breed selectivity? Does a school that is highly ranked, year after year, generate more applicants by nature of it being a “top school”? Or is it a top school because it selects only the best candidates? Likely, both factors contribute to this correlation, though once more, the dataset cannot provide definitive answers.

Interestingly, when SELECTing the 20 more selective schools, schools from far down in the rankings appear, like Tulane (no. 60) and Colby College (no. 67). A place for further analysis (likely qualitative analysis) would be to investigate why schools that are not in the top of all top schools are so selective? (Though in the top 60s of all US colleges is still relatively highly ranked.) Do external factors like location or reputation lead more students to apply? 

---

```sql
/* Which regions have the lowest acceptance rates for all 250 top schools */

SELECT
  region
  , ROUND (AVG (acceptance_rate)) AS region_acceptance
FROM
  `adept-turbine-353215.top_colleges.top_250_colleges`
GROUP BY
  region
ORDER BY
  region_acceptance ASC
```

| region | region_acceptance |
| --- | --- |
| New England | 28.0 |
| Mid East | 40.0 |
| Far West | 43.0 |
| Southeast | 53.0 |
| Great Lakes | 60.0 |
| Plains | 62.0 |
| Southwest | 62.0 |
| Rocky Mountains | 68.0 |

New England has the lowest acceptance rate by a significant amount when SELECTing from the top 250 colleges: less than half the average acceptance rate of Great Lakes, Plains, Southwest, and Rocky Mountains. Does this change when we narrow down to the top 100 schools? Top 50?

```sql
/* Which regions have the lowest acceptance rates in the top 100 schools? */

SELECT
  region
  , ROUND (AVG (acceptance_rate)) AS region_acceptance
FROM
  `adept-turbine-353215.top_colleges.top_250_colleges`
WHERE
  rank <= 100
GROUP BY
  region
ORDER BY
  region_acceptance ASC
```

| region | region_acceptance |
| --- | --- |
| New England | 17.0 |
| Far West | 23.0 |
| Mid East | 26.0 |
| Southeast | 30.0 |
| Plains | 33.0 |
| Great Lakes | 38.0 |
| Southwest | 39.0 |
| Rocky Mountains | 62.0 |

```sql
/* Which regions have the lowest acceptance rates in the top 50 schools? */

SELECT
  region
  , ROUND (AVG (acceptance_rate)) AS region_acceptance
FROM
  `adept-turbine-353215.top_colleges.top_250_colleges`
WHERE
  rank <= 50
GROUP BY
  region
ORDER BY
  region_acceptance ASC
```

| region | region_acceptance |
| --- | --- |
| Far West | 12.0 |
| Mid East | 12.0 |
| New England | 14.0 |
| Great Lakes | 15.0 |
| Plains | 16.0 |
| Southeast | 22.0 |
| Southwest | 22.0 |