#!/bin/bash

psql hockey -c "drop table if exists ncaa.results;"

psql hockey -f sos/standardized_results.sql

psql hockey -c "vacuum full verbose analyze ncaa.results;"

psql hockey -c "drop table if exists ncaa._parameter_levels;"
psql hockey -c "drop table if exists ncaa._basic_factors;"

R --vanilla -f sos/lmer.R

psql hockey -c "vacuum full verbose analyze ncaa._parameter_levels;"
psql hockey -c "vacuum full verbose analyze ncaa._basic_factors;"

psql hockey -f sos/normalize_factors.sql
psql hockey -c "vacuum full verbose analyze ncaa._factors;"

psql hockey -f sos/schedule_factors.sql
psql hockey -c "vacuum full verbose analyze ncaa._schedule_factors;"

psql hockey -f sos/current_ranking.sql > sos/current_ranking.txt

psql hockey -f sos/connectivity.sql > sos/connectivity.txt

psql hockey -f sos/division_ranking.sql > sos/division_ranking.txt

psql hockey -f sos/test_predictions.sql > sos/test_predictions.txt
