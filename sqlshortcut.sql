-- Try and Catch Block with transaction Syntax
Begin Try 
	Begin Tran   

	Commit
end try
begin catch
	if @@TRANCOUNT >0
	begin
		rollback
		select ERROR_MESSAGE()
	end

end catch
--------------------------------------------------------------------------------------------------------------------------------------
-- Store Proc Checking 
IF OBJECT_ID(N'API.GetRefreshToken', N'P') IS NOT NULL
BEGIN
	drop proc API.GetRefreshToken
END
go 
Create proc SPAPI.GetRefreshToken
@CompanyDetailId int 
As 
BEGIN
	
	SET NOCOUNT ON;

	SET NOCOUNT OFF;

END
-------------------------------------------------------------------------------------------------------------------------------------- 
-- Type Checking 
IF TYPE_ID(N'API.Wati_parameters') IS NOT NULL
BEGIN 
	drop type API.Wati_parameters
END

--------------------------------------------------------------------------------------------------------------------------------------
-- Table checking
IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.columns where TABLE_SCHEMA='Amazon' and table_Name = 'IORExpense' )
begin
	drop table Amazon.Amazon
end 
--------------------------------------------------------------------------------------------------------------------------------------
-- Table Creating 
IF NOT EXISTS(SELECT 1 FROM sys.objects where OBJECT_ID=OBJECT_ID('Amazon.TransactionDetails') and type   = (N'U'))
begin
	Create table Amazon.TransactionDetails(
	SysID int identity (1,1) not null,
	C1 varchar(100),
	C2 varchar(100),
	C3 Datetime,
	CreatedBy int,
	CreatedDate datetime)
end 
--------------------------------------------------------------------------------------------------------------------------------------
-- checking values before insert
IF NOT EXISTS(SELECT 1 FROM gstapi.AuthToken where ClientId='A')
begin
	
	insert into  gstapi.AuthToken (CompanyId,ClientId,UserName,AuthToken
	,Sek,TokenExpiry,CreatedDate)
	select 4 CompanyId, 'A' ClientId,'nsdlTest' UserName,'A' AuthToken,
	'A+TKAieHfz1OcH2jFzAVZUUiTl6QwgoG8/ZmsiMDrMiq0YMT81ux' Sek,'2023-07-04 20:14:47' TokenExpiry,getdate() CreatedDate
end
--------------------------------------------------------------------------------------------------------------------------------------
-- Schema checking
IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.columns where TABLE_SCHEMA='Amazon')
begin
	drop table Amazon.InvoiceCourierBillOEntryDetail
end 
--------------------------------------------------------------------------------------------------------------------------------------
-- checking column
IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.columns WHERE 1=1
and TABLE_SCHEMA='Product' and table_Name = 'AmazonProductTaxCode' and COLUMN_NAME='FileID')
begin
	alter table Product.AmazonProductTaxCode
	add FileID Bigint
end
--------------------------------------------------------------------------------------------------------------------------------------
-- checking column to delete 
IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.columns WHERE 1=1
and TABLE_SCHEMA='Product' and table_Name = 'AmazonProductTaxCode' and COLUMN_NAME='FileID')
begin
	alter table Product.AmazonProductTaxCode
	DROP COLUMN FileID  
end
--------------------------------------------------------------------------------------------------------------------------------------
-- Checking Primary Key 
IF NOT EXISTS(SELECT 1 FROM sys.key_constraints WHERE type = 'PK'   and name='PK_Roles')
begin
	alter table dbo.Roles
	add constraint PK_Roles primary key (RoleId)
end
--------------------------------------------------------------------------------------------------------------------------------------
-- Checking Foreign Key 
IF NOT EXISTS(SELECT 1 FROM sys.key_constraints WHERE type = 'FK'   and name='FK_RoleMenu')
begin
	alter table dbo.RoleMenu
	add constraint FK_RoleMenu Foreign key (RoleId) references Roles(RoleId)
end
--------------------------------------------------------------------------------------------------------------------------------------
-- Checking unique Key 
IF NOT EXISTS(SELECT 1 FROM sys.key_constraints WHERE type = 'UQ'   and name='UK_RoleMenu')
begin
	alter table dbo.RoleMenu
	add constraint UK_RoleMenu unique (RoleId,MenuId)  
