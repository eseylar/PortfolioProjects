# 2022 Year in Music (SQL Data Exploration)

## Questions for exploration:

How many songs did I stream, total, in 2022?

How many distinct songs did I listen to?

How many distinct artists did I listen to?

Top played artists, albums, and tracks?

Breakdown listening habits by day of week? Weekday vs weekend?

Breakdown listening habits by hour of the day?

What is the average number of different songs per artist? The max number of different songs per artist?

During which months did I listen to the most music? During which seasons? During which weeks of the year? Which buckets provide the most logical way to analyze?

Which were my top streamed genres?

---

## Data Structure

**full_2022_scrobbles** table

| column | description |
| --- | --- |
| album | The track’s album. |
| artist | The track’s artist. |
| song | The track’s title. |
| date_time_CST | The datetime element of when the track was scrobbled (in the Central Time Zone). |
| date_CST | The date element of when the track was scrobbled (in the Central Time Zone). |
| weekday_num | An integer representation of the day of the week the song was scrobbled (value in the range [1,7] with Sunday=1, Saturday=7, etc). |
| weekday | A string representation of the day of the week the song was scrobbled (e.g. “Sunday”). |
| time_CST | The time element of when the track was scrobbled (in the Central Time Zone). |
| genre | [COLUMN DROPPED] The top-voted track genres from the MusicBrainz database, as a space-separated list. |
| duration | The duration of the track, in seconds. |
| artist_id | The artist id for each track’s artist, as listed in the MusicBrainz database.  |
| song_id | The song id for each track, as listed in the MusicBrainz database.  |

**genres** table

| column | description |
| --- | --- |
| song_id | The song id for each track, as listed in the MusicBrainz database.  |
| genre | The top-voted genres for each track, as listed in the MusicBrainz database.  |

---

## SQL Queries and Results

### Table Joins (for reference)

```sql
/* JOINing 'genre' and 'full_2022_scrobbles' tables, for later reference */

SELECT
  * EXCEPT (song_id)
FROM
  `adept-turbine-353215.wrapped_22.full_2022_scrobbles` AS f
LEFT JOIN
  `adept-turbine-353215.wrapped_22.genres` AS g
ON
  f.song_id = g.song_id
ORDER BY
  date_time_CST
```

---

### Artist, Album, and Track Top Listens (by stream count and by time spent listening)

```sql
/* What songs did I stream the most number of times? */

SELECT
  DISTINCT (song) AS track
  , artist
  , COUNT (song) AS num_listens
FROM
  `adept-turbine-353215.wrapped_22.full_2022_scrobbles`
GROUP BY
  song
  , artist
ORDER BY
  num_listens DESC
LIMIT
  100
```

(First 25 rows of data)

| Row | track | artist | num_listens |
| --- | --- | --- | --- |
| 1 | It's Called: Freefall | Rainbow Kitten Surprise | 50 |
| 2 | Goodnight Chicago | Rainbow Kitten Surprise | 49 |
| 3 | Our Song | Rainbow Kitten Surprise | 46 |
| 4 | Kyoto | Phoebe Bridgers | 46 |
| 5 | Graceland Too | Phoebe Bridgers | 42 |
| 6 | Motion Sickness | Phoebe Bridgers | 42 |
| 7 | No Children | The Mountain Goats | 40 |
| 8 | HOT WIND BLOWS (feat. Lil Wayne) | Tyler the Creator | 40 |
| 9 | I Know the End | Phoebe Bridgers | 40 |
| 10 | Something Good | alt-J | 38 |
| 11 | Float On | Modest Mouse | 38 |
| 12 | Silk Chiffon | MUNA | 37 |
| 13 | Holland 1945 | Neutral Milk Hotel | 36 |
| 14 | Stick Season | Noah Kahan | 35 |
| 15 | All the Debts I Owe | Caamp | 35 |
| 16 | Ms | alt-J | 35 |
| 17 | Johnny Boy's Bones | Colter Wall | 34 |
| 18 | Dissolve Me | alt-J | 33 |
| 19 | Heat Above | Greta Van Fleet | 31 |
| 20 | In the Aeroplane Over the Sea | Neutral Milk Hotel | 30 |
| 21 | Garden Song | Phoebe Bridgers | 30 |
| 22 | Night Shift | Lucy Dacus | 30 |
| 23 | Homesick | Noah Kahan | 29 |
| 24 | First Class - Live from Athens Georgia | Rainbow Kitten Surprise | 29 |
| 25 | Vagabond | Caamp | 29 |

