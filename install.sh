#Lance le docker compose de façon detached
docker-compose up -d

#Attend 30 secondes avant d'éxécuter le script import_csv.sh, qui permet d'importer des données dans la base de données à partir d'un csv
sleep 30
bash import_csv.sh

#Permet d'ajouter une ligne dans le crontab pour que tout les jours à 1H du matin le script sauvegarde.sh s'éxécute, qui fait une sauvegarde de la base de donnée
echo "0 1 * * * /backup/sauvegarde.sh" > temp
sudo crontab temp
rm temp
