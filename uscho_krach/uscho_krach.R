library("BradleyTerry2")

library("RPostgreSQL")

drv <- dbDriver("PostgreSQL")

con <- dbConnect(drv,host="localhost",port="5432",dbname="hockey")

query <- dbSendQuery(con, "
select
(case when r.team_score>r.opponent_score then 1
      when r.team_score<r.opponent_score then 0
 end) as outcome,
r.school_name as team,
r.opponent_name as opponent
from uscho.results r
where
    r.year between 2013 and 2013
and r.school_div_id=1
and r.opponent_div_id=1
and r.team_score is not null
and r.opponent_score is not null
and not(r.team_score=r.opponent_score)

;")

games <- fetch(query,n=-1)
dim(games)

krach <- BTm(outcome,team,opponent,data=games)
krach

quit("no")
