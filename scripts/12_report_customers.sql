/*
===============================================================================
Rapport Clients
===============================================================================
Objectif :
    - Ce rapport consolide les principaux indicateurs et comportements des clients.

Points clés :
    1. Regroupe les champs essentiels tels que noms, âges, et détails des transactions.
    2. Segmente les clients en catégories (VIP, Réguliers, Nouveaux) et groupes d’âge.
    3. Agrège les indicateurs au niveau client :
       - nombre total de commandes
       - chiffre d’affaires total
       - quantité totale achetée
       - nombre total de produits
       - durée de vie (en mois)
    4. Calcule des indicateurs clés de performance (KPI) précieux :
       - récence (nombre de mois depuis la dernière commande)
       - valeur moyenne des commandes
       - dépense moyenne mensuelle
===============================================================================
*/

-- =============================================================================
-- Création du rapport : gold.report_customers
-- =============================================================================

IF OBJECT_ID('gold.report_customers', 'V') IS NOT NULL
    DROP VIEW gold.report_customers;

GO

CREATE VIEW gold.report_customers AS

    WITH base_query AS (

/*---------------------------------------------------------------------------
1) Requête de Base : Récupère les colonnes principales des tables
---------------------------------------------------------------------------*/
        SELECT
            f.order_number,
            f.product_key,
            f.order_date,
            f.sales_amount,
            f.quantity,
            c.customer_key,
            c.customer_number,
            CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
            DATEDIFF(YEAR, c.birthdate, GETDATE()) AS age
        FROM gold.fact_sales f
        LEFT JOIN gold.dim_customers c
        ON c.customer_key = f.customer_key
        WHERE f.order_date IS NOT NULL

    ), customer_aggregation AS (
/*---------------------------------------------------------------------------
2) Agrégations Clients : Agrège les indicateurs clés par client
---------------------------------------------------------------------------*/
        SELECT
            customer_key,
            customer_number,
            customer_name,
            age,
            COUNT(DISTINCT order_number) AS total_orders,
            SUM(sales_amount) AS total_sales,
            SUM(quantity) AS total_quantity,
            COUNT(DISTINCT product_key) AS total_products,
            MAX(order_date) AS last_order,
            DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS lifespan
        FROM base_query
        GROUP BY customer_key, customer_number, customer_name, age
    )

    SELECT
        customer_key,
        customer_number,
        customer_name,
        age,
        CASE
            WHEN age BETWEEN 0 AND 17 THEN 'Children'
            WHEN age BETWEEN 18 AND 60 THEN 'Adult'
            ELSE 'Senior'
        END age_segment,
        CASE
            WHEN lifespan >= 12 AND total_sales > 5000 THEN 'VIP'
            WHEN lifespan >= 12 AND total_sales <= 5000 THEN 'Regular'
            WHEN lifespan < 12 THEN 'New'
        END customer_segment,
        last_order,
        DATEDIFF(MONTH, last_order, GETDATE()) AS recency,
        total_orders,
        FORMAT(total_sales, 'C', 'en-US') AS total_sales,
        total_quantity,
        total_products,
        FORMAT(CASE
            WHEN total_orders = 0 THEN 0
            ELSE total_sales / total_orders
            END, 'C', 'en-US') AS average_order_value,
        FORMAT(CASE
            WHEN lifespan = 0 THEN total_sales
            ELSE total_sales / lifespan
        END, 'C', 'en-US') AS avg_monthly_spend
    FROM customer_aggregation
;