end
--------------------------------------------------------------------------------------------------------------------------------------
-- Find all store proc with schema using sp_s
CREATE proc sp_s  
@tbl varchar(100)  
as  
begin    
  
	select   'sp_helptext ''' +  s.name + '.'+ t.name  + '''' FROM sys.procedures as t   
	inner join sys.schemas s on s.schema_id=t.schema_id 
	where   t.name like '%'+ @tbl +'%'     or s.name like '%'+ @tbl +'%' 

end
go
--------------------------------------------------------------------------------------------------------------------------------------
-- Find all tables with schema using sp_t
CREATE proc sp_t  
@tbl varchar(100)  
as  
begin   
    
	select   'select top 3  * from ' +  s.name + '.'+ t.name + ' order by 1 desc ' FROM sys.tables as t   
	inner join sys.schemas s on s.schema_id=t.schema_id 
	where   t.name like '%'+ @tbl +'%'   or s.name like '%'+ @tbl +'%' 

end
---------------------------------------------------------------------------------------------------------------------------------------
-- Error Log table
insert into  Register.ErrorLog(CompanyDetailID,ScreenName,UniqueNumber,ErrorMessage,CreatedDate)
select  @CompanyDetailID,'DBS Confirmation - Failed'+'',null,ERROR_MESSAGE(),GETDATE()
-- Select
select * from Register.ErrorLog with(nolock)
where 1=1
and ScreenName like '%DBS Confirmation%' 
order by 1 desc 
--------------------------------------------------------------------------------------------------------------------------------------
-- write select statement with columns using schema.table  as parameter
IF OBJECT_ID(N'dbo.sp_se', N'P') IS NOT NULL
BEGIN
	drop proc dbo.sp_se
END
GO 
CREATE proc sp_se  
@P1 varchar(200)  
as  
begin   
    
	--DECLARE @P1 VARCHAR(100)
 
	--SET @P1='APIRPT.LEDGERSUMMARY'
 
	DECLARE @TABLE_NAME VARCHAR (100), @TABLE_SCHEMA VARCHAR(100) 
 
	SET @TABLE_SCHEMA= SUBSTRING (@P1, 0, CHARINDEX('.', @P1))
	SET @TABLE_SCHEMA = IIF(isnull(@TABLE_SCHEMA,'')='','DBO','') 

	SET @TABLE_NAME= SUBSTRING (@P1, CHARINDEX('.',@P1) +1,LEN (@P1)) 
	--SP_SE 
	SELECT 'SELECT '+ STUFF ( (SELECT ',' + IIF(ISNUMERIC(SUBSTRING (COLUMN_NAME, 1, 1))=1, '[' +COLUMN_NAME, COLUMN_NAME) + IIF(ISNUMERIC(SUBSTRING (COLUMN_NAME, 1, 1))=1, ']', '') 
	FROM INFORMATION_SCHEMA.COLUMNS
	WHERE TABLE_NAME =@TABLE_NAME AND TABLE_SCHEMA= @TABLE_SCHEMA
	FOR XML PATH('') ) ,1,1,'')
	+' FROM ' + @TABLE_SCHEMA+'.'+ @TABLE_NAME SELECTQUERY

end
go
--------------------------------------------------------------------------------------------------------------------------------------
IF OBJECT_ID(N'dbo.SP_I', N'P') IS NOT NULL
BEGIN
	drop proc dbo.SP_I
END
GO 
-- write insert statement with columns using schema.table as parameter
CREATE proc sp_i  
@P1 varchar(200)  
as  
begin   
    
	--DECLARE @P1 VARCHAR(100)
 
	--SET @P1='APIRPT.LEDGERSUMMARY'
 
	DECLARE @TABLE_NAME VARCHAR (100), @TABLE_SCHEMA VARCHAR(100) 
 
	SET @TABLE_SCHEMA= SUBSTRING (@P1, 0, CHARINDEX('.', @P1))
	SET @TABLE_SCHEMA = IIF(isnull(@TABLE_SCHEMA,'')='','DBO','') 

	SET @TABLE_NAME= SUBSTRING (@P1, CHARINDEX('.',@P1) +1,LEN (@P1)) 
 
	 -- SP_I 
	SELECT 'INSERT INTO '+ @TABLE_SCHEMA +'.'+ @TABLE_NAME + ' ( ' + STUFF ((SELECT ',', +IIF(ISNUMERIC(SUBSTRING (COLUMN_NAME, 1, 1))=1, 
	'[' +COLUMN_NAME, COLUMN_NAME) + IIF(ISNUMERIC(SUBSTRING (COLUMN_NAME, 1, 1))=1, ']', '') 
	FROM INFORMATION_SCHEMA.COLUMNS
	WHERE TABLE_NAME = @TABLE_NAME AND TABLE_SCHEMA=@TABLE_SCHEMA 
	FOR XML PATH('')),1,1,'')  + ' ) '+ CHAR(10)   + 
	+ 'SELECT '+ STUFF ( (SELECT ',' + IIF(ISNUMERIC(SUBSTRING (COLUMN_NAME, 1, 1))=1, '[' +COLUMN_NAME, COLUMN_NAME) + IIF(ISNUMERIC(SUBSTRING (COLUMN_NAME, 1, 1))=1, ']', '') 
	FROM INFORMATION_SCHEMA.COLUMNS
	WHERE TABLE_NAME =@TABLE_NAME AND TABLE_SCHEMA= @TABLE_SCHEMA
	FOR XML PATH('') ) ,1,1,'') + '' INSERTQUERY

end
go 
IF OBJECT_ID(N'dbo.sp_u', N'P') IS NOT NULL
BEGIN
	drop proc dbo.sp_u
END
GO 
--------------------------------------------------------------------------------------------------------------------------------------
-- write update statement with columns using schema.table as parameter
CREATE proc sp_u  
@P1 varchar(200)  
as  
begin   
    
	--DECLARE @P1 VARCHAR(100)
 
	--SET @P1='APIRPT.LEDGERSUMMARY'
 
	DECLARE @TABLE_NAME VARCHAR (100), @TABLE_SCHEMA VARCHAR(100) 
 
	SET @TABLE_SCHEMA= SUBSTRING (@P1, 0, CHARINDEX('.', @P1))
	SET @TABLE_SCHEMA = IIF(isnull(@TABLE_SCHEMA,'')='','DBO','') 

	SET @TABLE_NAME= SUBSTRING (@P1, CHARINDEX('.',@P1) +1,LEN (@P1)) 
 

	--sp_u 
	SELECT 'UPDATE ' + @TABLE_SCHEMA+ '.' + @TABLE_NAME +' SET ' +
	STUFF ( (SELECT '='''', ' + IIF(ISNUMERIC(SUBSTRING (COLUMN_NAME, 1, 1))=1, '[' +COLUMN_NAME, COLUMN_NAME) + IIF(ISNUMERIC(SUBSTRING (COLUMN_NAME, 1, 1))=1, ']', '') 
	FROM INFORMATION_SCHEMA.COLUMNS 
	WHERE TABLE_NAME= @TABLE_NAME AND TABLE_SCHEMA=@TABLE_SCHEMA 
	FOR XML PATH('') ),1,4,'') +  '='''''  +CHAR(10)+
	' WHERE ID= -101 ' UPDATEQUERY 

end
go 
--------------------------------------------------------------------------------------------------------------------------------------
-- Creating temp table 
drop table if exists #t1
create table #t1 (slno int identity(1,1),companydetailid int unique ) 
insert into #t1 (companydetailid)
select distinct companydetailid from api.MWSConfiguration_SPAPI C With(Nolock) 
where 1=1
and isnull(SellerAuthRefreshToken,'')!=''

select  *from #t1
--------------------------------------------------------------------------------------------------------------------------------------
-- Creating table variable 
Declare @t1  as table (slno int identity(1,1),companydetailid int unique ) 
insert into @t1 (companydetailid)
select distinct companydetailid from api.MWSConfiguration_SPAPI C With(Nolock) 
where 1=1
and isnull(SellerAuthRefreshToken,'')!=''

select  *from @t1
-------------------------------------------------------------------------------------------------------------------------------------- 
-- delete duplicates GET_V2_SETTLEMENT_REPORT_DATA_FLAT_FILE_V2
DELETE
FROM API.MWSReportFiles_SPAPI
    WHERE ReportFileID IN
    (
		SELECT  max(ReportFileID) 
		from API.MWSReportFiles_SPAPI nolock 
		where 1=1
		and ReportType like '%settlement%' 
		group by CompanyDetailId,ReportType,ReportId 
		having COUNT(1)>1 
    );
-------------------------------------------------------------------------------------------------------------------------------------- 
--Renaming the column name
EXEC sp_RENAME 'GST.ProcessExecution_WorkFlow.SysId' , 'WorkFlowId', 'COLUMN'
-------------------------------------------------------------------------------------------------------------------------------------- 
-- Simple While Example
DECLARE @TotalCount INT,@incre int 
SET @incre=1
SET @TotalCount= (select count(1) from api.MWSConfiguration_SPAPI)

WHILE ( @incre <= @TotalCount)
BEGIN
    PRINT 'The counter value is = ' + CONVERT(VARCHAR,@Counter)
	-- do your action

    SET @incre = @incre  + 1
END
-------------------------------------------------------------------------------------------------------------------------------------- 
-- Simple Cursor Example
DECLARE  @product_name VARCHAR(MAX),  @list_price   DECIMAL;

DECLARE cursor_product CURSOR
FOR SELECT product_name,list_price  FROM production.products;

OPEN cursor_product;

FETCH NEXT FROM cursor_product INTO @product_name, @list_price;

WHILE @@FETCH_STATUS = 0
BEGIN

    PRINT @product_name + CAST(@list_price AS varchar);
	-- do your action

    FETCH NEXT FROM cursor_product INTO @product_name,@list_price;
END;

CLOSE cursor_product;

DEALLOCATE cursor_product;
-------------------------------------------------------------------------------------------------------------------------------------- 
-- Creating Index with include columns 
IF Not Exists (SELECT 1  FROM sys.indexes  WHERE object_id = OBJECT_ID('Person.Address') AND name='IX_Address_PostalCode')
Begin
	-- Creates a nonclustered index on the Person.Address table with four included (nonkey) columns.   
	-- index key column is PostalCode and the nonkey columns are  
	-- AddressLine1, AddressLine2, City, and StateProvinceID.  
	CREATE NONCLUSTERED INDEX IX_Address_PostalCode  
	ON Person.Address (PostalCode)  
	INCLUDE (AddressLine1, AddressLine2, City, StateProvinceID);
End
-------------------------------------------------------------------------------------------------------------------------------------- 
-- Droping Index  
IF Exists (SELECT 1 FROM sys.indexes  WHERE object_id = OBJECT_ID('Person.Address') AND name='IX_Address_PostalCode')
Begin 
	Drop INDEX IX_Address_PostalCode  
	ON Person.Address  
End
-------------------------------------------------------------------------------------------------------------------------------------- 
-- Direct JSON from SQL select 
GO
IF OBJECT_ID(N'GSTAPI.findGSTR2BMaster', N'P') IS NOT NULL
BEGIN
	drop proc GSTAPI.findGSTR2BMaster
END
go 
Create proc GSTAPI.findGSTR2BMaster
@companyId int,
@year int,
@month int,
@GstNo varchar(255),
@GstType varchar(255)
As 
BEGIN
	
	SET NOCOUNT ON; 

	select   R2BM.company_id,R2BM.gst_no,R2BM.month,R2BM.year,R2BM.return_period,R2BM.created_at
	,
	--GSTR2B_Vendor
	gstr2b=(
	select ISNULL(
			(select  R2BMV.id,R2BMV.gstr2b_master_id,R2BMV.gst_no,R2BMV.trade_name,R2BMV.supplier_filing_date,R2BMV.supplier_filing_period
			--GSTR2B_Invoice
			,gstr2bInvoice=(
			select ISNULL(
					(select  R2BMI.id,R2BMI.gstr2b_vendor_id,R2BMI.place_of_supply,R2BMI.invoice_date,R2BMI.invoice_number,R2BMI.invoice_type
					,R2BMI.invoice_value,R2BMI.itc_availability,R2BMI.itc_unavailability,R2BMI.supply_reverse_charge,R2BMI.itc_claim_month
					,R2BMI.itc_claim_year	
					--gstr2bItem
					,GSTR2B_Item=(
					select ISNULL(
							(select  R2BMIT.id,R2BMIT.gstr2b_invoice_id,R2BMIT.item_number,R2BMIT.total_taxable_value,R2BMIT.tax_rate,R2BMIT.igst,R2BMIT.cgst,R2BMIT.sgst,R2BMIT.cess			
							from GSTAPI.GSTR2B_Item  as R2BMIT with (nolock)
							where  R2BMIT.gstr2b_invoice_id=R2BMI.id 
							for json path, include_null_values
							) ,'[]')
						)
					from GSTAPI.GSTR2B_Invoice  as R2BMI with (nolock)
					where  R2BMI.gstr2b_vendor_id=R2BMV.id 
					for json path, include_null_values
					) ,'[]')
				)
			from GSTAPI.GSTR2B_Vendor  as R2BMV with (nolock)
			where  R2BMV.gstr2b_master_id=R2BM.id 
			for json path, include_null_values
			) ,'[]')
		)
	from GSTAPI.GSTR2B_Master  as R2BM with (nolock)
	--inner join masters.[State] as s with(nolock) on s.GSTStateName = p.ship_to_state4gst
	where R2BM.company_id = @companyId and R2BM.year = @year and R2BM.month = @month
	for json path

	SET NOCOUNT OFF;

END
go  
-------------------------------------------------------------------------------------------------------------------------------------- 
	-- Example for Merge into with insert, Update and Delete
		MERGE ZOHO.Leads AS ST
		USING #t1	AS S
		ON S.id = ST.id 
		 --For Inserts
		WHEN NOT MATCHED BY Target THEN
			INSERT (CompanyId,Email,Store_Name,SellerName,POC_Name,Lead_Status,
			Modified_Date,First_Name,Last_Name,Company,Phone_Number,
			Owners,Secondary_Email,Lead_Source,Channel,Leads_Priority,
			WechatName_ID,We_Chat_Group,Created_Date,Leads_Country,Remarks,
			Lifetime_GMV,Source,id,Modified_Date1,CreatedDate,CreatedBy) 
			VALUES (@CompanyId,S.Email,S.Store_Name,S.SellerName,S.POC_Name,S.Lead_Status,S.
			Modified_Date,S.First_Name,S.Last_Name,S.Company,S.Phone_Number,S.
			Owners,S.Secondary_Email,S.Lead_Source,S.Channel,S.Leads_Priority,S.
			WechatName_ID,S.We_Chat_Group,S.Created_Date,S.Leads_Country,S.Remarks,S.
			Lifetime_GMV,S.Source,S.id,S.Modified_Date1,getdate(),@LoginId) 
		 --For Updates
		WHEN MATCHED THEN UPDATE SET
			ST.UpdatedDate= getdate(),
			ST.Email= S.Email,
			ST.Store_Name=S.Store_Name , 
			ST.Modified_Date1=S.Modified_Date1 
		 --For Deletes
		WHEN NOT MATCHED BY source THEN
			DELETE;
-------------------------------------------------------------------------------------------------------------------------------------------------------
-- To check the dependent or  text by in all store proc or all sql object except table
SELECT * FROM SYS.objects
WHERE OBJECT_DEFINITION(OBJECT_ID) LIKE '%RK%'
AND TYPE='P'

-------------------------------------------------------------------------------------------------------------------------------------------------------
-- Delete duplicate records using the CTE
with CTE as (

select id
,row_number() over ( partition by  taskid,CommandID,ExecutableParam order by taskid,CommandID,ExecutableParam  ) R  from ETL.DS_ETLCommands 
where 1=1
--and taskid=35
--group by taskid,CommandID,ExecutableParam
--having count(*)>1
) 
select * from CTE where R = 1
-------------------------------------------------------------------------------------------------------------------------------------------------------
-- JSON to table Query
IF OBJECT_ID(N'sp_jsont', N'P') IS NOT NULL
BEGIN
	drop proc sp_jsont
END
go 
-- exec sp_jsont 'Testtable', '{"Name": "John", "Age": 30, "IsStudent": true, "GPA": 3.5}'
CREATE proc sp_jsont
@tableName NVARCHAR(100),
@json varchar(max)  
as  
begin    
   	--set @tableName		='Testtable'
	--set @json			='{"Name": "John", "Age": 30, "IsStudent": true, "GPA": 3.5}'
 
	DECLARE @sql NVARCHAR(MAX) =   ''
	set @sql =  'CREATE TABLE ' + @tableName + ' (' ;

	set  @sql +=  ( SELECT 
				STRING_AGG ( QUOTENAME([key])  +
				CASE 
					WHEN ISNUMERIC(JSON_VALUE(@json, CONCAT('$.', [key]))) = 1 AND JSON_VALUE(@json, CONCAT('$.', [key])) like '%.%' THEN ' DECIMAL(18,2)'
					WHEN ISNUMERIC(JSON_VALUE(@json, CONCAT('$.', [key]))) = 1 THEN ' INT'
					WHEN LOWER(value) IN ('true', 'false') THEN ' BIT'
					ELSE ' VARCHAR(255)'
				END,',') 
				FROM OPENJSON(@json)
			 ) 

	set  @sql += ')'  

	select @sql

end
go 
-------------------------------------------------------------------------------------------------------------------------------------------------------
-- sample json with all types
declare @tableName NVARCHAR(100),
@json varchar(max)  

set @tableName		='Testtable'
set @json			='{"Name": "John", "Age": 30, "IsStudent": true, "GPA": 3.5,"GPAobject": {"a": 23213 },"GPAArray": [{"a": 23213 }]}'
 
SELECT  	*	FROM OPENJSON(@json)
-------------------------------------------------------------------------------------------------------------------------------------------------------
-- POC for nested json into nested tables
declare
@tableName NVARCHAR(100),
@json varchar(max)   
begin    

   	set @tableName		='Testtable'
	set @json			='{
    "InvRm": "TEST",
    "DocPerdDtls": {
        "InvStDt": "01/08/2020",
        "InvEndDt": "01/09/2020"
    },
    "PrecDocDtls": [
        {
            "InvNo": "DOC/002",
            "InvDt": "01/08/2020",
            "OthRefNo": "123456"
        }
    ],
    "ContrDtls": [
        {
            "RecAdvRefr": "Doc/003",
            "RecAdvDt": "01/08/2020",
            "TendRefr": "Abc001",
            "ContrRefr": "Co123",
            "ExtRefr": "Yo456",
            "ProjRefr": "Doc-456",
            "PORefr": "Doc-789",
            "PORefDt": "01/08/2020"
        }
    ]
}'
 
 select * from   OPENJSON(@json)
	DECLARE @sql NVARCHAR(MAX) =   ''
	set @sql =  'CREATE TABLE ' + @tableName + ' (' ;

	set  @sql +=  ( SELECT 
				STRING_AGG ( QUOTENAME([key])  +
				CASE 
					WHEN ISJSON([value]) = 1 and type =5  THEN 'NVARCHAR(MAX)'
					WHEN ISJSON(substring(trim([value]),1,len(trim([value])))) = 1 and type =4  THEN 'NVARCHAR(MAX)'
					WHEN ISNUMERIC(JSON_VALUE(@json, CONCAT('$.', [key]))) = 1 AND JSON_VALUE(@json, CONCAT('$.', [key])) like '%.%' THEN ' DECIMAL(18,2)'
					WHEN ISNUMERIC(JSON_VALUE(@json, CONCAT('$.', [key]))) = 1 THEN ' INT'
					WHEN LOWER(value) IN ('true', 'false') THEN ' BIT'
					ELSE ' VARCHAR(255)'
				END,',') 
				FROM OPENJSON(@json)
			 ) 

	set  @sql += ')'  

	select @sql

end 
go
------------------------------------------------------------------------------------------------------------------------------------------------------
IF OBJECT_ID(N'f_nj2t', N'FN') IS NOT NULL
BEGIN
	drop function f_nj2t
END
go 
Create function f_nj2t(
@tableName NVARCHAR(100),
@json varchar(max))
RETURNS varchar(max)
as  
begin     

	-- not working for order by 
	--declare @keyvalueparir as table  ([key] varchar(max),	[value]  varchar(max),	[type] int) 
	--insert into @keyvalueparir ([key],[value],[type])
	--select [key],[value],[type] FROM OPENJSON(@json)  
	--order by [type] desc
	

	--select * from @keyvalueparir

	DECLARE @sql NVARCHAR(MAX) =   ''
	set @sql =    CHAR(13) + CHAR(10) + 'CREATE TABLE ' + @tableName + ' (' ; 
	set  @sql +=  ( select STRING_AGG ( iif( (ISJSON([value]) = 1 and type =5) or (ISJSON([value]) = 1 and type =4),'',([key]))
							  +    
				CASE  
					WHEN ISJSON([value]) = 1 and type =5  THEN dbo.f_nj2t(@tableName + '|' + [key],[value]) 
					WHEN ISJSON([value]) = 1 and type =4  THEN dbo.f_nj2t( @tableName + '|' + [key],substring(trim([value]),2,len(trim([value])) - 2))
				 	WHEN isDate(JSON_VALUE(@json, CONCAT('$.', [key]))) = 1 AND len(JSON_VALUE(@json, CONCAT('$.', [key]))) = 10 THEN ' date'
				 	WHEN isDate(JSON_VALUE(@json, CONCAT('$.', [key]))) = 1 AND len(JSON_VALUE(@json, CONCAT('$.', [key]))) > 10 THEN ' datetime'
					WHEN ISNUMERIC(JSON_VALUE(@json, CONCAT('$.', [key]))) = 1 AND JSON_VALUE(@json, CONCAT('$.', [key])) like '%.%' THEN ' DECIMAL(18,2)'
					WHEN ISNUMERIC(JSON_VALUE(@json, CONCAT('$.', [key]))) = 1 THEN ' INT'
					WHEN LOWER(value) IN ('true', 'false') THEN ' BIT'
					ELSE ' VARCHAR(255)' 
				END,',' +  CHAR(13) + CHAR(10))  
				from 
				( 
					SELECT  [key],[value],[type]
					,ROW_NUMBER() OVER (ORDER BY [type] asc) AS RowNum  --< ORDER BY
					FROM OPENJSON(@json)       
				)
				as MyDerivedTable  
				WHERE MyDerivedTable.RowNum >=0
			 ) 

	set  @sql += ')'  
	 
 
	if(@sql like '%|%')
	begin
		set @sql= replace(@sql,'|','_')
	end
		

	return @sql

end
--- Testing nested Json
declare
@tableName NVARCHAR(100),
@json varchar(max)    

   	set @tableName		='Testtable'
	set @json			='{
    "InvRm": "TEST",
    "DocPerdDtls": {
        "A_Date": "01/08/2020",
        "A_DateTime": "01/08/2020 11:00"
    },
    "PrecDocDtls": [
        {
            "B": "DOC/002"
        }
    ],
    "ContrDtls": [
        {
            "C": 1,
            "FinalChild": [
                {
                    "D": 1.00,
                    "E": false,
                    "RecAdvRefr_": "Doc/003"
                }
            ]
        }
    ]
}'   
 select  dbo.f_nj2t(@tableName,@json)  
go 	
-------------------------------------------------------------------------------------------------------------------------------------------------------
--How to add description into particular column in MS SQL using extended_properties
EXEC sp_addextendedproperty 
    @name = N'TaxSch', @value = 'Tax Scheme',
    @level0type = N'Schema',   @level0name = 'EInvoice',
    @level1type = N'Table',    @level1name = 'TranDtls',
    @level2type = N'Column',   @level2name = 'TaxSch';
GO

-------------------------------------------------------------------------------------------------------------------------------------------------------
-- How to display the column's description in MS SQL using extended_properties
	select 	st.name [Table],sc.name [Column],sep.value [Description]
	from sys.tables st
	inner join sys.columns sc on st.object_id = sc.object_id
	left join sys.extended_properties sep on st.object_id = sep.major_id
	and sc.column_id = sep.minor_id 
	where st.name = 'TranDtls' 
GO
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--sample table
--create table aaa_
--( 
--c1 varchar (max),
--c2 varchar (10),
--c3 char (10),
--c4 nvarchar (10),
--c5 nchar (10),

--c6 date,
--c7 datetime,
--c8 tinyint,
--c9 smallint,
--c10 int,
--c11 decimal(18,2)
--)
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- To get select statement for staging table into raw table
DECLARE @SchemaName NVARCHAR (100)
DECLARE @tblName NVARCHAR (100) 
DECLARE @stgTblAlias VARCHAR (15)

SET @SchemaName =N'dbo'
SET @tblName =N'aaa_'

SET @stgTblAlias='stg' 
SELECT COLUMN_NAME,IS_NULLABLE,DATA_TYPE,CHARACTER_MAXIMUM_LENGTH,ORDINAL_POSITION,NUMERIC_PRECISION,NUMERIC_SCALE
,sqlStmt= '' + 
CASE    
	WHEN DATA_TYPE ='varchar'	AND sc.CHARACTER_MAXIMUM_LENGTH =-1 THEN 'TRIM('+@stgTblAlias+'.['+sc.COLUMN_NAME +'])  AS ['+ sc.COLUMN_NAME  + '],'
	WHEN DATA_TYPE ='varchar'	THEN 'SUBSTRING(TRIM('+@stgTblAlias+'.['+sc.COLUMN_NAME +']), 1, '+cast (sc.CHARACTER_MAXIMUM_LENGTH  as varchar)+' )  AS ['+ sc.COLUMN_NAME  + '],'
	WHEN DATA_TYPE ='char'	THEN 'SUBSTRING(TRIM('+@stgTblAlias+'.['+sc.COLUMN_NAME +']), 1, '+cast (sc.CHARACTER_MAXIMUM_LENGTH  as varchar)+' )  AS ['+ sc.COLUMN_NAME  + '],' 
	WHEN DATA_TYPE ='nvarchar'	THEN 'SUBSTRING(TRIM('+@stgTblAlias+'.['+sc.COLUMN_NAME +']), 1, '+cast (sc.CHARACTER_MAXIMUM_LENGTH/2  as varchar)+' )  AS ['+ sc.COLUMN_NAME  + '],'
	WHEN DATA_TYPE ='nchar'	THEN 'SUBSTRING(TRIM('+@stgTblAlias+'.['+sc.COLUMN_NAME +']), 1, '+cast (sc.CHARACTER_MAXIMUM_LENGTH/2  as varchar)+' )  AS ['+ sc.COLUMN_NAME  + '],' 

	WHEN DATA_TYPE ='date'		THEN 'CASE WHEN ISDATE('+@stgTblAlias+'.['+sc.COLUMN_NAME +'])= 0 THEN NULL ELSE cast ('+@stgTblAlias+'.['+sc.COLUMN_NAME +'] as Date) END' + ' AS ['+ sc.COLUMN_NAME  + '],' 
	WHEN DATA_TYPE ='Datetime'	THEN 'CASE WHEN ISDATE('+@stgTblAlias+'.['+sc.COLUMN_NAME +'])= 0 THEN NULL ELSE cast ('+@stgTblAlias+'.['+sc.COLUMN_NAME +'] as Datetime) END' + ' AS ['+ sc.COLUMN_NAME  + '],' 

	WHEN DATA_TYPE ='tinyint'	THEN 'CASE WHEN isnumeric('+@stgTblAlias+'.['+sc.COLUMN_NAME +'])= 0 THEN NULL ELSE cast ('+@stgTblAlias+'.['+sc.COLUMN_NAME +'] as tinyint) END' + ' AS ['+ sc.COLUMN_NAME  + '],' 
	WHEN DATA_TYPE ='smallint'	THEN 'CASE WHEN isnumeric('+@stgTblAlias+'.['+sc.COLUMN_NAME +'])= 0 THEN NULL ELSE cast ('+@stgTblAlias+'.['+sc.COLUMN_NAME +'] as smallint) END' + ' AS ['+ sc.COLUMN_NAME  + '],' 
	WHEN DATA_TYPE ='int'		THEN 'CASE WHEN isnumeric('+@stgTblAlias+'.['+sc.COLUMN_NAME +'])= 0 THEN NULL ELSE cast ('+@stgTblAlias+'.['+sc.COLUMN_NAME +'] as int) END' + ' AS ['+ sc.COLUMN_NAME  + '],' 
	WHEN DATA_TYPE ='decimal'	THEN 'CASE WHEN isnumeric('+@stgTblAlias+'.['+sc.COLUMN_NAME +'])= 0 THEN NULL ELSE cast ('+@stgTblAlias+'.['+sc.COLUMN_NAME +'] as decimal('+cast (sc.NUMERIC_PRECISION as varchar)+ ',' +cast (NUMERIC_SCALE as varchar)+ ')) END' + ' AS ['+ sc.COLUMN_NAME  + '],' 
	END 
FROM INFORMATION_SCHEMA.COLUMNS  as sc
WHERE 1=1
AND TABLE_SCHEMA=@SchemaName AND TABLE_NAME = @tblName
AND COLUMN_NAME NOT IN ('ID','CREATEDDATE')
ORDER BY  ORDINAL_POSITION asc 


