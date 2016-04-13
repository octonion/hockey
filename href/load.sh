#!/bin/bash

cmd="psql template1 --tuples-only --command \"select count(*) from pg_database where datname = 'hockey';\""

db_exists=`eval $cmd`

if [ $db_exists -eq 0 ] ; then
   createdb hockey
fi

psql hockey -f schema/create_schema.sql

cat csv/games_*.csv >> /tmp/href_games.csv
psql hockey -f loaders/load_href_games.sql
rm /tmp/href_games.csv

cat csv/playoffs*.csv >> /tmp/href_playoffs.csv
rpl -q ",,,," "" /tmp/href_playoffs.csv
psql hockey -f loaders/load_href_playoffs.sql
rm /tmp/href_playoffs.csv

psql hockey -f schema/create_teams.sql