```sql
/* What artists did I stream the most number of times? */

SELECT
  DISTINCT (artist) AS artist
  , COUNT (artist) AS num_listens
FROM
  `adept-turbine-353215.wrapped_22.full_2022_scrobbles`
GROUP BY
  artist
ORDER BY
  num_listens DESC
LIMIT
  100
```

(First 25 rows of results)

| Row | artist | num_listens |
| --- | --- | --- |
| 1 | Rainbow Kitten Surprise | 444 |
| 2 | Phoebe Bridgers | 320 |
| 3 | Sufjan Stevens | 294 |
| 4 | alt-J | 242 |
| 5 | Craig Duncan | 184 |
| 6 | Vampire Weekend | 173 |
| 7 | Noah Kahan | 154 |
| 8 | Taylor Swift | 134 |
| 9 | Tyler the Creator | 130 |
| 10 | Yung Gravy | 119 |
| 11 | Neutral Milk Hotel | 105 |
| 12 | Caamp | 97 |
| 13 | Kanye West | 94 |
| 14 | Tyler Childers | 83 |
| 15 | Frank Ocean | 71 |
| 16 | The Mountain Goats | 67 |
| 17 | Fleet Foxes | 66 |
| 18 | Harry Styles | 66 |
| 19 | Glass Animals | 58 |
| 20 | MUNA | 57 |
| 21 | The Lumineers | 56 |
| 22 | Lord Huron | 56 |
| 23 | Colter Wall | 56 |
| 24 | Lana Del Rey | 56 |
| 25 | Kenny Rogers | 56 |

```sql
/* What songs did I stream for the most amount of time? */

SELECT
  song
  , artist
  , COUNT (song) AS num_listens
  , ROUND ( (SUM (duration) / (60)), 2 ) AS min_listened
  , ROUND ( (SUM (duration) / (60*60)), 2 ) AS hrs_listened
FROM
  `adept-turbine-353215.wrapped_22.full_2022_scrobbles`
GROUP BY
  song, artist
ORDER BY
  hrs_listened DESC
LIMIT
  100
```

(First 25 rows)

|  Row  |   song |   artist |   num_listens |   min_listened |   hrs_listened |
| --- | --- | --- | --- | --- | --- |
| 1 | First Class - Live from Athens Georgia | Rainbow Kitten Surprise | 29 | 394.9 | 6.58 |
| 2 | Chateau Lobby #4 (in C for Two Virgins) | Father John Misty | 18 | 341.93 | 5.7 |
| 3 | Cocaine Jesus - Live from Athens Georgia | Rainbow Kitten Surprise | 24 | 300.66 | 5.01 |
| 4 | Night Shift | Lucy Dacus | 30 | 195.91 | 3.27 |
| 5 | Goodnight Chicago | Rainbow Kitten Surprise | 49 | 189.39 | 3.16 |
| 6 | Graceland Too | Phoebe Bridgers | 42 | 165.2 | 2.75 |
| 7 | Motion Sickness | Phoebe Bridgers | 42 | 162.3 | 2.71 |
| 8 | Heat Above | Greta Van Fleet | 31 | 160.65 | 2.68 |
| 9 | I Know the End | Phoebe Bridgers | 40 | 144.48 | 2.41 |
| 10 | Dissolve Me | alt-J | 33 | 141.39 | 2.36 |
| 11 | Kyoto | Phoebe Bridgers | 46 | 141.47 | 2.36 |
| 12 | Ms | alt-J | 35 | 139.4 | 2.32 |
| 13 | Float On | Modest Mouse | 38 | 134.11 | 2.24 |
| 14 | First Class | Rainbow Kitten Surprise | 23 | 131.48 | 2.19 |
| 15 | It's Called: Freefall | Rainbow Kitten Surprise | 50 | 126.94 | 2.12 |
| 16 | Silk Chiffon | MUNA | 37 | 127.39 | 2.12 |
| 17 | Vegas (From the Original Motion Picture Soundtrack ELVIS) | Doja Cat | 22 | 123.57 | 2.06 |
| 18 | Kilby Girl | The Backseat Lovers | 26 | 121.52 | 2.03 |
| 19 | HOT WIND BLOWS (feat. Lil Wayne) | Tyler the Creator | 40 | 113.98 | 1.9 |
| 20 | All the Debts I Owe | Caamp | 35 | 112.58 | 1.88 |
| 21 | Atlantic City | The Band | 21 | 110.83 | 1.85 |
| 22 | Garden Song | Phoebe Bridgers | 30 | 110.0 | 1.83 |
| 23 | Northern Attitude | Noah Kahan | 24 | 106.9 | 1.78 |
| 24 | Stick Season | Noah Kahan | 35 | 106.37 | 1.77 |
| 25 | Johnny Boy's Bones | Colter Wall | 34 | 99.73 | 1.66 |

