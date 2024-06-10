drop table if exists categories;
CREATE TABLE categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    description TEXT
);

INSERT INTO categories (name, description) VALUES
('Electronics', 'Electronic gadgets and devices'),
('Clothing', 'Apparel for men, women, and children'),
('Home Appliances', 'Appliances and goods for home use'),
('Books', 'Printed books and eBooks'),
('Health & Beauty', 'Healthcare and cosmetic products');
