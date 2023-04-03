## Extracting and Merging Data Using Python

### The second element of this exploratory data analysis was to add additional music metadata to my 2022 listening dataset, using a metadata API in Python.

Once I extracted and cleaned the dataset of my basic listening history in SQL, I needed a way to augment my data with further music metadata. I needed this additional track information (like song genre and duration) so I could perform a truly rich analysis of my 2022 listening; otherwise, my analysis would be rather flat.

To gather additional metadata, I used the website [MusicBrainz](https://musicbrainz.org/), an "open music encyclopedia that collects music metadata and makes it available to the public." While individual track metadata can be searched directly on the MusicBrainz website, I needed to develop a tool that would allow me to generate meta data _en masse_, for each and every song I streamed. To do this, I used Python in conjunction with the library [musicbrainzngs](https://python-musicbrainzngs.readthedocs.io/en/v0.7.1/), a tool which allows Python users to connect with the MusicBrainz database via the MusicBrainz API.

->

⭐️ The code I used to extract and merge music metadata can be found [here](https://github.com/eseylar/PortfolioProjects/blob/main/2022MusicWrapped/2_PythonDataMerging/2022_Music_Wrapped_Data_Merging.ipynb) on my GitHub repository.

Note: I am not uploading the .csv file of my entire listening history here in order to maintain some privacy.
