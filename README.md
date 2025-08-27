# Projet d'Analyse de Données Avancée avec SQL

## Description

Ce projet est une démonstration de plusieurs techniques avancées d'analyse de données en utilisant SQL. Il s'appuie sur un jeu de données de ventes pour explorer le comportement des clients, la performance des produits et les tendances de ventes. Les analyses sont structurées comme une séquence de scripts SQL, chacun approfondissant les résultats du précédent pour révéler des informations exploitables.

## Structure du Projet

Le projet est organisé comme suit :

-   `LICENSE`: Le fichier de licence du projet.
-   `datasets/`: Contient les jeux de données au format CSV qui servent de base à l'analyse.
-   `scripts/`: Contient tous les scripts d'analyse SQL, numérotés dans l'ordre de leur exécution logique.

### 1. Fichiers de Données (`datasets/`)

-   `gold.dim_customers.csv`: Table de dimension contenant les informations démographiques sur les clients.
-   `gold.dim_products.csv`: Table de dimension contenant les détails sur les produits.
-   `gold.fact_sales.csv`: Table de faits contenant les enregistrements de toutes les transactions de vente.

### 2. Scripts d'Analyse (`scripts/`)

Les scripts sont conçus pour être exécutés séquentiellement et couvrent un large éventail de techniques d'analyse :

1.  **Exploration :** Scripts initiaux pour se familiariser avec la structure de la base de données, les dimensions et les mesures.
2.  **Analyses Fondamentales :** Scripts axés sur la magnitude, le classement, l'évolution temporelle et les cumuls.
3.  **Analyses de Performance :** Scripts pour évaluer la performance et segmenter les données afin d'identifier des tendances clés.
4.  **Rapports :** Scripts finaux pour générer des vues consolidées pour les rapports sur les clients et les produits.

## Comment l'utiliser

1.  **Chargez les données :** Importez les fichiers CSV du répertoire `datasets` dans votre système de gestion de base de données (par exemple, PostgreSQL, MySQL, SQL Server).
2.  **Exécutez les scripts :** Lancez les scripts SQL du répertoire `scripts` dans l'ordre numérique pour suivre le flux d'analyse.
3.  **Explorez :** N'hésitez pas à modifier les scripts ou à en créer de nouveaux pour approfondir l'analyse et répondre à des questions spécifiques.

## Conclusion

Ce projet représente une exploration complète et structurée de l'analyse de données, depuis la simple interrogation jusqu'à la création de rapports complexes. Chaque script est une étape d'un parcours logique, transformant des données brutes en informations claires et stratégiques. Le résultat est une démonstration tangible de la puissance du SQL pour non seulement répondre à des questions, mais aussi pour raconter une histoire avec les données.