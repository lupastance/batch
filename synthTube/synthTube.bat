:: ZXfBHCbG2o8
:: with special characters fzK79PgKITI

@ECHO off
CLS

SET url=%1%
SET main=youtube-dl.exe

IF [%2%]==[] (
  SET format=mp3
  ECHO No output format specified, setting it to %format%
) ELSE (
  SET format=%2%
  ECHO Output format selected: %format%
)

CD bin

ECHO // Getting title
%main% -q -e %url% > title.txt

FOR /F "tokens=* USEBACKQ" %%F IN (`%main% -q -e %url%`) DO (
  SET title=%%F
)

ECHO // Getting video description ^& thumbnail
%main% -x --write-description --write-thumbnail %url%
REN "%title%-%url%.jpg" "cover.jpg"


FOR /F "delims=" %%a IN ('dir /b *.description') DO (
  SET "filename=%%a"
)

findstr "[0-9]:[0-9] "  "%filename%" > songs.txt
REM (FOR /F %%A In (songs.txt) Do @SET "_=%%A"&CALL ECHO ^%%_:~-5^%%) > times.txt

FOR /F "tokens=* USEBACKQ" %%F IN (`type songs.txt ^| find /C /V ""`) DO (
  SET nsongs=%%F
)

CLS

ECHO.
ECHO # SONGS: %nsongs%
ECHO # ALBUM: %title%

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

  ECHO.
  ECHO CONVERTING Track %%b/%nsongs%

  IF %%b LSS %nsongs% (    
    CALL ECHO from !ini! to !end!
    REM CALL ffmpeg -i "%ofile%" -i cover.jpg -map 0 -map 1 -ss !ini! -to !end! !output!
    CALL ffmpeg -hide_banner -loglevel panic -i "%ofile%" -ss !ini! -to !end! !output!

    ECHO.
    ECHO --------^| Track %%b converted ^|--------
    
  ) ELSE (
    CALL ECHO from !ini! until the end
    CALL ffmpeg -hide_banner -loglevel panic -i "%ofile%" -ss !ini! !output!
    
    ECHO.
    ECHO --------^| Track %%b converted ^|--------
    
    :: Borrar el archivo bajado
    CALL DEL "%ofile%"
  )
  
  SET /A x+=1
)

endlocal

MOVE "cover.jpg" "%title%" > NUL
DEL *.txt
MOVE "%title%" ..\ > NUL

CD..