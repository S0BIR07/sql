create database lesson_3
go
use lesson_3

CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Department VARCHAR(50),
    Salary DECIMAL(10,2),
    HireDate DATE
);

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(100),
    OrderDate DATE,
    TotalAmount DECIMAL(10,2),
    Status VARCHAR(20) CHECK (Status IN ('Pending', 'Shipped', 'Delivered', 'Cancelled'))
);

CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    Price DECIMAL(10,2),
    Stock INT
);

INSERT INTO Employees (EmployeeID, FirstName, LastName, Department, Salary, HireDate)
VALUES
(1, 'John', 'Doe', 'Sales', 50000.00, '2022-01-15'),
(2, 'Jane', 'Smith', 'Marketing', 60000.00, '2021-07-22'),
(3, 'Alice', 'Johnson', 'IT', 70000.00, '2020-03-11'),
(4, 'Bob', 'Williams', 'HR', 45000.00, '2023-02-20'),
(5, 'Emily', 'Brown', 'Finance', 55000.00, '2019-06-10'),
(6, 'Michael', 'Davis', 'Sales', 52000.00, '2020-11-05'),
(7, 'Sarah', 'Miller', 'Marketing', 65000.00, '2021-01-12'),
(8, 'David', 'Garcia', 'IT', 72000.00, '2022-04-25'),
(9, 'Laura', 'Martinez', 'HR', 47000.00, '2023-03-15'),
(10, 'James', 'Wilson', 'Sales', 49000.00, '2021-05-17'),
(11, 'Olivia', 'Moore', 'Finance', 58000.00, '2020-08-09'),
(12, 'Daniel', 'Taylor', 'Marketing', 61000.00, '2022-12-01'),
(13, 'Sophia', 'Anderson', 'IT', 75000.00, '2021-09-10'),
(14, 'Matthew', 'Thomas', 'HR', 46000.00, '2023-01-22'),
(15, 'Chloe', 'Jackson', 'Sales', 53000.00, '2019-10-30');

INSERT INTO Orders (OrderID, CustomerName, OrderDate, TotalAmount, Status)
VALUES
(101, 'Mary Brown', '2025-04-01', 250.75, 'Pending'),
(102, 'James Wilson', '2025-04-02', 320.50, 'Shipped'),
(103, 'Linda Davis', '2025-04-03', 100.00, 'Delivered'),
(104, 'Robert Miller', '2025-04-04', 145.25, 'Cancelled'),
(105, 'Jessica White', '2025-04-05', 200.00, 'Pending'),
(106, 'George Harris', '2025-04-06', 275.50, 'Shipped'),
(107, 'Patricia Clark', '2025-04-07', 150.00, 'Delivered'),
(108, 'Daniel Lewis', '2025-04-08', 500.75, 'Pending'),
(109, 'Mary Wilson', '2025-04-09', 350.00, 'Cancelled'),
(110, 'William Young', '2025-04-10', 180.00, 'Shipped'),
(111, 'Elizabeth King', '2025-04-11', 270.25, 'Delivered'),
(112, 'Michael Scott', '2025-04-12', 400.00, 'Pending'),
(113, 'Emma Green', '2025-04-13', 125.00, 'Shipped'),
(114, 'Liam Adams', '2025-04-14', 550.00, 'Cancelled'),
(115, 'Ava Nelson', '2025-04-15', 80.00, 'Delivered');

INSERT INTO Products (ProductID, ProductName, Category, Price, Stock)
VALUES
(1, 'Laptop', 'Electronics', 1200.00, 50),
(2, 'Smartphone', 'Electronics', 800.00, 200),
(3, 'Desk Chair', 'Furniture', 150.00, 30),
(4, 'Coffee Mug', 'Accessories', 12.50, 500),
(5, 'Wireless Mouse', 'Accessories', 25.00, 150),
(6, 'Keyboard', 'Accessories', 45.00, 100),
(7, 'Monitor', 'Electronics', 350.00, 75),
(8, 'Headphones', 'Electronics', 120.00, 180),
(9, 'Tablet', 'Electronics', 600.00, 120),
(10, 'Printer', 'Electronics', 200.00, 60),
(11, 'Wrist Watch', 'Accessories', 150.00, 250),
(12, 'Backpack', 'Accessories', 40.00, 300),
(13, 'Office Desk', 'Furniture', 200.00, 40),
(14, 'Air Conditioner', 'Home Appliances', 500.00, 20),
(15, 'Electric Kettle', 'Home Appliances', 30.00, 150);


--Task 1: Employee Salary Report

select top 10 percent * from Employees
order by Salary desc;

select AVG(salary) as avrg, Department
from Employees
group by Department;

--Doing without IIF or Case
select *, 'High' as SalaryCategory from Employees
where Salary>80000
select *, 'Medium' as SalaryCategory from Employees
where Salary>50000 and salary<=80000
select *, 'Low' as SalaryCategory from Employees
where Salary<=50000;

--Doing with Case
select *,
	case when Salary>80000 then 'High'
		 when Salary>50000 and Salary<=80000 then 'Medium'
		 when Salary<=50000 and Salary>0 then 'Low'
	end as SalaryCategory
from Employees;

--Doing with IIF()
select *,
	iif(Salary>80000, 'High', 
		iif(Salary>50000, 'MEdium', 
			iif(Salary>0, 'Low', null)
			)
		) as SalaryCategory
from Employees;

select AVG(salary) as avrg, Department
from Employees
group by Department
order by avrg desc;

select * from Employees
order by EmployeeID
offset 2 rows
fetch next 5 rows only;


--Task 2: Customer Order Insights

select * from Orders
where OrderDate between '2023-01-01' and '2023-12-31';
--to check whether my query works or not
update Orders
set OrderDate='2023-04-22'
where OrderID=103;

--we need rename column Status to [Status], because Status gives error when we use it
exec sp_rename 'Orders.Status', '[Status]', 'column';
--now we can create new column
alter table Orders
add OrderStatus as
	case
		when [Status]='Shipped' or Status='Delivered' then 'Completed'
		when [Status]='Pending' then 'Pending'
		when [Status]='Cancelled' then 'Cancelled'
	end;

select OrderStatus, count(*) as TotalOrders, sum(TotalAmount) as TotalRevenue
from Orders
where sum(TotalAmount)>5000
group by OrderStatus
order by TotalRevenue desc;


--Task 3: Product Inventory Check
select distinct Category from Products;

select max(price), category from Products
group by Category;

alter table Products
add InventoryStatus as
	iif(Stock=0, 'Out of Stock', 
		iif(Stock between 1 and 10, 'Low Stock', 'In Stock'))

select * from Products
order by Price desc
offset 5 rows;