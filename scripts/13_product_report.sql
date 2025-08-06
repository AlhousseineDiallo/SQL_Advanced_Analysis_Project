/*
===============================================================================
Rapport Produit
===============================================================================
Objectif :
    - Ce rapport consolide les indicateurs clés et comportements des produits.

Points Clés :
    1. Rassemble les champs essentiels tels que le nom du produit, la catégorie, la sous-catégorie et le coût.
    2. Segmente les produits par revenu pour identifier les Meilleures Performances, les Gammes Moyennes ou les Moindres Performances.
    3. Agrège les métriques au niveau du produit :
       - nombre total de commandes
       - ventes totales
       - quantité totale vendue
       - nombre total de clients (uniques)
       - durée de vie (en mois)
    4. Calcule des indicateurs clés de performance (KPI) précieux :
       - récence (mois depuis la dernière vente)
       - revenu moyen par commande (AOR)
       - revenu mensuel moyen
===============================================================================
*/
-- =============================================================================
-- Créer Rapport : gold.report_products
-- =============================================================================

IF OBJECT_ID('gold.product_report', 'V') IS NOT NULL
    DROP VIEW gold.product_report;

GO

CREATE VIEW gold.product_report AS

    WITH base_query AS (
  
/*---------------------------------------------------------------------------
1) Requête de Base : Récupère les colonnes principales depuis fact_sales et dim_products
---------------------------------------------------------------------------*/
  
        SELECT
            pr.product_key,
            pr.product_number,
            pr.product_name,
            pr.category,
            pr.subcategory,
            pr.cost,
            f.sales_amount,
            f.quantity,
            f.order_date,
            f.customer_key,
            f.order_number
        FROM gold.fact_sales f
        LEFT JOIN gold.dim_products pr
        ON pr.product_key = f.product_key
        WHERE f.order_date IS NOT NULL
    )
    , product_aggregation AS (
/*---------------------------------------------------------------------------
2) Agrégations Produit : Résume les métriques clés au niveau des produits
---------------------------------------------------------------------------*/

        SELECT
            product_key,
            product_number,
            product_name,
            category,
            subcategory,
            cost,
            SUM(sales_amount) AS total_revenue,
            SUM(quantity) AS total_quantity,
            COUNT(DISTINCT order_number) AS total_orders,
            MAX(order_date) AS last_sale,
            DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS lifespan,
            COUNT(DISTINCT customer_key) AS total_unique_customer,
            ROUND(AVG(CAST(sales_amount AS float) / NULLIF(quantity, 0)), 1) AS avg_selling_price
        FROM base_query
        GROUP BY product_key, product_number, product_name, category, subcategory, cost
    )
  
  /*---------------------------------------------------------------------------
  3) Requête Finale : Combine tous les résultats produits en une seule sortie
---------------------------------------------------------------------------*/

    SELECT
        product_key,
        product_number,
        product_name,
        category,
        subcategory,
        CASE
            WHEN total_revenue > 50000 THEN 'High Performers'
            WHEN total_revenue >= 10000 THEN 'Mid Range'
            ELSE 'Low Performers'
        END AS product_segments,
        last_sale,
        DATEDIFF(MONTH, last_sale, GETDATE()) AS recency,
        lifespan,
        cost,
        FORMAT(total_revenue, 'C', 'en-US') AS total_revenue,
        total_quantity,
        total_orders,
        total_unique_customer,
        FORMAT(CASE
            WHEN total_orders = 0 THEN 0
            ELSE total_revenue / total_orders
        END, 'C', 'en-US') AS avg_order_revenue,
        FORMAT(CASE
            WHEN lifespan = 0 THEN total_revenue
            ELSE total_revenue / lifespan
        END, 'C','en-US') AS avg_monthly_revenue
    FROM product_aggregation;