```sql
/* What artists did I stream for the most amount of time? */

SELECT
  artist
  , COUNT (artist) AS num_listens
  , ROUND ( (SUM (duration) / (60)), 2 ) AS min_listened
  , ROUND ( (SUM (duration) / (60*60)), 2 ) AS hrs_listened
FROM
  `adept-turbine-353215.wrapped_22.full_2022_scrobbles`
GROUP BY
  artist
ORDER BY
  hrs_listened DESC
LIMIT
  100
```

(First 25 rows)

| Row | artist | num_listens | min_listened | hrs_listened |
| --- | --- | --- | --- | --- |
| 1 | Rainbow Kitten Surprise | 444 | 2259.77 | 37.66 |
| 2 | Phoebe Bridgers | 320 | 1180.23 | 19.67 |
| 3 | Sufjan Stevens | 294 | 887.33 | 14.79 |
| 4 | alt-J | 242 | 701.1 | 11.68 |
| 5 | Craig Duncan | 184 | 593.99 | 9.9 |
| 6 | Vampire Weekend | 173 | 589.67 | 9.83 |
| 7 | Noah Kahan | 154 | 574.84 | 9.58 |
| 8 | Taylor Swift | 134 | 507.32 | 8.46 |
| 9 | Tyler the Creator | 130 | 381.33 | 6.36 |
| 10 | Father John Misty | 21 | 354.16 | 5.9 |
| 11 | Yung Gravy | 119 | 325.51 | 5.43 |
| 12 | Kanye West | 94 | 308.96 | 5.15 |
| 13 | Frank Ocean | 71 | 304.05 | 5.07 |
| 14 | Caamp | 97 | 292.12 | 4.87 |
| 15 | Tyler Childers | 83 | 290.26 | 4.84 |
| 16 | Lucy Dacus | 50 | 273.2 | 4.55 |
| 17 | Kenny Rogers | 56 | 265.34 | 4.42 |
| 18 | Neutral Milk Hotel | 105 | 258.34 | 4.31 |
| 19 | Lana Del Rey | 56 | 248.69 | 4.14 |
| 20 | Fleet Foxes | 66 | 239.15 | 3.99 |
| 21 | Lord Huron | 56 | 231.2 | 3.85 |
| 22 | Glass Animals | 58 | 226.52 | 3.78 |
| 23 | Harry Styles | 66 | 216.36 | 3.61 |
| 24 | Hozier | 41 | 199.68 | 3.33 |
| 25 | Adele | 51 | 192.55 | 3.21 |

Artists like Craig Duncan and Kenny Rogers, whom I only listen to around Christmastime (read: after Spotify stops cataloging my streams), populate my top 25 artists. Similarly, Sufjan Stevens, whose Christmas albums I streamed a lot in 2022, made it to my 3rd most streamed artist; I listen to his other work quite a bit, but his Christmas music was in particularly heavy rotation in 2022.

```sql
/* From which albums did I stream the most tracks? */

SELECT
  album
  , artist
  , COUNT (*) AS num_tracks_streamed
FROM
  `adept-turbine-353215.wrapped_22.full_2022_scrobbles`
GROUP BY
  album, artist
ORDER BY
  num_tracks_streamed DESC
LIMIT 100
```

(First 25 rows)

