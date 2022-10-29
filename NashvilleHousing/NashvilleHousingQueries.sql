/*
Cleaning Data in BigQuery SQL Server

The file I imported into BigQuery was an unclean CSV file. BigQuery did not assign proper column names, data types, or null values. 
Below are the queries I used to clean the data; this acts as a quasi change-log for the SQL database.
*/


/* -------  List of Column Names ------- */

unique_id,
parcel_id,
land_use,
property_address,
sale_date,
sale_price,
legal_reference,
sold_as_vacant,
owner_name,
owner_address,
acreage,
tax_district,
land_value,
building_value,
total_value,
year_built,
bedroom,
full_bath,
half_bath

--------------------------------------------------------------------------------------------------------------------------

/* ------- Renaming Columns ------- */
  -- Columns were imported with the not-so-useful naming schema "string_field_0", "string_field_1" etc.
  -- Wrote a query aliasesing all columns and then saved query as new table in database

SELECT
  string_field_0 AS unique_id,
  string_field_1 AS parcel_id,
  string_field_2 AS land_use,
  string_field_3 AS property_address,
  string_field_4 AS sale_date,
  string_field_5 AS sale_price,
  string_field_6 AS legal_reference,
  string_field_7 AS sold_as_vacant,
  string_field_8 AS owner_name,
  string_field_9 AS owner_address,
  string_field_10 AS acreage,
  string_field_11 AS tax_district,
  string_field_12 AS land_value,
  string_field_13 AS building_value,
  string_field_14 AS total_value,
  string_field_15 AS year_built,
  string_field_16 AS bedroom,
  string_field_17 AS full_bath,
  string_field_18 AS half_bath
FROM 
  `adept-turbine-353215.nashville_housing.housing_data` --- database name in BigQuery



--------------------------------------------------------------------------------------------------------------------------

/* ------- Converting "NULL" Text Strings to NULL value ------- */
  --Using NULLIF to search for and replace the string "NULL" in each column of the table
  --Ran query and saved the results, overwriting the working table (not the raw, original imported table)
  --Note: On the free, sandbox tier of BigQuery, I can save a query to overwrite a table; 
      --however, I cannot use DML to CREATE, UPDATE, or DELETE rows or tables, hence why I had to craft a new table.

SELECT 
  NULLIF(unique_id, 'NULL') AS unique_id,
  NULLIF(parcel_id, 'NULL') AS parcel_id,
  NULLIF(land_use, 'NULL') AS land_use,
  NULLIF(property_address, 'NULL') AS property_address,
  NULLIF(sale_date, 'NULL') AS sale_date,
  NULLIF(sale_price, 'NULL') AS sale_price,
  NULLIF(legal_reference, 'NULL') AS legal_reference,
  NULLIF(sold_as_vacant, 'NULL') AS sold_as_vacant,
  NULLIF(owner_name, 'NULL') AS owner_name,
  NULLIF(owner_address, 'NULL') AS owner_address,
  NULLIF(acreage, 'NULL') AS acreage,
  NULLIF(tax_district, 'NULL') AS tax_district,
  NULLIF(land_value, 'NULL') AS land_value,
  NULLIF(building_value, 'NULL') AS building_value,
  NULLIF(total_value, 'NULL') AS total_value,
  NULLIF(year_built, 'NULL') AS year_built,
  NULLIF(bedroom, 'NULL') AS bedroom,
  NULLIF(full_bath, 'NULL') AS full_bath,
  NULLIF(half_bath, 'NULL') AS half_bath
FROM 
  `adept-turbine-353215.nashville_housing.housing_data01`




--Query table to scan and see if "NULL" was converted to NULL values

SELECT 
  *
FROM
  `adept-turbine-353215.nashville_housing.housing_data01`

---------------------------------------------------------------------------------------------------------------------------

/* ------- Standardize Date Format on sale_date column ------- */
 
 -- Using the Parse() function to convert dates from string, rather than Cast()



