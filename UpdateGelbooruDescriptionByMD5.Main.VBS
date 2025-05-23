'====================================================================
' AJPapps - Update Gelbooru description by MD5
' 
' Линда Кайе 2016-2025. Посвящается Ариэль
'====================================================================
' 
' Этот скрипт принимает имя файла картинки, извлекает из него MD5, 
' запрашивает по нему адрес картинки на сервере Gelbooru и, если 
' получает его, записывает в Descript.ion. Обычно значение MD5 
' записывается в имя самого файла, когда сохраняется с сайта 
' Gelbooru.
' 
' Пример принимаемых имён файлов:
' 
' • cb7a783a25bd39cd939c77a89a32795c.jpg
' • sample-0cde69471c10ff6745b6cd1d91c44bc8.jpg
' • gelbooru_7b2067704dcaf21f6ed379b51d6ab996_nice_picture_111.jpg
' • Q:\Pictures\Hentai\7b2067704dcaf21f6ed379b51d6ab996.jpg
' 
' Сам файл может не существовать - Descript.ion будет обновлён 
' в любом случае.
' 
' Внимание! Программа использует библиотеку HRHT, которую можно 
'           скачать в Library Batch Installer тут:
' 
' https://www.lindachan.net/programs/redist.htm
' 
' История изменений
' -----------------
' 
' • 22.03.2016
'   Первая версия ^^
' 
' • 12.04.2016
'   [-] Скрипт определял URL картинки, но всё равно возвращал URL 
'       с MD5, который использовал для получения адреса картинки.
' 
' • 4.12.2016
'   [-] Убрала не определённую переменную в SaveDataToFile().
'   [-] Если в имени файла был пробел (на самом деле так быть 
'       не должно), то в Descript.ion оно не заключалось в кавычки.
' 
' • 15.01.2018
'   [+] Обновила модуль CharToOem.VBS.
'   [-] Скрипт не определял, когда картинка не находилась по MD5 - 
'       это было связано с тем, что URL конструировался с протоколом 
'       HTTP, а Gelbooru с некоторых пор форсирует HTTPS.
' 
' • 17.02.2018
'   [+] Новый алгоритм определения MD5 в переданной строке. Теперь 
'       принимаются самые разные имена файлов, а не только те, что 
'       содержали только MD5 или "sample-" и MD5. При этом MD5 строк 
'       не должно быть больше одной.
' 
' • 30.09.2018
'   [+] Обновила модуль CharToOem.VBS.
'   [+] Немного подправила код сохранения Descript.ion. Там не было 
'       ошибок, просто на будущее, если буду добавлять поддержку 
'       UTF-8 в Descript.ion.
' 
' • 2.02.2019
'   [+] Оставила один юзерагент, чтобы сервер не напрягся от того, 
'       что с одного айпишника десять броузеров ходят.
' 
' • 24.06.2019
'   [-] Вместо URL на шота картинки получался URL на главную. Судя 
'       по всему, теперь Gelbooru не показывает шотакон и всё такое 
'       без авторизации.
' 
' • 5.04.2020
'   [+] Спецверсия скрипта для сайта rule34.xxx. Делает то же самое.
' 
' • 16.03.2021
'   [-] Обновился адрес главной Gelbooru, на который перекидывает, 
'       если картинка не найдена, в результате чего скрипт думал, 
'       что получил валидный URL.
' 
' • 28.03.2021
'   [-] В HTTP запросах неправильно устанавливался юзерагент.
' 
' • 19.04.2022
'   [+] Переделан парсинг параметров командной строки.
'   [+] Обновлён юзерагент.
'   [+] При ошибке установления связи с сервером, текст и номер 
'       ошибки выводятся.
'   [+] Новый параметр "/WritePnF", который командует скрипту 
'       вписать специальное значение вместо URL, если картинка 
'       не будет найдена на сервере. Это чтобы специальные скрипты 
'       одни и те же картинки, которых нет на сервере, не дёргали. 
'       И записывается это значение только, если к серверу 
'       подключиться удалось, он вернул 200, но не вернул прямую 
'       ссылку на картинку.
' 
' • 11.12.2022
'   [+] Обновился юзерагент.
'   [+] Скрипт теперь возвращает код результата выполнения 
'       в ERRORLEVEL. Список кодов - в константах ReturnCode_*.
'   [+] Добавлен файл UpdateAllDescriptionByMD5.BAT, который ищет
'       URL картинки на обоих сервисах.
'   [-] В конце описания ошибки WinHTTP зачем-то возвращает CRLF. 
'       Убираем его.
' 
' • 13.05.2025
'   [-] Функция GetCharset() в модуле CharToOem.VBS была капитально 
'       поломана и возвращала только значения по умолчанию.
' 
' • 14.05.2025
'   [+] Теперь вместо WinHTTP используется библиотека HRHT.
' 
' Маленький копирайт
' ------------------
' 
' 1. Программа и исходный код распространяются бесплатно.
' 2. Вы имеете право распространять их на тех же условиях.
' 3. Вы не имеете права использовать имя автора после модификации 
'    исходного кода.
' 4. При этом желательно указывать ссылку на автора оригинальной 
'    версии исходного кода.
' 5. Вы не имеете права на платное распространение исходного кода, 
'    а также программных модулей, содержащих данный исходный код.
' 6. Программа и исходный код распространяются как есть. Автор 
'    не несёт ответственности за любые трагедии или несчастные 
'    случаи, вызванные использованием программы и исходного кода.
' 7. Для любого пункта данного соглашения может быть сделано 
'    исключение с разрешения автора программы.
' 8. По любым вопросам, связанным с данной программой, обращайтесь 
'    по адресу lindaoneesama@gmail.com
' 
' Контакты
' --------
' 
' Почта: lindaoneesama@gmail.com
' Сайт:  https://www.lindachan.net
'====================================================================
Option Explicit

