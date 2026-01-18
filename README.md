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

## Étape 2 — Ajout du fichier .dockerignore

Cette étape introduit un fichier `.dockerignore` afin de réduire le build context et exclure les fichiers inutiles, notamment `node_modules`.

Après l’ajout de `.dockerignore`, la construction de l’image met en évidence un problème dans le Dockerfile existant (copie de `node_modules` depuis la machine hôte), ce qui conduit logiquement à l’étape suivante de correction du Dockerfile.


