
-- confirm LittleLemonDB was created with the required tables

show databases;
use LittleLemonDB;
show tables;

-- virtual table to summarize data
CREATE VIEW OrdersView AS SELECT order_id, total_cost from Orders;
select * from OrdersView;

CREATE VIEW CustomersView AS SELECT customer_id, full_name from Customers;
select * from CustomersView;

CREATE VIEW MenusView AS SELECT menu_name from Menus;
SELECT * FROM MenusView;

CREATE VIEW MenusItemsView AS SELECT course_name, starter_name FROM MenusItems;
SELECT * FROM MenusItemsView;

-- subquery to check what menu name has been ordered more than twice.

SELECT menu_name from Menus WHERE menu_id in 
(SELECT menu_id FROM (SELECT menu_id, COUNT(*) as menu_count FROM Orders GROUP BY menu_id HAVING menu_count > 2));


-- stored procedures

DELIMITER //
CREATE PROCEDURE GetMaxQuantity()
BEGIN
	SELECT MAX(quantity) AS "Max Quantity in Order" FROM Orders;
END
//
DELIMITER ; 

CALL GetMaxQuantity();


DELIMITER //
CREATE PROCEDURE CancelOrder(IN order_id INT)
BEGIN
	DELETE FROM Orders where order_id=order_id;
	SELECT CONCAT('Order ', order_id, ' is cancelled') AS Confirmation;
END
//
DELIMITER ;

CALL CancelOrder(5);

-- prepared statement

PREPARE GetOrderDetail FROM 'SELECT order_id, quantity, total_cost FROM Orders INNER JOIN Bookings ON (Orders.booking_id = Bookings.booking_id) WHERE Bookings.customer_id=?';
SET @id = 1; EXECUTE GetOrderDetail USING @id;



-- Queries to add and update bookings

DELIMITER //
CREATE PROCEDURE AddBooking(IN booking_id INT, IN customer_id INT, IN date DATE, IN table_number INT)
BEGIN
	INSERT INTO Bookings(booking_id, customer_id, date, table_number, staff_number) VALUES
    (booking_id, customer_id, date, table_number, 1);
	SELECT 'New booking added' AS Confirmation;
END
//
DELIMITER ;


CALL AddBooking(9, 3, "2024-02-17", 8);



DELIMITER //
CREATE PROCEDURE UpdateBooking(IN booking_id INT, IN new_date DATE)
BEGIN
	UPDATE Bookings SET date = new_date WHERE booking_id = booking_id;
	SELECT CONCAT('Booking ', booking_id, ' updated') AS Confirmation;
END
//
DELIMITER ;

CALL UpdateBooking(9, "2024-02-18");




DELIMITER //
CREATE PROCEDURE CancelBooking(IN booking_id INT)
BEGIN
	DELETE FROM Bookings WHERE booking_id = booking_id;
	SELECT CONCAT('Booking ', booking_id, ' cancelled') AS Confirmation;
END
//
DELIMITER ;

CALL CancelBooking(9);

