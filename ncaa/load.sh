#!/bin/bash

cmd="psql template1 --tuples-only --command \"select count(*) from pg_database where datname = 'hockey';\""

db_exists=`eval $cmd`
 
if [ $db_exists -eq 0 ] ; then
   cmd="createdb hockey;"
   eval $cmd
fi

psql hockey -f schema/create_schema.sql

tail -q -n+2 csv/ncaa_games_*.csv > /tmp/ncaa_games.csv
psql hockey -f loaders/load_ncaa_games.sql
rm /tmp/ncaa_games.csv

#cat ncaa/ncaa_players_*.csv > /tmp/ncaa_statistics.csv
#rpl ",-," ",," /tmp/ncaa_statistics.csv
#rpl ",-," ",," /tmp/ncaa_statistics.csv
#rpl ".," "," /tmp/ncaa_statistics.csv
#rpl ".0," "," /tmp/ncaa_statistics.csv
#rpl ".00," "," /tmp/ncaa_statistics.csv
#rpl ".000," "," /tmp/ncaa_statistics.csv
#rpl -e ",-\n" ",\n" /tmp/ncaa_statistics.csv
#psql hockey -f load_ncaa_statistics.sql
#rm /tmp/ncaa_statistics.csv

#psql hockey -f create_ncaa_players.sql

cp csv/ncaa_schools.csv /tmp/ncaa_schools.csv
psql hockey -f loaders/load_ncaa_schools.sql
rm /tmp/ncaa_schools.csv

cp csv/ncaa_divisions.csv /tmp/ncaa_divisions.csv
psql hockey -f loaders/load_ncaa_divisions.sql
rm /tmp/ncaa_divisions.csv

cp csv/ncaa_colors.csv /tmp/ncaa_colors.csv
psql hockey -f loaders/load_ncaa_colors.sql
rm /tmp/ncaa_colors.csv
