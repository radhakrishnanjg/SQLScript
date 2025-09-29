USE [1SPI]
GO
drop proc if exists SPI.usp_FileUpload_Search
go 
Create proc  SPI.usp_FileUpload_Search
@SearchBy varchar(50)='',
@Search varchar(100)='' ,
@StartDate varchar(10)='' ,
@EndDate varchar(10)='' 
As
Begin 
	SELECT TOP 100 f.FileID ,[FileType], 
	FilePath,Remarks,isnull(f.UploadedBy,'') UploadedBy ,
	UploadedDate UploadedDate,
	FileUploadStatus         
	from  SPI.FileUpload as f  with(NOLOCK)  
	where 1=1 
	and ((@SearchBy ='ByFileType' and f.FileType LIKE '%' + isnull(@Search,'') + '%'    ) 
	OR (@SearchBy ='ByFilePath' and f.FilePath LIKE '%' +  isnull(@Search,'')  + '%'  )
	OR (@SearchBy ='ByUploadedDate' and convert(date,f.UploadedDate,23) between convert(date,@StartDate,23) and convert(date,@EndDate,23) )
	) 
	order by FileID Desc 
	for json path
End