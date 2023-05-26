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
IF OBJECT_ID(N'API.usp_Send_SingleWATISMS', N'P') IS NOT NULL
BEGIN
	drop proc API.usp_Send_SingleWATISMS
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
-- Checking Foreign Key 
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
IF Not Exists (SELECT 1 FROM sys.indexes  WHERE object_id = OBJECT_ID('Person.Address') AND name='IX_Address_PostalCode')
Begin 
	Drop INDEX IX_Address_PostalCode  
	ON Person.Address  
End
GO
