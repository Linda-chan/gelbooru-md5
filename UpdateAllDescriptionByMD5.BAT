@SETLOCAL

@IF "%~1"=="" (
  ECHO Использование: %~0 [/WritePnF] FileName
  GOTO :EOF
)

@IF "%~2"=="" (
  SET ARG_WRITE_PNF=
  SET ARG_FILE_NAME=%1
) ELSE (
  SET ARG_WRITE_PNF=/WritePnF
  SET ARG_FILE_NAME=%2
)

@CScript.EXE //NoLogo "%~dp0\UpdateGelbooruDescriptionByMD5.WSF" %ARG_FILE_NAME%
@IF "%ERRORLEVEL%"=="6" (
  CScript.EXE //NoLogo "%~dp0\UpdateRule34DescriptionByMD5.WSF" %ARG_WRITE_PNF% %ARG_FILE_NAME%
)
