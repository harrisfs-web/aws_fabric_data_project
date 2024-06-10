drop table if exists orders;
CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    product_id INT,
    quantity INT,
    order_date DATE,
    order_time TIME,
    total_amount DECIMAL(10, 2),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);
DROP PROCEDURE IF EXISTS PopulateOrders;
DELIMITER $$

CREATE PROCEDURE PopulateOrders()
BEGIN
    DECLARE v_counter INT DEFAULT 0;
    DECLARE v_customer_id INT;
    DECLARE v_product_id INT;
    DECLARE v_quantity INT;
    DECLARE v_order_date DATE;
    DECLARE v_order_time TIME;
    DECLARE v_total_amount DECIMAL(10, 2);

    WHILE v_counter < 10000 DO
        -- Generate random customer ID, product ID, and quantity
        SET v_customer_id = FLOOR(1 + (RAND() * 200)); -- Assuming you have 5 customers
        SET v_product_id = FLOOR(1 + (RAND() * 150)); -- Assuming you have 5 products
        SET v_quantity = FLOOR(1 + (RAND() * 10)); -- Quantities between 1 and 10
        
        -- Generate a random date within the last year
        SET v_order_date = DATE_SUB(CURDATE(), INTERVAL FLOOR(RAND() * 365) DAY);
        
        -- Generate a random time
        SET v_order_time = SEC_TO_TIME(FLOOR(RAND() * 86400));

        -- Calculate total amount assuming a random price per product
        SET v_total_amount = v_quantity * (ROUND(RAND() * (100 - 20) + 20, 2)); -- Prices between $20 and $100

        -- Insert the order into the orders table
        INSERT INTO orders (customer_id, product_id, quantity, order_date, order_time, total_amount)
        VALUES (v_customer_id, v_product_id, v_quantity, v_order_date, v_order_time, v_total_amount);

        SET v_counter = v_counter + 1;
    END WHILE;
END$$

DELIMITER ;
CALL PopulateOrders();


ALTER TABLE orders
ADD FOREIGN KEY (order_date) REFERENCES datedim(date);