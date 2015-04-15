begin;

drop table if exists href.rounds;

create table href.rounds (
	year				integer,
	round_id			integer,
	team_id				text,
	seed				integer,
	bracket				int[],
	p				float,
	primary key (year,round_id,team_id)
);

copy href.rounds from '/tmp/rounds.csv' with delimiter as ',' csv header quote as '"';

drop table if exists href.matrix_p;

create table href.matrix_p (
	year				integer,
	home_id				text,
	visitor_id			text,
	home_p				float,
	visitor_p			float,
	primary key (year,home_id,visitor_id)
);

insert into href.matrix_p
(year,home_id,visitor_id,home_p,visitor_p)
(select
r1.year,
r1.team_id,
r2.team_id,
(h.strength*o.exp_factor)^2.10/
((h.strength*o.exp_factor)^2.10+(v.strength*d.exp_factor)^2.10)
  as home_p,
(v.strength*d.exp_factor)^2.10/
((v.strength*d.exp_factor)^2.10+(h.strength*o.exp_factor)^2.10)
  as visitor_p
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
where
  r1.year=2015
);

commit;
