#!/bin/bash

#cp rounds_2015.csv /tmp/rounds.csv
cp rounds_updated.csv /tmp/rounds.csv
psql hockey -f load_rounds.sql
rm /tmp/rounds.csv

psql hockey -f update_round.sql

rpl "round_id=1" "round_id=2" update_round.sql

psql hockey -f update_round.sql

rpl "round_id=2" "round_id=1" update_round.sql

psql hockey -f round_p.sql > round_p.txt
cp /tmp/round_p.csv .

#psql hockey -f champion_p.sql > champion_p.txt
#cp /tmp/champion_p.csv .
