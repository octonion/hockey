#!/bin/bash

createdb hockey

psql hockey -f loaders/create_schema_uscho.sql

cat csv/uscho_games_*.csv > /tmp/uscho_games.csv
psql hockey -f loaders/load_uscho_games.sql
rm /tmp/uscho_games.csv

cp csv/uscho_teams.csv /tmp/uscho_teams.csv
psql hockey -f loaders/load_uscho_teams.sql
rm /tmp/uscho_teams.csv
