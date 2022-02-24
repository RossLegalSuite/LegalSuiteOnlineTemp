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


-- *******************************************
-- Create a simple bat file in the data folder
-- *******************************************

declare @Path varchar(max)
SELECT @Path = LEFT(physical_name, (LEN(physical_name)-(charindex('\', reverse(physical_name))))) FROM sys.master_files where DataBase_ID = DB_ID() and data_space_id=1

declare @FileContents varchar(max)

-- Try a simple command
SET @FileContents = 'echo hello'

execute spWriteStringToFile @FileContents, @Path,'test.bat'

-- ******************************************
-- The Stored Procedure saves the bat file!!
-- Now try and run the bat file using xp_cmdshell
-- ******************************************

declare @BatchFilePath varchar(max)
SELECT @BatchFilePath = LEFT(physical_name, (LEN(physical_name)-(charindex('\', reverse(physical_name))))) FROM sys.master_files where DataBase_ID = DB_ID() and data_space_id=1
declare @Cmd varchar(1000)

-- Note: Because of spaces in the path (C:\Program Files\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQL\DATA)
-- We need to change to the directory using double quotes and then run the bat file
SET @Cmd = 'cd "' + @BatchFilePath + '" && test.bat'

EXEC master..xp_cmdshell @Cmd

-- **********************************************************************************
-- It runs the bat file (because it has Permissions in the data folder!!)
-- But the Operating System executes the bat file, it complains about a character '■e' at the beginning of the batch file
-- I think the Stored Proc is doing something to the file when it saves it???
-- Can you check it out for me because I CANNOT seem to be able to go to C:\Program Files\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQL\DATA
-- to check what is in the test.bat myself for some reason. 
-- These "hidden" paths on different servers are confusing me!!
-- **********************************************************************************

