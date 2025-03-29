use lesson_1


--1. NOT NULL Constraint
IF OBJECT_ID('student') IS NULL
begin
	CREATE TABLE student(
		id INT,
		name NVARCHAR(255),
		age INT
	);

	ALTER TABLE student
	ALTER COLUMN id INT NOT NULL;

end


--2. UNIQUE Constraint
IF OBJECT_ID('product') IS NULL
begin
	CREATE TABLE product(
		product_id INT UNIQUE,
		product_name NVARCHAR(255),
		price DECIMAL
	);

	ALTER TABLE product
	DROP CONSTRAINT product_id;

	ALTER TABLE product
	ADD CONSTRAINT product_id_unique UNIQUE (product_id);

	ALTER TABLE product
	ADD CONSTRAINT product_id_product_name_unique UNIQUE (product_id, product_name);

end


--3. PRIMARY KEY Constraint
IF OBJECT_ID('orders') IS NULL
begin
	CREATE TABLE orders(
		order_id INT NOT NULL PRIMARY KEY,
		customer_name NVARCHAR(255),
		order_date DATE
	);

	ALTER TABLE orders
	DROP CONSTRAINT order_id;

	ALTER TABLE orders
	ADD CONSTRAINT order_id_primary PRIMARY KEY (order_id);

end


--4. FOREIGN KEY Constraint
IF OBJECT_ID('category') IS NULL
begin
	CREATE TABLE category(
		category_id INT NOT NULL PRIMARY KEY,
		category_name NVARCHAR(255),
	);
end

IF OBJECT_ID('item') IS NULL
begin
	CREATE TABLE item(
		item_id INT NOT NULL PRIMARY KEY,
		item_name NVARCHAR(255),
		category_id INT FOREIGN KEY REFERENCES category(category_id)
	);

	ALTER TABLE item
	DROP CONSTRAINT category_id;

	ALTER TABLE item
	ADD FOREIGN KEY (category_id) REFERENCES category(category_id);

end


--5. CHECK Constraint
IF OBJECT_ID('account') IS NULL
begin
	CREATE TABLE account(
		account_id INT NOT NULL PRIMARY KEY,
		balance DECIMAL CHECK (balance>=0),
		account_type NVARCHAR(255) CHECK(account_type='Saving' OR account_type='Checking')
	);

	ALTER TABLE account
	DROP CONSTRAINT balance;

	ALTER TABLE account
	DROP CONSTRAINT account_type;

	ALTER TABLE account
	ADD CHECK (balance>=0);

	ALTER TABLE account
	ADD CHECK(account_type='Saving' OR account_type='Checking');

end


--6. DEFAULT Constraint
IF OBJECT_ID('customer') IS NULL
begin
	CREATE TABLE customer(
		customer_id INT NOT NULL PRIMARY KEY,
		name NVARCHAR(MAX),
		city NVARCHAR(MAX) DEFAULT 'Unknown'
	);

	ALTER TABLE customer
	DROP CONSTRAINT DF_customer_city;

	ALTER TABLE customer
	ADD CONSTRAINT DF_customer_city
	DEFAULT 'Unknown' FOR city;

end


--7. IDENTITY Column
IF OBJECT_ID('invoice') IS NULL
begin
	CREATE TABLE invoice(
		invoice_id INT IDENTITY(1,1),
		amount DECIMAL,
	);

	INSERT INTO invoice (amount)
	VALUES (1), (2), (3), (4), (5)

	SET IDENTITY_INSERT invoice ON
	INSERT INTO invoice (invoice_id, amount) VALUES (100, 250.00);
	SET IDENTITY_INSERT invoice OFF

end


--8. All at once
IF OBJECT_ID('books') IS NULL
begin
	CREATE TABLE books(
		book_id INT PRIMARY KEY IDENTITY(1,1),
		title NVARCHAR(255) NOT NULL,
		price DECIMAL CHECK(price>0),
		genre NVARCHAR(MAX) DEFAULT 'Unknown'
	);
end


--9. Scenario: Library Management System
IF OBJECT_ID('book') IS NULL
begin
	CREATE TABLE book(
		book_id INT PRIMARY KEY IDENTITY(1,1),
		title TEXT,
		author TEXT,
		published_year INT
	);
	INSERT INTO book(title, author, published_year)
	VALUES
		('Harry Potter', 'Joe Rouling', 1997),
		('Death on the Nile', 'Agatha Christie', 1920),
		('The green mile', 'Steven King', 1996)
end

IF OBJECT_ID('member') IS NULL
begin
	CREATE TABLE member(
		member_id INT PRIMARY KEY,
		name TEXT,
		email TEXT,
		phone_number TEXT
	);
	INSERT INTO member
	VALUES
		(1, 'Sobir', 'sobir@email.com', '977777777'),
		(2, 'Kamron', 'kamron@email.com', '955555555'),
		(3, 'Doniyor', 'doniyor@email.com', '9999999999')
end

IF OBJECT_ID('loan') IS NULL
begin
	CREATE TABLE loan(
		loan_id INT PRIMARY KEY,
		book_id INT FOREIGN KEY REFERENCES book(book_id),
		member_id INT FOREIGN KEY REFERENCES member(member_id),
		loan_date DATE,
		return_date DATE
	);
	INSERT INTO loan
	VALUES
		(1, 1, 1, 2025-01-01, 2025-03-01),
		(2, 2, 2, 2025-03-01, 2025-03-21),
		(3, 3, 3, 2025-01-01, NULL)
end