-- **********************************************************
-- Run this to enable Ole Automation (if not done previously)
-- **********************************************************
sp_configure 'show advanced options', 1;  
GO  
RECONFIGURE;  
GO  
sp_configure 'Ole Automation Procedures', 1;  
GO  
RECONFIGURE;  
GO  

-- ******************************************************
-- Run this to enable xp_cmdshell (if not done previously)
-- ******************************************************
USE master
GO
EXEC sp_configure 'show advanced options', 1
GO
RECONFIGURE WITH OVERRIDE
GO
EXEC sp_configure 'xp_cmdshell', 1
GO
RECONFIGURE WITH OVERRIDE
GO



-- example
EXEC master..xp_cmdshell 'dir *.bat'  

-- Check the path
EXEC master..xp_cmdshell 'SET PATH = %PATH%;C:\lsw'
EXEC master..xp_cmdshell 'set path'

-- to see which user will run the file
EXEC master..xp_cmdshell 'whoami'

EXEC master..xp_cmdshell 'ftpupload.bat "c:\test\test.doc" ACME01 55555'


Path=C:\Windows\system32;C:\Windows;C:\Windows\System32\Wbem;C:\Windows\System32\WindowsPowerShell\v1.0\;C:\Program Files (x86)\Microsoft SQL Server\140\Tools\Binn\;C:\Program Files\Microsoft SQL Server\140\Tools\Binn\;C:\Program Files (x86)\Microsoft SQL
 Server\140\DTS\Binn\;C:\Program Files\Microsoft SQL Server\140\DTS\Binn\;C:\Program Files\Microsoft SQL Server\Client SDK\ODBC\130\Tools\Binn\;C:\Program Files (x86)\Microsoft SQL Server\Client SDK\ODBC\130\Tools\Binn\;C:\Program Files (x86)\Microsoft SQ