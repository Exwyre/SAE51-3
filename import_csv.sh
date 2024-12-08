docker cp "data/data.csv" "mariadb:/tmp/data.csv"
temp="LOAD DATA LOCAL INFILE '/tmp/data.csv' INTO TABLE llx_societe FIELDS TERMINATED BY ',' ENCLOSED BY '\"' LINES TERMINATED BY '\n' ignore 1 lines (@col1,@col2,@col3,@col4) set nom=@col1,status=@col2,client=@col3,fournisseur=@col4;"
docker exec mariadb mariadb -uroot -p"root" dolidb -e "$temp"
