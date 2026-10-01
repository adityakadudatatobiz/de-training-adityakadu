RESTORE VERIFYONLY
FROM DISK = 'D:\AdventureWorksLT2022.bak';

SELECT
    SERVERPROPERTY('InstanceDefaultDataPath') AS DataPath,
    SERVERPROPERTY('InstanceDefaultLogPath') AS LogPath;

    RESTORE FILELISTONLY
FROM DISK = 'D:\AdventureWorksLT2022.bak';

RESTORE DATABASE AdventureWorksLT2022
FROM DISK = 'D:\AdventureWorksLT2022.bak'
WITH
    MOVE 'AdventureWorksLT2022_Data'
        TO 'C:\Program Files\Microsoft SQL Server\MSSQL17.SQLEXPRESS\MSSQL\DATA\AdventureWorksLT2022.mdf',
    MOVE 'AdventureWorksLT2022_Log'
        TO 'C:\Program Files\Microsoft SQL Server\MSSQL17.SQLEXPRESS\MSSQL\DATA\AdventureWorksLT2022_log.ldf',
    RECOVERY,
    STATS = 10;

USE AdventureWorksLT2022;
GO

-- Step 1: List all tables in the SalesLT schema
SELECT
    TABLE_SCHEMA,
    TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'SalesLT'
  AND TABLE_TYPE = 'BASE TABLE'
ORDER BY TABLE_NAME;


-- Step 2: Get row count of every SalesLT table
SELECT
    sys.tables.name AS table_name,
    SUM(sys.partitions.rows) AS row_count
FROM sys.tables
JOIN sys.partitions
    ON sys.tables.object_id = sys.partitions.object_id
WHERE sys.tables.schema_id = SCHEMA_ID('SalesLT')
  AND sys.partitions.index_id IN (0, 1)
GROUP BY sys.tables.name
ORDER BY sys.tables.name;


-- Step 3: Find the primary key of each SalesLT table
SELECT
    tc.TABLE_NAME,
    kcu.COLUMN_NAME
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS AS tc
JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE AS kcu
    ON tc.CONSTRAINT_NAME = kcu.CONSTRAINT_NAME
    AND tc.TABLE_SCHEMA = kcu.TABLE_SCHEMA
    AND tc.TABLE_NAME = kcu.TABLE_NAME
WHERE tc.TABLE_SCHEMA = 'SalesLT'
  AND tc.CONSTRAINT_TYPE = 'PRIMARY KEY'
ORDER BY tc.TABLE_NAME;


-- Step 4: Find all foreign keys in SalesLT
SELECT
    child_table.name AS child_table,
    child_column.name AS child_column,
    parent_table.name AS parent_table,
    parent_column.name AS parent_column
FROM sys.foreign_keys AS fk
JOIN sys.foreign_key_columns AS fkc
    ON fk.object_id = fkc.constraint_object_id
JOIN sys.tables AS child_table
    ON fkc.parent_object_id = child_table.object_id
JOIN sys.columns AS child_column
    ON fkc.parent_object_id = child_column.object_id
    AND fkc.parent_column_id = child_column.column_id
JOIN sys.tables AS parent_table
    ON fkc.referenced_object_id = parent_table.object_id
JOIN sys.columns AS parent_column
    ON fkc.referenced_object_id = parent_column.object_id
    AND fkc.referenced_column_id = parent_column.column_id
WHERE OBJECT_SCHEMA_NAME(fk.parent_object_id) = 'SalesLT'
ORDER BY child_table.name;