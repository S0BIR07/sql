-- Create Departments table
CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(100) NOT NULL
);

-- Create Employees table
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    DepartmentID INT,
    Salary DECIMAL(10, 2)
);

-- Create Projects table
CREATE TABLE Projects (
    ProjectID INT PRIMARY KEY,
    ProjectName VARCHAR(100) NOT NULL,
    EmployeeID INT
);
-- Insert data into Departments
INSERT INTO Departments (DepartmentID, DepartmentName) VALUES
(101, 'IT'),
(102, 'HR'),
(103, 'Finance'),
(104, 'Marketing');

-- Insert data into Employees
INSERT INTO Employees (EmployeeID, Name, DepartmentID, Salary) VALUES
(1, 'Alice', 101, 60000),
(2, 'Bob', 102, 70000),
(3, 'Charlie', 101, 65000),
(4, 'David', 103, 72000),
(5, 'Eva', NULL, 68000);

-- Insert data into Projects
INSERT INTO Projects (ProjectID, ProjectName, EmployeeID) VALUES
(1, 'Alpha', 1),
(2, 'Beta', 2),
(3, 'Gamma', 1),
(4, 'Delta', 4),
(5, 'Omega', NULL);

---1---
select e.name as e_name, d.DepartmentName as d_name
from Employees as e inner join Departments as d
	on e.DepartmentID=d.DepartmentID

---2---
select e.name, d.DepartmentName
from Employees as e left join Departments as d
	on e.DepartmentID = d.DepartmentID

---3---
select e.name, d.DepartmentName
from Employees as e right join Departments as d
	on e.DepartmentID = d.DepartmentID

---4---
select e.name, d.DepartmentName
from Employees as e full outer join Departments as d
	on e.DepartmentID = d.DepartmentID

---5---
select d.DepartmentName,
	sum(e.salary) over(partition by e.departmentid) as total_salary
from employees as e right join departments as d
	on e.DepartmentID = d.DepartmentID

---6---
select p.projectname, d.departmentname
from projects as p cross join departments as d

---7---
select e.name, d.departmentname, p.projectname
from 
employees as e inner join departments as d 
	on e.departmentid = d.departmentid
left join projects as p
	on e.employeeid = p.employeeid 