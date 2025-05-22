-- ✅ Count of records in each major table

SELECT COUNT(*) AS customer_count FROM Customer;

SELECT COUNT(*) AS address_count FROM Customer_Addresses;

SELECT COUNT(*) AS payment_method_count FROM Payment_Method;

SELECT COUNT(*) AS payment_count FROM Payments;

SELECT COUNT(*) AS delivery_personnel_count FROM Delivery_Personnel;

SELECT COUNT(*) AS restaurant_count FROM Restaurant;

SELECT COUNT(*) AS menu_item_count FROM Menu_Items;

SELECT COUNT(*) AS order_count FROM Orders;

SELECT COUNT(*) AS order_item_count FROM Order_Item;

-- 1. Retrieve all orders placed by a particular customer (e.g., Customer_ID = 1)

SELECT * FROM Orders WHERE Customer_ID = 1;

-- 2. Get details of all menu items for a specific restaurant (e.g., Restaurant_ID = 1)

SELECT m.*
       FROM Menu_Items m
       JOIN Restaurant_Menu_Items rmi ON m.MenuItem_ID = rmi.MenuItem_ID
       WHERE rmi.Restaurant_ID = 1;

-- 3. List all items in a particular order (e.g., Order_ID = 1)

SELECT * FROM Order_Item WHERE Order_ID = 1;

-- 4. Find the total amount charged for a specific order (e.g., Order_ID = 1)

SELECT o.Order_ID, (o.OrderItem_Price + o.Taxes + o.Delivery_Fee) AS total_amount
       FROM Orders o WHERE o.Order_ID = 1;

-- 5. List all restaurants that offer a specific cuisine (e.g., Cuisine_ID = 1)

SELECT r.*
       FROM Restaurant r
       JOIN Restaurant_Cuisines rc ON r.Restaurant_ID = rc.Restaurant_ID
       WHERE rc.Cuisine_ID = 1;

-- 6. Find all orders with a 'Pending' delivery status

SELECT * FROM Orders WHERE Status = 'Pending';

-- 7. Retrieve the most recent order placed by a customer (e.g., Customer_ID = 1)

SELECT *
       FROM Orders
       WHERE Customer_ID = 1
       ORDER BY Delivery_time DESC
       LIMIT 1;

-- 8. List all completed orders within a specific date range

SELECT *
       FROM Orders
       WHERE Status = 'Delivered' AND Delivery_time BETWEEN '2024-01-01' AND '2024-12-31';

-- 9. Find all available delivery personnel

SELECT * FROM Delivery_Personnel WHERE Availability = TRUE;

-- 10. List the most popular menu items across all restaurants

SELECT MenuItem_ID, COUNT(*) AS order_count
       FROM Order_Item
       GROUP BY MenuItem_ID
       ORDER BY order_count DESC
       LIMIT 10;