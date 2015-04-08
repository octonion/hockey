#!/bin/bash

cmd="psql template1 --tuples-only --command \"select count(*) from pg_database where datname = 'hockey';\""

db_exists=`eval $cmd`

if [ $db_exists -eq 0 ] ; then
   createdb hockey
fi

psql hockey -f schema/create_schema.sql

cat csv/uscho_games_*.csv > /tmp/uscho_games.csv
psql hockey -f loaders/load_uscho_games.sql
rm /tmp/uscho_games.csv

cp csv/uscho_teams.csv /tmp/uscho_teams.csv
psql hockey -f loaders/load_uscho_teams.sql
rm /tmp/uscho_teams.csv
