
-------------------------------------------------------------------------------------------------------------------------------------
-- COALESCE Example

SELECT COALESCE(NULL, NULL, NULL, 'W3Schools.com', NULL, 'Example.com');

select COALESCE(a.Firstname,a.lastname, '') Name from register.users as a

-------------------------------------------------------------------------------------------------------------------------------------
Using IDENTITY() in a SELECT INTO Query
-- Example 1 
SELECT 
    IDENTITY(INT, 1, 1) AS IdentityColumn,
    SomeColumn,
    AnotherColumn
INTO NewTable
FROM YourTable;
-- Example 3 
SELECT 
    ROW_NUMBER() OVER (ORDER BY SomeColumn) AS IdentityColumn,
    SomeColumn,
    AnotherColumn
FROM YourTable;
-------------------------------------------------------------------------------------------------------------------------------------
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
-------------------------------------------------------------------------------------------------------------------------------------
Example: Using GOTO with TRY and CATCH
BEGIN TRY
    -- Example: Simulate a divide by zero error
    DECLARE @Result INT;
    DECLARE @Value1 INT = 10;
    DECLARE @Value2 INT = 0;

    IF @Value2 = 0
        GOTO HandleError; -- Jump to error handling section if @Value2 is zero

    SET @Result = @Value1 / @Value2;
    PRINT 'Result: ' + CAST(@Result AS NVARCHAR(50));

    GOTO EndExecution; -- Skip error handling section if no error occurs

HandleError:
    PRINT 'An error occurred: Division by zero is not allowed.';
    RETURN; -- Exit the execution

END TRY
BEGIN CATCH
    -- Capture and handle errors
    PRINT 'Error: ' + ERROR_MESSAGE();
END CATCH

EndExecution:
PRINT 'Execution completed.'; 
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
IF NOT EXISTS(SELECT * FROM sys.foreign_keys WHERE type = 'F' and name='FK_RoleMenu')
begin
	alter table dbo.RoleMenu
	add constraint FK_RoleMenu Foreign key (RoleId) references Roles(RoleId)
end
-- Checking Foreign Key with cascadding delete
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'FK_RoleMenu')
BEGIN
    ALTER TABLE dbo.RoleMenu    
    ADD CONSTRAINT FK_RoleMenu         FOREIGN KEY (RoleId)         REFERENCES dbo.Roles(RoleId)         ON DELETE CASCADE;
END
--------------------------------------------------------------------------------------------------------------------------------------
-- Checking unique Key 
IF NOT EXISTS(SELECT 1 FROM sys.key_constraints WHERE type = 'UQ'   and name='UK_RoleMenu')
begin
	alter table dbo.RoleMenu
	add constraint UK_RoleMenu unique (RoleId,MenuId)  
end 
--------------------------------------------------------------------------------------------------------------------------------------
-- Checking  CHECK constraints
IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS as c  where TABLE_SCHEMA='Register' and table_Name = 'FilterConfig' and CONSTRAINT_NAME='CHK_FilterConfig_SearchType')
begin
	ALTER TABLE Register.FilterConfig 
	ADD CONSTRAINT CHK_FilterConfig_SearchType CHECK ([SearchType] in ('TEXT','DATE','BOOLEAN'))
end 
go
--------------------------------------------------------------------------------------------------------------------------------------
IF EXISTS (SELECT * FROM sys.check_constraints WHERE name = 'chk_CatalogueDetail_CTH_HSN')
begin
	alter table Catalogue.CatalogueDetail   
	add CONSTRAINT chk_CatalogueDetail_CTH_HSN check  (LEN(CTH_HSN) = 8 and isnull(CTH_HSN,'') !='' );
end
go 
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
    
	select   'select top 3  * from ' +  s.name + '.'+ t.name + ' with (nolock) where 1=1 order by 1 desc ' FROM sys.tables as t   
	inner join sys.schemas s on s.schema_id=t.schema_id 
	where   t.name like '%'+ @tbl +'%'   or s.name like '%'+ @tbl +'%' 