|  Row  |   album |   artist |   num_tracks_streamed |
| --- | --- | --- | --- |
|  1  | Punisher | Phoebe Bridgers | 201 |
|  2  | An Awesome Wave | alt-J | 175 |
|  3  | Silver & Gold | Sufjan Stevens | 126 |
|  4  | Stick Season | Noah Kahan | 118 |
|  5  | RKS! Live From Athens Georgia | Rainbow Kitten Surprise | 107 |
|  6  | In the Aeroplane Over the Sea | Neutral Milk Hotel | 101 |
|  7  | RKS | Rainbow Kitten Surprise | 101 |
|  8  | Songs For Christmas | Sufjan Stevens | 97 |
|  9  | Vampire Weekend | Vampire Weekend | 92 |
|  10  | How To: Friend Love Freefall | Rainbow Kitten Surprise | 91 |
|  11  | Irish Christmas | Craig Duncan | 78 |
|  12  | Seven + Mary | Rainbow Kitten Surprise | 75 |
|  13  | Stranger in the Alps | Phoebe Bridgers | 70 |
|  14  | Caamp | Caamp | 66 |
|  15  | CALL ME IF YOU GET LOST | Tyler the Creator | 66 |
|  16  | The Gift | Kenny Rogers | 56 |
|  17  | Imaginary Appalachia | Colter Wall | 50 |
|  18  | Flower Boy | Tyler the Creator | 49 |
|  19  | Purgatory | Tyler Childers | 47 |
|  20  | Cleopatra | The Lumineers | 46 |
|  21  | Our Song | Rainbow Kitten Surprise | 46 |
|  22  | Blonde | Frank Ocean | 45 |
|  23  | Long Time Coming | Sierra Ferrell | 42 |
|  24  | Tallahassee | The Mountain Goats | 40 |
|  25  | Fleet Foxes | Fleet Foxes | 40 |

---

### Stream Counts

```sql
/* How many streams, total, did I log in 2022? */

SELECT
  COUNT (*) AS num_streams
FROM
  `adept-turbine-353215.wrapped_22.full_2022_scrobbles`
```

|   num_streams |
| --- |
| 8491 |

```sql
/* How many distint songs did I stream in 2022? */

SELECT
  COUNT ( DISTINCT (song_id) ) AS num_distinct_songs
FROM
  `adept-turbine-353215.wrapped_22.full_2022_scrobbles`
```

|   num_distinct_songs |
| --- |
| 3341 |

```sql
/* How many distint artists did I stream in 2022? */

SELECT
  COUNT ( DISTINCT (artist_id) ) AS num_distinct_artists
FROM
  `adept-turbine-353215.wrapped_22.full_2022_scrobbles`
```

|   num_distinct_artists |
| --- |
| 1259 |

```sql
/* How much time did I spend listening to music in 2022? */

WITH cte AS
(SELECT
  COALESCE (duration, avg(duration) over () )  as dur_sec --using COALESCE to replace NULL values with the average track duration
FROM
  `adept-turbine-353215.wrapped_22.full_2022_scrobbles`
)

SELECT
  ROUND (SUM (cte.dur_sec), 2) AS seconds_listening
  , ROUND (SUM (cte.dur_sec) / 60, 2) AS minutes_listening
  , ROUND (SUM (cte.dur_sec) / (60*60), 2) AS hours_listening
  , ROUND (SUM (cte.dur_sec) / (60*60*24), 2) AS days_listening
FROM
  cte
```

|   seconds_listening |   minutes_listening |   hours_listening |   days_listening |
| --- | --- | --- | --- |
| 1943148.15 | 32385.8 | 539.76 | 22.49 |

---

### Track Streams by Artist

```sql
/* For which artists did I listen to the most distinct number of songs? */

SELECT
  artist
  , COUNT ( DISTINCT (song) ) AS num_diff_songs
FROM
  `adept-turbine-353215.wrapped_22.full_2022_scrobbles`
GROUP BY
  artist
ORDER BY
  num_diff_songs DESC
LIMIT
  15
```

|  Row  |   artist |   num_diff_songs |
| --- | --- | --- |
| 1 | Craig Duncan | 100 |
| 2 | Sufjan Stevens | 79 |
| 3 | Rainbow Kitten Surprise | 46 |
| 4 | Phoebe Bridgers | 39 |
| 5 | alt-J | 34 |
| 6 | Taylor Swift | 33 |
| 7 | Vampire Weekend | 29 |
| 8 | Zach Bryan | 29 |
| 9 | The Mountain Goats | 25 |
| 10 | Yung Gravy | 25 |
| 11 | Tyler the Creator | 24 |
| 12 | Harry Styles | 24 |
| 13 | Adele | 23 |
| 14 | Kanye West | 23 |
| 15 | Frank Ocean | 22 |

```sql
/* What is the average number of distinct songs I listened to by an artist? */

WITH cte AS
(
SELECT
  COUNT ( DISTINCT (song) ) AS num_diff_songs
  , artist
FROM
  `adept-turbine-353215.wrapped_22.full_2022_scrobbles`
GROUP BY
  artist
)

SELECT
  ROUND ( AVG (num_diff_songs), 2 ) AS ave_songs_per_artist
FROM 
  cte
```

