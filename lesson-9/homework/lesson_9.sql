---1---
with EmployeeDepth as (
	select employeeid,
		   managerid,
		   jobtitle,
		   0 as depth
	from employees
	where managerid is null
	union all
	select e.employeeid,
		e.managerid,
		e.jobtitle,
		d.depth+1
	from employees e
	join employeedepth d on e.managerid=d.employeeid
)
select * from employeedepth

---2---
select
	row_number() over(order by(select null)) as Num
into nums
from string_split(replicate(',', 9), ',')

with cte as (
	select num,
		cast(1 as bigint) as fct
	from nums
	where num=1
	union all
	select f.num,
		cte.fct * f.num as fct
	from nums as f
	join cte on f.num=cte.num+1
) select * from cte

---3---
with cte2 as(
	select 1 as num,
		cast(1 as bigint) as fib,
		cast(1 as bigint) as nextfib
	union all
	select num+1,
		nextfib as fib,
		fib+nextfib as nextfib
	from cte2
	where num<10
) select num, fib from cte2