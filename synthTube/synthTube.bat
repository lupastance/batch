@ECHO off
CLS

SET url=%1%
SET main=youtube-dl.exe
SET encoder=SynthTube by Lupa Stance
SET format=mp3

CD bin

ECHO /// Getting title

FOR /F "tokens=* USEBACKQ" %%F IN (`%main% -q -e %url%`) DO (
  SET title=%%F
)

ECHO /// Getting uploader

FOR /F "tokens=* USEBACKQ" %%F IN (`%main% -j %url% ^| python.exe -c "import sys, json; print(json.load(sys.stdin)['uploader'])"`) DO (
  SET uploader=%%F
)

ECHO /// Getting video description ^& thumbnail

%main% -x --write-description --write-thumbnail %url%
REN "%title%-%url%.jpg" "cover.jpg"

FOR /F "delims=" %%a IN ('dir /b *.description') DO (
  SET "filename=%%a"
)

:: Filtering list song's list
findstr "[0-9]:[0-9] "  "%filename%" > songs.txt

FOR /F "tokens=* USEBACKQ" %%F IN (`type songs.txt ^| find /C /V ""`) DO (
  SET nsongs=%%F
)

CLS

ECHO.
ECHO # SONGS: %nsongs%
ECHO # ALBUM: %title%
ECHO # UPLOADER: %uploader%

MKDIR "%title%"
CALL DEL "%title%-%url%.description"
CALL DIR /B "%title%-%url%.*" > ofile.txt

FOR /F "delims=" %%a IN ('type ofile.txt') DO (
  SET ofile=%%a
)

SET i=1
SET x=2

setlocal EnableDelayedExpansion

FOR /F %%a in (songs.txt) do (
  SET elem[!i!]=%%a
  SET /A i+=1
)

FOR /L %%b in (1,1,%nsongs%) do (
  SET ini=!elem[%%b]!
  SET end=%%elem[!x!]%%
  SET output="%title%\%title%_%%b.%format%"
  SET metadata=-metadata album="%title%" -metadata album_artist="Various Artists" -metadata artist="%uploader%" -metadata comment="%encoder%" -metadata track="%%b/%nsongs%" -metadata author_url="https://www.youtube.com/watch?v=%url%"

  ECHO.
  ECHO CONVERTING Track %%b/%nsongs%

  IF %%b LSS %nsongs% (    
    CALL ECHO from !ini! to !end!
    CALL ffmpeg -hide_banner -loglevel panic -i "%ofile%" -ss !ini! -to !end! !metadata! -c:a libmp3lame -b:a 256k -id3v2_version 3 -write_id3v1 1 !output!

    ECHO.
    ECHO --------^| Track %%b converted ^|--------
    
  ) ELSE (
    CALL ECHO from !ini! until the end
    CALL ffmpeg -hide_banner -loglevel panic -i "%ofile%" -ss !ini! !metadata! -c:a libmp3lame -b:a 256k -id3v2_version 3 -write_id3v1 1 !output!
    
    ECHO.
    ECHO --------^| Track %%b converted ^|--------
    
    :: Delte downloaded audio file
    CALL DEL "%ofile%"
  )
  
  SET /A x+=1
)

endlocal

MOVE "cover.jpg" "%title%" > NUL
DEL *.txt
MOVE "%title%" ..\ > NUL

CD..