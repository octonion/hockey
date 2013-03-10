begin;

drop table if exists uscho.teams;

create table uscho.teams (
	team_id		      text,
	year		      integer,
	season		      text,
	coach		      text,
	conference	      text,
	division	      text,
	won		      integer,
	lost		      integer,
	tied		      integer,
	win_percentage	      text,
	space1		      text,
	rs		      text,
	lt		      text,
	ncaa		      text
);

copy uscho.teams from '/tmp/uscho_teams.csv' with delimiter as ',' csv quote as '"';

commit;
