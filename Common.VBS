Option Explicit

'====================================================================
Public Function DetectCommandLine(ByVal ReturnMD5)
  Dim MD5
  Dim FileName
  
  DetectCommandLine = ""
  
  FileName = DetectCommandLine2(ReturnMD5)
  If FileName = "" Then Exit Function
  
  If ReturnMD5 Then
    MD5 = GetMD5FromFileName(FileName)
    If MD5 = "" Then 
      Exit Function
    Else
      DetectCommandLine = MD5
    End If
  Else
    DetectCommandLine = FileName
  End If
End Function

'====================================================================
Private Function DetectCommandLine2(ByVal ReturnMD5)
  DetectCommandLine2 = ""
  
  If WScript.Arguments.Count <> 1 Then 
    ShowUsage ReturnMD5
    Exit Function
  End If
  
  If Trim(WScript.Arguments(0)) = "/?" Then 
    ShowUsage ReturnMD5
    Exit Function
  End If
  
  DetectCommandLine2 = WScript.Arguments(0)
End Function

'====================================================================
Private Sub ShowUsage(ByVal ReturnMD5)
  WScript.Echo AppTitle
  WScript.Echo AppCopyright
  WScript.Echo ""
  
  If ReturnMD5 Then
    WScript.Echo "Использование: " & WScript.ScriptName & " MD5Hash"
  Else
    WScript.Echo "Использование: " & WScript.ScriptName & " FileName"
  End If
End Sub

'====================================================================
Public Function GetMD5FromFileName(ByVal FileName)
  Dim TMP
  Dim RE
  Dim MC
  
  GetMD5FromFileName = ""
  FileName = Trim(FileName)
  
  TMP = InStrRev(FileName, "\")
  If TMP > 0 Then 
    FileName = Mid(FileName, TMP + 1)
    FileName = Trim(FileName)
  End If
  
  On Error Resume Next
  
  Set RE = New RegExp
  
  RE.Global = True
  RE.IgnoreCase = True
  RE.MultiLine = True
  
  RE.Pattern = "[1234567890abcdef]{32}"
  Set MC = RE.Execute(FileName)
  
  If Err.Number <> 0 Then 
    WScript.Echo "Ошибка вычленения хэша MD5."
    Exit Function
  End if
  
  If MC.Count < 1 Then 
    WScript.Echo "Хэш MD5 не найден."
    Exit Function
  End If
  
  If MC.Count > 1 Then 
    WScript.Echo "Найдено более одного хэша MD5."
    Exit Function
  End If
  
  GetMD5FromFileName = MC(0)
End Function
