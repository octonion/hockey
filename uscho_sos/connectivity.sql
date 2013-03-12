begin;

select
r.year,
r.school_div_id as t_div,
r.opponent_div_id as o_div,
sum(case when r.team_score>r.opponent_score then 1 else 0 end) as won,
sum(case when r.team_score<r.opponent_score then 1 else 0 end) as lost,
sum(case when r.team_score=r.opponent_score then 1 else 0 end) as tied,
count(*)
from uscho.results r
where
    r.school_div_id<=r.opponent_div_id
and r.year between 1999 and 2013
group by r.year,t_div,o_div
order by r.year,t_div,o_div;

commit;
