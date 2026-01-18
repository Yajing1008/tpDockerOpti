# tpDockerOpti

## Etape 0 — Baseline (image initiale sans modification)

L’objectif de cette première étape est de construire et exécuter l’image Docker **sans aucune optimisation**, afin d’obtenir une référence (baseline).  
Cette baseline servira de point de comparaison pour mesurer l’impact des optimisations réalisées dans les étapes suivantes.Aucun fichier n’a été modifié à cette étape.

### Commandes exécutées

1.docker build -t tp:baseline 
Construction de l’image Docker initiale

2.docker images tp:baseline 
Vérification de la taille de l’image 

3.docker history tp:baseline
Analyse des différentes couches de l’image 

4.docker run --rm -p 3000:3000 --name tp-baseline tp:baseline
Exécution du conteneur
-> http://localhost:3000

