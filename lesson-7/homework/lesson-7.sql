CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(100)
);

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    OrderDate DATE
);

CREATE TABLE OrderDetails (
    OrderDetailID INT PRIMARY KEY,
    OrderID INT FOREIGN KEY REFERENCES Orders(OrderID),
    ProductID INT,
    Quantity INT,
    Price DECIMAL(10,2)
);

CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Category VARCHAR(50)
);

INSERT INTO Customers (CustomerID, CustomerName)
VALUES 
    (1, 'Alice Johnson'),
    (2, 'Bob Smith'),
    (3, 'Charlie Lee'),
    (4, 'Diana Prince'),
    (5, 'Ethan Clark');


INSERT INTO Products (ProductID, ProductName, Category)
VALUES 
    (101, 'Laptop', 'Electronics'),
    (102, 'Desk Chair', 'Furniture'),
    (103, 'Smartphone', 'Electronics'),
    (104, 'Bookshelf', 'Furniture'),
    (105, 'Headphones', 'Electronics'),
    (106, 'Monitor', 'Electronics'),
    (107, 'Keyboard', 'Electronics'),
    (108, 'Office Desk', 'Furniture');


INSERT INTO Orders (OrderID, CustomerID, OrderDate)
VALUES 
    (1001, 1, '2025-04-10'),
    (1002, 2, '2025-04-09'),
    (1003, 3, '2025-04-08'),
    (1004, 1, '2025-04-07'),
    (1005, 4, '2025-04-06'),
    (1006, 5, '2025-04-05'),
    (1007, 3, '2025-04-04');


INSERT INTO OrderDetails (OrderDetailID, OrderID, ProductID, Quantity, Price)
VALUES 
    (1, 1001, 101, 1, 1200.00),
    (2, 1001, 105, 2, 100.00),
    
    (3, 1002, 102, 1, 150.00),
    (4, 1002, 104, 1, 80.00),

    (5, 1003, 103, 2, 900.00),
    (6, 1003, 107, 1, 40.00),

    (7, 1004, 105, 1, 50.00),

    (8, 1005, 108, 1, 250.00),
    (9, 1005, 106, 2, 180.00),

    (10, 1006, 103, 1, 450.00),
    (11, 1006, 107, 1, 40.00),
    
    (12, 1007, 101, 1, 1200.00),
    (13, 1007, 102, 1, 150.00),
    (14, 1007, 104, 1, 80.00);


---1---

select c.customername, p.productname
from customers as c 
left join orders on c.customerid=orders.customerid
left join orderdetails on orders.orderid=orderdetails.orderid
left join products as p on orderdetails.productid=p.productid

---2---

select c.customername
from customers as c
left join orders on c.customerid=orders.customerid
where orders.orderid is null

---3---

select orders.orderid, products.productname, orderdetails.quantity
from orders
join orderdetails on orders.orderid=orderdetails.orderid
join products on products.productid=orderdetails.productid

---4---

select distinct c.customername
from customers as c
join orders on c.customerid=orders.customerid
join orderdetails on orders.orderid=orderdetails.orderid
join products on orderdetails.productid=products.productid
where orderdetails.quantity>1

---5---

select productname, price
from (
	select products.productname, price,
		row_number() over(partition by orderdetails.orderid order by price desc) as rn
		from orderdetails
		join products on orderdetails.productid=products.productid) as t
where rn=1

---6---

select customername, orderid
from (select customers.customername, orders.orderid,
	row_number() over(partition by customers.customerid order by orderdate desc) as rn
	from customers
	join orders on customers.customerid=orders.customerid) as t
where rn=1

---7---

select c.customername
from customers as c
join orders as o on c.customerid=o.customerid
join orderdetails as od on o.orderid=od.orderid
join products as p on od.productid=p.productid
group by c.customerid, c.customername
having count(distinct case when p.category <> 'Electronics' then p.category end) =0;

---8---

select distinct c.customername, p.category
from customers as c
join orders as o on c.customerid=o.customerid
join orderdetails as od on o.orderid=od.orderid
join products as p on od.productid=p.productid
where p.category='Stationery'

---9---

select distinct c.customerid, c.customername, 
sum(price) over(partition by c.customername) as TotalSpent
from customers as c
join orders as o on c.customerid=o.customerid
join orderdetails as od on od.orderid=o.orderid