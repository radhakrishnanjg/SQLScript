USE [1SPI]
GO
drop proc if exists SPI.usp_FileUpload_Insert
go 
Create proc  SPI.usp_FileUpload_Insert 
@FileType varchar(50), 
@FilePath  varchar(250), 
@LoginId varchar(20), 
@Remarks varchar(1000) 
As
Begin 
	declare @FileID bigint
	insert into  SPI.FileUpload (FileType,FilePath,Remarks,
	UploadedBy,UploadedDate,FileUploadStatus)
	select @FileType,@FilePath,@Remarks
	,@LoginId,getdate() , 'New' as FileUploadStatus

	set @FileID = SCOPE_IDENTITY()

	select @FileID as SysId,'File has been uploaded successfully',cast(1 as bit) Flag
End