--Query to look at a sample of sale_date values to investigate date format
SELECT 
  sale_date
FROM
  `adept-turbine-353215.nashville_housing.housing_data01`
LIMIT 10 


--Query to look for NULL values that are disrupting date parsing
SELECT 
  sale_date
FROM `adept-turbine-353215.nashville_housing.housing_data01`
WHERE sale_date IS NULL 
--After running this program, I found 3 NULL sale dates, which I cannot delete with the BigQuery free "sandbox" version; 
--I will need to run SAFE.PARSE_DATE() instead of regualar PARSE_DATE to work around this, which will just skip NULL values in the conversion


-- Query to convert string value dates (from 01-Jan-19 format to a standardized DATE format)
SELECT 
  sale_date,
  SAFE.PARSE_DATE('%e-%h-%y', sale_date) AS new_sale_date 
FROM `adept-turbine-353215.nashville_housing.housing_data01`


-- Query to compare converted string to original string (test and check my results)
SELECT 
  sale_date, 
  SAFE.PARSE_DATE('%e-%h-%y', sale_date) AS new_sale_date,
  FORMAT_DATE('%e-%h-%y', SAFE.PARSE_DATE('%e-%h-%y', sale_date)) AS test
FROM 
  `adept-turbine-353215.nashville_housing.housing_data01`
WHERE 
  sale_date NOT LIKE FORMAT_DATE('%e-%h-%y', SAFE.PARSE_DATE('%e-%h-%y', sale_date)) -- testing to see if test column = sale_date column 
-- All entries look the way they should

  ---------------------------------------------------------------------------------------------------------------------------

/* ------- Assigning proper data types to columns ------- */


-- All columns transfered as STRING type. Below is a list of the columns that need to change and what they need to change to.
-- The entries that are inset with brackets are intended to be STRING types and do not need to be converted.
-- This is a reference entry, not a query to be used. 


/*
unique_id, INTEGER
   [parcel_id, STRING]
   [land_use, STRING]
   [property_address, STRING]
sale_date, DATE
sale_price, INTEGER
   [legal_reference, STRING]
   [sold_as_vacant, STRING] - Yes and No values, potential convert to boolean?
   [owner_name, STRING]
   [owner_address, STRING]
acreage, FLOAT
   [tax_district, STRING]
land_value, INTEGER
building_value, INTEGER
total_value, INTEGER
year_built, DATE (year)
bedroom, INTEGER
full_bath, INTEGER
half_bath, INTEGER
*/

-- Using SAFE_CAST() and SAFE_PARSE() functions when nessecary (and no fuctions when columns are in proper format), I use this query to convert to proper type.
SELECT
  SAFE_CAST(unique_id AS INT64) AS unique_id,
  parcel_id,
  land_use,
  property_address,
  SAFE.PARSE_DATE('%e-%h-%y', sale_date) AS sale_date,
  SAFE_CAST(sale_price AS INT64) AS sale_price,
  legal_reference,
  sold_as_vacant,
  owner_name,
  owner_address,
  SAFE_CAST(acreage AS FLOAT64) AS acreage,
  tax_district,
  SAFE_CAST(land_value AS INT64) AS land_value,
  SAFE_CAST(building_value AS INT64) AS building_value,
  SAFE_CAST(total_value AS INT64) AS total_value,
  FORMAT_DATE('%Y', SAFE.PARSE_DATE('%Y', year_built) ) AS year_built,
  SAFE_CAST(bedroom AS INT64) AS bedroom,
  SAFE_CAST(full_bath AS INT64) AS full_bath,
  SAFE_CAST(half_bath AS INT64) AS half_bath
FROM
  `adept-turbine-353215.nashville_housing.housing_data01`

--After running and investigating this query, all the columns and data seem to be in the proper format. I use this query to overwrite my working table

 --------------------------------------------------------------------------------------------------------------------------

