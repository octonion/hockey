#!/bin/bash

psql hockey -f standardized_results.sql

psql hockey -c "drop table ncaa._basic_factors;"
psql hockey -c "drop table ncaa._parameter_levels;"
psql hockey -c "drop table ncaa._factors;"
psql hockey -c "drop table ncaa._schedule_factors;"
#psql hockey -c "drop table ncaa._game_results;"

R --vanilla < ncaa_lmer.R

psql hockey -f normalize_factors.sql
psql hockey -f schedule_factors.sql

psql hockey -f connectivity.sql > connectivity.txt
psql hockey -f current_ranking.sql > current_ranking.txt
psql hockey -f division_ranking.sql > division_ranking.txt

psql hockey -f test_predictions.sql > test_predictions.txt
