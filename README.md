# tpDockerOpti

## Etape 0 — Baseline (image initiale sans modification)

L’objectif de cette première étape est de construire et exécuter l’image Docker **sans aucune optimisation**, afin d’obtenir une référence (baseline).  
Cette baseline servira de point de comparaison pour mesurer l’impact des optimisations réalisées dans les étapes suivantes.Aucun fichier n’a été modifié à cette étape.

### Commandes exécutées

- docker build -t tp:baseline 
Construction de l’image Docker initiale

- docker images tp:baseline 
Vérification de la taille de l’image
**Taille actuelle: 1.73GB**

- docker history tp:baseline
Analyse des différentes couches de l’image 

- docker run --rm -p 3000:3000 --name tp-baseline tp:baseline
Exécution du conteneur
-> http://localhost:3000

## Étape 2 — Ajout du fichier .dockerignore

Cette étape introduit un fichier `.dockerignore` afin de réduire le build context et exclure les fichiers inutiles, notamment `node_modules`.

Après l’ajout de `.dockerignore`, la construction de l’image met en évidence un problème dans le Dockerfile existant (copie de `node_modules` depuis la machine hôte), ce qui conduit logiquement à l’étape suivante de correction du Dockerfile.

## Étape 3 — Correction du Dockerfile

Cette étape vise à corriger le Dockerfile après l’introduction du fichier `.dockerignore`. La copie du dossier `node_modules` depuis la machine hôte a été supprimée, car elle est incompatible avec `.dockerignore` et ne constitue pas une bonne pratique.  
Les dépendances sont désormais installées directement dans l’image Docker.

Le Dockerfile a également été réorganisé afin d’améliorer l’utilisation du cache Docker, en copiant les fichiers `package*.json` avant l’installation des dépendances, puis le reste du code source.

Commandes exécutées :
- docker build -t tp:etape3 .
- docker images tp:etape3
**Taille actuelle: 1.69GB**
- docker history tp:etape3
- docker run --rm -p 3001:3000 tp:etape3


