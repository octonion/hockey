begin;

drop table if exists uscho_women.rounds;

create table uscho_women.rounds (
	year				integer,
	round_id			integer,
	school_id			text,
	school_name			text,
	bracket				int[],
	p				float,
	primary key (year,round_id,school_id)
);

copy uscho_women.rounds from '/tmp/rounds.csv' with delimiter as ',' csv header quote as '"';

commit;