|   ave_songs_per_artist |
| --- |
| 2.34 |

```sql
/* PERTAINING TO ARTISTS FOR WHOM I'VE LISTENED TO MORE THAN 1 SONG, what is the average number of distinct songs I listened to by an artist? */

WITH cte AS
(
SELECT
  COUNT ( DISTINCT (song) ) AS num_diff_songs
  , artist
FROM
  `adept-turbine-353215.wrapped_22.full_2022_scrobbles`
GROUP BY
  artist
)

SELECT
  ROUND ( AVG (num_diff_songs), 2 ) AS ave_songs_per_artist_over_1
FROM 
  cte
WHERE
  cte.num_diff_songs > 1
```

|   ave_songs_per_artist_over_1 |
| --- |
| 5.49 |

---

### Breakdown Listening by Time (day of week, hour of day, month of year, etc.)

```sql
/* On which days of the week did I listen to the most music? */

SELECT
  weekday
  , COUNT (*) AS num_streams_per_day
  , ROUND (100 * (COUNT (*) / (SELECT COUNT (*) FROM `adept-turbine-353215.wrapped_22.full_2022_scrobbles`)) , 2) AS pct_streams_per_day 
FROM
  `adept-turbine-353215.wrapped_22.full_2022_scrobbles`
GROUP BY
  weekday
ORDER BY
  num_streams_per_day DESC
```

| Row | weekday | num_streams_per_day | pct_streams_per_day |
| --- | --- | --- | --- |
| 1 | Friday | 1674 | 19.71 |
| 2 | Saturday | 1366 | 16.09 |
| 3 | Thursday | 1265 | 14.9 |
| 4 | Wednesday | 1245 | 14.66 |
| 5 | Monday | 1175 | 13.84 |
| 6 | Tuesday | 941 | 11.08 |
| 7 | Sunday | 825 | 9.72 |

```sql
/* During which hours do I listen to the most music? */

SELECT
  EXTRACT (HOUR FROM date_time_CST) AS hour
  , COUNT (*) AS num_streams_per_hour
  , ROUND (100 * (COUNT (*) / (SELECT COUNT (*) FROM `adept-turbine-353215.wrapped_22.full_2022_scrobbles`)) , 2) AS pct_streams_per_hour 
FROM
  `adept-turbine-353215.wrapped_22.full_2022_scrobbles`
GROUP BY
  hour
ORDER BY
  hour
```

|   hour |   num_streams_per_hour |   pct_streams_per_hour |
| --- | --- | --- |
| 0 | 90 | 1.06 |
| 1 | 31 | 0.37 |
| 2 | 0 | 0 |
| 3 | 1 | 0.01 |
| 4 | 5 | 0.06 |
| 5 | 65 | 0.77 |
| 6 | 366 | 4.31 |
| 7 | 415 | 4.89 |
| 8 | 221 | 2.6 |
| 9 | 377 | 4.44 |
| 10 | 626 | 7.37 |
| 11 | 586 | 6.9 |
| 12 | 453 | 5.34 |
| 13 | 531 | 6.25 |
| 14 | 487 | 5.74 |
| 15 | 608 | 7.16 |
| 16 | 684 | 8.06 |
| 17 | 659 | 7.76 |
| 18 | 577 | 6.8 |
| 19 | 489 | 5.76 |
| 20 | 471 | 5.55 |
| 21 | 341 | 4.02 |
| 22 | 261 | 3.07 |
| 23 | 147 | 1.73 |

```sql
/* During which months do I listen to the most music? */

SELECT
  EXTRACT (MONTH FROM date_time_CST) AS month
  , COUNT (*) AS num_streams_per_month
  , ROUND (100 * (COUNT (*) / (SELECT COUNT (*) FROM `adept-turbine-353215.wrapped_22.full_2022_scrobbles`)) , 2) AS pct_streams_per_month 
FROM
  `adept-turbine-353215.wrapped_22.full_2022_scrobbles`
GROUP BY
  month
ORDER BY
  month
```

|   month |   num_streams_per_month |   pct_streams_per_month |
| --- | --- | --- |
| 1 | 798 | 9.4 |
| 2 | 606 | 7.14 |
| 3 | 782 | 9.21 |
| 4 | 734 | 8.64 |
| 5 | 464 | 5.46 |
| 6 | 992 | 11.68 |
| 7 | 774 | 9.12 |
| 8 | 139 | 1.64 |
| 9 | 364 | 4.29 |
| 10 | 880 | 10.36 |
| 11 | 942 | 11.09 |
| 12 | 1016 | 11.97 |

