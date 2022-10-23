#!/bin/bash

psql hockey -c "drop table if exists uscho.results;"

psql hockey -f sos/standardized_results.sql

psql hockey -c "vacuum full verbose analyze uscho.results;"

psql hockey -c "drop table if exists uscho._parameter_levels;"
psql hockey -c "drop table if exists uscho._basic_factors;"

R -f sos/lmer.R

psql hockey -c "vacuum full verbose analyze uscho._parameter_levels;"
psql hockey -c "vacuum full verbose analyze uscho._basic_factors;"

psql hockey -f sos/normalize_factors.sql
psql hockey -c "vacuum full verbose analyze uscho._factors;"

psql hockey -f sos/schedule_factors.sql
psql hockey -c "vacuum full verbose analyze uscho._schedule_factors;"

psql hockey -f sos/current_ranking.sql > sos/current_ranking.txt
cp /tmp/current_ranking.csv sos

psql hockey -f sos/predict_daily.sql > sos/predict_daily.txt
cp /tmp/predict_daily.csv sos

psql hockey -f sos/division_ranking.sql > sos/division_ranking.txt

psql hockey -f sos/connectivity.sql > sos/connectivity.txt

psql hockey -f sos/test_predictions.sql > sos/test_predictions.txt
