#!/bin/bash

createdb hockey

psql hockey -f create_schema_uscho.sql

cat uscho/uscho_games_*.csv > /tmp/uscho_games.csv
psql hockey -f load_uscho_games.sql
rm /tmp/uscho_games.csv

cp uscho/uscho_teams.csv /tmp/uscho_teams.csv
psql hockey -f load_uscho_teams.sql
rm /tmp/uscho_teams.csv

