:: ZXfBHCbG2o8
:: with special characters fzK79PgKITI

@ECHO off
CLS

SET url=%1%
SET main=youtube-dl.exe

CD bin

ECHO // Getting title
%main% -e %url% > title.txt

FOR /F "tokens=* USEBACKQ" %%F IN (`%main% -e %url%`) DO (
  SET title=%%F
)

ECHO // Getting video description
%main% -x --write-description %url%
for /f "delims=" %%a in ('dir /b *.description') do set "filename=%%a"

findstr "[0-9]:[0-9] "  "%filename%" > songs.txt
REM (FOR /F %%A In (songs.txt) Do @SET "_=%%A"&CALL ECHO ^%%_:~-5^%%) > times.txt

DEL "%filename%"

FOR /F "tokens=* USEBACKQ" %%F IN (`type songs.txt ^| find /C /V ""`) DO (
  SET nsongs=%%F
)

ECHO.
ECHO SONGS: %nsongs%
ECHO.

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
  SET output="%title%\%title%_%%b.mp3"

  ECHO STARTING Track %%b at !ini!

  IF %%b LSS %nsongs% (    
    MKDIR "%title%"
    CALL ECHO ENDING Track %%b at !end!
    CALL ffmpeg -i "%title%-%url%.m4a" -ss !ini! -to !end! !output!
    
  ) ELSE (
    CALL ECHO Until the end
    CALL ffmpeg -i "%title%-%url%.m4a" -ss !ini! !output!
  )
  
  SET /A x+=1
)

endlocal

CD..