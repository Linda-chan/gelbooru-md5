Option Explicit

'====================================================================
Public Function DetectCommandLine(ByRef lpFileName, ByRef lpMD5, _
                                  ByRef lpWritePnF, ByRef lpRC)
  DetectCommandLine = False
  
  lpRC = ReturnCode_InvalidArguments
  
  Select Case WScript.Arguments.Count
    Case 1
      lpWritePnF = ""
      lpFileName = WScript.Arguments(0)
    Case 2
      lpWritePnF = WScript.Arguments(0)
      lpFileName = WScript.Arguments(1)
    Case Else
      ShowUsage
      Exit Function
  End Select
  
  lpMD5 = GetMD5FromFileName(lpFileName)
  If lpMD5 = "" Then 
    lpRC = ReturnCode_InvalidHash
    Exit Function
  End If
  
  lpWritePnF = Trim(lpWritePnF)
  lpWritePnF = UCase(lpWritePnF)
  
  Select Case lpWritePnF
    Case "/WRITEPNF"
      lpWritePnF = True
    Case ""
      lpWritePnF = False
    Case Else
      ShowUsage
      Exit Function
  End Select
  
  lpRC = ReturnCode_Success ' На всякий случай...
  DetectCommandLine = True
End Function

'====================================================================
Private Sub ShowUsage()
  WScript.Echo AppTitle
  WScript.Echo AppCopyright
  WScript.Echo
  WScript.Echo "Использование: " & WScript.ScriptName & " [/WritePnF] FileName"
End Sub
