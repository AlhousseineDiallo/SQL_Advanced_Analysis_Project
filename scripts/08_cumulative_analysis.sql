/*
===============================================================================
Analyse Cumulative
===============================================================================
Objectif :
    - Calculer les totaux cumulés ou les moyennes mobiles pour les indicateurs clés.
    - Suivre la performance au fil du temps de manière cumulative.
    - Utile pour l’analyse de croissance ou l’identification de tendances à long terme.

Fonctions SQL utilisées :
    - Fonctions de fenêtre : SUM() OVER(), AVG() OVER()
===============================================================================
*/

-- Calculer le total des ventes par mois  
-- ainsi que le total cumulé des ventes au fil du temps

-- 1 ère approche avec le total cumulé

SELECT
    DATENAME(MONTH, order_date) AS order_month,
    SUM(sales_amount) AS total_revenue,
    SUM(SUM(sales_amount)) OVER(PARTITION BY YEAR(order_date) ORDER BY MONTH(order_date) ASC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_sum
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date), DATENAME(MONTH, order_date), MONTH(order_date);

-- 2 ème approche avec une sous requêtes et un formate de notre revenue en devise Américaine avec la fonction FORMAT()

SELECT
    order_month,
    FORMAT(total_revenue, 'C', 'en-US') AS total_revenue,
    FORMAT(SUM(total_revenue) OVER(PARTITION BY YEAR(order_month) ORDER BY order_month ASC ROWS UNBOUNDED PRECEDING), 'C', 'en-US') AS running_sum
FROM (
    SELECT
        DATETRUNC(MONTH, order_date) AS order_month,
        SUM(sales_amount) AS total_revenue
    FROM gold.fact_sales
    WHERE order_date IS NOT NULL
    GROUP BY DATETRUNC(MONTH, order_date)
)t
ORDER BY order_month

-- Calcul du revenue cumulé et de la moyenne mobile du revenue

SELECT
    order_year,
    FORMAT(total_revenue, 'C', 'en-US') AS total_revenue,
    FORMAT(SUM(total_revenue) OVER(ORDER BY order_year ROWS UNBOUNDED PRECEDING), 'C', 'en-US') AS running_sum,
    FORMAT(AVG(avg_price) OVER(ORDER BY order_year ROWS UNBOUNDED PRECEDING), 'C', 'en-US') AS moving_average_price
FROM (
    SELECT
        DATETRUNC(YEAR,  order_date) AS order_year,
        SUM(sales_amount) AS total_revenue,
        AVG(price) AS avg_price
    FROM gold.fact_sales
    WHERE order_date IS NOT NULL
    GROUP BY DATETRUNC(YEAR, order_date)
)t
ORDER BY order_year;
