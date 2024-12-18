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
    Price DECIMAL(10, 2),
    Quantity INT -- Add quantity to the product table
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

CREATE TABLE Couriers (
    CourierID INT PRIMARY KEY,
    CourierName VARCHAR(100)
);

CREATE TABLE Shipments (
    ShipmentID INT PRIMARY KEY,
    OrderID INT,
    CourierID INT,
    ShipmentDate DATE,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (CourierID) REFERENCES Couriers(CourierID)
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

CREATE TABLE OrderLogs (
    LogID INT PRIMARY KEY AUTO_INCREMENT,
    OrderID INT,
    OldMerchantID INT,
    NewMerchantID INT,
    ChangeDate DATETIME,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

-- 示例数据
INSERT INTO Merchants (MerchantID, Name) VALUES (1, 'Merchant A');
INSERT INTO Users (UserID, UserName) VALUES (1, 'User A');
INSERT INTO Products (ProductID, ProductName, Price, Quantity) VALUES (1, 'Product A', 10.00, 100);

INSERT INTO Orders (OrderID, MerchantID, UserID, OrderDate) VALUES (1, 1, 1, '2024-12-18');
INSERT INTO OrderDetails (OrderDetailID, OrderID, ProductID, Quantity) VALUES (1, 1, 1, 2);

INSERT INTO Couriers (CourierID, CourierName) VALUES (1, 'Courier A');
INSERT INTO Shipments (ShipmentID, OrderID, CourierID, ShipmentDate) VALUES (1, 1, 1, '2024-12-19');
INSERT INTO Purchases (PurchaseID, UserID, ProductID, PurchaseDate, Quantity) VALUES (1, 1, 1, '2024-12-18', 2);

-- Triggers
CREATE TRIGGER update_shipment_date
AFTER INSERT ON Orders
FOR EACH ROW
BEGIN
    INSERT INTO Shipments (OrderID, CourierID, ShipmentDate)
    VALUES (NEW.OrderID, 1, DATE_ADD(NEW.OrderDate, INTERVAL 1 DAY));
END;

CREATE TRIGGER update_product_quantity
AFTER INSERT ON Purchases
FOR EACH ROW
BEGIN
    UPDATE Products
    SET Quantity = Quantity - NEW.Quantity
    WHERE ProductID = NEW.ProductID;
END;

CREATE TRIGGER log_order_changes
AFTER UPDATE ON Orders
FOR EACH ROW
BEGIN
    INSERT INTO OrderLogs (OrderID, OldMerchantID, NewMerchantID, ChangeDate)
    VALUES (OLD.OrderID, OLD.MerchantID, NEW.MerchantID, NOW());
END;

-- User roles and permissions
CREATE ROLE manager;
CREATE ROLE customer;

-- Grant permissions to manager
GRANT SELECT, INSERT, UPDATE, DELETE ON Merchants TO manager;
GRANT SELECT, INSERT, UPDATE, DELETE ON Users TO manager;
GRANT SELECT, INSERT, UPDATE, DELETE ON Products TO manager;
GRANT SELECT, INSERT, UPDATE, DELETE ON Orders TO manager;
GRANT SELECT, INSERT, UPDATE, DELETE ON OrderDetails TO manager;
GRANT SELECT, INSERT, UPDATE, DELETE ON Couriers TO manager;
GRANT SELECT, INSERT, UPDATE, DELETE ON Shipments TO manager;
GRANT SELECT, INSERT, UPDATE, DELETE ON Purchases TO manager;
GRANT SELECT, INSERT, UPDATE, DELETE ON OrderLogs TO manager;

-- Grant permissions to customer
GRANT SELECT ON Merchants TO customer;
GRANT SELECT ON Users TO customer;
GRANT SELECT ON Products TO customer;
GRANT SELECT, INSERT ON Orders TO customer;
GRANT SELECT, INSERT ON OrderDetails TO customer;
GRANT SELECT ON Couriers TO customer;
GRANT SELECT ON Shipments TO customer;
GRANT SELECT, INSERT ON Purchases TO customer;
GRANT SELECT ON OrderLogs TO customer;

CREATE PROCEDURE GetUserOrders(IN userID INT)
BEGIN
    SELECT Orders.OrderID, Orders.OrderDate, Products.ProductName, OrderDetails.Quantity
    FROM Orders
    JOIN OrderDetails ON Orders.OrderID = OrderDetails.OrderID
    JOIN Products ON OrderDetails.ProductID = Products.ProductID
    WHERE Orders.UserID = userID;
END;

CREATE PROCEDURE GetTotalQuantitySold()
BEGIN
    SELECT Products.ProductName, SUM(OrderDetails.Quantity) AS TotalQuantitySold
    FROM OrderDetails
    JOIN Products ON OrderDetails.ProductID = Products.ProductID
    GROUP BY Products.ProductName;
END;

CREATE PROCEDURE GetTotalSalesByMerchant()
BEGIN
    SELECT Merchants.Name AS MerchantName, SUM(Products.Price * OrderDetails.Quantity) AS TotalSales
    FROM Orders
    JOIN Merchants ON Orders.MerchantID = Merchants.MerchantID
    JOIN OrderDetails ON Orders.OrderID = OrderDetails.OrderID
    JOIN Products ON OrderDetails.ProductID = Products.ProductID
    GROUP BY Merchants.Name;
END;

CREATE PROCEDURE GetShipmentsByCourier(IN courierID INT)
BEGIN
    SELECT Shipments.ShipmentID, Shipments.ShipmentDate, Orders.OrderID
    FROM Shipments
    JOIN Couriers ON Shipments.CourierID = Couriers.CourierID
    JOIN Orders ON Shipments.OrderID = Orders.OrderID
    WHERE Couriers.CourierID = courierID;
END;

CREATE PROCEDURE GetUserPurchaseHistory(IN userID INT)
BEGIN
    SELECT Purchases.PurchaseID, Purchases.PurchaseDate, Products.ProductName, Purchases.Quantity
    FROM Purchases
    JOIN Products ON Purchases.ProductID = Products.ProductID
    WHERE Purchases.UserID = userID;
END;
