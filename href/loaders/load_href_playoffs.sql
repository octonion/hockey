begin;

drop table if exists href.playoffs;

create table href.playoffs (
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
	notes				text
);

copy href.playoffs from '/tmp/href_playoffs.csv' with delimiter as ',' csv header quote as '"';

alter table href.playoffs
add column visitor_id text;

alter table href.playoffs
add column home_id text;

update href.playoffs
set visitor_id=split_part(visitor_url,'/',3);

update href.playoffs
set home_id=split_part(home_url,'/',3);

alter table href.playoffs add column game_id serial primary key;

commit;
