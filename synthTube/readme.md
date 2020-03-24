<style>
    h1{ border-bottom: none; line-height: 0px; font-weight: 700}
    h4 { line-height: 0px; letter-spacing: 3.7px; font-weight: 100; font-style: italic; }
    hr { margin-bottom: 40px; }
</style>

<!-- --------------------------------------------------- -->

# SynthTube
#### by Lupa Stance

<hr>

With this script you will be able to download a Youtube music video and splitted it in mp3 files depending on the video description.

This idea was born from the need to be able to listen to Synthwave music at any time and from anywhere, especially on car trips.

It is difficult to find this kind of music on Spotify or similar but, Youtube is full of people creating its own playlists with an extensive variety of songs.

For example, if you like a Synthwave video on Youtube like [Horizon (Chillwave - Synthwave - Retrowave Mix)](https://www.youtube.com/watch?v=ZXfBHCbG2o8) and you want it to put all this music in your mobile phone, its easy to convert it with any Youtube converter online, but all the tracks will be one and you will not be able to pass a track.

With ***Synth Tube*** you will be able to split all the tracks into mp3 files at *256kbps* depending on the video description. Using the previous example:

```
00:00 Horizon - Hotel Pools
02:38 Coral Blush - Hello Meteor
08:02 another 80’s synthwave song - rayklin
12:33 SOMEBODY - 80AM
15:51 Flights of Fancy - FRACTAL MAN
19:54 Submerse - Safehouse
22:27 S a l v i a B l i s s  -  M Y D R E A M Y A D V E N T U R E
24:24 Surface Waves - Hello Meteor
29:58 Think of the Future - VentureX
34:10 Nothing Lasts Forever - bl00dwave
37:34 Beyond - Voyage
43:44 View Existent - Poetically
47:50 Imagine - Departure
51:20 Lost in a Sea of Stars - FRACTAL MAN
```

The script will create 14 different tracks in mp3 format.

## Requirements
- Windows 7 or above
- Youtube-dl (included)
- FFmpeg (included)
- Python 2

## Usage

Decompress the .zip files and run **synthTube.bat** with a youtube link.

```
synthTube.bat ZXfBHCbG2o8
```

Please mind, don't use full url format https://www.youtube.com/watch?v=ZXfBHCbG2o8, just the code after "v="

## Future Implementations
- Thumbnail embedded (due to a bug in ffmpeg with splitted files, is not possible to embed the *cover.jpg* file into each mp3 file)

- Filter special character in youtube video descriptions and name