#Copie le fichier data.csv dans le docker
docker cp "data/data.csv" "mariadb:/tmp/data.csv"
#Crée un variable avec la commande qui vas être effectuer dans mariadb
temp="LOAD DATA LOCAL INFILE '/tmp/data.csv' INTO TABLE llx_societe FIELDS TERMINATED BY ',' ENCLOSED BY '\"' LINES TERMINATED BY '\n' ignore 1 lines (@col1,@col2,@col3,@col4) set nom=@col1,status=@col2,client=@col3,fournisseur=@col4;"
#éxécute la commande précédente dans mariadb qui vas importer les données du csv sans prendre en compte la première ligne et ou nous présison ce quoi correspond chaque collones
docker exec mariadb mariadb -uroot -p"root" dolidb -e "$temp"
