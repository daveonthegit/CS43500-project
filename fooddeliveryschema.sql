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
