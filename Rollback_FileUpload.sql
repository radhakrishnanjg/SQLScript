USE [1SPI]
GO
IF EXISTS(SELECT 1 FROM sys.objects 
where OBJECT_ID=OBJECT_ID('SPI.FileUpload') and type   = (N'U'))
begin
	DROP TABLE SPI.FileUpload 
End
IF EXISTS(SELECT 1 FROM sys.objects 
where OBJECT_ID=OBJECT_ID('SPI.FileUploadErrorLog') and type   = (N'U'))
begin
	DROP TABLE SPI.FileUploadErrorLog 
end
GO