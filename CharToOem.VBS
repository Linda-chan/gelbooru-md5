'====================================================================
' Перекодировка с использованием встроенного объекта.
' 
' Найдено тут:
' http://forum.script-coding.com/viewtopic.php?id=1179
' 
' Доработано уже своими силами...
'====================================================================
Option Explicit

Private Const adTypeBinary = 1
Private Const adTypeText = 2

Private Const adModeUnknown = 0
Private Const adModeRead = 1
Private Const adModeWrite = 2
Private Const adModeReadWrite = 3
Private Const adModeShareDenyRead = 4
Private Const adModeShareDenyWrite = 8
Private Const adModeShareExclusive = 12
Private Const adModeShareDenyNone = &H10
Private Const adModeRecursive = &H400000

'====================================================================
' Вместо константы...
'====================================================================
Public Function UTF8_BOM()
  UTF8_BOM = Chr(&HEF) & Chr(&HBB) & Chr(&HBF)
End Function

'====================================================================
Public Function CharToOem(ByVal Text)
  CharToOem = CharTranslate(Text, GetCharsetOEM(), GetCharsetANSI())
End Function

Public Function OemToChar(ByVal Text)
  OemToChar = CharTranslate(Text, GetCharsetANSI(), GetCharsetOEM())
  
  ' Не знаю, что за фигня, но удалить нужно.
  If Left(OemToChar, 2) = ChrW(&H00A0) & ChrW(&H25A0) Then _
    OemToChar = Mid(OemToChar, 3)
End Function

'====================================================================
Public Function CharToUtf8(ByVal Text)
  CharToUtf8 = CharTranslate(Text, "utf-8", GetCharsetANSI())
  
  ' Удаляем UTF-8 сигнатуру, которая на самом деле в данном случае 
  ' не нужна. Если пишем файл, то будем писать её отдельно, там, 
  ' где файл пишется...
  If Left(CharToUtf8, 3) = UTF8_BOM Then _
    CharToUtf8 = Mid(CharToUtf8, 4)
End Function

Public Function Utf8ToChar(ByVal Text)
  ' Удаляем UTF-8 сигнатуру. Она однозначно не нужна!
  If Left(Text, 3) = UTF8_BOM Then _
    Text = Mid(Text, 4)
  
  Utf8ToChar = CharTranslate(Text, GetCharsetANSI(), "utf-8")
End Function

'====================================================================
' Общая функция перекодировки из чего угодно во что угодно.
' 
' Про свойство Charset:
' https://msdn.microsoft.com/ru-ru/library/ms681424%28v=vs.85%29.aspx
'====================================================================
Public Function CharTranslate(ByVal Text, _
                              ByVal PutAsCharset, _
                              ByVal GetAsCharset)
  Dim Stream
  
  Set Stream = CreateObject("ADODB.Stream")
  
  Stream.Type = adTypeText
  Stream.Mode = adModeReadWrite
  Stream.Open
  
  ' Указываем, в какой кодировке мы хотели бы хранить данные, 
  ' и записываем их. Как я понимаю, преобразование случится при 
  ' записи...
  Stream.Charset = PutAsCharset
  Stream.WriteText Text
  
  ' Переходим в начало потока...
  Stream.Position = 0
  
  ' Не совсем понимаю. Видимо, уже имеющиеся данные представляются 
  ' указанными, и мы их в таком формате читаем. Тоесть если указать 
  ' Unicode, то получим строку, где каждый символ содержит два 
  ' символа исходной ANSI строки. А если Windows-1251, то и получим 
  ' ANSI строку без преобразования, как есть.
  ' Если так, то это и объясняет путаницу в параметрах в изначальном 
  ' варианте функции. Я просто неправильно их понимала.
  Stream.Charset = GetAsCharset
  CharTranslate = Stream.ReadText
  
  ' Завершаем...
  Set Stream = Nothing
End Function

'====================================================================
Public Function GetCharsetANSI()
  GetCharsetANSI = GetCharset("windows-1251", "ACP")
  Err.Clear
End Function

Public Function GetCharsetOEM()
  GetCharsetOEM = GetCharset("cp866", "OEMCP")
  Err.Clear
End Function

'Public Function GetCharsetMAC()
'  GetCharsetMAC = GetCharset("mac", "MACCP")
'  Err.Clear
'End Function

'====================================================================
Public Function GetCharset(ByVal DefaultValue, _
                           ByVal CodePageKeyName)
  Dim WShell
  Dim CodePage
  Dim Charset
  
  GetCharset = DefaultValue
  Set WShell = CreateObject("WScript.Shell")
  
  On Error Resume Next
  
  CodePage = WShell.RegRead("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Nls\CodePage\" & CodePageKeyName)
  If Err.Number <> 0 Or CodePage = "" Then
    Err.Clear
    Exit Function
  End If
  
  CodePage = Trim(CodePage)
  'MsgBox "1. " & CodePage
  
  Charset = WShell.RegRead("HKEY_CLASSES_ROOT\Mime\Database\Codepage\" & CodePage & "\WebCharset")
  If Err.Number <> 0 Or Charset = "" Then
    Err.Clear
    Charset = WShell.RegRead("HKEY_CLASSES_ROOT\Mime\Database\Codepage\" & CodePage & "\BodyCharset")
    If Err.Number <> 0 Or Charset = "" Then
      Err.Clear
      Exit Function
    End If
  End If
  
  Charset = Trim(Charset)
  'MsgBox "4. " & Charset
  
  GetCharset = Charset
End Function
