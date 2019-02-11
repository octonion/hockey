sink("diagnostics/glmnet.txt")

library(glmnet)
library(RPostgreSQL)

drv <- dbDriver("PostgreSQL")

con <- dbConnect(drv,dbname="hockey")

query <- dbSendQuery(con, "
select
r.game_id,
r.year,
r.field as field,
r.school_id as team,
r.school_div_id as o_div,
r.opponent_id as opponent,
r.opponent_div_id as d_div,
r.game_length as game_length,
r.team_score::float as gs
from uscho.results r
where
    r.year between 2019 and 2019
and r.school_div_id is not null
and r.opponent_div_id is not null
and r.team_score is not null
and r.opponent_score is not null
and r.school_div_id=1
and r.opponent_div_id=1

-- fit all excluding NCAA tournament games
-- and not(coalesce(r.notes,'') like 'NCAA%')
;")

games <- fetch(query,n=-1)
dim(games)

attach(games)

pll <- list()

# Fixed parameters

year <- as.factor(year)

field <- as.factor(field)
field <- relevel(field, ref = "neutral")

d_div <- as.factor(d_div)
o_div <- as.factor(o_div)

game_length <- as.factor(game_length)

game_id <- as.factor(game_id)
offense <- as.factor(paste(year,"/",team,sep=""))
defense <- as.factor(paste(year,"/",opponent,sep=""))

fp <- data.frame(year,field,d_div,o_div,game_length)
rp <- data.frame(offense,defense)

g <- cbind(fp,rp)

g$gs <- gs

dim(g)

y <- model.matrix(~ field+game_length+offense+defense,g)

cvfit <- cv.glmnet(y, gs, family="poisson")
cvfit
summary(cvfit)

#opt.lam = c(cvfit$lambda.min, cvfit$lambda.1se)
#coef(cvfit, s = opt.lam)

coef(cvfit)

