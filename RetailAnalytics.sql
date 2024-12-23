-- create database RetailAnalytics;

CREATE TABLE Customers (
    CustomerID INT AUTO_INCREMENT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Gender VARCHAR(10),
    DateOfBirth DATE,
    City VARCHAR(50),
    State VARCHAR(50),
    SignupDate DATE NOT NULL
);
CREATE TABLE Products (
    ProductID INT AUTO_INCREMENT PRIMARY KEY,
    ProductName VARCHAR(100) NOT NULL,
    Category VARCHAR(50),
    Price DECIMAL(10, 2) NOT NULL,
    StockQuantity INT NOT NULL
);
CREATE TABLE Orders (
    OrderID INT AUTO_INCREMENT PRIMARY KEY,
    CustomerID INT NOT NULL,
    OrderDate DATE NOT NULL,
    OrderStatus VARCHAR(20),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);
CREATE TABLE OrderDetails (
    OrderDetailID INT AUTO_INCREMENT PRIMARY KEY,
    OrderID INT NOT NULL,
    ProductID INT NOT NULL,
    Quantity INT NOT NULL,
    TotalPrice DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);


INSERT INTO Customers (CustomerID, FirstName, LastName, Gender, DateOfBirth, City, State, SignupDate)
VALUES
(1, 'Alice', 'Johnson', 'Female', '1990-05-15', 'New York', 'NY', '2021-01-10'),
(2, 'Bob', 'Smith', 'Male', '1985-07-20', 'Los Angeles', 'CA', '2021-02-12'),
(3, 'Charlie', 'Brown', 'Male', '1992-03-25', 'Chicago', 'IL', '2021-03-15'),
(4, 'Diana', 'Prince', 'Female', '1988-11-11', 'Miami', 'FL', '2021-04-18'),
(5, 'Edward', 'Elric', 'Male', '1995-01-01', 'Austin', 'TX', '2021-05-20');


INSERT INTO Products (ProductID, ProductName, Category, Price, StockQuantity)
VALUES
(1, 'Smartphone', 'Electronics', 699.99, 50),
(2, 'Laptop', 'Electronics', 1299.99, 30),
(3, 'Jeans', 'Apparel', 49.99, 100),
(4, 'Headphones', 'Electronics', 199.99, 80),
(5, 'Shoes', 'Apparel', 79.99, 60);


INSERT INTO Orders (OrderID, CustomerID, OrderDate, OrderStatus)
VALUES
(1, 1, '2022-01-15', 'Completed'),
(2, 2, '2022-02-10', 'Completed'),
(3, 3, '2022-03-05', 'Pending'),
(4, 4, '2022-03-15', 'Completed'),
(5, 5, '2022-04-01', 'Canceled');

INSERT INTO OrderDetails (OrderDetailID, OrderID, ProductID, Quantity, TotalPrice)
VALUES
(1, 1, 1, 2, 1399.98),
(2, 3, 3, 1, 49.99),
(3, 2, 2, 1, 1299.99),
(4, 4, 4, 3, 599.97),
(5, 5, 5, 2, 159.98);

SELECT 
    State, COUNT(*) AS CustomerCount
FROM
    Customers
GROUP BY State
ORDER BY CustomerCount DESC
LIMIT 1; 


SELECT 
    SUM(TotalPrice) AS TotalRevenue
FROM
    OrderDetails; 
    
    SELECT 
    p.Category, SUM(od.TotalPrice) AS CategoryRevenue
FROM
    OrderDetails od
        JOIN
    Products p ON od.ProductID = p.ProductID
GROUP BY p.Category
ORDER BY CategoryRevenue DESC
LIMIT 1; 

SELECT 
    (COUNT(CASE
        WHEN OrderStatus = 'Completed' THEN 1
    END) * 100.0 / COUNT(*)) AS CompletedPercentage
FROM
    Orders; 
    
SELECT 
    AVG(TotalPrice) AS AverageOrderValue
FROM
    OrderDetails; 
    
    
    
SELECT 
    c.CustomerID,
    CONCAT(c.FirstName, ' ', c.LastName) AS CustomerName,
    SUM(od.TotalPrice) AS LifetimeValue
FROM
    Customers c
        JOIN
    Orders o ON c.CustomerID = o.CustomerID
        JOIN
    OrderDetails od ON o.OrderID = od.OrderID
WHERE
    o.OrderStatus = 'Completed'
GROUP BY c.CustomerID , c.FirstName , c.LastName
ORDER BY LifetimeValue DESC
LIMIT 5; 

SELECT 
    c.CustomerID,
    CONCAT(c.FirstName, ' ', c.LastName) AS CustomerName
FROM
    Customers c
        LEFT JOIN
    Orders o ON c.CustomerID = o.CustomerID
WHERE
    (o.OrderDate IS NULL
        OR o.OrderDate < CURDATE() - INTERVAL 6 MONTH); 
        
    
SELECT 
    c.CustomerID,
    CONCAT(c.FirstName, ' ', c.LastName) AS CustomerName,
    SUM(od.TotalPrice) AS LifetimeValue
FROM
    Customers c
        JOIN
    Orders o ON c.CustomerID = o.CustomerID
        JOIN
    OrderDetails od ON o.OrderID = od.OrderID
WHERE
    o.OrderStatus = 'Completed'
GROUP BY c.CustomerID , c.FirstName , c.LastName
ORDER BY LifetimeValue DESC
LIMIT 5;

SELECT 
    c.CustomerID,
    CONCAT(c.FirstName, ' ', c.LastName) AS CustomerName,
    SUM(od.TotalPrice) AS LifetimeValue
FROM
    Customers c
        JOIN
    Orders o ON c.CustomerID = o.CustomerID
        JOIN
    OrderDetails od ON o.OrderID = od.OrderID
WHERE
    o.OrderStatus = 'Completed'
GROUP BY c.CustomerID , c.FirstName , c.LastName
ORDER BY LifetimeValue DESC
LIMIT 5; 


SELECT 
    p.ProductID,
    p.ProductName,
    SUM(od.Quantity) AS UnitsSold,
    p.StockQuantity AS CurrentStock,
    (SUM(od.Quantity) / NULLIF(p.StockQuantity + SUM(od.Quantity), 0)) AS InventoryTurnover
FROM
    Products p
        LEFT JOIN
    OrderDetails od ON p.ProductID = od.ProductID
GROUP BY p.ProductID , p.ProductName , p.StockQuantity
ORDER BY InventoryTurnover ASC
LIMIT 1; 


