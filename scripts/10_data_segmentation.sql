/*
===============================================================================
Analyse de Segmentation des Données
===============================================================================
Objectif :
    - Regrouper les données en catégories significatives pour des insights ciblés.
    - Pour la segmentation client, la catégorisation produit ou l’analyse régionale.

Fonctions SQL utilisées :
    - CASE : Définit une logique personnalisée de segmentation.
    - GROUP BY : Regroupe les données en segments.
===============================================================================
*/

/* Segmenter les produits en tranches de coûts et  
compter combien de produits appartiennent à chaque segment */

WITH product_segments AS (
    SELECT
        product_key,
        product_name,
        cost,
        CASE 
            WHEN cost < 100 THEN 'Below 100'
            WHEN cost BETWEEN 100 AND 500 THEN '100-500'
            WHEN cost BETWEEN 500 AND 1000 THEN '500-1000'
            ELSE 'Above 1000'
        END AS cost_range
    FROM gold.dim_products
)
SELECT 
    cost_range,
    COUNT(product_key) AS total_products
FROM product_segments
GROUP BY cost_range
ORDER BY total_products DESC;

/* Regrouper les clients en trois segments basés sur leur comportement d'achat :
    - VIP : Clients avec au moins 12 mois d'historique et des dépenses supérieures à 5 000 €.
    - Réguliers : Clients avec au moins 12 mois d'historique mais des dépenses de 5 000 € ou moins.
    - Nouveaux : Clients avec une ancienneté inférieure à 12 mois.
Et trouver le nombre total de clients par groupe
*/

WITH customer_segmentation AS (
    SELECT
        c.customer_key,
        CASE
            WHEN DATEDIFF(MONTH, MIN(f.order_date), MAX(f.order_date)) >= 12 AND SUM(f.sales_amount)  > 5000 THEN 'VIP'
            WHEN DATEDIFF(MONTH, MIN(f.order_date), MAX(f.order_date)) >= 12 AND SUM(f.sales_amount) <= 5000 THEN 'Regular'
            ELSE 'New'
        END AS spending_behavior
    FROM gold.dim_customers c
    RIGHT JOIN gold.fact_sales f
    ON f.customer_key = c.customer_key
    WHERE f.order_date IS NOT NULL
    GROUP BY c.customer_key
)

SELECT
    spending_behavior,
    COUNT(customer_key) AS nbr_customers
FROM customer_segmentation
GROUP BY spending_behavior
ORDER BY nbr_customers DESC;

-- Voici une deuxième approche moins directe

WITH customer_spending AS (
    SELECT
        c.customer_key,
        SUM(f.sales_amount) AS total_spending,
        MIN(order_date) AS first_order,
        MAX(order_date) AS last_order,
        DATEDIFF(month, MIN(order_date), MAX(order_date)) AS lifespan
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_customers c
        ON f.customer_key = c.customer_key
    GROUP BY c.customer_key
)
SELECT 
    customer_segment,
    COUNT(customer_key) AS total_customers
FROM (
    SELECT 
        customer_key,
        CASE 
            WHEN lifespan >= 12 AND total_spending > 5000 THEN 'VIP'
            WHEN lifespan >= 12 AND total_spending <= 5000 THEN 'Regular'
            ELSE 'New'
        END AS customer_segment
    FROM customer_spending
) AS segmented_customers
GROUP BY customer_segment
ORDER BY total_customers DESC;