end
---------------------------------------------------------------------------------------------------------------------------------------
-- comma separated values using Stuff example 
	select distinct t1.id,
  STUFF(
         (SELECT ', ' + convert(varchar(10), t2.date, 120)
          FROM yourtable t2
          where t1.id = t2.id
          FOR XML PATH (''))
          , 1, 1, '')  AS date
from yourtable t1; 
---------------------------------------------------------------------------------------------------------------------------------------
-- comma separated values using STRING_AGG
SELECT STRING_AGG(cast(Name as varchar(max)) , ', ') AS ConcatenatedNames
FROM Employees;
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
CREATE proc sp_d     
@tbl varchar(100)      
as      
begin       
        
	SELECT * FROM SYS.objects
	WHERE 1=1
	and OBJECT_DEFINITION(OBJECT_ID) like '%'+ @tbl +'%'  
	AND TYPE='P'
end 
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
-- Simple JSON insert
set @json=concat('[' ,@json , ']')   
declare @Remarks  varchar(500)
declare @lstDebitNoteDetail  varchar(max)  

SET @Remarks=JSON_VALUE(@json,'$[0].Remarks');  
SET @lstDebitNoteDetail=JSON_query(@json,'$[0].lstDebitNoteDetail'); 

SELECT distinct @DNID,@CompanyDetailID,ItemID,0, TotalAmount,
PendingTotalAmount-TotalAmount,(PendingTotalAmount-TotalAmount)/IIF(PendingQty=0,1,PendingQty),Reason, @LoginId,getdate()  FROM
OPENJSON ( @lstDebitNoteDetail )  
WITH (      
	ItemID   BIGINT  '$.ItemID' ,
	Qty INT '$.Qty' ,  
	InvoiceQty INT '$.InvoiceQty' ,  
	PendingQty INT '$.PendingQty' ,  
	TotalAmount decimal(18,2) '$.TotalAmount' ,
	InvoiceTotalAmount decimal(18,2) '$.InvoiceTotalAmount' ,
	PendingTotalAmount decimal(18,2) '$.PendingTotalAmount' ,
	Reason varchar(200) '$.Reason' 
) 
	
-------------------------------------------------------------------------------------------------------------------------------------------------------
-- JSON to table Query
IF OBJECT_ID(N'sp_jsont', N'P') IS NOT NULL
BEGIN
	drop proc sp_jsont
END
go 
-- exec sp_jsont 'Testtable', '{"Name": "John", "Age": 30, "IsStudent": true, "GPA": 3.5,"ewbD": "2020-08-05","ewbDt": "2020-08-05 15:18:00"}'
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
				 	WHEN isDate(JSON_VALUE(@json, CONCAT('$.', [key]))) = 1 AND len(JSON_VALUE(@json, CONCAT('$.', [key]))) = 10 THEN ' date'
				 	WHEN isDate(JSON_VALUE(@json, CONCAT('$.', [key]))) = 1 AND len(JSON_VALUE(@json, CONCAT('$.', [key]))) > 10 THEN ' datetime'
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
-- To insert the rows into tables from json 
declare @tableName NVARCHAR(100),
@json varchar(max)  

set @tableName		='Testtable'
set @json			='{"Name": "John", "Age": 30, "IsStudent": true, "GPA": 3.5,"GPAobject": {"a": 1 ,"z": 2.00},"GPAArray": [{"a": 3 ,"z": 4.00}]}'
 

SELECT  	*	FROM OPENJSON(@json)

set @json			= concat('[',@json,']')
 
declare @Name varchar(100)
declare @Age int 
declare @IsStudent bit 
declare @GPA decimal(18,2)
declare @GPAobject varchar(max)
declare @GPAArray varchar(max)


SET @Name=JSON_VALUE(@json,'$[0].Name');  
SET @Age=JSON_VALUE(@json,'$[0].Age');  
SET @IsStudent=JSON_VALUE(@json,'$[0].IsStudent');  
SET @GPA=JSON_VALUE(@json,'$[0].GPA');  
 

select  @Name Name,  @Age Age,  @IsStudent IsStudent,  @GPA GPA 
 
	
SET @GPAobject=JSON_query(@json,'$[0].GPAobject'); 
 
