/*
===============================================================================
Analyse de Performance (Année sur Année, Mois sur Mois)
===============================================================================
Objectif :
    - Mesurer la performance des produits, clients ou régions au fil du temps.
    - Pour le benchmarking et l’identification des entités performantes.
    - Suivre les tendances et la croissance annuelles.

Fonctions SQL utilisées :
    - LAG() : Accède aux données des lignes précédentes.
    - AVG() OVER() : Calcule les valeurs moyennes au sein de partitions.
    - CASE : Définit une logique conditionnelle pour l’analyse des tendances.
===============================================================================
*/

/* Analyser la performance annuelle des produits en comparant leurs ventes  
à la fois à la performance moyenne des ventes du produit et aux ventes de l’année précédente */

WITH yearly_product_sales AS (

    SELECT
        YEAR(f.order_date) AS order_year,
        pr.product_name,
        SUM(f.sales_amount) AS current_sales
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_products pr
    ON pr.product_key = f.product_key
    WHERE order_date IS NOT NULL
    GROUP BY YEAR(f.order_date), pr.product_key, pr.product_name
)

SELECT
    order_year,
    product_name,
    FORMAT(current_sales, 'C', 'en-US') AS current_sales,
    FORMAT(AVG(current_sales) OVER(PARTITION BY product_name), 'C', 'en-US') AS avg_product_sales,
    CASE
        WHEN current_sales - AVG(current_sales) OVER(PARTITION BY product_name) > 0 THEN 'Above avg'
        WHEN current_sales - AVG(current_sales) OVER(PARTITION BY product_name) < 0 THEN 'Below avg'
    END AS avg_change,
    FORMAT(LAG(current_sales, 1, 0) OVER(PARTITION BY product_name ORDER BY order_year), 'C', 'en-US') AS product_previous_sales,
    CASE
        WHEN current_sales - LAG(current_sales, 1, 0) OVER(PARTITION BY product_name ORDER BY order_year) > 0 THEN 'Above py'
        WHEN current_sales - LAG(current_sales, 1, 0) OVER(PARTITION BY product_name ORDER BY order_year) < 0 THEN 'Below py'
    END AS diff_py -- py = previous_year
FROM yearly_product_sales;
