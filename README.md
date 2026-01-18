# tpDockerOpti

## Etape 1 — Baseline (image initiale sans modification)

L’objectif de cette première étape est de construire et exécuter l’image Docker sans aucune optimisation, afin d’obtenir une référence (baseline).  
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

## Étape 3 — Modification du Dockerfile (Suivi l'étape 2)

Cette étape vise à corriger le Dockerfile après l’introduction du fichier `.dockerignore`. La copie du dossier `node_modules` depuis la machine hôte a été supprimée, car elle est incompatible avec `.dockerignore` et ne constitue pas une bonne pratique.  
Les dépendances sont désormais installées directement dans l’image Docker.

Le Dockerfile a également été réorganisé afin d’améliorer l’utilisation du cache Docker, en copiant les fichiers `package*.json` avant l’installation des dépendances, puis le reste du code source.

**Taille actuelle: 1.69GB**

## Étape 4 — Multi-stage build

Mise en place d’un Dockerfile multi-stage afin de séparer l’installation des outils de build et des dépendances complètes de l’image finale d’exécution.

Le stage `builder` contient les outils de compilation nécessaires à l’installation de certains modules npm, tandis que le stage `runtime` n’embarque que les dépendances de production et le fichier `server.js`.

**Taille actuelle: 1.65GB**

La réduction reste modérée en raison de la simplicité du projet (serveur Node.js sans artefacts de build volumineux).  
Néanmoins, l’approche multi-stage améliore clairement la structure de l’image en séparant les dépendances de build et l’environnement d’exécution, ce qui constitue une bonne pratique recommandée pour les applications Dockerisées.



