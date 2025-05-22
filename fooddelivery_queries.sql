-- Count Queries
SELECT COUNT(*) AS customer_count FROM Customer;
SELECT COUNT(*) AS address_count FROM Customer_Addresses;
SELECT COUNT(*) AS payment_method_count FROM Payment_Method;
SELECT COUNT(*) AS payment_count FROM Payments;
SELECT COUNT(*) AS delivery_personnel_count FROM Delivery_Personnel;
SELECT COUNT(*) AS restaurant_count FROM Restaurant;
SELECT COUNT(*) AS menu_item_count FROM Menu_Items;
SELECT COUNT(*) AS order_count FROM Orders;
SELECT COUNT(*) AS order_item_count FROM Order_Item;

-- Query 1: All orders by customer ID 1
SELECT 
    o.Order_ID,
    o.Created_At,
    o.Status,
    o.OrderItem_Price,
    o.Taxes,
    o.Delivery_Fee,
    (o.OrderItem_Price + o.Taxes + o.Delivery_Fee) AS Total_Amount,
    r.Name AS Restaurant_Name
FROM Orders o
JOIN Restaurant r ON o.Restaurant_ID = r.Restaurant_ID
WHERE o.Customer_ID = 1
ORDER BY o.Created_At DESC;

-- Query 2: Menu items for restaurant ID 1
SELECT 
    mi.MenuItem_ID,
    mi.Name AS Item_Name,
    mi.Description,
    mi.Price,
    mi.Availability
FROM Menu_Items mi
JOIN Restaurant_Menu_Items rmi ON mi.MenuItem_ID = rmi.MenuItem_ID
WHERE rmi.Restaurant_ID = 1
ORDER BY mi.Name;

-- Query 3: Items in order ID 1
SELECT 
    oi.OrderItem_ID,
    mi.Name AS Item_Name,
    mi.Description,
    mi.Price AS Unit_Price,
    oi.Quantity,
    (mi.Price * oi.Quantity) AS Line_Total
FROM Order_Item oi
JOIN Menu_Items mi ON oi.MenuItem_ID = mi.MenuItem_ID
WHERE oi.Order_ID = 1
ORDER BY oi.OrderItem_ID;

-- Query 4: Total amount for order ID 1
SELECT 
    o.Order_ID,
    o.OrderItem_Price,
    o.Taxes,
    o.Delivery_Fee,
    (o.OrderItem_Price + o.Taxes + o.Delivery_Fee) AS Total_Amount,
    p.Payment_Status
FROM Orders o
LEFT JOIN Payments p ON o.Order_ID = p.Order_ID
WHERE o.Order_ID = 1;

-- Query 5: Restaurants offering "Mexican"
SELECT 
    r.Restaurant_ID,
    r.Name AS Restaurant_Name,
    r.Street_address,
    r.City,
    r.State,
    r.Phone_number,
    ct.Cuisine_name
FROM Restaurant r
JOIN Restaurant_Cuisines rc ON r.Restaurant_ID = rc.Restaurant_ID
JOIN Cuisine_Types ct ON rc.Cuisine_ID = ct.Cuisine_ID
WHERE ct.Cuisine_name = 'Mexican'
ORDER BY r.Name;

-- Query 6: Orders not yet delivered
SELECT 
    o.Order_ID,
    o.Created_At,
    o.Status,
    c.First_name || ' ' || c.Last_name AS Customer_Name,
    r.Name AS Restaurant_Name,
    dp.First_name || ' ' || dp.Last_name AS Delivery_Person,
    ca.Street_address || ', ' || ca.City AS Delivery_Address
FROM Orders o
JOIN Customer c ON o.Customer_ID = c.Customer_ID
JOIN Restaurant r ON o.Restaurant_ID = r.Restaurant_ID
JOIN Delivery_Personnel dp ON o.Personnel_ID = dp.Personnel_ID
JOIN Customer_Addresses ca ON o.Delivery_Address_ID = ca.Address_ID
WHERE o.Status IN ('Processing', 'Preparing', 'Out for Delivery')
ORDER BY o.Created_At;

-- Query 7: Most recent order by customer 1
SELECT 
    o.Order_ID,
    o.Created_At,
    o.Status,
    r.Name AS Restaurant_Name,
    (o.OrderItem_Price + o.Taxes + o.Delivery_Fee) AS Total_Amount
FROM Orders o
JOIN Restaurant r ON o.Restaurant_ID = r.Restaurant_ID
WHERE o.Customer_ID = 1
ORDER BY o.Created_At DESC
LIMIT 1;

-- Query 8: Completed orders from '2025-05-01' to '2025-05-21'
SELECT 
    o.Order_ID,
    o.Created_At,
    c.First_name || ' ' || c.Last_name AS Customer_Name,
    r.Name AS Restaurant_Name,
    (o.OrderItem_Price + o.Taxes + o.Delivery_Fee) AS Total_Amount,
    dp.First_name || ' ' || dp.Last_name AS Delivery_Person
FROM Orders o
JOIN Customer c ON o.Customer_ID = c.Customer_ID
JOIN Restaurant r ON o.Restaurant_ID = r.Restaurant_ID
JOIN Delivery_Personnel dp ON o.Personnel_ID = dp.Personnel_ID
WHERE o.Status = 'Delivered'
  AND o.Created_At >= '2025-05-01'
  AND o.Created_At < '2025-05-21'::DATE + INTERVAL '1 day'
ORDER BY o.Created_At DESC;

-- Query 9: Available delivery personnel
SELECT 
    Personnel_ID,
    First_name || ' ' || Last_name AS Full_Name,
    Phone_number,
    Email,
    Availability
FROM Delivery_Personnel
WHERE Availability = TRUE
ORDER BY Last_name, First_name;

-- Query 10: Most popular menu items
SELECT 
    mi.MenuItem_ID,
    mi.Name AS Item_Name,
    mi.Description,
    COUNT(oi.OrderItem_ID) AS Times_Ordered,
    SUM(oi.Quantity) AS Total_Quantity_Ordered,
    AVG(mi.Price) AS Average_Price,
    STRING_AGG(DISTINCT r.Name, ', ') AS Available_At_Restaurants
FROM Menu_Items mi
JOIN Order_Item oi ON mi.MenuItem_ID = oi.MenuItem_ID
JOIN Orders o ON oi.Order_ID = o.Order_ID
JOIN Restaurant_Menu_Items rmi ON mi.MenuItem_ID = rmi.MenuItem_ID
JOIN Restaurant r ON rmi.Restaurant_ID = r.Restaurant_ID
GROUP BY mi.MenuItem_ID, mi.Name, mi.Description
ORDER BY Total_Quantity_Ordered DESC, Times_Ordered DESC
LIMIT 20;
