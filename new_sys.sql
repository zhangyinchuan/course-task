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
