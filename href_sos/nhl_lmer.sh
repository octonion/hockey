#!/bin/bash

psql hockey -f standardized_results.sql

psql hockey -c "drop table href._basic_factors;"
psql hockey -c "drop table href._parameter_levels;"
psql hockey -c "drop table href._factors;"
psql hockey -c "drop table href._schedule_factors;"
#psql hockey -c "drop table href._game_results;"

R --vanilla < nhl_lmer.R

psql hockey -f normalize_factors.sql
psql hockey -f schedule_factors.sql

psql hockey -f current_ranking.sql > current_ranking.txt
psql hockey -f audit.sql > audit.txt
