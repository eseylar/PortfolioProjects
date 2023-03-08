# 🎓 An Analysis of the Top US Colleges in 2023

<img src="https://external.niche.com/rankings-badges/niche-best-colleges-badge-2023.png" width="250" height="250">

This five-part exploratory data project analyzes the trends within Niche.com's ranking of the best colleges in the US in the year 2023. The project engages in many steps of the data analytics workflow, including: 
- ETL processes (extracting data using web-scraping tools, cleaning data in SQL, and maintaining data integrity while moving between platforms)
- Analytics in SQL
- Analytics in Python
- Designing an interactive data visualization
In essence, I engage in most of the procedures involved in the data analysis lifecycle, from start to finish. I extract the data, transform the data, clean the data, explore the data, analyze the data, and present the data. 

The data for this project was extracted from Niche.com, a website that aggregates data about colleges and universities and produces an annual list ranking the schools. Though Niche's proprietary formula ranks all the schools on which they have data, I limited my search to only the top 250 schools, as extending to _all_ schools limits our ability to investigate _top_ schools. Niche's 2023 Best Colleges ranking can be found [here](https://www.niche.com/colleges/search/best-colleges/).

All the code for this project can be found in this repository. However, this project is best viewed in the order it was executed. See the chart to access the steps in order.

| **Process** | **Tools Used** |
|---|---|
| Step 1: [Web-Scraping](https://github.com/eseylar/PortfolioProjects/tree/main/TopCollegesAnalysis/PythonWebScraping) | Python3 (Jupyter Notebook), Pandas library, Beautiful Soup library |
| Step 2: [Data Cleaning](https://github.com/eseylar/PortfolioProjects/tree/main/TopCollegesAnalysis/SQLDataCleaning) | SQL |
| Step 3: [Data Exploration](https://github.com/eseylar/PortfolioProjects/tree/main/TopCollegesAnalysis/SQLDataExploration) | SQL (Tools like CTEs, window functions, etc.) |
| Step 4: [Data Analysis](https://github.com/eseylar/PortfolioProjects/tree/main/TopCollegesAnalysis/PythonDataAnalysis) | Python3 (Jupyter Notebook), Pandas library, NumPy library, Matplotlib library, Seaborn library |
| Step 5: [Data Visualization](https://github.com/eseylar/PortfolioProjects/tree/main/TopCollegesAnalysis/DataVisualization) | Google Looker Studio |
