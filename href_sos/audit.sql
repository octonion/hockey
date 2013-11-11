begin;

create temporary table r (
       team_id	 text,
       year	 integer,
       str	 numeric(4,3),
       ofs	 numeric(4,3),
       dfs	 numeric(4,3),
       sos	 numeric(4,3)
);

insert into r
(team_id,year,str,ofs,dfs,sos)
(
select
sf.team_id,
sf.year,
sf.strength::numeric(4,3) as str,
offensive::numeric(4,3) as ofs,
defensive::numeric(4,3) as dfs,
schedule_strength::numeric(4,3) as sos
from href._schedule_factors sf
where sf.year in (2014)
and sf.team_id is not null
order by str desc);

select
year,
exp(avg(log(str)))::numeric(4,3) as str,
exp(avg(log(ofs)))::numeric(4,3) as ofs,
exp(-avg(log(dfs)))::numeric(4,3) as dfs,
exp(avg(log(sos)))::numeric(4,3) as sos,
count(*) as n
from r
group by year
order by year asc;

commit;
