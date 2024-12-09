docker-compose up -d

sleep 30
bash import_csv.sh

echo "0 1 * * * /backup/sauvegarde.sh" > temp
crontab temp
rm temp
