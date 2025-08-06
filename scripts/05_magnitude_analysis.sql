/*
===============================================================================
Analyse de magnitude
===============================================================================
Objectif :
    - Quantifier les données et regrouper les résultats par dimensions spécifiques.
    - Comprendre la distribution des données selon les catégories.

Fonctions SQL utilisées :
    - Fonctions d’agrégation : SUM(), COUNT(), AVG()
    - GROUP BY, ORDER BY
===============================================================================
*/

-- Trouver le nombre total de clients par pays
SELECT
    country,
    COUNT(customer_key) AS total_customers
FROM gold.dim_customers
GROUP BY country
ORDER BY total_customers DESC;

-- Trouver le nombre total de clients par genre
SELECT
    gender,
    COUNT(customer_key) AS total_customers
FROM gold.dim_customers
GROUP BY gender
ORDER BY total_customers DESC;

-- Trouver le nombre total de produits par catégorie

SELECT
    category,
    COUNT(product_key) AS total_products
FROM gold.dim_products
GROUP BY category
ORDER BY total_products DESC;

-- Quel est le coût moyen dans chaque catégorie ?

SELECT
    category,
    AVG(cost) AS avg_cost
FROM gold.dim_products
GROUP BY category
ORDER BY avg_cost DESC;

-- Quel est le chiffre d’affaires total généré pour chaque catégorie ?

SELECT
    p.category,
    SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
    ON p.product_key = f.product_key
GROUP BY p.category
ORDER BY total_revenue DESC;

-- Quel est le chiffre d’affaires total généré par chaque client ?
SELECT
	CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
	FORMAT(SUM(f.sales_amount), 'C', 'en-US') AS total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
ON c.customer_key = f.customer_key
GROUP BY c.customer_key, c.first_name, c.last_name
ORDER BY SUM(f.sales_amount) DESC;

-- Quelle est la répartition des articles vendus par pays ?
SELECT
    c.country,
    SUM(f.quantity) AS total_sold_items
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
    ON c.customer_key = f.customer_key
GROUP BY c.country
ORDER BY total_sold_items DESC;
