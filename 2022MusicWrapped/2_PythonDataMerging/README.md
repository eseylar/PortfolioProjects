## Extracting and Merging Data Using Python

### The second element of this exploratory data analysis was to add additional music metadata to my 2022 listening dataset, using a metadata API in Python.

Once I extracted and cleaned the dataset of my basic listening history in SQL, I needed a way to augment my data with further music metadata. I needed this additional track information (like song genre and duration) so I could perform a truly rich analysis of my 2022 listening; otherwise, my analysis would be rather flat.

To gather additional metadata, I used the website [MusicBrainz](https://musicbrainz.org/), an "open music encyclopedia that collects music metadata and makes it available to the public." While individual track metadata can be searched directly on the MusicBrainz website, I needed to develop a tool that would allow me to generate metadata _en masse_, for each and every song I streamed. To do this, I used Python in conjunction with the library [musicbrainzngs](https://python-musicbrainzngs.readthedocs.io/en/v0.7.1/), a tool which allows Python users to connect with the MusicBrainz database via the MusicBrainz API.

Working within Google's "Colaboratory" Jupyter Notebook environment, I set course to generate my code. All my code is commented inline, but I will outline the function of my code here, as well.

After installing the necessary libraries (Pandas, JSON, time, NumPy, and MusicBrainzNGS), I wrote code to contact MusicBrainz's API. Next, I imported the .csv file of my basic listening history, which I cleaned in the [previous step](https://github.com/eseylar/PortfolioProjects/blob/main/2022MusicWrapped/1_SQLDataCleaning) of my project. Then, I began crafting the code to import and merge music metadata. I start by creating empty lists for the new information to be added to my dataframe -- genre data, track duration, and artist and track IDs (primary keys from the MusicBrainz database). Next is the loop that runs for each row in the dataframe. 

The basic structure of my code loop is as follows. For each row in the dataframe, run the following code:
- Set the variables 'artist', 'song', and 'album' to the artist, song, and album found on that row of the dataframe.
- Search for the artist in MusicBrainz and select the most compatible option.
- Extract the artist_id from the artist profile.
- Search for the song using track title, artist, and album and select the most compatible option.
- Extract the track duration from the song profile.
- Extract the track's song_id from the song profile.
- Extract all the artist's genre tags from the artist profile.
- Add all the extracted information to temp lists.
- Wait .02 seconds to avoid API error.
- Rinse and repeat for the next dataframe row.

Once this loop has been run for every row, the code takes all those lists of extracted information and writes them into new columns on the dataframe. By the end, the code has generated two dataframe -- one with all the track information inline (artist, song, album, stream datetime, track duration, track genre, etc.), and the other with song_id and genre tag information. Since each song has a variable number of genre tags, I generated this genre table to optimize my data for a relational database.

A major limitation of the MusicBrainz API is speed -- MusicBrainz itself is relatively slow to procure database information, and it further throttles the database to prevent DDoS attacks (max of 50 queries per second). As a result, it takes a long time to generate metadata for all 8491 song instances; I estimate it would take over 9 hours if everything ran smoothly. Due to limitations in Google Colab's IDE (12 hours maximum of continued runtime) and fear of code error forcing me to restart the entire extraction process, I chose to break my listening history dataframe into chunks of 1000 rows at a time. I executed the code on those 1000 rows, then extracted the generated .csv files. After successfully executing my code for all dataframe rows, I concatenated all the smaller dataframes into one large dataframe. The code for truncating and concatenating dataframes can be found, with comments, within my code. 

⭐️ The code I used to extract and merge music metadata can be found [here](https://github.com/eseylar/PortfolioProjects/blob/main/2022MusicWrapped/2_PythonDataMerging/2022_Music_Wrapped_Data_Merging.ipynb) on my GitHub repository. The code is commented to increase readability.

Note: I am not uploading the .csv file of my entire listening history here in order to maintain privacy.
