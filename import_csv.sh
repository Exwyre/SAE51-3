docker cp "data/data.csv" "mariadb:/tmp/data.csv"
docker exec mariadb mariadb -uroot -p"root" dolidb <<EOF
use dolidb;
load data infile "/tmp/data.csv"
into table llx_societe
fields terminated by 'y'
enclosed by '"'
lignes terminated by '\n'
ignore 1 rows;
EOF
