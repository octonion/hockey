begin;

set timezone to 'America/Los_Angeles';

select

--g.pulled_id,
distinct
g.school_name as team,
--g.school_id,
g.school_div_id as h_div,
--h.offensive,
--h.defensive,
g.field as site,
g.opponent_name as opp,
--g.opponent_id,
g.opponent_div_id as v_div,

(exp(i.estimate)*y.exp_factor*hdof.exp_factor*h.offensive*o.exp_factor*v.defensive*vddf.exp_factor)::numeric(4,1) as t_score,

(exp(i.estimate)*y.exp_factor*vdof.exp_factor*v.offensive*hddf.exp_factor*h.defensive*d.exp_factor)::numeric(4,1) as o_score

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
          when g.field='none' then 'none' end))
join uscho._factors y
  on (y.parameter,y.level)=('year',g.year::text)
join uscho._basic_factors i
  on (i.factor)=('(Intercept)')
where
    TRUE
and g.game_date = current_date
and g.year=2015
and g.field in ('offense_home','none')
--and g.pulled_id=least(g.school_id,g.opponent_id)
--and g.pulled_id='alaska-anchorage'
order by team asc;

commit;
