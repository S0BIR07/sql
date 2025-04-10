--Task 1
CREATE TABLE [dbo].[TestMultipleZero]
(
    [A] [int] NULL,
    [B] [int] NULL,
    [C] [int] NULL,
    [D] [int] NULL
);
GO

INSERT INTO [dbo].[TestMultipleZero](A,B,C,D)
VALUES 
    (0,0,0,1),
    (0,0,1,0),
    (0,1,0,0),
    (1,0,0,0),
    (0,0,0,0),
    (1,1,1,0);

SELECT *
FROM [dbo].[TestMultipleZero]
WHERE NOT ([A] = 0 AND [B] = 0 AND [C] = 0 AND [D] = 0);


--Task 2
CREATE TABLE TestMax
(
    Year1 INT
    ,Max1 INT
    ,Max2 INT
    ,Max3 INT
);
GO
 
INSERT INTO TestMax 
VALUES
    (2001,10,101,87)
    ,(2002,103,19,88)
    ,(2003,21,23,89)
    ,(2004,27,28,91);

select Year1, greatest(Max1,Max2,Max3) as [Max] from TestMax


--Task 3
CREATE TABLE EmpBirth
(
    EmpId INT  IDENTITY(1,1) 
    ,EmpName VARCHAR(50) 
    ,BirthDate DATETIME 
);
 
INSERT INTO EmpBirth(EmpName,BirthDate)
SELECT 'Pawan' , '12/04/1983'
UNION ALL
SELECT 'Zuzu' , '11/28/1986'
UNION ALL
SELECT 'Parveen', '05/07/1977'
UNION ALL
SELECT 'Mahesh', '01/13/1983'
UNION ALL
SELECT'Ramesh', '05/09/1983';

select * from EmpBirth
where BirthDate between 
	datefromparts(year(Birthdate), 5, 7) and
	datefromparts(year(Birthdate), 5, 15);


--Task 4
create table letters
(letter char(1));

insert into letters
values ('a'), ('a'), ('a'), 
  ('b'), ('c'), ('d'), ('e'), ('f');

select letter from letters
order by
	case
		when letter='b' then 0 -- letter b comes first
		else 1	
	end,
	letter;

select letter from letters
order by
	case	
		when letter='b' then 1
		else 0
	end,
	letter;

WITH NumberedLetters AS (
SELECT letter, ROW_NUMBER() OVER (ORDER BY letter) AS rn
FROM letters
)

SELECT letter
FROM NumberedLetters
ORDER BY
    CASE
        WHEN rn < 3 THEN 1   -- First two letters stay in place
        WHEN letter = 'b' THEN 2  -- 'b' is forced to the 3rd position
        ELSE 3               -- Other letters come after
    END,
    letter; -- Ensure remaining letters are sorted naturally