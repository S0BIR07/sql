---Task 1---

CREATE TABLE Groupings (
    Step_Number INT PRIMARY KEY,
    Status VARCHAR(10)
);

-- Insert sample data
INSERT INTO Groupings (Step_Number, Status) VALUES
(1, 'Passed'),
(2, 'Passed'),
(3, 'Passed'),
(4, 'Passed'),
(5, 'Failed'),
(6, 'Failed'),
(7, 'Failed'),
(8, 'Failed'),
(9, 'Failed'),
(10, 'Passed'),
(11, 'Passed'),
(12, 'Passed');

select * from groupings

select
	min(step_number) as min_step_number,
	max(step_number) as max_step_number,
	status,
	count(*) as consecutive_count
from
	(select *,
		row_number() over (order by step_number)-
		row_number() over (partition by status order by step_number) as grp
	from groupings) as groupings
group by status, grp
order by min_step_number

---Task 2---

create table employees_n
(
	employee_id int not null,
	first_name varchar(20) null,
	hire_date date not null
);
INSERT INTO [dbo].[EMPLOYEES_N] ([EMPLOYEE_ID], [FIRST_NAME], [HIRE_DATE]) VALUES
(1, 'John', '1975-06-15'),
(2, 'Alice', '1976-03-10'),
(3, 'Bob',   '1977-09-25'),
(4, 'Jane',  '1979-12-01'),
(5, 'Mike',  '1980-05-17'),
(6, 'Sara',  '1982-07-11'),
(7, 'Tom',   '1983-01-22'),
(8, 'Emma',  '1984-10-09'),
(9, 'David', '1985-11-30'),
(10, 'Lily', '1990-04-20'),
(11, 'Chris','1997-08-14');


select
	year+1-diff as begin_year,
	year-1 as end_year
from
	(select
		year(hire_date) as year,
		year(hire_date)-lag(year(hire_date), 1, year(hire_date)) over(order by year(hire_date)) as diff
	from employees_n) as t
where diff>1
