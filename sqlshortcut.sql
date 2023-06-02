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
	C3 Datetime)
end 
--------------------------------------------------------------------------------------------------------------------------------------
-- Schema checking
IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.columns where TABLE_SCHEMA='Amazon')
begin
	drop table Amazon.InvoiceCourierBillOEntryDetail
end 
--------------------------------------------------------------------------------------------------------------------------------------
-- checking column
IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.columns WHERE table_Name = 'IORExpense' 
and TABLE_SCHEMA='Payment' and COLUMN_NAME='ApprovalStatus')
begin
	alter table Payment.IORExpense
	add ApprovalStatus varchar(20)
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
	inner join sys.schemas s on s.schema_id=t.schema_id where   t.name like '%'+ @tbl +'%'   

end
go
--------------------------------------------------------------------------------------------------------------------------------------
-- Find all tables with schema using sp_t
CREATE proc sp_t  
@tbl varchar(100)  
as  
begin   
    
	select   'select top 3  * from ' +  s.name + '.'+ t.name + ' ORDER BY  1 DESC ' FROM sys.tables as t   
	inner join sys.schemas s on s.schema_id=t.schema_id where   t.name like '%'+ @tbl +'%'   

end
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
CREATE proc SP_I  
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
	SELECT 'INSERT INTO '+ @TABLE_SCHEMA +'.'+ @TABLE_NAME + ' ( ' + STUFF ((SELECT ',', +IIF(ISNUMERIC(SUBSTRING (COLUMN_NAME, 1, 1))=1, '[' +COLUMN_NAME, COLUMN_NAME) + IIF(ISNUMERIC(SUBSTRING (COLUMN_NAME, 1, 1))=1, ']', '') 
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
 

	--SP_U 
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
