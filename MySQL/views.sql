DROP VIEW IF EXISTS CustomerOrdersSummary;
CREATE VIEW CustomerOrdersSummary AS
SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    COUNT(o.order_id) AS total_orders,
    SUM(o.total_amount) AS total_spent,
    MAX(o.order_date) AS last_order_date
FROM 
    customers c
JOIN 
    orders o ON c.customer_id = o.customer_id
GROUP BY 
    c.customer_id;
DROP VIEW IF EXISTS ProductSalesPerformance;
CREATE VIEW ProductSalesPerformance AS
SELECT 
    p.product_id,
    p.name,
    SUM(o.quantity) AS total_units_sold,
    SUM(o.total_amount) AS total_sales,
    AVG(o.total_amount / o.quantity) AS average_price_per_unit
FROM 
    products p
JOIN 
    orders o ON p.product_id = o.product_id
GROUP BY 
    p.product_id;

DROP VIEW IF EXISTS DailySalesAnalysis;    
CREATE VIEW DailySalesAnalysis AS
SELECT 
    o.order_date,
    COUNT(o.order_id) AS number_of_orders,
    SUM(o.quantity) AS total_items_sold,
    SUM(o.total_amount) AS total_sales
FROM 
    orders o
GROUP BY 
    o.order_date
ORDER BY 
    o.order_date DESC;

DROP VIEW IF EXISTS SalesByCategory;        
CREATE VIEW SalesByCategory AS
SELECT 
    cat.name AS category_name,
    COUNT(ord.order_id) AS number_of_orders,
    SUM(ord.quantity) AS total_quantity_sold,
    SUM(ord.total_amount) AS total_sales
FROM 
    categories cat
JOIN 
    products prod ON cat.category_id = prod.category_id
JOIN 
    orders ord ON prod.product_id = ord.product_id
GROUP BY 
    cat.category_id;

DROP VIEW IF EXISTS CustomerGeographicDistribution;        
CREATE VIEW CustomerGeographicDistribution AS
SELECT 
    state,
    COUNT(customer_id) AS number_of_customers,
    SUM(total_spent) AS total_spent
FROM 
    (SELECT 
		 c.customer_id, 
         state, 
         SUM(total_amount) AS total_spent
     FROM 
         customers c
     JOIN 
         orders o ON c.customer_id = o.customer_id
     GROUP BY 
         customer_id) AS customer_spending
GROUP BY 
    state;


