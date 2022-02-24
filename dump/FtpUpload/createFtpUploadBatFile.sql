declare @Path varchar(max)
declare @FileContents varchar(max)
SELECT @FileContents = '@echo off' + CHAR(13) +
'net use Y: \\lsfs01\LegalSuite\lsw /PERSISTENT:YES' + CHAR(13) +
'echo user liveupdate> ftpcmd.dat' + CHAR(13) +
'echo legalsuite>> ftpcmd.dat' + CHAR(13) +
'echo bin>> ftpcmd.dat' + CHAR(13) +
'echo cd clientdocs>> ftpcmd.dat' + CHAR(13) +
'echo mkdir %2>> ftpcmd.dat' + CHAR(13) +
'echo cd %2>> ftpcmd.dat' + CHAR(13) +
'echo mkdir %3>> ftpcmd.dat' + CHAR(13) +
'echo cd %3>> ftpcmd.dat' + CHAR(13) +
'echo put "%~1">> ftpcmd.dat' + CHAR(13) +
'echo quit>> ftpcmd.dat' + CHAR(13) +
'ftp -n -s:ftpcmd.dat legalsuite.co.za' + CHAR(13) +
'del ftpcmd.dat'
SELECT @Path = LEFT(physical_name, (LEN(physical_name)-(charindex('\', reverse(physical_name)))))
FROM sys.master_files where DataBase_ID = DB_ID() and data_space_id=1
execute spWriteStringToFile @FileContents, @Path,'ftpupload.bat'