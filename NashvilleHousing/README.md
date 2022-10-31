## SQL Data Cleaing Portfolio Project

### Project Source
*Data source:*  https://github.com/AlexTheAnalyst/PortfolioProjects/blob/main/Nashville%20Housing%20Data%20for%20Data%20Cleaning.xlsx 

*Project developer: AlexTheAnalyst*


### Dataset Information

The dataset for this project is a set of information about real estate sales in Nashville, TN. The dataset includes the following columns:
    `unique_id,`
    `parcel_id,`
    `land_use,`
    `property_address,`
    `sale_date,`
    `sale_price,`
    `legal_reference,`
    `sold_as_vacant,`
    `owner_name,`
    `owner_address,`
    `acreage,`
    `tax_district,`
    `land_value,`
    `building_value,`
    `total_value,`
    `year_built,`
    `bedroom,`
    `full_bath,`
    `half_bath`

The document ****NashvilleHousingQueries.sql**** contains all the queries used to clean the dataset, as well as comments explaining the process and why certain techniques were used.
    
### Data Cleaning Techniques

The dataset is "dirty" insofar as there are many duplicate rows, rows with missing values, rows with extraneous information, and rows that are formatted in unusable ways.

To clean this dataset, I employed some of the following techniques:

- populating missing data from other locations in the dataset using self-JOINS
- removing duplicates using WITH statements, PARTITION BY, and ROW_NUMBER()
- splitting string along delimiters into new columns using SUBSTRING() and STRPOS() (STRPOS is BigQuery's equivilent to CHARINDEX)
- normalizing inconsistent string responses using CASE
- parsing date values from stings using PARSE() 
- converting "null" string to NULL values using NULLIF()
- converting columns from the imported string type to a more appropriate type using CAST()


### Additional Project Successes 

Though this data cleaning project was inspired by creator AlexTheAnalyst, I faced many additional roadblocks that I had to independently problem solve. Here are some steps I had to take to properly clean this dataset:

- The SQL editor I used was Google BigQuery, a relatively unpopular SQL editor compared to MS SQL Server or MySQL. This means that tech support for BigQuery is not as easy to find. Further, certain BigQuery functions are different than the functions on more popular databases. I frequently had to read through the BigQuery documentation to find the functions and syntax I needed to properly clean the data. 
- BigQuery struggled to import the CSV file used for this project. Despite the data having a clear header row and similar data-types within a column, BigQuery did not assign the proper headers or data type to any row; they were all imported as string types with column names like "string_field_0". To remedy this, I had to problem solve to change datatype and headers. I researched techniques like creating a JSON schema to import, but ultimately landed on renaming and CASTing/PARSEing the data to the proper format. In doing this, I had to research BigQuery's CAST() syntax and PARSE_DATE() syntax. 
