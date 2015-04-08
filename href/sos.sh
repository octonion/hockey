#!/bin/bash

psql hockey -c "drop table if exists href.results;"

psql hockey -f sos/standardized_results.sql

psql hockey -c "vacuum full verbose analyze href.results;"

psql hockey -c "drop table if exists href._parameter_levels;"
psql hockey -c "drop table if exists href._basic_factors;"

R --vanilla < sos/lmer.R

psql hockey -c "vacuum full verbose analyze href._parameter_levels;"
psql hockey -c "vacuum full verbose analyze href._basic_factors;"

psql hockey -f sos/normalize_factors.sql
psql hockey -c "vacuum full verbose analyze href._factors;"

psql hockey -f sos/schedule_factors.sql
psql hockey -c "vacuum full verbose analyze href._schedule_factors;"

psql hockey -f sos/current_ranking.sql > sos/current_ranking.txt
cp /tmp/current_ranking.csv sos

psql hockey -f sos/audit.sql > sos/audit.txt

psql hockey -f sos/predict_playoffs.sql > sos/predict_playoffs.txt
