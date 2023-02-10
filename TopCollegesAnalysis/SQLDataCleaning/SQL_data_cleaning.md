## Data Cleaning

Data is relatively clean by this stage (most cleaning steps were taken during the scraping process).

Cleaning steps:

- Removing first column `int64_field_0`, which was a row counter exported with the .csv file (done by selecting all columns but `int64_field_0`)
- Changing the field `acceptance` to `acceptance_rate` for clarity
- CASTing `SAT_low` as INT64, rather than FLOAT, as all values are whole numbers
- CASTing `SAT_high` as INT64, rather than FLOAT, as all values are whole numbers
- Add a `region` column based on the Bureau of Economic Analysis’s economic regions of the USA
    - USA regions according to the Bureau of Economic Analysis:
        
        New England (CT, ME, MA, NH, RI, VT), Mid East (DE, DC, MD, NJ, NY, PA), Great Lakes (IL, IN, MI, OH, WI), Plains (IA, KS, MN, MO, NE, ND, SD), Southeast (AL, AR, FL, GA, KY, LA, MS, NC, SC, TN, VA, WV), Southwest (AZ, NM, OK, TX), Rocky Mountains (CO, ID, MT, UT, WY), Far West (AK, CA, HI, NV, OR, WA)
- Saved and over-wrote the original `top_250_colleges` table
        

```sql
SELECT  
  rank
  , name
  , city_state
  , city
  , state
  , acceptance AS acceptance_rate
  , price
  , SAT_range
  , CAST (SAT_low AS INT64) AS SAT_low
  , CAST (SAT_high AS INT64) AS SAT_high
	, CASE
      WHEN state IN ('CT', 'ME', 'MA', 'NH', 'RI', 'VT') THEN 'New England'
      WHEN state IN ('DE', 'DC', 'MD', 'NJ', 'NY', 'PA') THEN 'Mid East'
      WHEN state IN ('IL', 'IN', 'MI', 'OH', 'WI') THEN 'Great Lakes'
      WHEN state IN ('IA', 'KS', 'MN', 'MO', 'NE', 'ND', 'SD') THEN 'Plains'
      WHEN state IN ('AL', 'AR', 'FL', 'GA', 'KY', 'LA', 'MS', 'NC', 'SC', 'TN', 'VA', 'WV') THEN 'Southeast'
      WHEN state IN ('AZ', 'NM', 'OK', 'TX') THEN 'Southwest'
      WHEN state IN ('CO', 'ID', 'MT', 'UT', 'WY') THEN 'Rocky Mountains'
      WHEN state IN ('AK', 'CA', 'HI', 'NV', 'OR', 'WA') THEN 'Far West'
	   END AS region
FROM 
  `adept-turbine-353215.top_colleges.top_250_colleges`
ORDER BY
  rank
```
