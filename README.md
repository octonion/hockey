hockey
======

hockey analytics

## System Requirements

### Ubuntu
apt-get install rpl
apt-get install postgresql-9.2
apt-get install r-base-core

### Fedora
dnf install rpl
dnf install postgresql
dnf install R

## Application Requirements
### For Power Ranking
R
R package lme4
R package RPostgreSQL

### Ruby
mechanize (available via dnf or gem)

## Instructions
Install the two R packages if you want to run the power ratings scripts.

To load data from Hockey Reference:

./load_href.sh

NHL power ratings:

./href_sos.sh

To load data from NCAA:

./load_ncaa.sh

NCAA power ratings:

./ncaa_sos.sh

The NHL power ratings are based on regular season games only and are tested on playoff games.
The NCAA power ratings exclude March and April games and are tested on March and April games.