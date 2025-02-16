drop  TABLE XMLMappingConfig
go
CREATE TABLE XMLMappingConfig (
    XMLField	VARCHAR(100),
    XMLNodePath VARCHAR(250),
    TableName	VARCHAR(100),
    ColumnName	VARCHAR(100)
);
go 
INSERT INTO XMLMappingConfig (XMLField,XMLNodePath, TableName, ColumnName) VALUES 
('CatalogueID', '/root/data','CatalogueHeader', 'CatalogueID'),
('CatalogueNumber','/root/data', 'CatalogueHeader', 'CatalogueNumber'),
('CatalogueDate', '/root/data','CatalogueHeader', 'CatalogueDate'),
('CatalogueID','/root/data/lstCatalogueHistory', 'CatalogueDetail', 'CatalogueID'),
('CatalogueStatus', '/root/data/lstCatalogueHistory','CatalogueDetail', 'Catalogue_Status'),
('Remarks','/root/data/lstCatalogueHistory', 'CatalogueDetail', 'Remarks_');
go
drop  TABLE CatalogueHeader
go
CREATE TABLE CatalogueHeader(
	[CatalogueID] [bigint] NULL,
	[CatalogueNumber] [varchar](100) NULL,
	[CatalogueDate] [datetime] NULL
) ON [PRIMARY]
go
drop  TABLE CatalogueDetail
go
CREATE TABLE CatalogueDetail(
	[CatalogueID] [bigint] NULL,
	[Catalogue_Status] [varchar](100) NULL,
	[Remarks_] [varchar](500) NULL
)