USE [1SPI]
GO
drop proc if exists SPI.usp_FileUploadError_Save
go 
Create proc  SPI.usp_FileUploadError_Save 
@FileID bigint, 
@RowNum int, 
@RejectedReason varchar(4000) 
As
Begin 
	Insert into SPI.FileUploadError(FileID,RowNum,RejectedReason)
	select @FileID FileID,@RowNum RowNum,@RejectedReason RejectedReason
	 
	Update SPI.FileUpload set
	FileUploadStatus ='Rejected'
	where FileID= @FileID

End
GO