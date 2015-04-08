select
p.year,
sum(
(h.strength*o.exp_factor)^1.86/
((h.strength*o.exp_factor)^1.86+(v.strength*d.exp_factor)^1.86)
)::numeric(4,2) as e_home_wins,
sum(case when (p.visitor_score<p.home_score) then 1
    else 0 end) as home_wins
from href.playoffs p
join href._schedule_factors v
  on (v.year,v.team_id)=(p.year,p.visitor_id)
join href._schedule_factors h
  on (h.year,h.team_id)=(p.year,p.home_id)
join href._factors o
  on (o.parameter,o.level)=('field','offense_home')
join href._factors d
  on (d.parameter,d.level)=('field','defense_home')
group by p.year
order by p.year asc;

select
p.year,
(sum(
case when ((h.strength*o.exp_factor)>(v.strength*d.exp_factor)
            and p.home_score>p.visitor_score) then 1
     when ((h.strength*o.exp_factor)<(v.strength*d.exp_factor)
            and p.home_score<p.visitor_score) then 1
else 0 end)::float/
count(*))::numeric(4,2) as model,
(sum(
case when p.home_score>p.visitor_score then 1
else 0 end)::float/
count(*))::numeric(4,2) as naive,

(sum(
case when ((h.strength*o.exp_factor)>(v.strength*d.exp_factor)
            and p.home_score>p.visitor_score) then 1
     when ((h.strength*o.exp_factor)<(v.strength*d.exp_factor)
            and p.home_score<p.visitor_score) then 1
else 0 end)::float/
count(*)-
sum(
case when p.home_score>p.visitor_score then 1
else 0 end)::float/
count(*))::numeric(4,2) as diff,
count(*)
from href.playoffs p
join href._schedule_factors v
  on (v.year,v.team_id)=(p.year,p.visitor_id)
join href._schedule_factors h
  on (h.year,h.team_id)=(p.year,p.home_id)
join href._factors o
  on (o.parameter,o.level)=('field','offense_home')
join href._factors d
  on (d.parameter,d.level)=('field','defense_home')
group by p.year
order by p.year asc;

select
(sum(
case when ((h.strength*o.exp_factor)>(v.strength*d.exp_factor)
            and p.home_score>p.visitor_score) then 1
     when ((h.strength*o.exp_factor)<(v.strength*d.exp_factor)
            and p.home_score<p.visitor_score) then 1
else 0 end)::float/
count(*))::numeric(4,2) as model,
(sum(
case when p.home_score>p.visitor_score then 1
else 0 end)::float/
count(*))::numeric(4,2) as naive,

(sum(
case when ((h.strength*o.exp_factor)>(v.strength*d.exp_factor)
            and p.home_score>p.visitor_score) then 1
     when ((h.strength*o.exp_factor)<(v.strength*d.exp_factor)
            and p.home_score<p.visitor_score) then 1
else 0 end)::float/
count(*)-
sum(
case when p.home_score>p.visitor_score then 1
else 0 end)::float/
count(*))::numeric(4,2) as diff,
count(*)
from href.playoffs p
join href._schedule_factors v
  on (v.year,v.team_id)=(p.year,p.visitor_id)
join href._schedule_factors h
  on (h.year,h.team_id)=(p.year,p.home_id)
join href._factors o
  on (o.parameter,o.level)=('field','offense_home')
join href._factors d
  on (d.parameter,d.level)=('field','defense_home');
