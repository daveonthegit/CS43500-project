-- DROP TABLES IF THEY EXIST (for re-runs)
DROP TABLE IF EXISTS 
    Order_Item, Payments, Orders, Payment_Method, Delivery_Personnel,
    Restaurant_Cuisines, Cuisine_Types, Restaurant_Menu_Items, Menu_Items, Restaurant,
    Customer_Addresses, Customer CASCADE; -- Clean slate by removing all existing tables

-- Customer
CREATE TABLE Customer (
    Customer_ID SERIAL PRIMARY KEY,                             -- Auto-incremented unique ID
    First_name VARCHAR(50) NOT NULL,                            -- Up to 50 characters, names usually short
    Last_name VARCHAR(50) NOT NULL,                             -- Same rationale as first name
    Phone_number VARCHAR(15),                                   -- Allows formats with dashes or country codes
    Email VARCHAR(100)                                          -- Accommodates typical full-length email addresses
);

-- Customer Addresses
CREATE TABLE Customer_Addresses (
    Address_ID SERIAL PRIMARY KEY,                              -- Auto-generated unique address ID
    Postal_code VARCHAR(10) NOT NULL,                           -- Handles US ZIPs and other formats
    Street_address VARCHAR(100) NOT NULL,                       -- Standard max length for address lines
    City VARCHAR(50) NOT NULL,                                  -- Most city names are < 50 characters
    State VARCHAR(50) NOT NULL,                                 -- Supports full state/province names
    Customer_ID INTEGER NOT NULL,                               -- FK to identify owner of address
    FOREIGN KEY (Customer_ID) REFERENCES Customer(Customer_ID) ON DELETE CASCADE -- Cascade deletion to clean up orphaned addresses
);

-- Restaurant
CREATE TABLE Restaurant (
    Restaurant_ID SERIAL PRIMARY KEY,                           -- Unique ID for each restaurant
    Name VARCHAR(100) NOT NULL,                                 -- Accommodates long restaurant names
    Postal_code VARCHAR(10) NOT NULL,                           -- Standard postal code format
    Street_address VARCHAR(100) NOT NULL,                       -- Physical street address
    City VARCHAR(50) NOT NULL,                                  -- City location
    State VARCHAR(50) NOT NULL,                                 -- State location
    Phone_number VARCHAR(15),                                   -- Optional restaurant contact number
    Email VARCHAR(100)                                          -- Email address for restaurant contact
);

-- Menu Items
CREATE TABLE Menu_Items (
    MenuItem_ID SERIAL PRIMARY KEY,                             -- Unique identifier
    Description TEXT,                                           -- TEXT for full description flexibility
    Price NUMERIC(10, 2) NOT NULL,                              -- Currency-safe: 10 total digits, 2 decimals
    Availability BOOLEAN NOT NULL DEFAULT TRUE                  -- True if available for order; defaults to available
);

-- Restaurant Menu Items (M:M relationship)
CREATE TABLE Restaurant_Menu_Items (
    Restaurant_ID INTEGER,                                      -- FK to restaurant
    MenuItem_ID INTEGER,                                        -- FK to menu item
    PRIMARY KEY (Restaurant_ID, MenuItem_ID),                   -- Prevents duplicate links
    FOREIGN KEY (Restaurant_ID) REFERENCES Restaurant(Restaurant_ID) ON DELETE CASCADE,
    FOREIGN KEY (MenuItem_ID) REFERENCES Menu_Items(MenuItem_ID) ON DELETE CASCADE
);

-- Cuisine Types
CREATE TABLE Cuisine_Types (
    Cuisine_ID SERIAL PRIMARY KEY,                              -- Unique cuisine type ID
    Cuisine_name VARCHAR(50) NOT NULL                           -- Supports names like "Mediterranean", "Latin Fusion"
);

-- Restaurant Cuisines (M:M relationship)
CREATE TABLE Restaurant_Cuisines (
    Restaurant_ID INTEGER,                                      -- FK to restaurant
    Cuisine_ID INTEGER,                                         -- FK to cuisine
    PRIMARY KEY (Restaurant_ID, Cuisine_ID),                    -- Ensures each pairing is unique
    FOREIGN KEY (Restaurant_ID) REFERENCES Restaurant(Restaurant_ID) ON DELETE CASCADE,
    FOREIGN KEY (Cuisine_ID) REFERENCES Cuisine_Types(Cuisine_ID) ON DELETE CASCADE
);

