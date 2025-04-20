-- DROP TABLES IF THEY EXIST (for re-runs)
DROP TABLE IF EXISTS 
    Order_Item, Orders, Payment_Method, Delivery_Personnel,
    Restaurant_Cuisines, Cuisine_Types, Restaurant_Menu_Items, Menu_Items, Restaurant,
    Customer_Addresses, Customer CASCADE;

-- CREATE TABLES
-- Customer
CREATE TABLE Customer (
    Customer_ID SERIAL PRIMARY KEY,
    First_name VARCHAR(50) NOT NULL,
    Last_name VARCHAR(50) NOT NULL,
    Phone_number VARCHAR(15),
    Email VARCHAR(100)
);

-- Customer Addresses
CREATE TABLE Customer_Addresses (
    Address_ID SERIAL PRIMARY KEY,
    Postal_code VARCHAR(10) NOT NULL,
    Street_address VARCHAR(100) NOT NULL,
    City VARCHAR(50) NOT NULL,
    State VARCHAR(50) NOT NULL,
    Customer_ID INTEGER NOT NULL,
    FOREIGN KEY (Customer_ID) REFERENCES Customer(Customer_ID) ON DELETE CASCADE
);

-- Restaurant
CREATE TABLE Restaurant (
    Restaurant_ID SERIAL PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Postal_code VARCHAR(10) NOT NULL,
    Street_address VARCHAR(100) NOT NULL,
    City VARCHAR(50) NOT NULL,
    State VARCHAR(50) NOT NULL,
    Phone_number VARCHAR(15),
    Email VARCHAR(100)
);

-- Menu Items
CREATE TABLE Menu_Items (
    MenuItem_ID SERIAL PRIMARY KEY,
    Description TEXT,
    Price NUMERIC(10, 2) NOT NULL,
    Availability BOOLEAN NOT NULL DEFAULT TRUE
);

-- Restaurant Menu Items (M:M)
CREATE TABLE Restaurant_Menu_Items (
    Restaurant_ID INTEGER,
    MenuItem_ID INTEGER,
    PRIMARY KEY (Restaurant_ID, MenuItem_ID),
    FOREIGN KEY (Restaurant_ID) REFERENCES Restaurant(Restaurant_ID) ON DELETE CASCADE,
    FOREIGN KEY (MenuItem_ID) REFERENCES Menu_Items(MenuItem_ID) ON DELETE CASCADE
);

-- Cuisine Types
CREATE TABLE Cuisine_Types (
    Cuisine_ID SERIAL PRIMARY KEY,
    Cuisine_name VARCHAR(50) NOT NULL
);

-- Restaurant Cuisines (M:M)
CREATE TABLE Restaurant_Cuisines (
    Restaurant_ID INTEGER,
    Cuisine_ID INTEGER,
    PRIMARY KEY (Restaurant_ID, Cuisine_ID),
    FOREIGN KEY (Restaurant_ID) REFERENCES Restaurant(Restaurant_ID) ON DELETE CASCADE,
    FOREIGN KEY (Cuisine_ID) REFERENCES Cuisine_Types(Cuisine_ID) ON DELETE CASCADE
);

-- Delivery Personnel
CREATE TABLE Delivery_Personnel (
    Personnel_ID SERIAL PRIMARY KEY,
    First_name VARCHAR(50) NOT NULL,
    Last_name VARCHAR(50) NOT NULL,
    Phone_number VARCHAR(15),
    Email VARCHAR(100),
    Availability BOOLEAN NOT NULL DEFAULT TRUE
);

-- Payment Method
CREATE TABLE Payment_Method (
    Payment_ID SERIAL PRIMARY KEY,
    Transaction_id VARCHAR(100),
    Payment_type VARCHAR(50) NOT NULL,
    Payment_status VARCHAR(20) NOT NULL DEFAULT 'Pending',
    Customer_ID INTEGER NOT NULL,
    FOREIGN KEY (Customer_ID) REFERENCES Customer(Customer_ID) ON DELETE CASCADE
);

-- Orders
CREATE TABLE Orders (
    Order_ID SERIAL PRIMARY KEY,
    Delivery_time TIMESTAMP,
    Real_time_location VARCHAR(200),
    Special_Instructions TEXT,
    Status VARCHAR(50) NOT NULL DEFAULT 'Processing',
    OrderItem_Price NUMERIC(10, 2) NOT NULL,
    Taxes NUMERIC(10, 2) NOT NULL,
    Delivery_Fee NUMERIC(10, 2) NOT NULL,
    Customer_ID INTEGER NOT NULL,
    Restaurant_ID INTEGER NOT NULL,
    Personnel_ID INTEGER NOT NULL,
    FOREIGN KEY (Customer_ID) REFERENCES Customer(Customer_ID) ON DELETE CASCADE,
    FOREIGN KEY (Restaurant_ID) REFERENCES Restaurant(Restaurant_ID),
    FOREIGN KEY (Personnel_ID) REFERENCES Delivery_Personnel(Personnel_ID)
);

