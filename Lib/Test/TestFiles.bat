@SET PATH=..\Bin;..\..\Bin;%PATH%
@SET OBERON=%CD%;%CD%\..\Sym

@ofront+ -m TestFiles.Mod
@IF errorlevel 1 PAUSE
@CALL gcc.bat TestFiles.c -o TestFiles.exe

@IF EXIST TestFiles.exe TestFiles.exe
@PAUSE
