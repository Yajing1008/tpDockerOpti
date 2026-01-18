# tpDockerOpti

## Etape 1 — Baseline (image initiale sans modification)

L’objectif de cette première étape est de construire et exécuter l’image Docker sans aucune optimisation, afin d’obtenir une référence (baseline).  
Cette baseline servira de point de comparaison pour mesurer l’impact des optimisations réalisées dans les étapes suivantes.Aucun fichier n’a été modifié à cette étape.

### Commandes exécutées

- docker build -t tp:baseline 
Construction de l’image Docker initiale

- docker images tp:baseline 
Vérification de la taille de l’image
**Taille actuelle: 1.73GB(DISK USAGE) 436MB(CONTENT SIZE)**

- docker history tp:baseline
Analyse des différentes couches de l’image 

- docker run -d -p 3000:3000 --name tp-baseline tp:baseline
Exécution du conteneur
-> http://localhost:3000

## Étape 2 — Ajout du fichier .dockerignore

Cette étape introduit un fichier `.dockerignore` afin de réduire le build context et exclure les fichiers inutiles, notamment `node_modules`.

Après l’ajout de `.dockerignore`, la construction de l’image met en évidence un problème dans le Dockerfile existant (copie de `node_modules` depuis la machine hôte), ce qui conduit logiquement à l’étape suivante de correction du Dockerfile.

## Étape 3 — Modification du Dockerfile (Suivie de l'étape 2)

Cette étape vise à corriger le Dockerfile après l’introduction du fichier `.dockerignore`. La copie du dossier `node_modules` depuis la machine hôte a été supprimée, car elle est incompatible avec `.dockerignore` et ne constitue pas une bonne pratique.  
Les dépendances sont désormais installées directement dans l’image Docker.

Le Dockerfile a également été réorganisé afin d’améliorer l’utilisation du cache Docker, en copiant les fichiers `package*.json` avant l’installation des dépendances, puis le reste du code source.

**Taille actuelle: 1.69GB(DISK USAGE) 420MB(CONTENT SIZE)**

La réduction reste limitée à cette étape, ce qui justifie la poursuite des optimisations.

## Étape 4 — Multi-stage build

Mise en place d’un Dockerfile multi-stage afin de séparer l’installation des outils de build et des dépendances complètes de l’image finale d’exécution.

Le stage `builder` contient les outils de compilation nécessaires à l’installation de certains modules npm, tandis que le stage `runtime` n’embarque que les dépendances de production et le fichier `server.js`.

**Taille actuelle: 1.65GB(DISK USAGE) 411MB(CONTENT SIZE)**

La réduction reste modérée en raison de la simplicité du projet (serveur Node.js sans artefacts de build volumineux).  
Néanmoins, l’approche multi-stage améliore clairement la structure de l’image en séparant les dépendances de build et l’environnement d’exécution, ce qui constitue une bonne pratique recommandée pour les applications Dockerisées.

## Étape 5 — Runtime plus léger (Alpine)

Cette étape remplace l’image de base du stage d’exécution par `node:alpine` afin de réduire davantage la taille de l’image finale.
Le stage `builder` reste basé sur `node:latest` pour conserver la compatibilité lors de l’installation d’éventuels modules nécessitant une compilation.

**Taille actuelle: 256MB(DISK USAGE) 62.6MB(CONTENT SIZE)**

### Conclusion

L’optimisation progressive de l’image Docker a permis de réduire significativement sa taille après l'étape 5.

Les premières étapes ont amélioré la structure du Dockerfile et l’utilisation du cache Docker, tandis que la mise en place d’un build multi-stage a permis de séparer clairement les phases de build et d’exécution.

Le gain le plus important a été obtenu lors de l’étape 5, en remplaçant l’image de base du runtime par `node:alpine`.  
La taille réelle de l’image est ainsi passée d’environ 411 MB (étape 4) à environ 62 MB (étape 5), soit une réduction de plus de 80 %.

Cette démarche met en évidence l’impact du choix de l’image de base et illustre les bonnes pratiques de construction d’images Docker légères et maintenables.

Cette optimisation n’altère pas le fonctionnement applicatif, comme validé par l’exécution du conteneur à chaque étape.


