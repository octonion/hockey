library(BradleyTerry2)

library(RPostgreSQL)

drv <- dbDriver("PostgreSQL")

con <- dbConnect(drv,dbname="hockey")

query <- dbSendQuery(con, "
select
(case when r.team_score>r.opponent_score then 1.0
      when r.team_score<r.opponent_score then 0.0
      when r.team_score=r.opponent_score then 0.5
 end) as outcome,
r.school_id as team,
r.opponent_id as opponent
from uscho.results r
where
    r.year between 2015 and 2015
and r.school_div_id=1
and r.opponent_div_id=1
and r.team_score is not null
and r.opponent_score is not null

;")

games <- fetch(query,n=-1)
dim(games)

fit <- BTm(outcome,team,opponent,data=games)

krach <- as.data.frame(BTabilities(fit))
krach[with(krach, order(-ability)), ]

quit("no")