-- Order Item
CREATE TABLE Order_Item (
    OrderItem_ID SERIAL PRIMARY KEY,
    Quantity INTEGER NOT NULL,
    Name VARCHAR(100) NOT NULL,
    MenuItem_ID INTEGER NOT NULL,
    Order_ID INTEGER NOT NULL,
    FOREIGN KEY (MenuItem_ID) REFERENCES Menu_Items(MenuItem_ID),
    FOREIGN KEY (Order_ID) REFERENCES Orders(Order_ID) ON DELETE CASCADE
);

-- INSERT SAMPLE DATA
INSERT INTO Customer (First_name, Last_name, Phone_number, Email)
VALUES ('Alice', 'Lee', '5551234567', 'alice@example.com');

INSERT INTO Customer_Addresses (Postal_code, Street_address, City, State, Customer_ID)
VALUES ('10001', '123 Main St', 'New York', 'NY', 1);

INSERT INTO Restaurant (Name, Postal_code, Street_address, City, State, Phone_number, Email)
VALUES ('Burger Haven', '10002', '456 Burger Blvd', 'New York', 'NY', '5559876543', 'contact@burgerhaven.com');

INSERT INTO Menu_Items (Description, Price, Availability)
VALUES ('Classic Cheeseburger', 8.99, TRUE);

INSERT INTO Cuisine_Types (Cuisine_name)
VALUES ('American');

INSERT INTO Restaurant_Menu_Items (Restaurant_ID, MenuItem_ID)
VALUES (1, 1);

INSERT INTO Restaurant_Cuisines (Restaurant_ID, Cuisine_ID)
VALUES (1, 1);

INSERT INTO Delivery_Personnel (First_name, Last_name, Phone_number, Email)
VALUES ('Bob', 'Driver', '5550001122', 'bob.driver@example.com');

INSERT INTO Payment_Method (Transaction_id, Payment_type, Payment_status, Customer_ID)
VALUES ('TX123456789', 'Credit Card', 'Pending', 1);

INSERT INTO Orders (
    Delivery_time, Real_time_location, Special_Instructions, Status,
    OrderItem_Price, Taxes, Delivery_Fee,
    Customer_ID, Restaurant_ID, Personnel_ID
) VALUES (
    NOW(), '123 Main St, NY', 'Leave at door', 'Processing',
    8.99, 0.80, 2.00,
    1, 1, 1
);

INSERT INTO Order_Item (Quantity, Name, MenuItem_ID, Order_ID)
VALUES (1, 'Classic Cheeseburger', 1, 1);
-- Add more customers
INSERT INTO Customer (First_name, Last_name, Phone_number, Email) VALUES ('Customer2', 'Test', '555000002', 'customer2@example.com');
INSERT INTO Customer (First_name, Last_name, Phone_number, Email) VALUES ('Customer3', 'Test', '555000003', 'customer3@example.com');
INSERT INTO Customer (First_name, Last_name, Phone_number, Email) VALUES ('Customer4', 'Test', '555000004', 'customer4@example.com');
INSERT INTO Customer (First_name, Last_name, Phone_number, Email) VALUES ('Customer5', 'Test', '555000005', 'customer5@example.com');

-- Add more restaurants
INSERT INTO Restaurant (Name, Postal_code, Street_address, City, State, Phone_number, Email) VALUES ('Tasty Place 2', '1002', 'Street 2', 'City2', 'NY', '555222002', 'tasty2@email.com');
INSERT INTO Restaurant (Name, Postal_code, Street_address, City, State, Phone_number, Email) VALUES ('Tasty Place 3', '1003', 'Street 3', 'City3', 'NY', '555222003', 'tasty3@email.com');
INSERT INTO Restaurant (Name, Postal_code, Street_address, City, State, Phone_number, Email) VALUES ('Tasty Place 4', '1004', 'Street 4', 'City4', 'NY', '555222004', 'tasty4@email.com');

-- Add more menu items
INSERT INTO Menu_Items (Description, Price, Availability) VALUES ('Veggie Burger', 7.95, TRUE);
INSERT INTO Menu_Items (Description, Price, Availability) VALUES ('Spicy Wings', 14.17, FALSE);
INSERT INTO Menu_Items (Description, Price, Availability) VALUES ('Fish Tacos', 12.35, FALSE);
INSERT INTO Menu_Items (Description, Price, Availability) VALUES ('Pasta Alfredo', 11.03, TRUE);

-- Link new menu items to restaurants
INSERT INTO Restaurant_Menu_Items (Restaurant_ID, MenuItem_ID) VALUES (2, 2);
INSERT INTO Restaurant_Menu_Items (Restaurant_ID, MenuItem_ID) VALUES (3, 3);
INSERT INTO Restaurant_Menu_Items (Restaurant_ID, MenuItem_ID) VALUES (4, 4);

-- Add more cuisines
INSERT INTO Cuisine_Types (Cuisine_name) VALUES ('Mexican');
INSERT INTO Restaurant_Cuisines (Restaurant_ID, Cuisine_ID) VALUES (2, 2);
INSERT INTO Cuisine_Types (Cuisine_name) VALUES ('Italian');
INSERT INTO Restaurant_Cuisines (Restaurant_ID, Cuisine_ID) VALUES (3, 3);
INSERT INTO Cuisine_Types (Cuisine_name) VALUES ('Indian');
INSERT INTO Restaurant_Cuisines (Restaurant_ID, Cuisine_ID) VALUES (4, 4);

