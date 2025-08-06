/*
===============================================================================
Exploration des dimensions
===============================================================================
Objectif :
    - Explorer la structure des tables de dimensions.
	
Fonctions SQL utilisées :
    - DISTINCT
    - ORDER BY
===============================================================================
*/

-- Récupérer la liste des pays uniques d'origine des clients
SELECT DISTINCT 
    country 
FROM gold.dim_customers
ORDER BY country;

-- Récupérer la liste des catégories, sous-catégories, et produits

SELECT DISTINCT 
    category, 
    subcategory, 
    product_name 
FROM gold.dim_products
ORDER BY category, subcategory, product_name;

-- Récupérer la liste unique des situations matrimoniales
SELECT DISTINCT
	marital_status
FROM gold.dim_customers;

-- Récupérer la liste unique des genres des clients
SELECT DISTINCT
	gender
FROM gold.dim_customers;