Const AppTitle = "AJPapps - Update Gelbooru description by MD5"
Const AppCopyright = "Линда Кайе 2016-2025. Посвящается Ариэль"

Const reeSuccess = 0
Const reeURLNotSpecified = 1
Const reeCookieFileWriteError = 2
Const reeOptionalDataFileWriteError = 3
Const reeCantRunWGet = 4
Const reeLogFileReadError = 5
Const reeWGetReturnsError = 6
Const reeResultFileReadError = 7
Const reeCookieFileReadError = 8
Const reeCancelled = 98
Const reeUnknownError = 99

Const atSystem = 0
Const atDirect = 1
Const atProxy = 2

Const ForReading = 1
Const ForWriting = 2
Const ForAppending = 8

Const ReturnCode_Success = 0
Const ReturnCode_InvalidArguments = 1
Const ReturnCode_InvalidHash = 2
Const ReturnCode_ActiveXError = 3
Const ReturnCode_RequestSendingError = 4
Const ReturnCode_ServerReturnsError = 5
Const ReturnCode_PictureNotFound = 6
Const ReturnCode_ErrorWritingDescription = 7

Dim UserAgent
Dim FSO

'====================================================================
Public Function Main()
  Dim FileName
  Dim MD5
  Dim WritePnF
  Dim URL
  Dim RC
  
  If Not DetectCommandLine(FileName, MD5, WritePnF, RC) Then
    Main = RC
    Exit Function
  End If
  
  ' Заранее получаем юзерагент, чтобы он не менялся при запросах...
  UserAgent = GetUserAgent()
  
  URL = GetPicturePageURL(MD5, WritePnF, RC)
  If URL = "" Then
    Main = RC
    Exit Function
  End If
  
  If UpdateDescriptionFile(FileName, URL) Then
    ' Тут может вернуться PnF или Success, так что передаём то, что 
    ' вернулось ранее...
    Main = RC
  Else
    Main = ReturnCode_ErrorWritingDescription
  End If
End Function

'====================================================================
Private Function GetPicturePageURL(ByVal MD5, ByVal WritePnF, ByRef lpRC)
  Dim TXT
  Dim URL
  
  GetPicturePageURL = ""
  
  TXT = MakeServiceURL(MD5)
  URL = GetPicturePageURL2(TXT, WritePnF, lpRC)
  
  GetPicturePageURL = URL
