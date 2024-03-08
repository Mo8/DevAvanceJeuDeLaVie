# DevAvanceJeuDeLaVie

## Description
Le but de l’application est de pouvoir faire des simulations du jeu de la vie avec différentes règles
( https://fr.wikipedia.org/wiki/Jeu_de_la_vie ) et de pouvoir jouer à plusieurs en ligne.

## Installation release

Voir release pour les versions disponibles ( https://github.com/Mo8/DevAvanceJeuDeLaVie/releases )
Lancer le serveur avec la commande suivante (en remplaçant l'url de la base de données par la valeur souhaitée):
```
.\server.exe -m 'mongodb+srv://host:password@localhost:27017/jeuDeLaVie?retryWrites=true&w=majority'
```
Lancer le client en éxécutant le fichier jeu_de_la_vie.exe ( le client est configuré pour se connecter au serveur http://localhost:8082 )
## Utilisation
### Run server pour test
Utiliser le server.exe pour lancer le serveur. Le serveur est lancé sur le port 8080 par défaut. Le serveur utilise une base de données MongoDB.
Lancer avec la commande suivante pour changer le port et définir un serveur mongodb:
```
.\server\bin\server.exe -p 8082 -m 'mongodb://localhost:27017'
```
### Run client pour test
Pour build le client, il suffit de lancer la commande suivante dans le dossier client:
```
flutter run --dart-define=apiUrl='http://localhost:8082'
```
### Connection
Vous pouvez vous connecter via le bouton "Se connecter" pour modifier les règles : 
- admin:admin
- user:user
### Un joueur 
Lancement via le bouton "Jeu de la vie - 1 joueur" sur la page d'accueil
Sur la page de la simulation vous pouvez lancer la simulation et la mettre en pause avec le bouton en haut à droite. Vous pouvez aussi rajouter des cellules en cliquant sur la grille ou cliquer sur le bouton "+" en bas a drotie pour rajouter un regroupement aléatoire de cellule
### Deux joueurs
Lancement via le bouton "Jeu de la vie via chat - 2 joueurs". Vous pouvez ouvrir une connection avec un autre utilisateur en rentrant un id ( un nombre entre 0 et 999999 généré aléatoirement ) correspondant à l'utilisateur cible voulu. Quand la connection est établi
### Chat commandes
- RULES: affiche les règles du jeu de la vie ( exemple : "RULES:23A3D" pour le jeu de la vie classique avec survie si 2 ou 3 voisins et naissance si 3 voisins)

## Changelog

V1 :

login -> pour un utilisateur un password un login une configuration du jeu de la vie 

affichage pour 10000 générations de la simulation du jeu de la vie + bouton d'arrêt 

2 jours de travail 

proposition technique : base de donnée mongodb + client flutter 

V1.1 :

chat via socket pour deux utilisateurs

1 jour de travail

V1.2 :

ajout de la possibilité de jouer à plusieurs:
    - proposition de règles de jeu
    - validation des règles par les joueurs
    - renvoie si validé, la grille à la millième génération avec les règles choisies et une grille aléatoire initiale

1 jour de travail

v1.3 :

- modification interface graphique
- sécurité : ajout d'une api/serveur intermédiaire pour contré les injection nosql
- ajout d'un icon pour l'application
- debug

2 jours de travail

## Documentation technique
https://docs.google.com/document/d/1CR-cL-39FZsQSUdEGfrbYmOMWxBXKB-zGtCkr1C3vfQ