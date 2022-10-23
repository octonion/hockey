begin;

create temporary table r (
       rk	 serial,
       school 	 text,
       school_id text,
       div_id	 integer,
       year	 integer,
       str	 numeric(4,3),
       o_div	 numeric(4,3),
       d_div	 numeric(4,3),
       ofs	 numeric(4,3),
       dfs	 numeric(4,3),
       sos	 numeric(4,3)
);

insert into r
(school,school_id,div_id,year,str,ofs,dfs,sos)
(
select
sf.school_id,
sf.school_id,
length(t.division) as div_id,
sf.year,
(sf.strength*o.exp_factor/d.exp_factor)::numeric(4,3) as str,
--o.exp_factor::numeric(4,3) as o_div,
--d.exp_factor::numeric(4,3) as d_div,
(offensive*o.exp_factor)::numeric(4,3) as ofs,
(defensive*d.exp_factor)::numeric(4,3) as dfs,
schedule_strength::numeric(4,3) as sos
from uscho._schedule_factors sf
join uscho.teams t
  on (t.team_id,t.year)=(sf.school_id,sf.year)
--join uscho.schools_divisions sd
--  on (sd.school_id)=(sf.school_id)
--  on (sd.school_id,sd.year)=(sf.school_id,sf.year)
join uscho._factors o
  on (o.parameter,o.level::integer)=('o_div',length(t.division))
join uscho._factors d
  on (d.parameter,d.level::integer)=('d_div',length(t.division))
where sf.year in (2023)
order by str desc);

select
rk,school,div_id as div,str,ofs,dfs,sos
from r
order by rk asc;

copy
(
select
rk,
school,
('D'||div_id::text) as div,
str,
ofs,
dfs,
sos
from r
order by rk asc
) to '/tmp/current_ranking.csv' csv header;

commit;
