USE [1SPI]
GO
drop proc if exists SPI.usp_FileUpload_Update
go 
Create proc  SPI.usp_FileUpload_Update 
@FileID bigint,
@FileUploadStatus varchar(50)-- New | Rejected | Uploaded
As 
Begin
	Update SPI.FileUpload set
	FileUploadStatus =@FileUploadStatus
	where FileID= @FileID
End