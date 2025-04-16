create table Employees(
	EmployeeID int,
	Name varchar(50),
	Department varchar(50),
	Salary decimal(10, 2),
	HireDate Date
)
INSERT INTO Employees (EmployeeID, Name, Department, Salary, HireDate) VALUES
(1, 'Alice Johnson', 'Human Resources', 60000.00, '2019-03-15'),
(2, 'Bob Smith', 'Engineering', 85000.00, '2018-07-22'),
(3, 'Charlie Brown', 'Marketing', 58000.00, '2020-01-10'),
(4, 'Diana Prince', 'Engineering', 92000.00, '2017-11-05'),
(5, 'Evan Davis', 'Finance', 73000.00, '2021-05-30'),
(6, 'Fiona Lee', 'Sales', 67000.00, '2020-08-12'),
(7, 'George Harris', 'Engineering', 88000.00, '2016-06-25'),
(8, 'Hannah Kim', 'Design', 62000.00, '2022-02-14'),
(9, 'Ian Thompson', 'Sales', 69000.00, '2019-09-03'),
(10, 'Julia Martinez', 'Finance', 75000.00, '2018-12-18');
select * from Employees

--- 1 ---
select 
	*,
	rank() over(order by salary desc) as salary_rank
from Employees

--- 2 ---
select
	salary_rank, count(*) as [count]
from (
	select rank() over(order by salary) as salary_rank
	from Employees
) as t
group by salary_rank
having count(*)>1

--- 3 ---
select top 2 *,
	rank() over(order by salary desc) as salary_rank
from Employees
order by salary_rank

--- 4 ---
select *
from (
	select *,rank() over(partition by department order by salary asc) as salary_rank
	from Employees
) as t
where salary_rank=1

--- 5 ---
select 
	department,
	sum(salary)
from Employees
group by department

--- 6 ---
select
	distinct department,
	sum(salary) over(partition by department) as total_salary
from Employees

--- 7 ---
select
	distinct department,
	cast(avg(salary) over(partition by department) as decimal(10,2)) as average_salary
from Employees

--- 8 ---
select
	*,
	abs(cast(avg(salary) over(partition by department)-salary as decimal(10,2))) as [difference]
from Employees

--- 9 ---
select
	*,
	cast(avg(salary) over(order by EmployeeID rows between 1 preceding and 1 following) as decimal(10,2)) as average
from Employees

--- 10 ---
select
	distinct sum(salary) over()
from (
	select 
		salary,
		rank() over(order by hiredate desc) as date_rank
	from Employees) as t
where date_rank <=3

select * from Employees
order by hiredate desc

--- 11 ---
select
	*,
	sum(salary) over(order by employeeid) as total
from Employees

--- 12 ---
select
	*,
	max(salary) over(order by employeeid rows between 2 preceding and 2 following) as max_salary
from Employees

--- 13 ---
select
	*,
	cast(salary * 100 /sum(salary) over(partition by department) as decimal(10,2)) as contribution
from Employees