#!/bin/sh
#Créer un fichier zip à partir du dossier /home/dolibarr_mariadb dans le dossier backup dont le nomage seras Année-mois-jour_backup.zip 

zip -r "$(date +"%Y-%m-%d")_backup.zip" "/home/dolibarr_mariadb"

# Supprime les sauvegardes qui ont été crée il y a plus de 7 jours
find -type f -name "backup_*.zip" -mtime +7 -exec rm -- '{}' \;
