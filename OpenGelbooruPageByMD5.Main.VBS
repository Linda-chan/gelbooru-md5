'====================================================================
' AJPapps - Open Gelbooru page by MD5
' 
' Линда Кайе 2015-2022. Посвящается Ариэль
'====================================================================
' 
' Этот скрипт принимает MD5 хэш картинки и в броузере по умолчанию 
' открывает страницу с ней на Gelbooru. MD5 должен быть передан 
' в текстовом виде - скрипт не умеет его вычислять. Обычно это 
' значение записывается в имя самого файла, когда сохраняется 
' с сайта Gelbooru (или другого совместимого). Скрипт умеет 
' вычленять MD5 из имени файла, содержащего дополнительные данные.
' 
' Пример принимаемых данных:
' 
' • 4c9e60604233fe06330713ef0db087b1
' • cb7a783a25bd39cd939c77a89a32795c.jpg
' • sample-0cde69471c10ff6745b6cd1d91c44bc8.jpg
' • gelbooru_7b2067704dcaf21f6ed379b51d6ab996_nice_picture_111.jpg
' • Q:\Pictures\Hentai\7b2067704dcaf21f6ed379b51d6ab996.jpg
' 
' Из всех этих значений вычисляется сам MD5, с ним формируется URL, 
' который и передаётся броузеру.
' 
' История изменений
' -----------------
' 
' • 7.12.2015
'   Первая версия ^^
' 
' • 22.03.2016
'   [+] Скрипт портирован в WSF формат.
' 
' • 15.01.2018
'   [-] URL конструируется теперь с протоколом HTTPS.
' 
' • 17.02.2018
'   [+] Новый алгоритм определения MD5 в переданной строке. Теперь 
'       принимаются самые разные имена файлов, а не только те, что 
'       содержали только MD5 или "sample-" и MD5. При этом MD5 строк 
'       не должно быть больше одной.
' 
' • 5.04.2020
'   [+] Спецверсия скрипта для сайта rule34.xxx. Делает то же самое.
' 
' • 19.04.2022
'   [+] Переделан парсинг параметров командной строки.
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

Const AppTitle = "AJPapps - Open Gelbooru page by MD5"
Const AppCopyright = "Линда Кайе 2015-2022. Посвящается Ариэль"

'====================================================================
Public Sub Main()
  Dim MD5
  
  If Not DetectCommandLine(MD5) Then Exit Sub
  
  MakeAndOpenURL MD5
End Sub

'====================================================================
Private Sub MakeAndOpenURL(ByVal MD5)
  Dim WShell
  
  ' Debug...
  'MsgBox MakeServiceURL(MD5), vbInformation, AppTitle
  
  Set WShell = CreateObject("WScript.Shell")
  WShell.Run """" & MakeServiceURL(MD5) & """", 10, False
End Sub
