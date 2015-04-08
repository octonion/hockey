begin;

create table href.teams (
       team_id	  	  text,
       team_name	  text,
       primary key (team_id)
);

insert into href.teams
(team_id,team_name)
(
select
distinct visitor_id,visitor_name
from href.games
where visitor_id is not null
union
select
distinct home_id,home_name
from href.games
where home_id is not null
);

commit;
