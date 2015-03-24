#!/bin/bash

psql hockey -f sos/standardized_results.sql

psql hockey -c "drop table uscho._basic_factors;"
psql hockey -c "drop table uscho._parameter_levels;"
psql hockey -c "drop table uscho._factors;"
psql hockey -c "drop table uscho._schedule_factors;"
#psql hockey -c "drop table uscho._game_results;"

R --vanilla -f sos/uscho_lmer.R

psql hockey -f sos/normalize_factors.sql
psql hockey -f sos/schedule_factors.sql

psql hockey -f sos/connectivity.sql > sos/connectivity.txt
psql hockey -f sos/current_ranking.sql > sos/current_ranking.txt
psql hockey -f sos/division_ranking.sql > sos/division_ranking.txt
psql hockey -f sos/test_predictions.sql > sos/test_predictions.txt