End Function

'====================================================================
Private Function GetPicturePageURL2(ByVal URL, ByVal WritePnF, ByRef lpRC)
  Dim HTR 'As New ajpHTTPRequestHT
  Dim Query
  Dim NewURL
  
  On Error Resume Next
  
  GetPicturePageURL2 = ""
  
  Set HTR = CreateObject("HRHT0100.ajpHTTPRequestHT")
  If Err.Number <> 0 Then
    WScript.Echo "Не удаётся создать объект ajpHTTPRequestHT."
    lpRC = ReturnCode_ActiveXError
    Exit Function
  End If
  
  Set HTR.ProxySettings = CreateObject("HRHT0100.ProxySettings")
  HTR.ProxySettings.AccessType = atSystem
  
  HTR.URL = URL
  HTR.HTTPVerb = "HEAD"
  HTR.NoCookies = True
  HTR.UserAgent = UserAgent
  HTR.Timeout = 300 * 1000
  HTR.NoRedirects = True
  
  HTR.Execute
  
  ' Это всё не нужно, потому что отмены у нас не будет в любом 
  ' случае, а 302 – это ошибка в терминах WGet. Так что проверяем 
  ' только заголовки Location...
  'If HTR.LastRC = reeCancelled Then Exit Function
  'If HTR.LastRC <> reeSuccess Then
  
  ' Debug!
  'MsgBox HTR.LocationHeaders.Count
  'MsgBox HTR.LocationHeaders(HTR.LocationHeaders.Count)
  'MsgBox HTR.OutputLog
  'WScript.Quit
  
  If HTR.LocationHeaders.Count = 0 Then
    WScript.Echo "Ошибка отправки HTTP запроса. " & _
                 "Заголовок Location не найден."
    lpRC = ReturnCode_RequestSendingError
    Exit Function
  End If
  
  ' Этот статус теперь не возвращается, поскольку мы не можем 
  ' узнать, это сервер сломался или нет...
  'lpRC = ReturnCode_ServerReturnsError
  
  ' Компрексная проверка. Смотрим, чтобы заголовок присутствовал, 
  ' переадресация была не на список и не на тот же URL, с которого 
  ' начали... Если что-то из этого не выполняется – идём в конец, 
  ' где – сообщение об ошибке.
  Query = HTR.LocationHeaders(HTR.LocationHeaders.Count)
  If Query <> "" Then
    If Query <> "index.php?page=post&s=list" Then
      If Query <> "/index.php?page=post&s=list" Then
        If Query <> "index.php?page=post&s=list&tags=all" Then
          If Query <> "/index.php?page=post&s=list&tags=all" Then
                NewURL = MakeServiceURL2(Query)
            If NewURL <> URL Then
              lpRC = ReturnCode_Success
              GetPicturePageURL2 = NewURL
              Exit Function
            End If
          End If
        End If
      End If
    End If
  End If
  
  WScript.Echo "Картинка не найдена на " & SERVICE_NAME & ", либо произошла какая ошибка."
  lpRC = ReturnCode_PictureNotFound
  
  ' Это чтобы по пятьдесят раз несуществующую картинку скрипт поиска 
  ' непомеченных картинок не дёргал.
  If WritePnF Then _
    GetPicturePageURL2 = "*PnF*"
End Function

'====================================================================
Private Function MyHex(ByVal Num)
  Dim TXT
  
  TXT = Hex(Num)
  If Len(TXT) < 8 Then _
    TXT = String(8 - Len(TXT), "0") & TXT
  
  MyHex = "0x" & TXT
End Function

'====================================================================
Private Function TrimCRLF(ByVal Text)
  Do While Left(Text, 1) = vbCr Or Left(Text, 1) = vbLf
    Text = Mid(Text, 2)
  Loop
  
  Do While Right(Text, 1) = vbCr Or Right(Text, 1) = vbLf
    Text = Left(Text, Len(Text) - 1)
  Loop
  
  TrimCRLF = Text
End Function

'====================================================================
Private Function GetUserAgent()
  GetUserAgent = "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:107.0) Gecko/20100101 Firefox/107.0"
