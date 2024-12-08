zip -r "$(date +"%Y-%m-%d")_backup.zip" "/home/dolibarr_mariadb"

# (Optionnel) Supprimer les sauvegardes plus anciennes que 7 jours
find -type f -name "backup_*.zip" -mtime +7 -exec rm -- '{}' \;
