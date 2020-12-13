@ECHO off
CLS

setlocal EnableDelayedExpansion

SET url=%1%
SET main=youtube-dl.exe
SET encoder=SynthTube by Lupa Stance
SET format=mp3

CD bin

ECHO /// Getting uploader

FOR /F "tokens=* USEBACKQ" %%F IN (`%main% -j %url% ^| python.exe -c "import sys, json; print(json.load(sys.stdin)['uploader'])"`) DO (
  SET uploader=%%F
)

ECHO /// Getting video description ^& thumbnail

%main% --rm-cache-dir -x --write-description --write-thumbnail %url%

FOR /F "delims=" %%a IN ('dir /b *.description') DO (
  SET "filename=%%a"
)

FOR /f "tokens=1 delims=." %%a IN ("%filename%") do (
  SET title=%%a
)

IF EXIST "!title!.webp" (
  SET cover=!title!.webp
  CALL ffmpeg -loglevel panic -hide_banner -i "!cover!" "cover.jpg"

) ELSE IF EXIST "!title!.png" (
  SET cover=!title!.png
  CALL ffmpeg -loglevel panic -hide_banner -i "!cover!" "cover.jpg"

) ELSE (
  SET cover=!title!.jpg
  CALL ffmpeg -loglevel panic -hide_banner -i "!cover!" "cover.jpg"
)

:: Filtering list song's list
findstr "[0-9]:[0-9] "  "%filename%" > songs.txt

FOR /F "tokens=* USEBACKQ" %%F IN (`type songs.txt ^| find /C /V ""`) DO (
  SET nsongs=%%F
)

CLS

ECHO.
ECHO # SONGS: !nsongs!
ECHO # ALBUM: !title!
ECHO # UPLOADER: !uploader!

MKDIR "!title!"

IF EXIST "!title!.opus" (
  CALL DIR /B "!title!.opus" > ofile.txt
) ELSE (
  CALL DIR /B "!title!.m4a" > ofile.txt
)

FOR /F "delims=" %%a IN ('type ofile.txt') DO (
  SET ofile=%%a
)

SET i=1
SET x=2

FOR /F %%a in (songs.txt) do (
  SET elem[!i!]=%%a
  SET /A i+=1
)

FOR /L %%b in (1,1,!nsongs!) do (
  SET ini=!elem[%%b]!
  SET end=%%elem[!x!]%%

  SET output=!title!\!title!_%%b.%format%
  SET metadata=-metadata album="!title!" -metadata album_artist="Various Artists" -metadata artist="!uploader!" -metadata comment="!encoder!" -metadata track="%%b/!nsongs!" -metadata author_url="https://www.youtube.com/watch?v=!url!"

  ECHO.
  ECHO CONVERTING Track %%b/!nsongs!

  IF %%b EQU 1 (
    MKDIR "..\!uploader!\!title!"
  )

  IF %%b LSS !nsongs! (
    CALL ECHO from !ini! to !end!
    CALL ffmpeg -loglevel panic -hide_banner -i "!ofile!" -ss !ini! -to !end! !metadata! -c:a libmp3lame -b:a 256k -id3v2_version 3 -write_id3v1 1 "!output!"

    ECHO.
    ECHO --------^| Track %%b converted ^|--------
    
  ) ELSE (
    CALL ECHO from !ini! until the end
    CALL ffmpeg -loglevel panic -hide_banner -i "!ofile!" -ss !ini! !metadata! -c:a libmp3lame -b:a 256k -id3v2_version 3 -write_id3v1 1 "!output!"
    
    ECHO.
    ECHO --------^| Track %%b converted ^|--------
  )

  CALL ffmpeg -loglevel panic -hide_banner -i "!output!" -i cover.jpg -map 0 -map 1 -c copy -c:v:1 jpg -disposition:v:1 attached_pic "..\!uploader!\!output!"
  
  SET /A x+=1
)


DEL "!ofile!"
DEL "!title!.*"
DEL *.txt
DEL cover.jpg
RMDIR /Q /S "!title!"

endlocal