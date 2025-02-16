 

DECLARE @XMLData XML = 
N' 
<root>
    <data>
         <CatalogueID>114475</CatalogueID>
         <CatalogueNumber>XCN37567936</CatalogueNumber>
         <CatalogueDate>2025-02-12T06:36:17.680</CatalogueDate>
         <Seller_CatalogueStatus>Under Review</Seller_CatalogueStatus>
         <Custom_CatalogueStatus>New</Custom_CatalogueStatus>
         <IOR_CatalogueStatus>Under Review</IOR_CatalogueStatus>
         <EOR_CatalogueStatus>Under Review</EOR_CatalogueStatus> 
         <CatalogueDetailID>119934</CatalogueDetailID>
         <CountryID>47</CountryID>
         <CountryName>China</CountryName> 
         <SKU>IN-FY-11-Indigo-PJQ</SKU> 
         <lstCatalogueHistory>
             <CatalogueID>114475</CatalogueID>
             <CatalogueStatus>New</CatalogueStatus>
             <Remarks>Newly Added</Remarks>
             <LastModifiedByName>624983179</LastModifiedByName>
             <LastModifiedDate>2025-02-12T06:36:17.680</LastModifiedDate>
         </lstCatalogueHistory>
         <ReferenceId></ReferenceId>
    </data>
</root>';
 
 DELETE FROM CatalogueHeader;
DELETE FROM CatalogueDetail;

DECLARE @TableName NVARCHAR(100), @ColumnName NVARCHAR(100), @XMLField NVARCHAR(100);
DECLARE @SQL NVARCHAR(MAX), @ColumnList NVARCHAR(MAX), @ValueList NVARCHAR(MAX);
DECLARE @XMLNodePath NVARCHAR(500), @XPath NVARCHAR(500);

-- Cursor to iterate over distinct table names in mapping
DECLARE table_cursor CURSOR FOR 
SELECT DISTINCT TableName FROM XMLMappingConfig;

OPEN table_cursor;
FETCH NEXT FROM table_cursor INTO @TableName;

WHILE @@FETCH_STATUS = 0
BEGIN
    SET @ColumnList = '';
    SET @ValueList = '';

    -- Cursor to iterate over columns for each table
    DECLARE column_cursor CURSOR FOR 
    SELECT XMLField, ColumnName, XMLNodePath FROM XMLMappingConfig WHERE TableName = @TableName;

    OPEN column_cursor;
    FETCH NEXT FROM column_cursor INTO @XMLField, @ColumnName, @XMLNodePath;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Construct dynamic XPath from XMLMappingConfig
        SET @XPath = 'x.Data.value(''(' + @XMLField + ')[1]'', ''NVARCHAR(MAX)'')';

        SET @ColumnList = @ColumnList + QUOTENAME(@ColumnName) + ', ';
        SET @ValueList = @ValueList + @XPath + ', ';

        FETCH NEXT FROM column_cursor INTO @XMLField, @ColumnName, @XMLNodePath;
    END;

    CLOSE column_cursor;
    DEALLOCATE column_cursor;

    -- Remove last comma
    IF LEN(@ColumnList) > 0 
    BEGIN
        SET @ColumnList = LEFT(@ColumnList, LEN(@ColumnList) - 1);
        SET @ValueList = LEFT(@ValueList, LEN(@ValueList) - 1);

        -- Construct dynamic SQL with correct XMLNodePath
        SET @SQL = '
        INSERT INTO ' + @TableName + ' (' + @ColumnList + ')
        SELECT ' + @ValueList + '
        FROM @XMLData.nodes(''' + @XMLNodePath + ''') AS x(Data);';

        -- Debugging: Print SQL before execution
        PRINT @SQL;

        -- Execute dynamic SQL
        EXEC sp_executesql @SQL, N'@XMLData XML', @XMLData;
    END

    FETCH NEXT FROM table_cursor INTO @TableName;
END;

CLOSE table_cursor;
DEALLOCATE table_cursor;

-- Check inserted records
SELECT * FROM CatalogueHeader;
SELECT * FROM CatalogueDetail;