End Function

'====================================================================
Private Function UpdateDescriptionFile(ByVal FileName, ByVal URL)
  Dim TXT
  Dim IonFileName
  
  UpdateDescriptionFile = False
  
  On Error Resume Next
  
  Set FSO = CreateObject("Scripting.FileSystemObject")
  If Err.Number <> 0 Then
    WScript.Echo "Не удаётся создать объект File System Object."
    Exit Function
  End If
  
  TXT = FSO.GetFileName(FileName)
  If InStr(TXT, " ") <> 0 Then TXT = """" & TXT & """"
  TXT = TXT & " " & URL & vbCrLf
  
  If Not SaveDataToFile(FileName, "Descript.ion", _
                        TXT, True, IonFileName) Then Exit Function
  
  ' Тут уже не важно, ошибка или нет...
  HideFile IonFileName
  UpdateDescriptionFile = True
End Function

'====================================================================
' Дозаписывает данные в файл.
' 
' OriginalFileName - имя файла (полное или относительное), рядом 
'                    с которым должен лежать новый файл. От него 
'                    берётся путь.
' NewFileName      - имя файла без каталога, с которым нужно 
'                    сохранить данные. К этому имени дописывается 
'                    путь из предыдущего параметра.
' DataToSave       - данные.
' OEMMode          - рудимент. Сохранять ли данные в OEM кодировке 
'                    или в UTF-8. Если файл существует, то его 
'                    кодировка не проверяется.
' lpNewFileName    - имя файла, в который в итоге попали данные. 
'                    Возвращается наружу.
'====================================================================
Private Function SaveDataToFile(ByVal OriginalFileName, _
                                ByVal NewFileName, _
                                ByVal DataToSave, _
                                ByVal OEMMode, _
                                ByRef lpNewFileName)
  Dim Stream
  
  SaveDataToFile = False
  NewFileName = FSO.BuildPath(FSO.GetParentFolderName(OriginalFileName), NewFileName)
  
  On Error Resume Next
  
  ' Запанее перекодируем...
  If OEMMode Then
    DataToSave = CharToOem(DataToSave)
  Else
    DataToSave = CharToUtf8(DataToSave)
  End If

  ' Не надо. Будем считать, что в конце Descript.ion всегда 
  ' пустая строка...
  '' Гарантируем пустую строку в начале, если файл уже существует. 
  '' Мало ли, вдруг там в конце нет переноса. Если же файл 
  '' не существует, то гарантируем BOM...
  ''If FSO.FileExists(NewFileName) Then
  ''  DataToSave = vbCrLf & DataToSave
  ''Else
  ''  If Not OEMMode Then _
  ''    DataToSave = UTF8_BOM & DataToSave
  ''End If
  
  Set Stream = FSO.OpenTextFile(NewFileName, ForAppending, True, False)
  If Err.Number <> 0 Then
    WScript.Echo "Не удалось записать файл: " & NewFileName
    WScript.Echo "Ошибка " & Err.Number & ": " & Err.Description
    Exit Function
  End If
  
  Stream.Write DataToSave
  If Err.Number <> 0 Then
    WScript.Echo "Не удалось записать файл: " & NewFileName
    WScript.Echo "Ошибка " & Err.Number & ": " & Err.Description
    Exit Function
  End If
  
  WScript.Echo "Файл был обновлён: " & NewFileName
  
  lpNewFileName = NewFileName
  SaveDataToFile = True
End Function

'====================================================================
Private Function HideFile(ByVal FileName)
  Dim File
  
  HideFile = False
  
  On Error Resume Next
  
  Set File = FSO.GetFile(FileName)
  If Err.Number <> 0 Then
    WScript.Echo "Не удалось сделать скрытым файл: " & FileName
    WScript.Echo "Ошибка " & Err.Number & ": " & Err.Description
    Exit Function
  End If
  
  File.Attributes = 2
  If Err.Number <> 0 Then
    WScript.Echo "Не удалось сделать скрытым файл: " & FileName
    WScript.Echo "Ошибка " & Err.Number & ": " & Err.Description
    Exit Function
  End If
  
  HideFile = True
End Function