```sql
/* During which season do I listen to the most music? */

SELECT
  CASE
    WHEN EXTRACT (MONTH FROM date_time_CST) IN (12, 1, 2) THEN "Winter"
    WHEN EXTRACT (MONTH FROM date_time_CST) IN (3, 4, 5) THEN "Spring"
    WHEN EXTRACT (MONTH FROM date_time_CST) IN (6, 7, 8) THEN "Summer"
    WHEN EXTRACT (MONTH FROM date_time_CST) IN (9, 10, 11) THEN "Autumn"
  END AS season
  , COUNT (*) AS num_streams_per_season
  , ROUND (100 * (COUNT (*) / (SELECT COUNT (*) FROM `adept-turbine-353215.wrapped_22.full_2022_scrobbles`)) , 2) AS pct_streams_per_season 
FROM
  `adept-turbine-353215.wrapped_22.full_2022_scrobbles`
GROUP BY
  season
ORDER BY
  num_streams_per_season
```

|   season |   num_streams_per_season |   pct_streams_per_season |
| --- | --- | --- |
| Summer | 1905 | 22.44 |
| Spring | 1980 | 23.32 |
| Autumn | 2186 | 25.74 |
| Winter | 2420 | 28.5 |

```sql
/* Breaking down my number of streams by week of the year */

SELECT
  EXTRACT (WEEK FROM date_time_CST) AS week
  , COUNT (*) AS num_streams_per_week
  , ROUND (100 * (COUNT (*) / (SELECT COUNT (*) FROM `adept-turbine-353215.wrapped_22.full_2022_scrobbles`)) , 2) AS pct_streams_per_week 
FROM
  `adept-turbine-353215.wrapped_22.full_2022_scrobbles`
GROUP BY
  week
ORDER BY
  week
```

| week | num_streams_per_week | pct_streams_per_week |
| --- | --- | --- |
| 0 | 2 | 0.02 |
| 1 | 114 | 1.34 |
| 2 | 263 | 3.1 |
| 3 | 219 | 2.58 |
| 4 | 175 | 2.06 |
| 5 | 119 | 1.4 |
| 6 | 139 | 1.64 |
| 7 | 120 | 1.41 |
| 8 | 189 | 2.23 |
| 9 | 129 | 1.52 |
| 10 | 87 | 1.02 |
| 11 | 317 | 3.73 |
| 12 | 170 | 2 |
| 13 | 200 | 2.36 |
| 14 | 158 | 1.86 |
| 15 | 211 | 2.48 |
| 16 | 137 | 1.61 |
| 17 | 171 | 2.01 |
| 18 | 126 | 1.48 |
| 19 | 32 | 0.38 |
| 20 | 160 | 1.88 |
| 21 | 130 | 1.53 |
| 22 | 182 | 2.14 |
| 23 | 412 | 4.85 |
| 24 | 138 | 1.63 |
| 25 | 168 | 1.98 |
| 26 | 149 | 1.75 |
| 27 | 140 | 1.65 |
| 28 | 181 | 2.13 |
| 29 | 237 | 2.79 |
| 30 | 163 | 1.92 |
| 31 | 79 | 0.93 |
| 32 | 45 | 0.53 |
| 34 | 18 | 0.21 |
| 35 | 11 | 0.13 |
| 36 | 78 | 0.92 |
| 37 | 120 | 1.41 |
| 38 | 114 | 1.34 |
| 39 | 75 | 0.88 |
| 40 | 260 | 3.06 |
| 41 | 373 | 4.39 |
| 42 | 86 | 1.01 |
| 43 | 104 | 1.22 |
| 44 | 131 | 1.54 |
| 45 | 91 | 1.07 |
| 46 | 228 | 2.69 |
| 47 | 298 | 3.51 |
| 48 | 298 | 3.51 |
| 49 | 265 | 3.12 |
| 50 | 361 | 4.25 |
| 51 | 208 | 2.45 |
| 52 | 110 | 1.3 |

---

### Top Genres

```sql
/* Which genres do I listen to the most? */

SELECT
  genre
  , COUNT (genre) AS count_gen
FROM
  `adept-turbine-353215.wrapped_22.genres`
GROUP BY
  genre
ORDER BY
  count_gen DESC
```

