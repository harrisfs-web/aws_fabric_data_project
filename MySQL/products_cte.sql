WITH Product_Count_Per_Category AS (
    SELECT 
        category_id,
        COUNT(*) AS product_count
    FROM 
        products
    GROUP BY 
        category_id
)
SELECT 
    p.product_id,
    p.name,
    p.category_id,
    c.product_count
FROM 
    products p
JOIN 
    Product_Count_Per_Category c
ON 
    p.category_id = c.category_id;
