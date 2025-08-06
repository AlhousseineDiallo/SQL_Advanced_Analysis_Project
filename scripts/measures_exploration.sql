/*
===============================================================================
Exploration des mesures (indicateurs clés)
===============================================================================
Objectif :
    - Calculer des métriques agrégées (ex. : totaux, moyennes) pour obtenir des insights rapides.
    - Identifier des tendances générales ou repérer des anomalies.

Fonctions SQL utilisées :
    - COUNT(), SUM(), AVG()
===============================================================================
*/

-- Trouver le total des ventes
/*
===============================================================================
Exploration des mesures (indicateurs clés)
===============================================================================
Objectif :
    - Calculer des métriques agrégées (ex. : totaux, moyennes) pour obtenir des insights rapides.
    - Identifier des tendances générales ou repérer des anomalies.

Fonctions SQL utilisées :
    - COUNT(), SUM(), AVG()
===============================================================================
*/

-- Trouver le total des ventes
SELECT SUM(sales_amount) AS total_sales FROM gold.fact_sales

-- Trouver le nombre total d'articles commandés
SELECT SUM(quantity) AS total_quantity FROM gold.fact_sales

-- Trouver le prix de vente moyen
SELECT AVG(price) AS avg_price FROM gold.fact_sales

-- Trouver le nombre total de commandes

SELECT COUNT(order_number) AS total_orders FROM gold.fact_sales
SELECT COUNT(DISTINCT order_number) AS total_orders FROM gold.fact_sales

-- Trouver le nombre total de produits
SELECT COUNT(product_name) AS total_products FROM gold.dim_products

-- Trouver le nombre total de clients

SELECT COUNT(customer_key) AS total_customers FROM gold.dim_customers;

-- Trouver le nombre total de clients qui ont effectuées une commande

SELECT COUNT(DISTINCT customer_key) AS total_customers FROM gold.fact_sales;

-- Voici un report qui résume toutes les métriques clés

SELECT 'Total Sales' AS measure_name, SUM(sales_amount) AS measure_value FROM gold.fact_sales
UNION ALL
SELECT 'Total Quantity', SUM(quantity) FROM gold.fact_sales
UNION ALL
SELECT 'Average Price', AVG(price) FROM gold.fact_sales
UNION ALL
SELECT 'Total Orders', COUNT(DISTINCT order_number) FROM gold.fact_sales
UNION ALL
SELECT 'Total Products', COUNT(DISTINCT product_name) FROM gold.dim_products
UNION ALL
SELECT 'Total Customers', COUNT(customer_key) FROM gold.dim_customers;

