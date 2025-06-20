--Puzzle 1: The Shifting Employees
﻿CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    Name VARCHAR(100),
    Department VARCHAR(50),
    Salary DECIMAL(10, 2)
);
go
INSERT INTO Employees (EmployeeID, Name, Department, Salary) VALUES
(1, 'Alice', 'HR', 5000),
(2, 'Bob', 'IT', 7000),
(3, 'Charlie', 'Sales', 6000),
(4, 'David', 'HR', 5500),
(5, 'Emma', 'IT', 7200);


-- swap departments --  HR → IT → Sales → HR

update employees
set department = case 
	when department = 'HR' then 'IT'
	when department = 'IT' then 'Sales'
	when department = 'Sales' then 'HR'
end

drop table if exists #EmployeeTransfers

select * 
into #EmployeeTransfers
from employees

select * from #EmployeeTransfers


--Puzzle 2: The Missing Orders
CREATE TABLE Orders_DB1 (
    OrderID       INT         PRIMARY KEY,
    CustomerName  VARCHAR(100) NOT NULL,
    Product       VARCHAR(100) NOT NULL,
    Quantity      INT          NOT NULL
);

INSERT INTO Orders_DB1 (OrderID, CustomerName, Product, Quantity) VALUES
(101, 'Alice',   'Laptop',  1),
(102, 'Bob',     'Phone',   2),
(103, 'Charlie', 'Tablet',  1),
(104, 'David',   'Monitor', 1);



CREATE TABLE Orders_DB2 (
    OrderID       INT         PRIMARY KEY,
    CustomerName  VARCHAR(100) NOT NULL,
    Product       VARCHAR(100) NOT NULL,
    Quantity      INT          NOT NULL
);

INSERT INTO Orders_DB2 (OrderID, CustomerName, Product, Quantity) VALUES
(101, 'Alice',   'Laptop', 1),
(103, 'Charlie', 'Tablet', 1);


--- declare table variable
declare @MissingOrders table (
	OrderID       INT         PRIMARY KEY,
    CustomerName  VARCHAR(100) NOT NULL,
    Product       VARCHAR(100) NOT NULL,
    Quantity      INT          NOT NULL
)
--- insert the missing orders into table variable
insert into @MissingOrders
select t1.* from Orders_DB1 t1
left join Orders_DB2 t2
on t1.OrderID = t2.OrderID
where t2.orderid is null

select * from @MissingOrders


--Puzzle 3: The Unbreakable View
CREATE TABLE WorkLog (
    EmployeeID     INT,
    EmployeeName   VARCHAR(100),
    Department     VARCHAR(50),
    WorkDate       DATE,
    HoursWorked    INT,
    PRIMARY KEY (EmployeeID, WorkDate)
);


INSERT INTO WorkLog (EmployeeID, EmployeeName, Department, WorkDate, HoursWorked) VALUES
(1, 'Alice',   'HR',    '2024-03-01', 8),
(2, 'Bob',     'IT',    '2024-03-01', 9),
(3, 'Charlie', 'Sales', '2024-03-02', 7),
(1, 'Alice',   'HR',    '2024-03-03', 6),
(2, 'Bob',     'IT',    '2024-03-03', 8),
(3, 'Charlie', 'Sales', '2024-03-04', 9);



create view vw_TotalHoursWorked as
select EmployeeID, EmployeeName, Department,
	sum(hoursworked) as TotalHoursWorked
from worklog
group by employeeid, employeename, department;

create view vw_TotalHoursDepartment as
select department,
	sum(hoursworked) as TotalHoursDepartment
from worklog
group by department;

create view vw_AvgHoursDepartment as
select department,
	avg(hoursworked) as AvgHoursDepartment
from worklog
group by department;


select * from vw_TotalHoursWorked
select * from vw_TotalHoursDepartment
select * from vw_AvgHoursDepartment