SELECT a,z  FROM
OPENJSON ( @GPAobject )  
WITH (        
	a	int				'$.a' ,
	z	decimal(18,2)	'$.z' 
) 

SET @GPAArray=JSON_query(@json,'$[0].GPAArray');  

SELECT a,z  FROM
OPENJSON ( @GPAArray )  
WITH (        
	a	int				'$.a' ,
	z	decimal(18,2)	'$.z' 
) 
	



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
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Validating the Json with specifi property
declare @JsonData varchar(max)

set @JsonData='[
    {
        "CompanydetailID": "1687",
        "Storename": "Britzgo",
        "ItemCode": "BHA-1607-S",
        "ProductTaxCode": "A_GEN_REDUCED"
    } 
]'

drop table if exists #t_schema_error
create table #t_schema_error (slno int ,Error varchar(1000)) 
insert into #t_schema_error (slno,Error)
SELECT distinct 1,CASE WHEN JSON_VALUE(value, '$.CompanyDetailID') IS   NULL THEN 'CompanyDetailID property does not exist and property(Header Column) is case sensitive!' ELSE '' END
FROM OPENJSON(@JsonData)  
union all
SELECT distinct 2,CASE WHEN JSON_VALUE(value, '$.StoreName') IS   NULL THEN 'StoreName property does not exist and property(Header Column) is case sensitive!' ELSE '' END
FROM OPENJSON(@JsonData) 
union all
SELECT distinct 3,CASE WHEN JSON_VALUE(value, '$.ItemCode') IS   NULL THEN 'ItemCode property does not exist and property(Header Column) is case sensitive! ' ELSE '' END
FROM OPENJSON(@JsonData)
union all
SELECT distinct 4,CASE WHEN JSON_VALUE(value, '$.ProductTaxCode') IS   NULL THEN 'ProductTaxCode property does not exist and property(Header Column) is case sensitive!' ELSE '' END
FROM OPENJSON(@JsonData)

delete from #t_schema_error where isnull(Error,'')=''

