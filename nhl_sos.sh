#!/bin/bash

psql hockey -f sos/standardized_results.sql

psql hockey -c "drop table href._basic_factors;"
psql hockey -c "drop table href._parameter_levels;"
psql hockey -c "drop table href._factors;"
psql hockey -c "drop table href._schedule_factors;"
#psql hockey -c "drop table href._game_results;"

R --vanilla < sos/nhl_lmer.R

psql hockey -f sos/normalize_factors.sql
psql hockey -f sos/schedule_factors.sql

psql hockey -f sos/current_ranking.sql > sos/current_ranking.txt
psql hockey -f sos/audit.sql > sos/audit.txt
