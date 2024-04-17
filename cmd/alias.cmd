@echo off

@echo Temporary aliases at cmd startup
@echo 	from https://stackoverflow.com/questions/20530996/aliases-in-windows-command-prompt
:: 1. Run regedit and go to HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Command Processor
:: 2. Add String Value entry with the name AutoRun and the full path of your .bat/.cmd file.
:: 	For example, %USERPROFILE%\alias.cmd, replacing the initial segment of the path with 
::  	%USERPROFILE% is useful for syncing among multiple machines.
:: 		set PATH=%PATH%;"%SYSTEMROOT%\System32\WindowsPowerShell\v1.0\"
@echo Save the following 2 lines to a file called add-aliases.reg to add String Value entry
@echo for this file.
@echo	[HKEY_CURRENT_USER\Software\Microsoft\Command Processor]
@echo	"AutoRun"="%USERPROFILE%\\alias.cmd"

:: Add to path by command

:: DOSKEY add_python26=set PATH=%PATH%;"C:\Python26\"
:: DOSKEY add_python33=set PATH=%PATH%;"C:\Python33\"

:: Commands

DOSKEY ls=dir /B $*
:: DOSKEY sublime=sublime_text $*  
    :: sublime_text.exe is name of the executable. By adding a temporary entry to system path, we don't have to write the whole directory anymore.
:: DOSKEY gsp="C:\Program Files (x86)\Sketchpad5\GSP505en.exe"
:: DOSKEY alias=notepad %USERPROFILE%\Dropbox\alias.cmd
DOSKEY rgc="C:\dev\tools\ripgrep-14.1.0-x86_64-pc-windows-gnu\rg.exe $*"

:: Common directories

DOSKEY dropbox=cd "%USERPROFILE%\Dropbox\$*"
:: DOSKEY research=cd %USERPROFILE%\Dropbox\Research\