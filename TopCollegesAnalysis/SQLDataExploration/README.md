## Exploring the Data in SQL

**The second element of this exploratory data analysis was to use SQL to understand the dataset, identify trends, and interpret important values in the data.**

After [cleaning the data](https://github.com/eseylar/PortfolioProjects/tree/main/TopCollegesAnalysis/SQLDataCleaning), I began to explore key values and trends in the cleaned data. Coming into this data exploration, I already had a solid grasp of things like number of rows and max/min values. I utilized SQL to, instead, look for commonalities among groupings like `states` and `region` and `rank`ing.

I began with a broad set of questions that guided my search. This set of questions can be found at the very top of my SQL data exploration document, [SQL_data_exploration.md](https://github.com/eseylar/PortfolioProjects/blob/main/TopCollegesAnalysis/SQLDataExploration/SQL_data_exploration.md). Additionally, here is a brief sampling of the types of questions I asked of the data:
  - Which states have the most of the 250 top colleges? What about the top 100 colleges?
  - Which regions have the most of the 250 top colleges? What about the top 100 colleges?
  - What is the average price when grouping by region?
  - What trends emerge in price, SAT, and acceptance rate when we group the schools into "buckets" of ranking? (i.e. schools ranked 1-10, 11-20, 21-30, etc.)
  
The above Markdown document includes the following: some questions for exploration, the SQL queries I used to determine answers, the results of my queries (as tables), and some brief analysis of the results. I used the results of my SQL data exploration to inform my data visualization. 
