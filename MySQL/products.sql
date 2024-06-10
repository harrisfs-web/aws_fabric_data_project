drop table if exists products;
CREATE TABLE products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255),
    description TEXT,
    price DECIMAL(10, 2),
    category_id INT,
    FOREIGN KEY (category_id) REFERENCES categories(category_id)
);

DELIMITER $$
DROP PROCEDURE IF EXISTS PopulateProducts;

CREATE PROCEDURE PopulateProducts()
BEGIN
    DECLARE v_max INT DEFAULT 150;
    DECLARE v_counter INT DEFAULT 1;
    DECLARE v_name VARCHAR(255);
    DECLARE v_description TEXT;
    DECLARE v_price DECIMAL(10, 2);
    DECLARE v_category_id INT;

    WHILE v_counter <= v_max DO
        -- Create varying product details
        SET v_name = CONCAT('Product ', v_counter);
        SET v_description = CONCAT('Description for product ', v_counter);
        SET v_price = ROUND(RAND() * (500 - 10) + 10, 2); -- Prices between $10 and $500
        SET v_category_id = FLOOR(1 + (RAND() * 5)); -- Assuming category IDs range from 1 to 5
        
        INSERT INTO products (name, description, price, category_id) VALUES (v_name, v_description, v_price, v_category_id);
        
        SET v_counter = v_counter + 1;
    END WHILE;
END$$

DELIMITER ;

CALL PopulateProducts();
