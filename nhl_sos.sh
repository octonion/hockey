#!/bin/bash

psql hockey -f href_sos/standardized_results.sql

psql hockey -c "drop table href._basic_factors;"
psql hockey -c "drop table href._parameter_levels;"
psql hockey -c "drop table href._factors;"
psql hockey -c "drop table href._schedule_factors;"
#psql hockey -c "drop table href._game_results;"

R --vanilla < href_sos/nhl_lmer.R

psql hockey -f href_sos/normalize_factors.sql
psql hockey -f href_sos/schedule_factors.sql

psql hockey -f href_sos/current_ranking.sql > href_sos/current_ranking.txt
psql hockey -f href_sos/audit.sql > href_sos/audit.txt
