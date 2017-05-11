begin;

drop table if exists href.rounds;

create table href.rounds (
	year				integer,
	round_id			integer,
	team_id				text,
	seed				integer,
	points				integer,
	bracket				int[],
	p				float,
	primary key (year,round_id,team_id)
);

copy href.rounds from '/tmp/rounds.csv' with delimiter as ',' csv header quote as '"';

-- matchup probabilities

drop table if exists href.matrix_p;

create table href.matrix_p (
	year				integer,
	field				text,
	team_id				text,
	opponent_id			text,
	team_p				float,
	opponent_p			float,
	primary key (year,field,team_id,opponent_id)
);

insert into href.matrix_p
(year,field,team_id,opponent_id,team_p,opponent_p)
(select
r1.year,
'home',
r1.team_id,
r2.team_id,

skellam(
exp(i.estimate)*y.exp_factor*h.offensive*o.exp_factor*v.defensive,
exp(i.estimate)*y.exp_factor*v.offensive*h.defensive*d.exp_factor,
'win') as team_p,

skellam(
exp(i.estimate)*y.exp_factor*h.offensive*o.exp_factor*v.defensive,
exp(i.estimate)*y.exp_factor*v.offensive*h.defensive*d.exp_factor,
'lose') as opponent_p

from href.rounds r1
join href.rounds r2
  on ((r2.year)=(r1.year) and not((r2.team_id)=(r1.team_id)))
join href._schedule_factors v
  on (v.year,v.team_id)=(r2.year,r2.team_id)
join href._schedule_factors h
  on (h.year,h.team_id)=(r1.year,r1.team_id)
join href._factors o
  on (o.parameter,o.level)=('field','offense_home')
join href._factors d
  on (d.parameter,d.level)=('field','defense_home')
join href._factors y
  on (y.parameter,y.level)=('year',r1.year::text)
join href._basic_factors i
  on (i.factor)=('(Intercept)')
where
  r1.year=2017
);

insert into href.matrix_p
(year,field,team_id,opponent_id,team_p,opponent_p)
(select
r1.year,
'away',
r1.team_id,
r2.team_id,

skellam(
exp(i.estimate)*y.exp_factor*h.offensive*v.defensive*d.exp_factor,
exp(i.estimate)*y.exp_factor*v.offensive*o.exp_factor*h.defensive,
'win') as team_p,

skellam(
exp(i.estimate)*y.exp_factor*h.offensive*v.defensive*d.exp_factor,
exp(i.estimate)*y.exp_factor*v.offensive*o.exp_factor*h.defensive,
'lose') as opponent_p

from href.rounds r1
join href.rounds r2
  on ((r2.year)=(r1.year) and not((r2.team_id)=(r1.team_id)))
join href._schedule_factors v
  on (v.year,v.team_id)=(r2.year,r2.team_id)
join href._schedule_factors h
  on (h.year,h.team_id)=(r1.year,r1.team_id)
join href._factors o
  on (o.parameter,o.level)=('field','offense_home')
join href._factors d
  on (d.parameter,d.level)=('field','defense_home')
join href._factors y
  on (y.parameter,y.level)=('year',r1.year::text)
join href._basic_factors i
  on (i.factor)=('(Intercept)')
where
  r1.year=2017
);

insert into href.matrix_p
(year,field,team_id,opponent_id,team_p,opponent_p)
(select
r1.year,
'neutral',
r1.team_id,
r2.team_id,

skellam(
exp(i.estimate)*y.exp_factor*h.offensive*v.defensive,
exp(i.estimate)*y.exp_factor*v.offensive*h.defensive,
'win') as team_p,

skellam(
exp(i.estimate)*y.exp_factor*h.offensive*v.defensive,
exp(i.estimate)*y.exp_factor*v.offensive*h.defensive,
'lose') as opponent_p

from href.rounds r1
join href.rounds r2
  on ((r2.year)=(r1.year) and not((r2.team_id)=(r1.team_id)))
join href._schedule_factors v
  on (v.year,v.team_id)=(r2.year,r2.team_id)
join href._schedule_factors h
  on (h.year,h.team_id)=(r1.year,r1.team_id)
join href._factors y
  on (y.parameter,y.level)=('year',r1.year::text)
join href._basic_factors i
  on (i.factor)=('(Intercept)')
where
  r1.year=2017
);

-- home advantage

drop table if exists href.matrix_field;

create table href.matrix_field (
	year				integer,
	round_id			integer,
	team_id				text,
	opponent_id			text,
	field				text,
	primary key (year,round_id,team_id,opponent_id)
);

insert into href.matrix_field
(year,round_id,team_id,opponent_id,field)
(select
r1.year,
gs.round_id,
r1.team_id,
r2.team_id,
'neutral'
from href.rounds r1
join href.rounds r2
  on (r2.year=r1.year and not(r2.team_id=r1.team_id))
join (select generate_series(1, 6) round_id) gs
  on TRUE
where
  r1.year=2017
);

-- 1-2 round lower seeds have home

update href.matrix_field
set field='home'
from href.rounds r1,href.rounds r2
where
    (r1.year,r1.team_id)=
    (matrix_field.year,matrix_field.team_id)
and (r2.year,r2.team_id)=
    (matrix_field.year,matrix_field.opponent_id)
and r1.round_id=1
and r2.round_id=1
and matrix_field.round_id between 1 and 2
and r1.seed < r2.seed;

update href.matrix_field
set field='away'
from href.rounds r1,href.rounds r2
where
    (r1.year,r1.team_id)=
    (matrix_field.year,matrix_field.team_id)
and (r2.year,r2.team_id)=
    (matrix_field.year,matrix_field.opponent_id)
and r1.round_id=1
and r2.round_id=1
and matrix_field.round_id between 1 and 2
and r1.seed > r2.seed;

-- 3+ round

update href.matrix_field
set field='home'
from href.rounds r1,href.rounds r2
where
    (r1.year,r1.team_id)=
    (matrix_field.year,matrix_field.team_id)
and (r2.year,r2.team_id)=
    (matrix_field.year,matrix_field.opponent_id)
and r1.round_id=1
and r2.round_id=1
and matrix_field.round_id >= 3
and r1.points > r2.points;

update href.matrix_field
set field='away'
from href.rounds r1,href.rounds r2
where
    (r1.year,r1.team_id)=
    (matrix_field.year,matrix_field.team_id)
and (r2.year,r2.team_id)=
    (matrix_field.year,matrix_field.opponent_id)
and r1.round_id=1
and r2.round_id=1
and matrix_field.round_id >= 3
and r1.points < r2.points;

commit;
