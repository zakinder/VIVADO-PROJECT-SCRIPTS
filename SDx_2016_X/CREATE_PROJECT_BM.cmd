@echo off
REM BATCH MODE PROJECT
REM SET VARIABLE
REM PROJECT NAME
set /p VPROJECTFOLDER=Project Name :
setlocal enableextensions disabledelayedexpansion
REM SET THE NAME KEY WORD : worldcup
set "VAR_SEARCH=worldcup"
set "VAR_UPDATE_VALUE=%VPROJECTFOLDER%"
REM 2ND REPLACEMENT
set "SECONDSEARCH=NULL_SEARCH"
set "SET_SECOND_SEARCH=%SET_SECOND_SEARCH_VALUE%"
REM MASTER TCL SOURCE
set "THE_M_FILE=scripts/master_settings.tcl"
REM PROJECT TCL SOURCE
set "UPDATE_THE_FILE=scripts/settings.tcl"
(for /f "delims=" %%i in (%THE_M_FILE%) do (
    set "line=%%i"
    setlocal enabledelayedexpansion
    set "line=!line:%VAR_SEARCH%=%VAR_UPDATE_VALUE%!"
	set "line=!line:%SECONDSEARCH%=%SET_SECOND_SEARCH%!"
    echo(!line!
    endlocal
))>"%UPDATE_THE_FILE%"
REM VIVADO VERSION
set /p Version=Vivado Version 2016.? :
setlocal enableextensions disabledelayedexpansion
REM SET THE NAME KEY WORD : umd
set "VAR_SEARCH=umd"
set "VAR_UPDATE_VALUE=%Version%"
REM SET THE NAME KEY WORD : atm
set "SECONDSEARCH=atm"
set "SECOND_SEARCH_ITEM=2016"
set "THE_M_FILE=M_SET.cmd"
set "UPDATE_THE_FILE=S_SET.cmd"
(for /f "delims=" %%i in (%THE_M_FILE%) do (
    set "line=%%i"
    setlocal enabledelayedexpansion
    set "line=!line:%VAR_SEARCH%=%VAR_UPDATE_VALUE%!"
	set "line=!line:%SECONDSEARCH%=%SECOND_SEARCH_ITEM%!"
    echo(!line!
    endlocal
))>"%UPDATE_THE_FILE%"
setlocal
REM PROJECT DIRECTORY
@set batchfile_name=%~n0
@set batchfile_drive=%~d0
@set batchfile_path=%~dp0
@%batchfile_drive%
@cd %batchfile_path%
@echo -- RUN DESIGN WITH: %batchfile_name%
@echo -- USE DESIGN PATH: %batchfile_path%
@call %mylocalpath%S_SET.cmd
@echo -- SET XILINX ENVIRONMENT VARIABLES
@set VIVADO_XSETTINGS=%XILDIR%\%VIVADO_VERSION%\Vivado\.settings64-Vivado.bat
REM @set SDK_XSETTINGS=%XILDIR%\%VIVADO_VERSION%\SDK\.settings64-Software_Development_Kit.bat
@set LABTOOL_XSETTINGS=%XILDIR%\Vivado_Lab\%VIVADO_VERSION%\settings64.bat
REM ENABLE SDSOC
@if not defined ENABLE_SDSOC (
  @set ENABLE_SDSOC=0
)
@if %ENABLE_SDSOC%==1 (
  @echo --Info: SDSOC Settings overwrite SDK Settings --
  @set SDSOC_XSETTINGS=%XILDIR%\SDSoC\%VIVADO_VERSION%\settings64.bat
)
@if not defined VIVADO_AVAILABLE (
  @set VIVADO_AVAILABLE=0
)
@if not defined SDK_AVAILABLE (
  @set SDK_AVAILABLE=0
)
@if not defined LABTOOL_AVAILABLE (
  @set LABTOOL_AVAILABLE=0
)
@if not defined SDSOC_AVAILABLE (
  @set SDSOC_AVAILABLE=0
)
@echo -- Use Xilinx Version: %VIVADO_VERSION% --
@if not defined VIVADO_XSETTINGS_ISDONE ( @echo --Info: Configure Xilinx Vivado Settings --
  @if not exist %VIVADO_XSETTINGS% ( @echo -- Info: %VIVADO_XSETTINGS% not found --
  ) else (
    @call %VIVADO_XSETTINGS%
    @set VIVADO_AVAILABLE=1
  )
  @set VIVADO_XSETTINGS_ISDONE=1
)
@if not defined SDK_XSETTINGS_ISDONE ( @echo --Info: Configure Xilinx SDK Settings --
  @if not exist %SDK_XSETTINGS% ( @echo -- Info: %SDK_XSETTINGS% not found --
  ) else (
    @call %SDK_XSETTINGS%
    @set SDK_AVAILABLE=1
  )
  @set SDK_XSETTINGS_ISDONE=1
)
@if not defined LABTOOL_XSETTINGS_ISDONE ( @echo --Info: Configure Xilinx LabTools Settings --
  @if not exist %LABTOOL_XSETTINGS% ( @echo -- Info: %LABTOOL_XSETTINGS% not found --
  ) else (
    @call %LABTOOL_XSETTINGS%
    @set LABTOOL_AVAILABLE=1
  )
  @set LABTOOL_XSETTINGS_ISDONE=1
)
@if not defined SDSOC_XSETTINGS_ISDONE ( @echo --Info: Configure Xilinx SDSoC Settings --
  @if not exist %SDSOC_XSETTINGS% ( @echo -- Info: %SDSOC_XSETTINGS% not found --
  ) else (
    @call %SDSOC_XSETTINGS%
    @set SDSOC_AVAILABLE=1
  )
  @set SDSOC_XSETTINGS_ISDONE=1
)
@echo ----
@if %VIVADO_AVAILABLE%==1 (
  @goto  RUN
)
@echo -- Error: Need Vivado to run. --
@goto  ERROR
:RUN
@echo ----check old project exists----
@set vivado_p_folder=%batchfile_path%vivado/"%VAR_UPDATE_VALUE%"
@if exist %vivado_p_folder% ( @echo Found old vivado project: Create project will delete old project!
  @goto  before_uinput
)  
@goto  after_uinput
:before_uinput
set /p creatProject="Are you sure to continue? (y/N):"
@echo User Input: "%creatProject%"
if not "%creatProject%"=="y" (GOTO EOF)
:after_uinput
@echo Start create project..."
@echo ----Change to log folder----
@set vlog_folder=%batchfile_path%v_log
@echo %vlog_folder%
@if not exist %vlog_folder% ( @mkdir %vlog_folder% )   
@cd %vlog_folder%
@echo ----
@echo -Start VIVADO scripts ----
call vivado -source ../scripts/main.tcl  -mode batch -notrace -tclargs --run 1 --gui 0 --clean 2 --boardpart %PARTNUMBER%
@echo -scripts finished----
@echo ----
@echo ----Change to design folder----
@cd..
@echo Design finished----
@if not defined DO_NOT_CLOSE_SHELL (
  @set DO_NOT_CLOSE_SHELL=0
)
@if %DO_NOT_CLOSE_SHELL%==1 (
  PAUSE
)
GOTO EOF
REM ERROR
:ERROR
@echo -- ERROR OCCURS
PAUSE
:EOF
