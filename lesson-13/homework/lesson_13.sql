--Calendar Table Query with Sunday as First Column
create function calendar(@day datetime)
returns @t table
(
	Sunday int,
	Monday int,
	Tuesday int,
	Wednesday int,
	Thursday int,
	Friday int,
	Saturday int
	
)
begin
	with cte as (
		select
			datefromparts(year(@day), month(@day), 1) as date,
			datename(weekday, datefromparts(year(@day), month(@day), 1)) as weekday,
			datepart(weekday, datefromparts(year(@day), month(@day), 1)) as weekdaynum,
			1 as weeknumber
		union all
		select
			dateadd(day, 1, date),
			datename(weekday, dateadd(day, 1, date)),
			datepart(weekday, dateadd(day, 1, date)),
			case 
				when datepart(weekday, dateadd(day, 1, date)) > weekdaynum then weeknumber
				else weeknumber + 1
			end
		from cte
		where date < eomonth(date)	
	)insert into @t
	select
		MAX(case when weekday='Sunday' then DAY(date) end) as Sunday,
		MAX(case when weekday='Monday' then DAY(date) end) as Monday,
		MAX(case when weekday='Tuesday' then DAY(date) end) as Tuesday,
		MAX(case when weekday='Wednesday' then DAY(date) end) as Wednesday,
		MAX(case when weekday='Thursday' then DAY(date) end) as Thursday,
		MAX(case when weekday='Friday' then DAY(date) end) as Friday,
		MAX(case when weekday='Saturday' then DAY(date) end) as Saturday
	from cte
	
return
end
go

select * from calendar(getdate())