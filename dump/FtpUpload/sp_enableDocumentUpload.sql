DROP PROCEDURE IF EXISTS dbo.sp_EnableDocumentUpload

CREATE PROCEDURE dbo.sp_EnableDocumentUpload AS
RECONFIGURE WITH OVERRIDE
GO
sp_configure 'xp_cmdshell', 1
GO
sp_configure 'Ole Automation Procedures', 1;  
GO
RECONFIGURE WITH OVERRIDE
GO
