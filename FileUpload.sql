USE [1SPI]
GO
IF NOT EXISTS(SELECT 1 FROM sys.objects 
where OBJECT_ID=OBJECT_ID('SPI.FileUpload') and type   = (N'U'))
begin
	CREATE TABLE SPI.FileUpload(
	[FileID] [bigint] IDENTITY(1,1) NOT NULL Primary key,
	[FileType] [varchar](50) NULL,  
	[FilePath] [varchar](250) NULL,
	[Remarks] [varchar](1000) NULL,
	[UploadedBy] varchar(20) NULL,
	[UploadedDate] [datetime] NULL,
	[ProcessedDate] [datetime] NULL, 
	[FileUploadStatus] [varchar](20) NULL
	)
End
IF NOT EXISTS(SELECT 1 FROM sys.objects 
where OBJECT_ID=OBJECT_ID('SPI.FileUploadError') and type   = (N'U'))
begin
	CREATE TABLE SPI.FileUploadError(
		[SysID] [bigint] IDENTITY(1,1) NOT NULL,
		[FileID] [bigint] NULL,  
		[RowNum] [int] NULL,
		[RejectedReason] [varchar](4000) NULL,
	)  
end
GO