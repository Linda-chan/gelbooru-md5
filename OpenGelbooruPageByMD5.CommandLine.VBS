Option Explicit

'====================================================================
Public Function DetectCommandLine(ByRef lpMD5)
  DetectCommandLine = False
  
  Select Case WScript.Arguments.Count
    Case 1
      lpMD5 = WScript.Arguments(0)
    Case Else
      ShowUsage
      Exit Function
  End Select
  
  lpMD5 = GetMD5FromFileName(lpMD5)
  If lpMD5 = "" Then Exit Function
  
  DetectCommandLine = True
End Function

'====================================================================
Private Sub ShowUsage()
  WScript.Echo AppTitle
  WScript.Echo AppCopyright
  WScript.Echo ""
  WScript.Echo "Использование: " & WScript.ScriptName & " MD5Hash"
End Sub