/* ------- Populate Property Address Data on NULL Values ------- */
    
  --There are several rows with duplicated parcel_id fields.
  --Based on the nature of the data, this suggests that a certain parcel of land went through a series of different real estate transactions.
  --As such, the data should not be deleted since they contain valuable information about the sale process.
  --Some of these rows have missing property_address fields, yet other rows for that same parcel_id contain the property_address.
  --Since the parcel_id refers to the same plot of land no matter the transaction, the NULL property_address should be the same.
  --The NULL values can be filled by the property_address of the same parcel_id.
  

--Performing a self-JOIN to look for duplicate property_address entries by joining where parcel_id is the same,
--but unique_id (the transaction identifier) is different.
--Additionally, this query only looks for rows where there is a missing property_address field.
SELECT 
  a.parcel_id,
  a.property_address,
  b.parcel_id,
  b.property_address,
FROM
  `adept-turbine-353215.nashville_housing.housing_data01` AS a
JOIN
  `adept-turbine-353215.nashville_housing.housing_data01` AS b
  ON a.parcel_id = b.parcel_id
  AND a.unique_id <> b.unique_id
WHERE
  a.property_address IS NULL


--After identifying appropraite rows in the previous query, this query uses IFNULL to replace the NULL value with the
--property_id from another row with the same parcel_id.
SELECT 
  a.parcel_id,
  a.property_address,
  b.parcel_id,
  b.property_address,
  IFNULL (a.property_address, b.property_address) 
FROM
  `adept-turbine-353215.nashville_housing.housing_data01` AS a
JOIN
  `adept-turbine-353215.nashville_housing.housing_data01` AS b
  ON a.parcel_id = b.parcel_id
  AND a.unique_id <> b.unique_id
WHERE
  a.property_address IS NULL


-- Using UPDATE with the previous script to make changes appropriate changes to the missing data.
--(Note: UPDATE is not a funciton allowed on the free tier of BigQuery, so this query is hypthetical)
UPDATE a 
SET
  property_address = IFNULL (a.property_address, b.property_address) 
FROM
  `adept-turbine-353215.nashville_housing.housing_data01` AS a
JOIN
  `adept-turbine-353215.nashville_housing.housing_data01` AS b
  ON a.parcel_id = b.parcel_id
  AND a.unique_id <> b.unique_id
WHERE
  a.property_address IS NULL


--------------------------------------------------------------------------------------------------------------------------
/* ------- Breaking Addresses into Individual Columns (Address, City, State) ------- */
    
    --Addresses exist in the following format [1201 5TH AVE N, NASHVILLE] with a comma separating the street address from the town
    --Using substrings to break address entries at the , delimter, the data can be split into more meaningful columns of address, city, and state.
    

