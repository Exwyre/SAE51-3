# Sae51-3 - Mise en place d'un ERP/CRM Dolibarr - Guide d'utilisation et de fonctionnement
**08/12/24**
***Valentin DAVID
Corentin CHRETIEN***

## Rappel de l'objectif

Vous etes responsable informatique dans l’entreprise XXX. La direction souhaite migrer d’une solution ERP/CRM externalisee vers une solution hébergée en interne, basée sur le progiciel ”Dolibarr”. Elle a reussi a récuperer un export des données du prestataire actuel, sous la forme d’un ensemble de fichiers CSV (fichiers clients, fournisseurs, factures, commandes, etc.) La direction vous donne le cahier des charges suivants : Faire l’etude de la mise en place d’un Dolibarr fonctionnel sur un serveur dédié hébergé dans l’entreprise. Ceci implique de considerer a la fois le coté installation, l’aspect import des donnees, et l’aspect sauvegarde des données. L’objectif final est d’arriver a une solution respectant les contraintes suivantes :
* L’installation sera automatisee, via le lancement d’un unique script install.sh qui va a la fois installer Dolibarr mais aussi le SGBD nécessaire. 
* L’import des donnees exportées depuis l’ancien système sera automatisé via un unique script import_csv.sh
* Afin de s’affranchir de l’OS sous-jacent du serveur, toute l’installation (Dolibarr + SGBD) sera de preférence ”dockerisée”.
* L’aspect sauvegarde est crucial. On veut pouvoir a un instant t faire une sauvegarde de toutes les donnees, et etre capable, via la procédure d’installation ci-dessus, de repartir de 0 et tout recupérer (contexte d’un ”PRA” apres incident).

## Description



## Fonctionnement

Notre Docker Compose lance 2 conteneurs dont leur rôle est :
* Dolibarr correspond au logiciel ERP/CRM
* Mariadb s'occupe de stocker les données de dolibarr.

Afin de mieux comprendre, voici un schéma de leur fonctionnement :
![Diagram_Fonctionnement](Images/Diagram_Fonctionnement.png)


## Mise en place
### Prérequis

Pour tester cette configuration, vous aurez besoin de :

* Docker, Docker Compose et zip installés sur votre machine. 
  S'ils ne sont pas installés sur votre machine, effectuez les commandes suivantes :
  ``sudo apt install docker``, ``sudo apt install docker-compose`` et ``sudo apt install zip``.
* Un clone du projet avec les fichiers de configuration pour Mariadb ainsi que Dolibarr.

### Démarrage du projet
1. Cloner le projet :
   ```
   git clone https://github.com/Exwyre/sae-dolibarr
   cd sae-dolibarr
   ```
2. Vérifier que le service docker-compose soit actif:
   ```
   systemctl status docker-compose
   ```   
3. Lancer le script d'installation :
   ```
   bash install.sh
   ```   
4. Accéder à l'interface Dolibarr :

   Une fois que les conteneurs sont en marche (Cela peut prendre quelques secondes), vous pouvez accéder à Dolibarr via votre navigateur à l'URL suivante :
   ```
   http://localhost:8085
   ```
   Ou bien:
   ```
   http://0.0.0.0:8085
   ```
6. Se connecter dans l'ERP/CRM

    Les logins sont admin / admin

### Import et sauvegarde des données

1. Pour importer des données, vous devez modifier le fichier csv en remplissant les information nécessaire. Puis dans un terminal, entrer la commande suivante
   ```
   bash import_csv.sh
   ```
2.  La sauvegarde automatique

  Pour vérifier que la sauvegarde automatique est bien fonctionnel, entrer dans un terminal la commande:
  ```
  sudo crontab -l
  ```
  Si la sauvegarde est bien activé, vous devrier voir cet ligne:
  ```
  0 1 * * * /backup/sauvegarde.sh
  ```
  Sinon, entrer ces lignes de commandes dans le terminal:
  ```
  echo "0 1 * * * cd /home/vboxuser/temps/sae-dolibarr/backup/ && sudo bash sauvegarde.sh" > temp
  crontab temp
  rm temp
  ```
  Ainsi, dès qu'une sauvegarde est effectuée, elle sera présente dans le dossier backup. De plus, les fichiers sont compressés et supprimés après une semaine.

3. Pour faire une sauvegarde manuelle
  Si vous souhaitez effectuer un sauvegarde manuelle, effectuer cette commande dans le dossier backup:
  ```
  zip -r "$(date +"%Y-%m-%d")_backup_manuelle.zip" "/home/dolibarr_mariadb"
  ```
4. Relance suite à une sauvegarde
  Si vous souhaiter revenir sur une sauvegarde passée, dans le dossier backup, effectuer cette commande:
  ```
  unzip DateDeLaSauvegarde_backup.zip -d /home/dolibarr_mariadb
  ```
## Ce que vous devriez voir à l'exécution
Lorsque le projet est en marche, vous dervriez arriver sur cette page
![Apercu](Images/Apercu.png)
Une fois connéctée (pour rappel, les logins sont admin/admin), voici ce que vous devez voir:
![Dashbord](Images/Dashbord.png)
Afin de vérifier que des clients on bien été ajouter à la base de données, le nombre de "Customers" devrait affiché et ne pas être égale à 0.

## Points clés du projet
* Ce qui a bien fonctionné:
  * Répartition du travail entre nous :  Chacun a pu se concentrer sur des tâches précises (définies grâce au cahier des charges et au suivi des séances), de manière à travailler sur la partie du projet où il se sentait le plus à l’aise.

* Problèmes rencontrés :
  * Au début du projet, nous avons rencontré des difficultés concernant la configuration du Dockerfile, notamment pour la liaison entre la base de données et Dolibarr. Suite à un échange avec M. Kramm, nous avons pris la décision d'utiliser un Docker Compose plutôt qu'un Dockerfile.