(Top 25 genre tags)

|  Row  |   genre |   count_gen |
| --- | --- | --- |
|  1  | indie-rock | 2209 |
|  2  | rock | 1816 |
|  3  | pop | 1708 |
|  4  | alternative-rock | 1359 |
|  5  | indie-pop | 1343 |
|  6  | indie-folk | 1312 |
|  7  | singer/songwriter | 1034 |
|  8  | folk-rock | 1011 |
|  9  | singer-songwriter | 931 |
|  10  | folk | 894 |
|  11  | pop-rock | 893 |
|  12  | hip-hop | 873 |
|  13  | 2010s | 789 |
|  14  | american | 763 |
|  15  | country | 760 |
|  16  | indie | 749 |
|  17  | art-pop | 735 |
|  18  | pop-rap | 643 |
|  19  | chamber-pop | 574 |
|  20  | indietronica | 535 |
|  21  | americana | 438 |
|  22  | blues-rock | 424 |
|  23  | chamber-folk | 395 |
|  24  | folk-pop | 360 |
|  25  | trip-hop | 358 |

```sql
/* How many different genres did I listen to? */

SELECT
  COUNT (DISTINCT (genre)) AS count_gen
FROM
  `adept-turbine-353215.wrapped_22.genres`
```

|   count_gen |
| --- |
| 888 |

It is worth re-iterating three things about this number. First, these are user generated “tags”, and so all do not fall under the umbrella of “genre” in the strictest sense. Though “2010s” and “usa” appear in my genre list, these are more musical categories than genres. Next, these tags are added by lay-people, not by a music service or music label; thus, there is a question of accuracy. Nonetheless, users may up- or down-vote the tags they agree or disagree with; my extraction code only pulls tags that have a positive “score” (read: more people agree than disagree with a tag). This provides some, but not complete, validation for the data. Finally, there is a lot of overlap between genres, both in terms of where the music industry is today, and in terms of modifiers added to a tag. For example, my top two genres are “indie-rock” and “rock”, two genres that certainly have distinctions, but also certainly overlap. And since tracks can have multiple user-generated tags, it is likely that I have listened to many songs that are labeled as both “indie-rock” ****and**** “rock”. 

---

### Top Genres (of only my top artists)

```sql
/* Top genres of my top 50 artists, WEIGHTED BY ARTIST STREAMS (artists that received more streams will have their genres appear more often) */

--cte1: SELECT the artists with the top 50 most number of streams
WITH cte1 AS
(
SELECT
  DISTINCT (artist) AS artist_dist
  , COUNT (artist) AS num_listens
FROM
  `adept-turbine-353215.wrapped_22.full_2022_scrobbles`
GROUP BY
  artist
ORDER BY
  num_listens DESC
LIMIT
  50
),

--cte2: JOINing cte1 and full_2022_scrobbles to SELECT the song_id from tracks by my top 50 artists 
cte2 AS
(
SELECT
  DISTINCT(f.song_id)
  , f.artist
  , f.song
FROM
  cte1
INNER JOIN
  `adept-turbine-353215.wrapped_22.full_2022_scrobbles` AS f
ON
  f.artist = cte1.artist_dist
),

--cte3: generate a list of genres for each song by the artists in my top 50 by JOINing with the genres table
cte3 AS 
(
SELECT
  cte2.song_id
  , cte2.song
  , cte2.artist
  , g.genre
FROM
  cte2
LEFT JOIN
  `adept-turbine-353215.wrapped_22.genres` AS g
ON
  g.song_id = cte2.song_id
GROUP BY
  cte2.song_id
  , cte2.song
  , cte2.artist
  , g.genre
)

--generate a list of distinct genres and the number of times it appears in the list of streamed songs by my top 50 artists
SELECT
  DISTINCT(genre) AS distinct_genre
  , COUNT(*) AS count_genre
FROM
  cte3
GROUP BY
  genre
HAVING
  distinct_genre IS NOT NULL
ORDER BY
  count_genre DESC
```

