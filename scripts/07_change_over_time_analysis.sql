/*
===============================================================================
Analyse de l'Évolution dans le Temps
===============================================================================
Objectif :
    - Suivre les tendances, la croissance et les évolutions des indicateurs clés dans le temps.
    - Réaliser des analyses chronologiques et identifier la saisonnalité.
    - Mesurer la croissance ou le déclin sur des périodes spécifiques.

Fonctions SQL utilisées :
    - Fonctions de date : DATEPART(), DATETRUNC(), FORMAT()
    - Fonctions d’agrégation : SUM(), COUNT(), AVG()
===============================================================================
*/

-- Analyse des performances de ventes au cours du temps
-- Approche simple avec YEAR() et MONTH()

SELECT
    YEAR(order_date) AS order_year,
    MONTH(order_date) AS order_month,
    SUM(sales_amount) AS total_sales,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date), MONTH(order_date)
ORDER BY order_year, order_month;

-- Avec DATETRUNC()
SELECT
    DATETRUNC(month, order_date) AS order_date,
    SUM(sales_amount) AS total_sales,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC(month, order_date)
ORDER BY order_date;
