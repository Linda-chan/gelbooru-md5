Option Explicit

Const SERVICE_NAME = "Rule34"

'====================================================================
Public Function MakeServiceURL(ByVal MD5)
  MakeServiceURL = "https://rule34.xxx/index.php?page=post&s=list&md5=" & MD5
End Function

'====================================================================
Public Function MakeServiceURL2(ByVal Query)
  If Left(Query, 1) <> "/" Then Query = "/" & Query
  MakeServiceURL2 = "https://rule34.xxx" & Query
End Function
