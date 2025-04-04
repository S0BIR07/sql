 --1.DELETE vs TRUNCATE vs DROP (with IDENTITY example)
create database lesson_2
use lesson_2
drop table if exists table_identity
create table test_identity
(
	id int identity(1,1),
	name varchar(50),
	city varchar(50),
	country varchar(50)
);
insert into test_identity (name,city,country)
values
	('Jhon', 'Tashkent', 'Uzbekistan'),
	('Doni', 'Stambul', 'Turkey'),
	('Alex', 'Moscow', 'Russia'),
	('Maks', 'Afina', 'Greece'),
	('Anne', 'Pekin', 'China');
delete from test_identity where name='Alex'  /*deletes specific row in the table by where condition; does not reset identity*/
truncate table table_identity /*deletes all data in table, but not the table itself; resets identity*/
drop table test_identity /*drops/deletes the whole table with all structures and data*/

--2. Common Data Types
drop table if exists data_types_demo
create table data_types_demo
(
	id bigint primary key identity(1,1),
	name varchar(100),
	email nvarchar(100),
	age tinyint,
	saved_money int,
	days_in_century smallint,
	price decimal(10,2),
	calculations float,
	texts ntext,
	birth_date date,
	exam_time time,
	created_datetime datetime,
	transaction_number uniqueidentifier,
	photo_path varchar(100),
	photo varbinary(max)
);
insert into data_types_demo(name, email, age, saved_money, days_in_century, price, calculations, texts, birth_date, exam_time, created_datetime, transaction_number, photo_path, photo)
values
	('Sobir', 'sobir@email.com', 17, 1999888777, 32000, 32.17, 3.1415, 'Text', '2007-06-13', '23:36', getdate(), newid(), 'C:\SQL_Server\sql\sql\lesson-2\Photo_of_space.jpg', (select * from openrowset(bulk 'C:\SQL_Server\sql\sql\lesson-2\Photo_of_space.jpg', single_blob) as img)),
	('Akbar', 'akbar@email.com', 17, 1478252475, 23846, 27.42, 2.7182, 'Text', '2007-06-13', '23:36', getdate(), newid(), 'C:\SQL_Server\sql\sql\lesson-2\Photo_of_space.jpg', (select * from openrowset(bulk 'C:\SQL_Server\sql\sql\lesson-2\Photo_of_space.jpg', single_blob) as img));
select * from data_types_demo;


--3. Inserting and Retrieving an Image
drop table if exists photos;
create table photos
(
    id int primary key identity(1,1),
    photo varbinary(max)
);
insert into photos (photo)
select * from openrowset(bulk 'C:\SQL_Server\sql\sql\lesson-2\Photo_of_space.jpg', single_blob) as img;


--4. Computed Columns
DROP TABLE IF EXISTS student;
CREATE TABLE student
(
    id INT PRIMARY KEY IDENTITY(1,1),
    name VARCHAR(100),
    classes INT,
    tuition_per_class DECIMAL(10, 2),
    total_tuition AS (classes * tuition_per_class)
);
INSERT INTO student (name, classes, tuition_per_class)
VALUES
    ('Alice', 5, 500.00),
    ('Bob', 3, 600.00),
    ('Charlie', 6, 450.00);
SELECT * FROM student;


--5. CSV to SQL Server
DROP TABLE IF EXISTS worker;
CREATE TABLE worker
(
    id INT PRIMARY KEY,
    name VARCHAR(100)
);
BULK INSERT worker
FROM 'C:\SQL_Server\sql\sql\lesson-2\homework\workers.csv'
WITH
(
    FIELDTERMINATOR = '.',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2
);
SELECT * FROM worker;