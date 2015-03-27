begin;

set timezone to 'America/New_York';

select
distinct
g.game_date as date,
g.field as site,
g.school_name as team,
g.school_div_id as div,
(exp(i.estimate)*y.exp_factor*hdof.exp_factor*h.offensive*o.exp_factor*v.defensive*vddf.exp_factor)::numeric(4,1) as score,
g.opponent_name as opp,
g.opponent_div_id as div,
(exp(i.estimate)*y.exp_factor*vdof.exp_factor*v.offensive*hddf.exp_factor*h.defensive*d.exp_factor)::numeric(4,1) as score
from uscho.results g
join uscho._schedule_factors h
  on (h.year,h.school_id)=(g.year,g.school_id)
join uscho._schedule_factors v
  on (v.year,v.school_id)=(g.year,g.opponent_id)
join uscho._factors hdof
  on (hdof.parameter,hdof.level::integer)=('o_div',g.school_div_id)
join uscho._factors hddf
  on (hddf.parameter,hddf.level::integer)=('d_div',g.school_div_id)
join uscho._factors vdof
  on (vdof.parameter,vdof.level::integer)=('o_div',g.opponent_div_id)
join uscho._factors vddf
  on (vddf.parameter,vddf.level::integer)=('d_div',g.opponent_div_id)
join uscho._factors o
  on (o.parameter,o.level)=('field',g.field)
join uscho._factors d
  on (d.parameter,d.level)=('field',
    (case when g.field='offense_home' then 'defense_home'
          when g.field='defense_home' then 'offense_home'
          when g.field='neutral' then 'neutral' end))
join uscho._factors y
  on (y.parameter,y.level)=('year',g.year::text)
join uscho._basic_factors i
  on (i.factor)=('(Intercept)')
where
    TRUE
and g.game_date = current_date
and g.year=2015
and (g.field in ('offense_home') or
    (g.field in ('neutral') and g.school_id < g.opponent_id))
order by team asc;

copy
(
select
distinct
g.game_date as date,
g.field as site,
g.school_name as team,
g.school_div_id as div,
(exp(i.estimate)*y.exp_factor*hdof.exp_factor*h.offensive*o.exp_factor*v.defensive*vddf.exp_factor)::numeric(4,1) as score,
g.opponent_name as opp,
g.opponent_div_id as div,
(exp(i.estimate)*y.exp_factor*vdof.exp_factor*v.offensive*hddf.exp_factor*h.defensive*d.exp_factor)::numeric(4,1) as score
from uscho.results g
join uscho._schedule_factors h
  on (h.year,h.school_id)=(g.year,g.school_id)
join uscho._schedule_factors v
  on (v.year,v.school_id)=(g.year,g.opponent_id)
join uscho._factors hdof
  on (hdof.parameter,hdof.level::integer)=('o_div',g.school_div_id)
join uscho._factors hddf
  on (hddf.parameter,hddf.level::integer)=('d_div',g.school_div_id)
join uscho._factors vdof
  on (vdof.parameter,vdof.level::integer)=('o_div',g.opponent_div_id)
join uscho._factors vddf
  on (vddf.parameter,vddf.level::integer)=('d_div',g.opponent_div_id)
join uscho._factors o
  on (o.parameter,o.level)=('field',g.field)
join uscho._factors d
  on (d.parameter,d.level)=('field',
    (case when g.field='offense_home' then 'defense_home'
          when g.field='defense_home' then 'offense_home'
          when g.field='neutral' then 'neutral' end))
join uscho._factors y
  on (y.parameter,y.level)=('year',g.year::text)
join uscho._basic_factors i
  on (i.factor)=('(Intercept)')
where
    TRUE
and g.game_date = current_date
and g.year=2015
and (g.field in ('offense_home') or
    (g.field in ('neutral') and g.school_id < g.opponent_id))
order by team asc
) to '/tmp/predict_daily.csv' csv header;

commit;
