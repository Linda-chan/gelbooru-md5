Option Explicit

Const SERVICE_NAME = "Gelbooru"

'====================================================================
Public Function MakeServiceURL(ByVal MD5)
  MakeServiceURL = "https://gelbooru.com/index.php?page=post&s=list&md5=" & MD5
End Function

'====================================================================
Public Function MakeServiceURL2(ByVal Query)
  If Left(Query, 1) <> "/" Then Query = "/" & Query
  MakeServiceURL2 = "https://gelbooru.com" & Query
End Function
