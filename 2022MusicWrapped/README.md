# 🎵 Un-Wrapped: Making Sense of My 2022 Music Habits

Every year around December, music streaming service Spotify releases its annual "Wrapped" feature. The much-loved, much-publicized Spotify Wrapped gives each Spotify user a breakdown of their own listening history for the preceding calendar year, highlighting metrics like minutes of streaming, top songs, top artists, and top genres. To social media users, the day Spotify Wrapped releases almost appears to be a holiday. Release day is anticipated and celebrated. Myriad screenshots, jokes, and think pieces litter Instagram and Twitter feeds for days after Wrapped begins appearing on users' Spotify apps. It is truly a master-class in individualized brand experiences. 

Yet, there is a major issue with Spotify Wrapped. While Wrapped claims to generate data about a user's entire year of streaming, the feature only tracks music from January 1 to around October 31. This leaves users with about 17% of their annual streaming unaccounted for in the year-end visualization; streaming tastes and habits can change quite a bit in two months.

**This four-part exploratory data project is my attempt to fill in the gap created by Spotify Wrapped.** Within this project, I analyze trends and notable figures within my personal music streaming history in the year 2022. The project engages in many steps across the data analytics workflow, including:
- Data cleaning in SQL
- Scripting in Python (including connecting with APIs)
- Analytics in SQL
- Designing a data visualization


---

### Data Sources
The dataset used for this project was my own, personal Spotify streaming history from the year 2022. 

My Spotify streams were logged using the service [last.fm](https://www.last.fm/home), a website which tracks individual music listening ("scrobbles", to use the site's jargon) across a variety of music services. I exported my last.fm history using Ben Foxall's script [Last.fm to csv](https://benjaminbenben.com/lastfm-to-csv/). Foxall's script takes a user's last.fm username and generates a .csv file with a user's entire last.fm history. This generates a file with the following information: when a song was streamed, the name of the song, the artist of the song, and the album of the song. This is a great place to start, but does not include all the information necessary for analysis.

Additional metadata about my streaming was generated from [MusicBrainz](https://musicbrainz.org/), the "open music encyclopedia that collects music metadata and makes it available to the public." I used Python to connect with the MusicBrainz [API](https://python-musicbrainzngs.readthedocs.io/en/v0.7.1/) so I could generate additional information about my "scrobbles," including track and artist primary keys, track duration, and artist genre tags. 

---
### Table of Contents
All the code for this project can be found in this repository. However, this project is best viewed in the order it was executed. See the chart below to access the steps in order.

| Process | Tools Used |
|---|---|
| Step 1: [Data Extraction and Data Cleaning in SQL](/2022MusicWrapped/1_SQLDataCleaning/) | SQL |
| Step 2: [Data Merging and Extraction in Python](https://github.com/eseylar/PortfolioProjects/tree/main/2022MusicWrapped/2_PythonDataMerging) | Python (Jupyter Notebook), Pandas library, NumPy library, MusicBrainz API |
| Step 3: [Data Analysis in SQL](https://github.com/eseylar/PortfolioProjects/tree/main/2022MusicWrapped/3_SQLAnalysis) | SQL |
| Step 4: [Data Visualization in Figma](https://github.com/eseylar/PortfolioProjects/tree/main/2022MusicWrapped/4_DataVisualization) | Figma (graphic design tool) |
