begin;

create temporary table r (
       rk	 serial,
       team 	 text,
       team_id	 text,
       year	 integer,
       str	 float,
       ofs	 float,
       dfs	 float,
       sos	 float
);

insert into r
(team,team_id,year,str,ofs,dfs,sos)
(
select
coalesce(s.team_name,sf.team_id::text),
sf.team_id,
sf.year,
sf.strength as str,
offensive as ofs,
defensive as dfs,
schedule_strength as sos
from href._schedule_factors sf
join href.teams s
  on (s.team_id)=(sf.team_id)
where sf.year in (2017)
order by str desc);

select
rk,
team,
str::numeric(4,3),
ofs::numeric(4,3),
dfs::numeric(4,3),
sos::numeric(4,3)
from r
order by rk asc;

copy
(
select
rk,
team,
str::numeric(4,3),
ofs::numeric(4,3),
dfs::numeric(4,3),
sos::numeric(4,3)
from r
order by rk asc
) to '/tmp/current_ranking.csv' csv header;

commit;
