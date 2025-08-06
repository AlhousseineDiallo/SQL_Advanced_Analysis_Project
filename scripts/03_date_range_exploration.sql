/*
===============================================================================
Exploration de l’intervalle de dates
===============================================================================
Objectif :
    - Déterminer les limites temporelles des données clés.
    - Comprendre l’étendue des données historiques.

Fonctions SQL utilisées :
    - MIN(), MAX(), DATEDIFF()
===============================================================================
*/

-- Déterminer la première et la dernière date de commande ainsi que la durée totale en mois

SELECT 
    MIN(order_date) AS first_order_date,
    MAX(order_date) AS last_order_date,
    DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS order_range_months
FROM gold.fact_sales;

-- Trouver le client le plus jeune et le plus âgé en se basant sur la date de naissance

SELECT
    MIN(birthdate) AS oldest_birthdate,
    DATEDIFF(YEAR, MIN(birthdate), GETDATE()) AS oldest_age,
    MAX(birthdate) AS youngest_birthdate,
    DATEDIFF(YEAR, MAX(birthdate), GETDATE()) AS youngest_age
FROM gold.dim_customers;
