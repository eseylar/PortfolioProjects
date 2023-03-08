## Data Extraction and Data Cleaning Using SQL

### The first element of this exploratory data analysis project was to extract a dataset of my Spotify streaming history, and to clean the dataset using SQL.

For several years, I have used the web service [last.fm](https://www.last.fm/home) to track my Spotify listening. Last.fm allows users to connect their service to an outside streaming platform, like Spotify, so users may see their entire music listening history. I was only able to complete this project because I was a user of last.fm at the start of 2022; I would not have been able to access my listening history otherwise.

Since I had my Spotify streaming history stored within last.fm, all I needed was a way to extract that data. Fortunately, GitHub user benfoxall has written a JavaScript [program](https://github.com/benfoxall/lastfm-to-csv) that allows users to extract their last.fm history as a .csv file, just by typing in your last.fm username. Using Foxall's script, I was able to generate a .csv with my entire last.fm listening history. 

---

#### Data Structure

"Last.fm to csv" generated a .csv file with listening history that extends beyond 2022.

The file had four unnamed fields, which I imported into SQL using the following schema:
- `album` - string; the album upon which a streamed track appeared
- `artist` - string; the artist by whom a streamed track was performed
- `song` - string; the title for which a track is named
- `date_time_str` - string; format - “07 Nov 2020 21:44”; the datetime data for which a particular stream instance occurred

---

#### Data Cleaning

There were two major issues that needed to be addressed by my data cleaning process:
1. The dataset included streams prior to the start of 2022 and streams following the end of 2022.
2. The datetime information for my streams was in the GMT timezone, not the CST timezone (in which I live).

I wrote my queries in Google's BigQuery environment, so my functions use BigQuery's syntax. Here are some of the function I used to clean my data: 
- PARSE_DATETIME() - to extract datetime data from a string
- DATETIME_SUB() - to subtract time from the datetime data to move data into my own timezone
- DATE() / TIME() - to extract date and/or time from datatime data
- FORMAT_TIME() - to change the format of my time data
- EXTRACT() - to extract the day of the week from my date data
- CASE/WHEN statements - to name numerical day of week data (e.g. 1 = "Sunday", 2 = "Monday" ...)
- BETWEEN __ AND __ - to select only fields with datetime data between two certain dates

The queries I used to clean my dataset (as well as comments explain my process) can be found within the file [SQL_data_cleaning.md](SQL_data_cleaning.md).
