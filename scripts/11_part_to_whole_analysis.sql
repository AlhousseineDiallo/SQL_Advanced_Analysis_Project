/*
===============================================================================
Analyse de contribution au tout des différentes catégories
===============================================================================
Objectif :
    - Comparer la performance ou les indicateurs entre différentes dimensions ou périodes.
    - Évaluer les différences entre catégories.
    - Utile pour les tests A/B ou les comparaisons régionales.

Fonctions SQL utilisées :
    - SUM(), AVG() : Agrègent les valeurs pour la comparaison.
    - Fonctions de fenêtre : SUM() OVER() pour les calculs totaux.
===============================================================================
*/

-- Quelles catégories contribuent le plus au chiffre d’affaires global ?
-- Voici un résultat formaté en devise américaine !

WITH category_part AS (
    SELECT
        pr.category,
        SUM(f.sales_amount) AS category_sales
    FROM gold.dim_products pr
    RIGHT JOIN gold.fact_sales f
    ON f.product_key = pr.product_key
    GROUP BY pr.category
)

SELECT
    category,
    FORMAT(category_sales, 'C', 'en-US') AS category_sales,
    FORMAT(CONVERT(float, category_sales) / SUM(category_sales) OVER(), 'P', 'en-US') AS total_sales
FROM category_part;

-- Une deuxième approche sans formatage des devises !

WITH category_sales AS (
    SELECT
        p.category,
        SUM(f.sales_amount) AS total_sales
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_products p
        ON p.product_key = f.product_key
    GROUP BY p.category
)
SELECT
    category,
    total_sales,
    SUM(total_sales) OVER () AS overall_sales,
    ROUND((CAST(total_sales AS FLOAT) / SUM(total_sales) OVER ()) * 100, 2) AS percentage_of_total
FROM category_sales
ORDER BY total_sales DESC;
