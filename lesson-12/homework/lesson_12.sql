--Task 1--

create table #temp
(
	DatabaseName varchar(max),
	SchemaName varchar(max),
	TableName varchar(max),
	ColumnName varchar(max),
	DataType varchar(max)
);

create procedure sp_table_info @database_name varchar(max)
as
begin
declare @main_cmd varchar(max)= 
concat('select 
	TABLE_CATALOG as DatabaseName,
	TABLE_SCHEMA as SchemaName,
	TABLE_NAME as TableName,
	COLUMN_NAME as ColumnName,
	DATA_TYPE as DataType
from ',@database_name ,'.information_schema.columns
where TABLE_CATALOG not in (''master'',''tempdb'',''model'',''msdb'')')

insert into #temp
execute(@main_cmd)
end


declare @name varchar(255);
declare @i int=1;
declare @count int;

select @count = count(1)
from sys.databases where name not in ('master', 'tempdb','model','msdb')


while @i<@count
begin
	;with cte as (
		select name, row_number() over(order by name) as rn
		from sys.databases where name not in ('master', 'tempdb', 'model', 'msdb')
	)
	select @name=name from cte
	where rn=@i

	exec sp_table_info @name
	set @i = @i + 1
end

select * from #temp


--Task 2--
create table #temp
(
	SchemaName varchar(max),
	RoutineName varchar(max),
	ParameterName varchar(max),
	DataType varchar(max)
);


create procedure sp_with_parameter @database_name varchar(max)
as
begin
declare @base_query varchar(max)=concat(
'SELECT
    SPECIFIC_SCHEMA AS SchemaName,
    SPECIFIC_NAME AS RoutineName,
    PARAMETER_NAME AS ParameterName,
    concat(DATA_TYPE, ''('', iif (CHARACTER_MAXIMUM_LENGTH<>-1,cast(CHARACTER_MAXIMUM_LENGTH as varchar), ''Max''), '')'') AS DataType
FROM ', @database_name, '.INFORMATION_SCHEMA.PARAMETERS')
exec(@base_query)
end

create procedure sp_without_parameter
as
begin
	declare @name varchar(255);
	declare @i int=1;
	declare @count int;

	select @count = count(1)
	from sys.databases where name not in ('master', 'tempdb','model','msdb')


	while @i<=@count
	begin
		;with cte as (
			select name, row_number() over(order by name) as rn
			from sys.databases where name not in ('master', 'tempdb', 'model', 'msdb')
		)
		select @name=name from cte -- get the database_name
		where rn=@i

		insert into #temp              -- insert the data in the temporary table
		exec sp_with_parameter @name

		set @i = @i + 1 --move to the next database
	end
	select * from #temp
end


exec sp_without_parameter