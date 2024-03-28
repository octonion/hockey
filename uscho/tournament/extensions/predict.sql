select
ts.game_date::date,
'neutral',

t.team_id,
(exp(i.estimate)*y.exp_factor*tf.exp_factor*tol.exp_factor*sft.offensive*odl.exp_factor*sfo.defensive)::numeric(3,2) as teo,

o.team_id,
(exp(i.estimate)*y.exp_factor*of.exp_factor*ool.exp_factor*sfo.offensive*tdl.exp_factor*sft.defensive)::numeric(3,2) as opo,

(skellam(exp(i.estimate)*y.exp_factor*tf.exp_factor*tol.exp_factor*sft.offensive*odl.exp_factor*sfo.defensive,exp(i.estimate)*y.exp_factor*of.exp_factor*ool.exp_factor*sfo.offensive*tdl.exp_factor*sft.defensive,'win'))::numeric(4,3) as win,

(skellam(exp(i.estimate)*y.exp_factor*tf.exp_factor*tol.exp_factor*sft.offensive*odl.exp_factor*sfo.defensive,exp(i.estimate)*y.exp_factor*of.exp_factor*ool.exp_factor*sfo.offensive*tdl.exp_factor*sft.defensive,'lose'))::numeric(4,3) as lose,

(skellam(exp(i.estimate)*y.exp_factor*tf.exp_factor*tol.exp_factor*sft.offensive*odl.exp_factor*sfo.defensive,exp(i.estimate)*y.exp_factor*of.exp_factor*ool.exp_factor*sfo.offensive*tdl.exp_factor*sft.defensive,'draw'))::numeric(4,3) as draw,

(skellam(exp(i.estimate)*y.exp_factor*tf.exp_factor*tol.exp_factor*sft.offensive*odl.exp_factor*sfo.defensive,exp(i.estimate)*y.exp_factor*of.exp_factor*ool.exp_factor*sfo.offensive*tdl.exp_factor*sft.defensive,'win')+0.5*skellam(exp(i.estimate)*y.exp_factor*tf.exp_factor*tol.exp_factor*sft.offensive*odl.exp_factor*sfo.defensive,exp(i.estimate)*y.exp_factor*of.exp_factor*ool.exp_factor*sfo.offensive*tdl.exp_factor*sft.defensive,'draw'))::numeric(4,3) as o_win

from uscho.games ts
join uscho.teams t
  on (t.team_id,t.year)=(ts.team_id,ts.year)
--join uscho.leagues tl
--  on (tl.division)=(t.division)
join uscho._schedule_factors sft
  on (sft.school_id,sft.year)=(ts.team_id,ts.year)
join uscho._factors tol
  on (tol.parameter,tol.level)=('o_div',length(t.division)::text)
join uscho._factors tdl
  on (tdl.parameter,tdl.level)=('d_div',length(t.division)::text)

join uscho.teams o
  on (o.team_id,o.year)=(ts.opponent_id,ts.year)
--join uscho.leagues ol
--  on (ol.division)=(o.division)
join uscho._schedule_factors sfo
  on (sfo.school_id,sfo.year)=(ts.opponent_id,ts.year)
join uscho._factors ool
  on (ool.parameter,ool.level)=('o_div',length(o.division)::text)
join uscho._factors odl
  on (odl.parameter,odl.level)=('d_div',length(o.division)::text)

--join uscho._factors tf on
--  tf.level='offense_home'
--join uscho._factors of on
--  of.level='defense_home'

join uscho._factors tf on
  tf.level='neutral'
join uscho._factors of on
  of.level='neutral'
  
join uscho._factors y on
  y.level='2023'

join uscho._basic_factors i on
  i.factor='(Intercept)'

where
ts.team_id=ts.team_id
and ts.game_date >= current_date
order by ts.team_id asc
;
