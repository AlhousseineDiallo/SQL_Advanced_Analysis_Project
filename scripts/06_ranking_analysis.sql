/*
===============================================================================
Analyse par Classement
===============================================================================
Objectif :
    - Classer les éléments (ex. : produits, clients) en fonction de leur performance ou d'autres indicateurs.
    - Identifier les meilleurs éléments ou ceux en difficulté.

Fonctions SQL utilisées :
    - Fonctions de classement de fenêtre : RANK(), DENSE_RANK(), ROW_NUMBER(), TOP
    - Clauses : GROUP BY, ORDER BY
===============================================================================
*/

-- Quels sont les 5 produits générant le plus de chiffre d'affaires ?

SELECT TOP 5
    p.product_name,
    SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
ON p.product_key = f.product_key
GROUP BY p.product_name
ORDER BY total_revenue DESC;
-- Classement complexe mais flexible à l'aide des fonctions de fenêtrage
SELECT *
FROM (
    SELECT
        p.product_name,
        SUM(f.sales_amount) AS total_revenue,
        RANK() OVER (ORDER BY SUM(f.sales_amount) DESC) AS rank_products
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_products p
    ON p.product_key = f.product_key
    GROUP BY p.product_name
) AS ranked_products
WHERE rank_products <= 5;

-- Voici une autre approche utilisant une CTE

WITH ranking_revenue AS (

	SELECT
		pr.product_name,
		SUM(f.sales_amount) AS total_revenue,
		ROW_NUMBER() OVER(ORDER BY SUM(f.sales_amount) DESC) AS rn
	FROM gold.fact_sales f
	LEFT JOIN gold.dim_products pr
	ON pr.product_key = f.product_key
	GROUP BY pr.product_key, pr.product_name

)
SELECT
	product_name,
	FORMAT(total_revenue, 'C', 'en-US') AS total_revenue
FROM ranking_revenue
WHERE rn <= 5;

-- Quels sont les 5 produits les moins performants en termes de ventes ?

SELECT
	TOP 5
	pr.product_name,
	FORMAT(SUM(f.sales_amount), 'C', 'en-US') AS total_revenue
FROM gold.dim_products pr
RIGHT JOIN gold.fact_sales f
ON f.product_key = pr.product_key
GROUP BY pr.product_key, pr.product_name
ORDER BY SUM(f.sales_amount);

-- Trouver les 10 clients ayant généré le plus de chiffre d'affaires

SELECT TOP 10
    c.customer_key,
    c.first_name,
    c.last_name,
    SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
ON c.customer_key = f.customer_key
GROUP BY 
    c.customer_key,
    c.first_name,
    c.last_name
ORDER BY total_revenue DESC;

-- Les 3 clients ayant passé le moins de commandes
SELECT TOP 3
    c.customer_key,
    c.first_name,
    c.last_name,
    COUNT(DISTINCT order_number) AS total_orders
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
ON c.customer_key = f.customer_key
GROUP BY 
    c.customer_key,
    c.first_name,
    c.last_name
ORDER BY total_orders;
