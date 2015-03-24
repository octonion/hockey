begin;

drop table if exists uscho.rounds;

create table uscho.rounds (
	year				integer,
	round_id			integer,
	school_id			text,
	school_name			text,
	bracket				int[],
	p				float,
	primary key (year,round_id,school_id)
);

copy uscho.rounds from '/tmp/rounds.csv' with delimiter as ',' csv header quote as '"';

commit;
