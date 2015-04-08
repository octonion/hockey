begin;

drop table if exists uscho_women.results;

create table uscho_women.results (
	pulled_id		      text,
	game_id		      integer,
	game_date	      date,
	year		      integer,
	school_name	      text,
	school_id	      text,
	school_div_id	      integer,
	opponent_name	      text,
	opponent_id	      text,
	opponent_div_id	      integer,
	location_name	      text,
	location_id	      text,
	field		      text,
	team_score	      integer,
	opponent_score	      integer,
	game_length	      text,
	notes		      text
);

insert into uscho_women.results
(pulled_id,
 game_id,game_date,year,
 school_name,school_id,
 opponent_name,opponent_id,
 location_name,location_id,field,
 team_score,opponent_score,game_length,notes)
(
select
team_id,
game_id,
game_date,
year,
team_name,
team_id,
opponent_name,
opponent_id,
(case when location='@' then opponent_name
      else 'neutral' end) as location_name,
(case when location='@' then opponent_id
      else 'neutral' end) as location_id,
(case when location='@' then 'defense_home'
      else 'neutral' end) as field,
/*
 (case when location='vs.' then team_name
       when location='@' then opponent_name
       when location='Neutral' then 'neutral' end) as location_name,
 (case when location='vs.' then team_id
       when location='@' then opponent_id
       when location='Neutral' then 'neutral' end) as location_id,
 (case when location='vs.' then 'offense_home'
       when location='@' then 'defense_home'
       when location='Neutral' then 'neutral' end) as field,
*/
 g.team_score,
 g.opponent_score,
 (case when g.overtime is null then '0 OT'
       when g.overtime='' then '0 OT'
       when g.overtime='OT' then '1 OT'
       else g.overtime end) as game_length,
 g.notes
 from uscho_women.games g
 where
     TRUE
-- and g.team_score is not NULL
-- and g.opponent_score is not NULL
-- and g.team_score >= 0
-- and g.opponent_score >= 0
 and g.team_id is not NULL
 and g.opponent_id is not NULL
 and g.game_date is not null
);

insert into uscho_women.results
(pulled_id,
 game_id,game_date,year,
 school_name,school_id,
 opponent_name,opponent_id,
 location_name,location_id,field,
 team_score,opponent_score,game_length,notes)
(
select
team_id,
game_id,
game_date,
year,
opponent_name,
opponent_id,
team_name,
team_id,
/*
(case when location='vs.' then team_name
      when location='@' then opponent_name
      when location='Neutral' then 'neutral' end) as location_name,
(case when location='vs.' then team_id
      when location='@' then opponent_id
      when location='Neutral' then 'neutral' end) as location_id,
(case when location='vs.' then 'defense_home'
      when location='@' then 'offense_home'
      when location='Neutral' then 'neutral' end) as field,
*/
(case when location='@' then opponent_name
      else 'neutral' end) as location_name,
(case when location='@' then opponent_id
      else 'neutral' end) as location_id,
(case when location='@' then 'offense_home'
      else 'neutral' end) as field,
g.opponent_score,
g.team_score,
(case when g.overtime is null then '0 OT'
      when g.overtime='' then '0 OT'
      when g.overtime='OT' then '1 OT'
      else g.overtime end) as game_length,
g.notes
from uscho_women.games g
where
    TRUE
--and g.team_score is not NULL
--and g.opponent_score is not NULL
--and g.team_score >= 0
--and g.opponent_score >= 0
and g.team_id is not NULL
and g.opponent_id is not NULL
and g.game_date is not null
);

update uscho_women.results
set school_div_id=length(t.division)
from uscho_women.teams t
where (t.team_id,t.year)=(results.school_id,results.year);

update uscho_women.results
set opponent_div_id=length(t.division)
from uscho_women.teams t
where (t.team_id,t.year)=(results.opponent_id,results.year);

commit;
