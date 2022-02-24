@echo off
REM ***************************************************
REM Batch file to upload files to LegalSuite FTP server
REM Date: 19 Dec 2021
REM Author: Rick Jordan
REM Prameters:
REM ftpupload "{Full path and name of file to upload}" {Company Code} {MatterId}
REM Example:
REM ftpupload "Y:\MERGED\BRA1-0028\BRA10028POC 3793830.DOC" ACME01 71017
REM ftpupload "Y:\MERGED\BRAN01\LegalSuite issues.docx" ACME01 BRAN01
REM See https://www.howtogeek.com/howto/windows/how-to-automate-ftp-uploads-from-the-windows-command-line/
REM net use Y: \\lsfs01\LegalSuite\lsw /PERSISTENT:YES
REM SELECT physical_name FROM sys. master_files where physical_name like '%legalsuite.mdf'
REM ***************************************************
net use Y: \\lsfs01\LegalSuite\lsw /PERSISTENT:YES
echo user liveupdate> ftpcmd.dat
echo legalsuite>> ftpcmd.dat
echo bin>> ftpcmd.dat
echo cd clientdocs>> ftpcmd.dat
echo mkdir %2>> ftpcmd.dat
echo cd %2>> ftpcmd.dat
echo mkdir %3>> ftpcmd.dat
echo cd %3>> ftpcmd.dat
echo put "%~1">> ftpcmd.dat
echo quit>> ftpcmd.dat
ftp -n -s:ftpcmd.dat legalsuite.co.za
del ftpcmd.dat