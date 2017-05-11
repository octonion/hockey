begin;

create temporary table rp (
       year		  integer,
       team_field	  text,
       team_id		  text,
       team_home_p	  float,
       team_away_p	  float,
       opponent_id	  text,
       opponent_home_p	  float,
       opponent_away_p	  float
);

insert into rp
(year,
team_field,
team_id,team_home_p,team_away_p,
opponent_id,opponent_home_p,opponent_away_p)
(
select
mp1.year as year,
mp1.field,
mp1.team_id as team_id,
mp1.team_p as team_home_p,
mp2.opponent_p as team_away_p,
mp1.opponent_id as opponent_id,
mp2.team_p as opponent_home_p,
mp1.opponent_p as opponent_away_p

from href.matrix_p mp1
join href.matrix_p mp2
  on (mp2.year,mp2.team_id,mp2.opponent_id,mp2.field)=
     (mp1.year,mp1.opponent_id,mp1.team_id,mp1.field)
where
    mp1.year=2017
);

--select * from rp;

/*
select

*

from href.rounds r1
left join href.rounds r2
  on ((r1.year,r1.round_id,r1.bracket[r1.round_id+1])=
      (r2.year,r2.round_id,r2.bracket[r1.round_id+1])
       and not(r1.bracket[r1.round_id]=r2.bracket[r1.round_id]))
left join href.matrix_field mf
  on (mf.year,mf.round_id,mf.team_id,mf.opponent_id)=
     (r1.year,r1.round_id,r1.team_id,r2.team_id)
left join rp
  on (rp.year,rp.team_field,rp.team_id,rp.opponent_id)=
     (mf.year,mf.field,mf.team_id,mf.opponent_id)
where
    r1.year=2017
and r1.round_id=1;
--group by r1.year,r1.round_id,r1.team_id,r1.seed,r1.points,r1.bracket;
*/

--

insert into href.rounds
(year,round_id,team_id,seed,points,bracket,p)
(
select
r1.year as year,
r1.round_id+1 as round,
r1.team_id,
r1.seed,
r1.points,
r1.bracket,

sum(
(case when r2.team_id is null then 1.0
 else
r1.p*r2.p*
(
-- Win in 4

  (rp.team_home_p)^2*(rp.team_away_p)^2
  
-- Win in 5

-- lost 1 away
+ 2*(rp.team_home_p)^3*(rp.team_away_p)*(1-rp.team_away_p)
-- lost 1 home
+ 2*(rp.team_home_p)^2*(1-rp.team_home_p)*(rp.team_away_p)^2

-- Win in 6

-- lost 2 away
+ (rp.team_home_p)^3*(rp.team_away_p)*(1-rp.team_away_p)^2
-- lost 2 home
+ 3*(rp.team_home_p)*(1-rp.team_home_p)^2*(rp.team_away_p)^3
-- lost 1 home, 1 away
+ 6*(rp.team_home_p)^2*(1-rp.team_home_p)*(rp.team_away_p)^2*(1-team_away_p)

-- Win in 7

-- lost 3 away
+ (rp.team_home_p)^4*(1-rp.team_away_p)^3
-- lost 3 home
+ (rp.team_home_p)*(1-rp.team_home_p)^3*(rp.team_away_p)^3
-- lost 1 home, 2 away
+ 9*(rp.team_home_p)^3*(1-rp.team_home_p)*(rp.team_away_p)*(1-rp.team_away_p)^2
-- lost 2 home, 1 away
+ 9*(rp.team_home_p)^2*(1-rp.team_home_p)^2*(rp.team_away_p)^2*(1-rp.team_away_p))
end)
)
as p

from href.rounds r1
left join href.rounds r2
  on ((r1.year,r1.round_id,r1.bracket[r1.round_id+1])=
      (r2.year,r2.round_id,r2.bracket[r1.round_id+1])
       and not(r1.bracket[r1.round_id]=r2.bracket[r1.round_id]))
left join href.matrix_field mf
  on (mf.year,mf.round_id,mf.team_id,mf.opponent_id)=
     (r1.year,r1.round_id,r1.team_id,r2.team_id)
left join rp
  on (rp.year,rp.team_field,rp.team_id,rp.opponent_id)=
     (mf.year,mf.field,mf.team_id,mf.opponent_id)
where
    r1.year=2017
and r1.round_id=1
group by r1.year,round,r1.team_id,r1.seed,r1.points,r1.bracket
);

commit;