-- Delivery Personnel
CREATE TABLE Delivery_Personnel (
    Personnel_ID SERIAL PRIMARY KEY,                            -- Unique delivery person ID
    First_name VARCHAR(50) NOT NULL,                            -- First name
    Last_name VARCHAR(50) NOT NULL,                             -- Last name
    Phone_number VARCHAR(15),                                   -- Driver contact
    Email VARCHAR(100),                                         -- Optional communication method
    Availability BOOLEAN NOT NULL DEFAULT TRUE                  -- Indicates if personnel is active
);

-- Secure Payment Method (Reusable)
CREATE TABLE Payment_Method (
    PaymentMethod_ID SERIAL PRIMARY KEY,                        -- Internal method ID
    Customer_ID INTEGER NOT NULL,                               -- FK to owner
    Method_Type VARCHAR(50) NOT NULL,                           -- Type (e.g., Visa, PayPal)
    Masked_Details VARCHAR(100),                                -- Non-sensitive display string
    Provider_Method_ID VARCHAR(100),                            -- External token (e.g. Stripe ID)
    Last_Used TIMESTAMP,                                        -- Timestamp of recent use
    FOREIGN KEY (Customer_ID) REFERENCES Customer(Customer_ID) ON DELETE CASCADE
);

-- Orders
CREATE TABLE Orders (
    Order_ID SERIAL PRIMARY KEY,                                -- Internal tracking ID
    Delivery_time TIMESTAMP,                                    -- When delivery is scheduled
    Real_time_location VARCHAR(200),                            -- Optional GPS/notes
    Special_Instructions TEXT,                                  -- Notes like "no onions"
    Status VARCHAR(50) NOT NULL DEFAULT 'Processing',           -- Current state of the order
    OrderItem_Price NUMERIC(10, 2) NOT NULL,                    -- Total before fees/tax
    Taxes NUMERIC(10, 2) NOT NULL,                              -- Tax amount
    Delivery_Fee NUMERIC(10, 2) NOT NULL,                       -- Flat or dynamic fee
    Customer_ID INTEGER NOT NULL,                               -- FK to customer
    Restaurant_ID INTEGER NOT NULL,                             -- FK to restaurant
    Personnel_ID INTEGER NOT NULL,                              -- Assigned delivery person
    FOREIGN KEY (Customer_ID) REFERENCES Customer(Customer_ID) ON DELETE CASCADE,
    FOREIGN KEY (Restaurant_ID) REFERENCES Restaurant(Restaurant_ID),
    FOREIGN KEY (Personnel_ID) REFERENCES Delivery_Personnel(Personnel_ID)
);

-- Payments (Linked to specific Order and Method)
CREATE TABLE Payments (
    Payment_ID SERIAL PRIMARY KEY,                              -- Transaction ID
    Order_ID INTEGER UNIQUE NOT NULL,                           -- Paid order
    PaymentMethod_ID INTEGER NOT NULL,                          -- Method used
    Transaction_ID VARCHAR(100) UNIQUE NOT NULL,                -- External ref
    Amount NUMERIC(10,2) NOT NULL,                              -- Exact billed total
    Payment_Status VARCHAR(20) NOT NULL DEFAULT 'Pending',      -- Current payment state
    Timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,              -- When processed
    FOREIGN KEY (Order_ID) REFERENCES Orders(Order_ID) ON DELETE CASCADE,
    FOREIGN KEY (PaymentMethod_ID) REFERENCES Payment_Method(PaymentMethod_ID) ON DELETE SET NULL
);

-- Order Items
CREATE TABLE Order_Item (
    OrderItem_ID SERIAL PRIMARY KEY,                            -- Line item ID
    Quantity INTEGER NOT NULL,                                  -- Quantity ordered
    Name VARCHAR(100) NOT NULL,                                 -- Snapshot name of item
    MenuItem_ID INTEGER NOT NULL,                               -- FK to menu catalog
    Order_ID INTEGER NOT NULL,                                  -- FK to order
    FOREIGN KEY (MenuItem_ID) REFERENCES Menu_Items(MenuItem_ID),
    FOREIGN KEY (Order_ID) REFERENCES Orders(Order_ID) ON DELETE CASCADE
);
