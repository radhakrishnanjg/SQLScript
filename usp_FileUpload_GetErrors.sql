USE [1SPI]
GO
drop proc if exists SPI.usp_FileUpload_GetErrors
go 
create proc SPI.usp_FileUpload_GetErrors
@FileID bigint
as 
Begin
	
	select RowNum,RejectedReason from SPI.FileUploadError 
	where 1=1
	order by RowNum
	for json path
End
go