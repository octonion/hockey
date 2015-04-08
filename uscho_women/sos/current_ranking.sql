begin;

create temporary table r (
       rk	 serial,
       school 	 text,
       school_id text,
       div_id	 integer,
       year	 integer,
       str	 float,
       o_div	 float,
       d_div	 float,
       ofs	 float,
       dfs	 float,
       sos	 float
);

insert into r
(school,school_id,div_id,year,str,ofs,dfs,sos)
(
select
sf.school_id,
sf.school_id,
length(t.division) as div_id,
sf.year,
(sf.strength*o.exp_factor/d.exp_factor) as str,
(offensive*o.exp_factor) as ofs,
(defensive*d.exp_factor) as dfs,
schedule_strength as sos
from uscho_women._schedule_factors sf
join uscho_women.teams t
  on (t.team_id,t.year)=(sf.school_id,sf.year)
join uscho_women._factors o
  on (o.parameter,o.level::integer)=('o_div',length(t.division))
join uscho_women._factors d
  on (d.parameter,d.level::integer)=('d_div',length(t.division))
where sf.year in (2015)
order by str desc);

select
rk,
school,
('D'||div_id::text) as div,
str::numeric(5,3),
ofs::numeric(5,3),
dfs::numeric(5,3),
sos::numeric(5,3)
from r
order by rk asc;

copy
(
select
rk,
school,
('D'||div_id::text) as div,
str::numeric(5,3),
ofs::numeric(5,3),
dfs::numeric(5,3),
sos::numeric(5,3)
from r
order by rk asc
) to '/tmp/current_ranking.csv' csv header;

commit;