--Using SUBSTRING and STRPOS(BigQuery's equivilent to CHARINDEX) to find and isolate the address by looking for the comma in the field
SELECT 
  property_address,
  SAFE.SUBSTRING(property_address, 1, ( STRPOS(property_address, ',')-1 )) 
      --- STRPOS to locate the position where the comma is, then subtracting 1 to create a substring that does not include the comma
FROM
  `adept-turbine-353215.nashville_housing.housing_data01`


--Isolating the address after the comma 
SELECT 
  property_address,
  SAFE.SUBSTRING(property_address, ( STRPOS(property_address, ',') + 2 ), LENGTH(property_address) ) 
      --- STRPOS to locate the position where the comma is, then adding 2 to start the substring after ", "
      --- LENGTH to navigate to the end position in the string
FROM
  `adept-turbine-353215.nashville_housing.housing_data01`


--Putting both queries together to create new columns for property_split_address and property_split_city
SELECT 
  SAFE.SUBSTRING(property_address, 1, ( STRPOS(property_address, ',')-1 )) AS property_split_address,
  SAFE.SUBSTRING(property_address, ( STRPOS(property_address, ',') + 2 ), LENGTH(property_address) ) AS property_split_city
FROM
  `adept-turbine-353215.nashville_housing.housing_data01`



-- Splitting the owner_address column into address, city, and state columns using the same process
-- (Though the PRASENAME() function would be a more elegant solution, I must use substrings because PARSENAME() is not a function in BigQuery)
SELECT 
  SAFE.SUBSTRING(owner_address, 1, ( STRPOS(owner_address, ',')-1 )) AS owner_split_address,
  SAFE.SUBSTRING(owner_address,    (STRPOS(owner_address, ',') + 2),   LENGTH(owner_address)-(STRPOS(owner_address, ',')+5)) AS owner_split_city,
  REVERSE(SAFE.SUBSTRING(REVERSE(owner_address), 1, ( STRPOS(REVERSE(owner_address), ',')-1 ))) AS owner_split_state 
FROM
  `adept-turbine-353215.nashville_housing.housing_data01`

-- Note: I am unable to add these columns to my table in BigQuery free sandbox using DML. However, that would be a logical next step.

--------------------------------------------------------------------------------------------------------------------------

/* ------- Change "Y" and "N" to "Yes" and "No" in "Sold as Vacant" Column ------- */

  --Data in the sold_as_vacant column is inconsistent. Some example responses are Y, N, Yes, and No.
  --The data are much more useful when in the same format, so we must clean to a consistent response type.


--Query to review response types in this column
SELECT 
  DISTINCT(sold_as_vacant)
FROM
  `adept-turbine-353215.nashville_housing.housing_data01` 
-- Query yields 'Y','N','Yes','No',NULL, and 3 addresses (which, of course, should not be there)


--Query to determine if more values are stored as Y/N or Yes/No
SELECT 
  DISTINCT(sold_as_vacant),
  COUNT(sold_as_vacant) AS count_type
FROM
  `adept-turbine-353215.nashville_housing.housing_data01`
GROUP BY
  sold_as_vacant
ORDER BY
  count_type
---Yes/No are far more common than Y/N, so I will convert Y/N into Yes/No


-- Using CASE to turn Y -> Yes and N -> No
SELECT 
  CASE
    WHEN sold_as_vacant = 'Y' THEN 'Yes'
    WHEN sold_as_vacant = 'N' THEN 'No'
    ELSE sold_as_vacant
  END AS updated_sold_as_vacant,
FROM
  `adept-turbine-353215.nashville_housing.housing_data01` 

----------------------------------------------------------------------------------------------------------------------

/* ------- Removing Duplicate Rows ------- */

  --Using window fuctions (CTE), PARTITION BY, and ROW_NUMBER () to identify duplicate rows.
  --Using this partition, duplicated rows would have a number larger than 1 (because all data is the same in the partition). 


--Starting with a CTE to number rows, partitioned by the duplicated elements.
--The SELECT statement then selects all rows where the row_num (based on the partition) is greater than 1.
--All rows with a row_num greater than 1 are duplicates.

WITH row_num_cte AS
(
SELECT
  *,
  ROW_NUMBER () OVER (
    PARTITION BY
      parcel_id,
      property_address,
      sale_price,
      sale_date,
      legal_reference,
  ) AS row_num
FROM
  `adept-turbine-353215.nashville_housing.housing_data01`
)

SELECT
  *
FROM
  row_num_cte
WHERE
  row_num > 1
  
  
 
--After identifying and verifying the duplicates, a simple change of SELECT to DELETE will remove the duplicates.

WITH row_num_cte AS
(
SELECT
  *,
  ROW_NUMBER () OVER (
    PARTITION BY
      parcel_id,
      property_address,
      sale_price,
      sale_date,
      legal_reference,
  ) AS row_num
FROM
  `adept-turbine-353215.nashville_housing.housing_data01`
)

DELETE
  *
FROM
  row_num_cte
WHERE
  row_num > 1
              --Note: On the free version of BigQuery, I am unable to use DML like DELETE. 