|  Row  |   distinct_genre |   count_genre |
| --- | --- | --- |
|  1  | indie-rock | 302 |
|  2  | pop | 300 |
|  3  | indie-pop | 259 |
|  4  | indie-folk | 253 |
|  5  | rock | 215 |
|  6  | singer/songwriter | 195 |
|  7  | folk-rock | 195 |
|  8  | 2010s | 176 |
|  9  | chamber-pop | 163 |
|  10  | art-pop | 154 |
|  11  | singer-songwriter | 151 |
|  12  | hip-hop | 144 |
|  13  | alternative-rock | 141 |
|  14  | pop-rap | 133 |
|  15  | chamber-folk | 110 |
|  16  | american | 107 |
|  17  | country | 105 |
|  18  | indie | 102 |
|  19  | indietronica | 93 |
|  20  | soul | 92 |
|  21  | ambient | 91 |
|  22  | new-age | 91 |
|  23  | progressive-electronic | 91 |
|  24  | pop-rock | 90 |
|  25  | 2020s | 85 |
|  26  | r&b | 83 |
|  27  | folk | 79 |
|  28  | blues-rock | 79 |
|  29  | trip-hop | 76 |
|  30  | americana | 73 |

```sql
/* Top genres of my top 50 artists, NOT weighted by number of streams (artists that received more streams will NOT have their genres appear more often) */

--cte1: SELECT the artists with the top 50 most number of streams
WITH cte1 AS
(
SELECT
  DISTINCT (artist) AS artist_dist
  , COUNT (artist) AS num_listens
FROM
  `adept-turbine-353215.wrapped_22.full_2022_scrobbles`
GROUP BY
  artist
ORDER BY
  num_listens DESC
LIMIT
  50
),

--cte2: JOINing cte1 and full_2022_scrobbles to SELECT the song_id from tracks by my top 50 artists 
cte2 AS
(
SELECT
  DISTINCT(f.song_id)
  , f.artist
  , f.song
FROM
  cte1
INNER JOIN
  `adept-turbine-353215.wrapped_22.full_2022_scrobbles` AS f
ON
  f.artist = cte1.artist_dist
),

--cte3: generate a list of genres for each song by the artists in my top 50 by JOINing with the genres table
cte3 AS 
(
SELECT
  cte2.artist
  , g.genre
FROM
  cte2
LEFT JOIN
  `adept-turbine-353215.wrapped_22.genres` AS g
ON
  g.song_id = cte2.song_id
GROUP BY
  cte2.artist
  , g.genre
)

--generate a list of distinct genres and the number of times it appears in the list of streamed songs by my top 50 artists
SELECT
  DISTINCT(genre) AS distinct_genre
  , COUNT(*) AS count_genre
FROM
  cte3
GROUP BY
  genre
HAVING
  distinct_genre IS NOT NULL
ORDER BY
  count_genre DESC
```

|  Row  |   distinct_genre |   count_genre |
| --- | --- | --- |
|  1  | pop | 16 |
|  2  | indie-rock | 15 |
|  3  | rock | 13 |
|  4  | american | 12 |
|  5  | hip-hop | 11 |
|  6  | 2010s | 9 |
|  7  | indie-pop | 9 |
|  8  | alternative-rock | 8 |
|  9  | indie-folk | 8 |
|  10  | indie | 8 |
|  11  | pop-rap | 8 |
|  12  | folk-rock | 8 |
|  13  | pop-rock | 7 |
|  14  | americana | 7 |
|  15  | folk | 6 |
|  16  | singer-songwriter | 6 |
|  17  | r&b | 6 |
|  18  | country | 6 |
|  19  | electronic | 6 |
|  20  | neo-soul | 5 |
|  21  | chamber-pop | 5 |
|  22  | contemporary-r&b | 5 |
|  23  | singer/songwriter | 4 |
|  24  | trap | 4 |
|  25  | 2020s | 4 |
|  26  | art-pop | 4 |
|  27  | blues-rock | 4 |
|  28  | indietronica | 4 |
|  29  | rap | 4 |
|  30  | english | 4 |
|  31  | soul | 4 |
|  32  | chillwave | 3 |
|  33  | late-2000s | 3 |
|  34  | alternative | 3 |
|  35  | country-pop | 3 |
|  36  | hip-hop-soul | 3 |
|  37  | contemporary-country | 3 |
|  38  | trip-hop | 3 |
|  39  | hardcore-hip-hop | 3 |
|  40  | west-coast-hip-hop | 3 |
|  41  | electropop | 3 |
|  42  | usa | 3 |
|  43  | américain | 3 |
|  44  | teen-pop | 3 |
|  45  | bluegrass | 3 |
|  46  | power-pop | 3 |
|  47  | slowcore | 2 |
|  48  | alternative-folk | 2 |
|  49  | us | 2 |
|  50  | icon | 2 |