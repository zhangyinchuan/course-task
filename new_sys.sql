CREATE TABLE Merchants (
    MerchantID INT PRIMARY KEY,
    Name VARCHAR(100)
);

CREATE TABLE Users (
    UserID INT PRIMARY KEY,
    UserName VARCHAR(100)
);

CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Price DECIMAL(10, 2)
);

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    MerchantID INT,
    UserID INT,
    OrderDate DATE,
    FOREIGN KEY (MerchantID) REFERENCES Merchants(MerchantID),
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

CREATE TABLE OrderDetails (
    OrderDetailID INT PRIMARY KEY,
    OrderID INT,
    ProductID INT,
    Quantity INT,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

CREATE TABLE Shipments (
    ShipmentID INT PRIMARY KEY,
    OrderID INT,
    ShipmentDate DATE,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

CREATE TABLE Purchases (
    PurchaseID INT PRIMARY KEY,
    UserID INT,
    ProductID INT,
    PurchaseDate DATE,
    Quantity INT,
    FOREIGN KEY (UserID) REFERENCES Users(UserID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- 示例数据
INSERT INTO Merchants (MerchantID, Name) VALUES (1, 'Merchant A');
INSERT INTO Users (UserID, UserName) VALUES (1, 'User A');
INSERT INTO Products (ProductID, ProductName, Price) VALUES (1, 'Product A', 10.00);

INSERT INTO Orders (OrderID, MerchantID, UserID, OrderDate) VALUES (1, 1, 1, '2024-12-18');
INSERT INTO OrderDetails (OrderDetailID, OrderID, ProductID, Quantity) VALUES (1, 1, 1, 2);

INSERT INTO Shipments (ShipmentID, OrderID, ShipmentDate) VALUES (1, 1, '2024-12-19');
INSERT INTO Purchases (PurchaseID, UserID, ProductID, PurchaseDate, Quantity) VALUES (1, 1, 1, '2024-12-18', 2);
