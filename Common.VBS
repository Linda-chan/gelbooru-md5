Option Explicit

'====================================================================
Public Function GetMD5FromFileName(ByVal FileName)
  Dim TMP
  Dim RE
  Dim MC
  
  GetMD5FromFileName = ""
  
  TMP = InStrRev(FileName, "\")
  If TMP > 0 Then _
    FileName = Mid(FileName, TMP + 1)
  
  FileName = Trim(FileName)
  
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
