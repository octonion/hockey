begin;

drop table if exists uscho.results;

create table uscho.results (
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
	opponent_score	      integer
);

insert into uscho.results
(game_id,game_date,year,
 school_name,school_id,
 opponent_name,opponent_id,
 location_name,location_id,field,
 team_score,opponent_score)
(
select
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
      else 'none' end) as location_id,
(case when location='@' then 'defense_home'
      else 'none' end) as field,
/*
 (case when location='vs.' then team_name
       when location='@' then opponent_name
       when location='Neutral' then 'neutral' end) as location_name,
 (case when location='vs.' then team_id
       when location='@' then opponent_id
       when location='Neutral' then 'none' end) as location_id,
 (case when location='vs.' then 'offense_home'
       when location='@' then 'defense_home'
       when location='Neutral' then 'none' end) as field,
*/
 g.team_score,
 g.opponent_score
 from uscho.games g
 where
     TRUE
 and g.team_score is not NULL
 and g.opponent_score is not NULL
 and g.team_score >= 0
 and g.opponent_score >= 0
 and g.team_id is not NULL
 and g.opponent_id is not NULL
 and g.game_date is not null
);

insert into uscho.results
(game_id,game_date,year,
 school_name,school_id,
 opponent_name,opponent_id,
 location_name,location_id,field,
 team_score,opponent_score)
(
select
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
      when location='Neutral' then 'none' end) as location_id,
(case when location='vs.' then 'defense_home'
      when location='@' then 'offense_home'
      when location='Neutral' then 'none' end) as field,
*/
(case when location='@' then opponent_name
      else 'neutral' end) as location_name,
(case when location='@' then opponent_id
      else 'none' end) as location_id,
(case when location='@' then 'offense_home'
      else 'none' end) as field,
g.opponent_score,
g.team_score
from uscho.games g
where
    TRUE
and g.team_score is not NULL
and g.opponent_score is not NULL
and g.team_score >= 0
and g.opponent_score >= 0
and g.team_id is not NULL
and g.opponent_id is not NULL
and g.game_date is not null
);

update uscho.results
set school_div_id=length(t.division)
from uscho.teams t
where (t.team_id,t.year)=(results.school_id,results.year);

update uscho.results
set opponent_div_id=length(t.division)
from uscho.teams t
where (t.team_id,t.year)=(results.opponent_id,results.year);

commit;
