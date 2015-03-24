#!/bin/bash

psql hockey -f uscho_sos/standardized_results.sql

psql hockey -c "drop table uscho._basic_factors;"
psql hockey -c "drop table uscho._parameter_levels;"
psql hockey -c "drop table uscho._factors;"
psql hockey -c "drop table uscho._schedule_factors;"
#psql hockey -c "drop table uscho._game_results;"

R --vanilla < uscho_sos/uscho_lmer.R

psql hockey -f uscho_sos/normalize_factors.sql
psql hockey -f uscho_sos/schedule_factors.sql

psql hockey -f uscho_sos/connectivity.sql > uscho_sos/connectivity.txt
psql hockey -f uscho_sos/current_ranking.sql > uscho_sos/current_ranking.txt
psql hockey -f uscho_sos/division_ranking.sql > uscho_sos/division_ranking.txt

psql hockey -f uscho_sos/test_predictions.sql > uscho_sos/test_predictions.txt
