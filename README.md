# FaceWorker

L'application FaceWorker est capable d’appliquer des filtres à une photo, de reconnaitre un visage sur une photo, ou même de reconnaître une personne en video en temps réel.
L’application se présente ainsi : 3 boutons pour accéder aux trois fonctionnalités principales que propose FaceWorker : FaceFilter, IRecognition (Eigenfaces) ou VRecognition (reconnaissance faciale en temps réel). 
La première permet de charger une image, de sélectionner un ou plusieurs filtres via une interface très intuitive qui propose de nombreux filtres dans un menu déroulant et accessibles via des boutons sur le côté droit de l’image. Lorsque l’image est chargée, on peut directement visualiser les modifications apportées sur l’image. Lorsque les modifications sont faites, on peut sauvegarder l’image.
La deuxième, permet de charger une image et de détecter le visage puis en parcourant une base de données de visages pré-enregistrées, reconnaitre à qui appartient cette photo. 
La dernière option, est malheureusement encore en cours d’implémentation car elle s’est avérée plus complexe que prevue. Nous allons tout de même expliquer son fonctionnement. Elle permet de reconnaître en temps réel le visage d’une personne et de lui associer un nom.

## Filtres

Il existe 18 filtres différents dont les filtres passe haut, passe bas ou des filtres utilisant les histogrammes mais pas seulement (une liste exhaustive est donnée plus bas). Il est également possible de cumuler différents filtres et ainsi de rajouter un second filtre par-dessus un premier filtre. 
Enfin, une option de sauvegarde d'image a été ajoutée, ce qui crée un nouveau fichier utilisable par la suite dont le nom commence par ```fw``` avec le même format de l'image sélectionnée.

Voici la liste des 18 filtres dans notre application : 
- nuance de gris 
- binaire 
- complément binaire
- égalisation d’histogramme
- Sobel
- Sepia
- Prewitt
- luminosité
- Laplacien
- Sharpen
- moyenneur
- médian
- inversion de couleurs
- tourbillon
- bilatéral
- interpolation bilinéaire
- miroir

## IRecognition

Cette fonctionnalité permet de reconnaitre une image parmi une base de données à l'aide de la méthode Eigenfaces.
Les eigenfaces sont un ensemble de vecteurs propres utilisés dans le domaine de la vision artificielle afin de résoudre le problème de la reconnaissance du visage humain. Le recours à des eigenfaces pour la reconnaissance a été développé par Sirovich et Kirby (1987) et utilisé par Matthew Turk et Alex Pentland pour la classification de visages. Cette méthode est considérée comme le premier exemple réussi de technologie de reconnaissance faciale. Ces vecteurs propres sont dérivés de la matrice de covariance de la distribution de probabilité de l'espace vectoriel de grande dimension des possibles visages d'êtres humains (source: Wikipedia). 

Cette méthode va permettre d'identifier le visage en analysant l'ensemble du visage, on parle alors d'analyse en composant principale (PCA) se différenciant ainsi des méthodes géométriques ou locales qui eux se concentrent sur les signes/marques du visage (et qui peuvent parfois paraître imprécises). La méthode Eigenfaces est un algorithme plutôt simple à implémenter et efficace : elle présente un bon taux de réussite (évidemment plus la base de données est grande, plus le taux de réussite est significatif).

Les fonctions concernant Eigenfaces se trouvent dans le fichier ```fwEigen.m``` qui s'occupe de charger la base de données d'apprentissage ```Dataset``` et une image à reconnaître que l'on peut trouver dans ```Testset```.

## VRecognition

Pour le moment le ```VRecognition``` est en cours de développement, le principe est de reconnaître le visage en temps réel (via une webcam) à partir des cartes auto adaptatives (SOM, également appelé cartes de Kohonen).

## En savoir plus

Pour en savoir plus sur les fonctionnalités de l'application, vous pouvez également consulter le fichier ```framework.pdf```.
