begin;

drop table if exists uscho.games;

create table uscho.games (
	year		      integer,
	day		      text,
	flag		      text,
	game_date	      date,
	start_time	      text,
	team_name	      text,
	team_id		      text,
	team_url	      text,
	team_name2	      text,
	team_score	      integer,
	location	      text,
	opponent_name	      text,
	opponent_id	      text,
	opponent_url	      text,
	opponent_name2	      text,
	opponent_score	      integer,
	overtime	      text,
	notes		      text,
	conference	      text,
	misc1		      text,
	misc2		      text
--	misc3		      text
	
);

copy uscho.games from '/tmp/uscho_games.csv' with delimiter as ',' csv quote as '"';

alter table uscho.games add column game_id serial primary key;

commit;
