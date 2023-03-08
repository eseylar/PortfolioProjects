## Data Extraction and Data Cleaning Using SQL

### The first element of this exploratory data analysis project was to extract a dataset of my Spotify streaming history, and to clean the dataset using SQL.

For several years, I have used the webservice [last.fm](https://www.last.fm/home) to track my Spotify listening. Last.fm allows users to connect their service to an outside streaming platform, like Spotify, so users may see their entire music listening history. I was only able to complete this project because I was a user of last.fm at the start of 2022; I would not have been able to access my listening history otherwise.

Since I had my Spotify streaming history stored within last.fm, all I needed was a way to extract that data. Fortunately, Github user benfoxall has written a Javascript [program](https://github.com/benfoxall/lastfm-to-csv) that allows users to extract their last.fm history as a .csv file, just by typing in your last.fm username. Using Foxall's script, I was able to generate a .csv with my entire last.fm listening history. 

---

#### Data Structure

"Last.fm to csv" generated a .csv file with listening history that extends beyond 2022.

The file had four unnamed fields, which I imported into SQL using the following schema:
- `album` - string; the album upon which a streamed track appeared
- `artist` - string; the artist by whom a streamed track was performed
- `song` - string; the title for which a track is named
- `date_time_str` - string; format - “07 Nov 2020 21:44”; the datetime data for which a particular stream instance occured

---

#### Data Cleaning