-- More delivery personnel
INSERT INTO Delivery_Personnel (First_name, Last_name, Phone_number, Email) VALUES ('Deliverer2', 'Test', '555444002', 'deliverer2@example.com');
INSERT INTO Delivery_Personnel (First_name, Last_name, Phone_number, Email) VALUES ('Deliverer3', 'Test', '555444003', 'deliverer3@example.com');

-- More orders
INSERT INTO Orders (Delivery_time, Real_time_location, Special_Instructions, Status, OrderItem_Price, Taxes, Delivery_Fee, Customer_ID, Restaurant_ID, Personnel_ID)
VALUES ('2025-04-19 23:58:31', 'Somewhere NY', 'Leave with doorman', 'Delivered', 18.96, 1.90, 2.18, 2, 2, 3);
INSERT INTO Order_Item (Quantity, Name, MenuItem_ID, Order_ID) VALUES (1, 'Veggie Burger', 2, 2);

INSERT INTO Orders (Delivery_time, Real_time_location, Special_Instructions, Status, OrderItem_Price, Taxes, Delivery_Fee, Customer_ID, Restaurant_ID, Personnel_ID)
VALUES ('2025-04-19 22:58:31', 'Somewhere NY', 'Leave with doorman', 'Delivered', 12.90, 1.29, 3.27, 3, 3, 1);
INSERT INTO Order_Item (Quantity, Name, MenuItem_ID, Order_ID) VALUES (1, 'Spicy Wings', 3, 3);

INSERT INTO Orders (Delivery_time, Real_time_location, Special_Instructions, Status, OrderItem_Price, Taxes, Delivery_Fee, Customer_ID, Restaurant_ID, Personnel_ID)
VALUES ('2025-04-19 21:58:31', 'Somewhere NY', 'Leave with doorman', 'Delivered', 12.09, 1.21, 4.08, 4, 4, 2);
INSERT INTO Order_Item (Quantity, Name, MenuItem_ID, Order_ID) VALUES (1, 'Fish Tacos', 4, 4);

INSERT INTO Orders (Delivery_time, Real_time_location, Special_Instructions, Status, OrderItem_Price, Taxes, Delivery_Fee, Customer_ID, Restaurant_ID, Personnel_ID)
VALUES ('2025-04-19 20:58:31', 'Somewhere NY', 'Leave with doorman', 'Delivered', 16.50, 1.65, 4.96, 5, 2, 3);
INSERT INTO Order_Item (Quantity, Name, MenuItem_ID, Order_ID) VALUES (1, 'Veggie Burger', 2, 5);

-- TEST QUERY
--Query 1
SELECT o.Order_ID, c.First_name, r.Name AS Restaurant, oi.Name AS Item, oi.Quantity
FROM Orders o
JOIN Customer c ON o.Customer_ID = c.Customer_ID
JOIN Order_Item oi ON o.Order_ID = oi.Order_ID
JOIN Restaurant r ON o.Restaurant_ID = r.Restaurant_ID;
--Query 2
SELECT 
    r.Name AS Restaurant,
    COUNT(o.Order_ID) AS Total_Orders,
    SUM(o.OrderItem_Price + o.Taxes + o.Delivery_Fee) AS Total_Revenue
FROM Orders o
JOIN Restaurant r ON o.Restaurant_ID = r.Restaurant_ID
GROUP BY r.Name
ORDER BY Total_Revenue DESC;
--Query 3
SELECT 
    DATE_TRUNC('day', o.Delivery_time) AS Revenue_Day,
    SUM(o.OrderItem_Price + o.Taxes + o.Delivery_Fee) AS Total_Revenue
FROM Orders o
GROUP BY Revenue_Day
ORDER BY Revenue_Day;
--Query 4
SELECT 
    mi.Description AS Menu_Item,
    COUNT(oi.OrderItem_ID) AS Times_Ordered
FROM Order_Item oi
JOIN Menu_Items mi ON oi.MenuItem_ID = mi.MenuItem_ID
GROUP BY mi.Description
ORDER BY Times_Ordered DESC;
--Query 5
SELECT 
    dp.First_name || ' ' || dp.Last_name AS Deliverer,
    COUNT(o.Order_ID) AS Orders_Assigned
FROM Orders o
JOIN Delivery_Personnel dp ON o.Personnel_ID = dp.Personnel_ID
GROUP BY dp.Personnel_ID, dp.First_name, dp.Last_name
ORDER BY Orders_Assigned DESC;
--Query 6
SELECT 
    r.Name AS Restaurant,
    DATE_TRUNC('day', o.Delivery_time) AS Revenue_Day,
    SUM(o.OrderItem_Price + o.Taxes + o.Delivery_Fee) AS Daily_Revenue
FROM Orders o
JOIN Restaurant r ON o.Restaurant_ID = r.Restaurant_ID
GROUP BY r.Name, Revenue_Day
ORDER BY r.Name, Revenue_Day;