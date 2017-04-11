begin;

drop table if exists href.games;

create table href.games (
	year				integer,
	game_date			text,
	boxscore_url			text,
	visitor_name			text,
	visitor_url			text,
	visitor_score			integer,
	home_name			text,
	home_url			text,
	home_score			integer,
	status				text,
	attendance			text,
	length_of_game			text,
	notes				text
);

copy href.games from '/tmp/href_games.csv' with delimiter as ',' csv;

alter table href.games
add column visitor_id text;

alter table href.games
add column home_id text;

update href.games
set visitor_id=split_part(visitor_url,'/',3);

update href.games
set home_id=split_part(home_url,'/',3);

alter table href.games add column game_id serial primary key;

commit;
