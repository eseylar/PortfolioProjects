# 2022 Year in Music (Data Cleaning)

Imported .csv with information that goes beyond 2022.

**Fields**:

`album` - string

`artist` - string

`song` - string

`date_time_str` - string; format - “07 Nov 2020 21:44”

---

I saved the following query and overwrote the original table with it to add a `date_time` column.

```sql
SELECT  
  *
  , PARSE_DATETIME('%d %h %Y %R', date_time_str) AS date_time #parse the datetime format from `date_time_str`
FROM 
  `adept-turbine-353215.wrapped_22.all_listening` 
```

I saved the following query and overwrote the original table with it to add `date_time_GMT` (original time in .csv) and `date_time_cst` with the time that is correct for my time zone (CST, Chicago)

```sql
SELECT  
  album
  , artist
  , song
  , date_time AS date_time_GMT #the original date_time is in GMT, not CST, 6 hours ahead of my local time
	, DATETIME_SUB (date_time_GMT, INTERVAL 6 HOUR) AS date_time_CST #subtract 6 hours from `date_time_GMT` to get time in Central Time Zone (Chigaco)
FROM 
  `adept-turbine-353215.wrapped_22.all_listening`
ORDER BY
  date_time_GMT DESC
```

I ran and overwrote the following query to extract and format a `date_CST` and `time_CST` column, with the extracted date and time in CST (rather than GMT).

```sql
SELECT
  album
  , artist
  , song
  , date_time_CST
  , DATE(date_time_CST) AS date_CST
  , FORMAT_TIME ('%R', TIME(date_time_CST)) AS time_CST
FROM
  `adept-turbine-353215.wrapped_22.all_listening`
ORDER BY
  date_time_CST ASC
```

I ran the following query to limit my data to the year 2022 and saved it to a new table called ‘listening_2022_raw’.

```sql
SELECT
  *
FROM
  `adept-turbine-353215.wrapped_22.all_listening`
WHERE
  date_time_CST BETWEEN '2022-01-01' AND '2022-12-31 23:59:59'
ORDER BY
  date_time_CST ASC
```

Added column `weekday_num` (value in the range [1,7] with Sunday as the first day
of the week) and `weekday` (string representation of day of week) to aid in analysis of listening habits. This query was saved to a new table called ‘listening_2022_clean’.

```sql
SELECT
  album
  , artist
	, song
	, date_time_CST
	, date_CST
  , EXTRACT(DAYOFWEEK FROM date_CST) AS weekday_num	
  , CASE
      WHEN EXTRACT(DAYOFWEEK FROM date_CST) = 1 THEN "Sunday"
      WHEN EXTRACT(DAYOFWEEK FROM date_CST) = 2 THEN "Monday"
      WHEN EXTRACT(DAYOFWEEK FROM date_CST) = 3 THEN "Tuesday"
      WHEN EXTRACT(DAYOFWEEK FROM date_CST) = 4 THEN "Wednesday"
      WHEN EXTRACT(DAYOFWEEK FROM date_CST) = 5 THEN "Thursday"
      WHEN EXTRACT(DAYOFWEEK FROM date_CST) = 6 THEN "Friday"
      WHEN EXTRACT(DAYOFWEEK FROM date_CST) = 7 THEN "Saturday"
      ELSE NULL
    END AS weekday
  , time_CST
FROM
  `adept-turbine-353215.wrapped_22.listening_2022_raw`
ORDER BY
  date_time_CST ASC
```