select * from #t_schema_error

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Validating the Json with specifi property other option like schema validation 
drop table if exists #t1_headercolumns
create table #t1_headercolumns (slno int identity(1,1),HeaderColumn varchar(100) unique ) 
insert into #t1_headercolumns (HeaderColumn)
select value from dbo.fn_Split('SUPPLYCODE,FILELOCATION,DOCUMENTTYPE,DOCUMENTNUMBER,DOCUMENTDATE,BUYERGSTIN,BUYERLEGALNAME
,BUYERPOS,BUYERADDR1,BUYERADDR2,BUYERLOCATION,BUYERPINCODE,BUYERSTATE
,SLNO,HSNCODE,QUANTITY,UNIT,UNITPRICE,GROSSAMOUNT,TAXABLEVALUE,GSTRATE,SGSTAMT_RS,CGSTAMT_RS,IGSTAMT_RS,ITEMTOTAL
,TOTALTAXABLEVALUE,SGSTAMT,CGSTAMT,IGSTAMT,TOTALINVOICEVALUE',',') 

--select  *from #t1_headercolumns

drop table if exists #t_schema_error
create table #t_schema_error (slno int identity(1,1),Error varchar(1000)) 

--select * from #t_schema_error
insert into #t_schema_error (Error)
SELECT distinct  CASE WHEN JSON_VALUE(value, '$.' + HeaderColumn ) IS   NULL THEN HeaderColumn + ' property does not exist and property(Header Column) is case sensitive!' ELSE '' END
FROM OPENJSON('[{"SupplyCode":"B2B","Filelocation":"","DocumentType":"Credit Note","DocumentNumber":"BLR7-C-53625","DocumentDate":"02/02/2024","BuyerGSTIN":"29ACYPA5997Q1Z6","BuyerLegalName":"MOGALA SREENIVASAMURTHY AMAR","BuyerPOS":"29","BuyerAddr1":"100 feet ring road","BuyerAddr2":"","BuyerLocation":"Bangalore","BuyerPinCode":"560029","BuyerState":"29","SlNo":"1","HSNCode":"85444299","Quantity":"2","Unit":"Nos","UnitPrice":"1016.1","GrossAmount":"2032.2","Taxablevalue":"2032.2","GSTRate":"18","SgstAmt_RS":"182.9","CgstAmt_RS":"182.9","IgstAmt_RS":"0","ItemTotal":"2398","TotalTaxablevalue":"2032.2","SgstAmt":"182.9","CgstAmt":"182.9","IgstAmt":"0","TotalInvoicevalue":"2398"},{"SupplyCode":"B2B","Filelocation":"","DocumentType":"Tax Invoice","DocumentNumber":"BLR7-365503","DocumentDate":"02/02/2024","BuyerGSTIN":"29ACYPA5997Q1Z6","BuyerLegalName":"MOGALA SREENIVASAMURTHY AMAR","BuyerPOS":"29","BuyerAddr1":"100 feet ring road","BuyerAddr2":"","BuyerLocation":"Bangalore","BuyerPinCode":"560029","BuyerState":"29","SlNo":"1","HSNCode":"85444299","Quantity":"2","Unit":"Nos","UnitPrice":"1016.1","GrossAmount":"2032.2","Taxablevalue":"2032.2","GSTRate":"18","SgstAmt_RS":"182.9","CgstAmt_RS":"182.9","IgstAmt_RS":"0","ItemTotal":"2398","TotalTaxablevalue":"2032.2","SgstAmt":"182.9","CgstAmt":"182.9","IgstAmt":"0","TotalInvoicevalue":"2398"}]') 
cross join #t1_headercolumns

select * from #t_schema_error
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Simple Json Insert into table from json array
declare @json varchar(max)  
 
set @json			='
[
 {
  "Gstin": "29AAFCV5265N1ZK",
  "LglNm": "VALUECART PRIVATE LIMITED",
  "Addr1": "2ND FLOOR, 1\/1 VINAYAKA TOWERS, 1ST CROSS, GANDHINAGAR, ",
  "Loc": "BANGALORE",
  "Pin": 560009,
  "Stcd": "29"
 }
]'
 


insert into RKGST.GSTINDetail (CompanyID,Type,CreatedBy,CreatedDate,Gstin,LglNm,Addr1,Loc,Pin,Stcd) 
SELECT  3 CompanyID,'Seller' as Type, 9999 CreatedBy,getdate() CreatedDate,Gstin,LglNm,Addr1,Loc,Pin,Stcd	
FROM OPENJSON(@json)
WITH (        
	Gstin	varchar(250) '$.Gstin' ,
	LglNm	varchar(250) '$.LglNm' ,
	Addr1	varchar(250) '$.Addr1' ,
	Loc		varchar(250) '$.Loc' ,
	Pin		varchar(250) '$.Pin' ,
	Stcd	varchar(250)	'$.Stcd' 
);


select * from RKGST.GSTINDetail
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Output clause example with nestd level 3 json
	-- https://www.sqlservercentral.com/articles/the-output-clause-for-the-merge-statements
	
	insert into  Amazon.InvoiceHeader(CompanyId,FileType,InvoiceFileID,InvoiceDate,InvoiceNumber,GSTTaxRegistrationNo,GSTIN,Total,LastModifiedBy,LastModifiedDate  
	,CurrentStatusoftheCBE,CBE_XIIINumber,AirportOfArrival,FirstPortOfArrival,AssessableValue,DutyRs,InvoiceValue,KYCID,StateCode,InterestAmount,TotalAmount)  
	SELECT @CompanyId,@FileType,@InvoiceFileID,@InvoiceDate ,@InvoiceNumber, null,null,null,@LoginId,getdate()   
	,@CurrentStatusoftheCBE,@CBE_XIIINumber,@AirportOfArrival,@FirstPortOfArrival,@AssessableValue,@DutyRs,@InvoiceValue,@KYCID,@StateCode,@InterestAmount,@DutyRs  

	set @InvoiceHeaderID=SCOPE_IDENTITY()   

	declare @insertedBOEheader as table (InvoiceCourierBillOEntryDetailID bigint not null,RowIndex bigint null,lstInvoiceCourierBillOEntryDutySDetail nvarchar(max))   

	insert into Amazon.InvoiceCourierBillOEntryDetail ( CompanyId,InvoiceHeaderID,RowIndex,CTSH  
	,DescriptionofGoods,Quantity,InvoiceNumber,InvoiceValue  
	,UnitPrice,RateofExchange,AssessableValue,DutyRS  
	,LastModifiedBy,LastModifiedDate  
	,lstInvoiceCourierBillOEntryDutySDetail)   
	OUTPUT INSERTED.InvoiceCourierBillOEntryDetailID,INSERTED.RowIndex,INSERTED.lstInvoiceCourierBillOEntryDutySDetail into @insertedBOEheader  
	SELECT distinct @CompanyId,@InvoiceHeaderID,RowIndex,CTSH  
	,DescriptionofGoods,Quantity,InvoiceNumber,InvoiceValue  
	,UnitPrice,RateofExchange,AssessableValue,DutyRS  
	,@LoginId,getdate()  
	,lstInvoiceCourierBillOEntryDutySDetail  
	FROM  
	OPENJSON ( @lstInvoiceCourierBillOEntryDetail )    
	WITH (        
		RowIndex								int     '$.RowIndex' ,  
		CTSH									varchar(100)  '$.CTSH' ,  
		DescriptionofGoods						varchar(500) '$.DescriptionofGoods'  ,  
		Quantity								varchar(100) '$.Quantity'  ,  
		InvoiceNumber							varchar(100) '$.InvoiceNumber'  ,  
		InvoiceValue							varchar(100) '$.InvoiceValue'   ,  

		UnitPrice								varchar(30) '$.UnitPrice'   ,  
		RateofExchange							varchar(30) '$.RateofExchange'   ,  
		AssessableValue							varchar(30) '$.AssessableValue'   ,  
		DutyRS									varchar(30) '$.DutyRS'  ,   
		lstInvoiceCourierBillOEntryDutySDetail	nvarchar(max) AS JSON  

	)  
	order by rowindex   

	--select * from @insertedBOEheader  

	select @c=count(RowIndex) FROM @insertedBOEheader  
	set @i=1  
	while (@i<=@c)  
	begin   

		declare @lstInvoiceCourierBillOEntryDutySDetail nvarchar(max)  
		declare @InvoiceCourierBillOEntryDetailID bigint    

		SELECT  @InvoiceCourierBillOEntryDetailID=InvoiceCourierBillOEntryDetailID  
		,@lstInvoiceCourierBillOEntryDutySDetail=lstInvoiceCourierBillOEntryDutySDetail    
		FROM @insertedBOEheader where RowIndex=@i   


		insert into Amazon.InvoiceCourierBillOEntryDutySDetail ( CompanyId,InvoiceHeaderID  
		,InvoiceCourierBillOEntryDetailID,SrNo,DutyHead,AdValorem,SpecificRate,DutyForgon,DutyAmount  
		,LastModifiedBy,LastModifiedDate)   
		SELECT distinct @CompanyId,@InvoiceHeaderID  
		,@InvoiceCourierBillOEntryDetailID,SrNo,DutyHead,AdValorem,SpecificRate,DutyForgon,DutyAmount  
		,@LoginId,getdate()  
		FROM  
		OPENJSON ( @lstInvoiceCourierBillOEntryDutySDetail )    
		WITH (        
			RowIndex		int     '$.RowIndex' ,  
			SrNo			varchar(30)   '$.SrNo' ,  
			DutyHead		varchar(100)  '$.DutyHead' ,  
			AdValorem		varchar(500)  '$.AdValorem'  ,  
			SpecificRate	varchar(30)   '$.SpecificRate'  ,  
			DutyForgon		varchar(30)   '$.DutyForgon'  ,  
			DutyAmount		varchar(30)   '$.DutyAmount'      
		)    


		set @i=@i+1   
	end  
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Cross Apply and Outer apply
	-- CROSS APPLY:
		-- Inner Join Behavior: It acts like an inner join between a table and a table-valued function. 
	-- OUTER APPLY:
		-- Left Join Behavior: It acts like a left join between a table and a table-valued function.
	Declare @Json varchar(max)
	set @json ='{
	    "lstSTNDetail": [ 
	        {
	            "SNO": "7",
	            "DESCRIPTIONOFGOODS": "Comfyable Puffy Laptop Sl..., 13 in 14 in Cover, Pink",
	            "FNSKU": "X001YYUHW5",
	            "ASIN": "B0BWRQRXKS",
	            "MRP": "4999",
	            "QTY": "8",
	            "BOXNO": "5",
	            "WEIGHTQTY": "16.1",
	            "MERCHANTSKU": "LS-LJJ-80-13-A-1"
	        },
	        {
	            "SNO": "8",
	            "DESCRIPTIONOFGOODS": "Comfyable Puffy Laptop Sl... 14 Inch, Neutral, Orange",
	            "FNSKU": "X001YYQGGB",
	            "ASIN": "B0BHW3MP7J",
	            "MRP": "4999",
	            "QTY": "8",
	            "BOXNO": "5",
	            "WEIGHTQTY": "16.1",
	            "MERCHANTSKU": "LS-LJJ-62-13-A-1"
	        }
	    ],
	    "SHIPFROM": "V28063779",
	    "SHIPTO":"2",
	    "GSTIN": "29AAFCV5265N1ZK",
	    "APPOINTMENTID": "",
	    "SHIPMENTID": "FBA15HW9S335",
	    "TIMEDATE": "15-03-2024 00:00:00"
	}'
        INSERT INTO Amazon.STNHeader (CompanyId,InvoiceHeaderID,CreatedBy,CreatedDate
	,SHIPFROM, SHIPTO, GSTIN, APPOINTMENTID, SHIPMENTID, TIMEDATE)
	SELECT  @CompanyId CompanyId, @InvoiceHeaderID InvoiceHeaderID,@LoginId CreatedBy,getdate() CreatedDate  
	,SHIPFROM, SHIPTO, GSTIN, APPOINTMENTID, SHIPMENTID, TIMEDATE
	FROM OPENJSON(@json)
	WITH (
		SHIPFROM		VARCHAR(500) '$.SHIPFROM',
		SHIPTO			VARCHAR(500) '$.SHIPTO',
		GSTIN			VARCHAR(500) '$.GSTIN',
		APPOINTMENTID	VARCHAR(500) '$.APPOINTMENTID',
		SHIPMENTID		VARCHAR(500) '$.SHIPMENTID',
		TIMEDATE		VARCHAR(500) '$.TIMEDATE' 
	);

	declare @STNHeaderId bigint
	set @STNHeaderId=SCOPE_IDENTITY() 

	INSERT INTO Amazon.STNDetail (STNHeaderId,CompanyId
	,SNO, DESCRIPTIONOFGOODS, FNSKU, ASIN, MRP, QTY, BOXNO, WEIGHTQTY, MERCHANTSKU)
	SELECT distinct @STNHeaderId STNHeaderId,@CompanyId CompanyId
	,SNO, DESCRIPTIONOFGOODS, FNSKU, ASIN, MRP, QTY, BOXNO, WEIGHTQTY, MERCHANTSKU
	FROM OPENJSON(@json)
	OUTER APPLY OPENJSON(@json, '$.lstSTNDetail') 
	WITH (
		SNO					VARCHAR(10) '$.SNO',
		DESCRIPTIONOFGOODS	VARCHAR(500) '$.DESCRIPTIONOFGOODS',
		FNSKU				VARCHAR(500) '$.FNSKU',
		ASIN				VARCHAR(500) '$.ASIN',
		MRP					VARCHAR(500) '$.MRP',
		QTY					VARCHAR(500) '$.QTY',
		BOXNO				VARCHAR(500) '$.BOXNO',
		WEIGHTQTY			VARCHAR(500) '$.WEIGHTQTY',
		MERCHANTSKU			VARCHAR(500) '$.MERCHANTSKU'
	);
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- How to get all jobs names from sql server instance 

	SELECT job_id,sj.name AS jobName  
	,date_created,	date_modified 
	FROM msdb.dbo.sysjobs sj 
	WHERE 1 =1
	and (sj.name LIKE 'citi%')    
