sink("diagnostics/lmer.txt")

library(lme4)
library(RPostgreSQL)

drv <- dbDriver("PostgreSQL")
con <- dbConnect(drv, dbname="hockey")

query <- dbSendQuery(con, "
select
r.game_id,
r.year,
r.field as field,
r.team_id as team,
r.opponent_id as opponent,
r.team_score as gs,
r.game_length as status,
(((r.game_date-f.base_date)/6.9)::integer)^2 as week
from href.results r
join
(
select year,min(game_date::date-7) as base_date
from href.games
group by year) f
  on (f.year)=(r.year)
where
    r.year between 2008 and 2016
and r.team_score is not null
;")

games <- fetch(query,n=-1)

dim(games)

attach(games)

pll <- list()

# Fixed parameters

year <- as.factor(year)
field <- as.factor(field)
status <- as.factor(status)

fp <- data.frame(year,field,status)
fpn <- names(fp)

# Random parameters

game_id <- as.factor(game_id)
offense <- as.factor(paste(year,"/",team,sep=""))
defense <- as.factor(paste(year,"/",opponent,sep=""))

rp <- data.frame(offense,defense)
rpn <- names(rp)

for (n in fpn) {
  df <- fp[[n]]
  level <- as.matrix(attributes(df)$levels)
  parameter <- rep(n,nrow(level))
  type <- rep("fixed",nrow(level))
  pll <- c(pll,list(data.frame(parameter,type,level)))
}

for (n in rpn) {
  df <- rp[[n]]
  level <- as.matrix(attributes(df)$levels)
  parameter <- rep(n,nrow(level))
  type <- rep("random",nrow(level))
  pll <- c(pll,list(data.frame(parameter,type,level)))
}

# Model parameters

parameter_levels <- as.data.frame(do.call("rbind",pll))
dbWriteTable(con,c("href","_parameter_levels"),parameter_levels,row.names=TRUE)

g <- cbind(fp,rp,week)

head(g)

g$gs <- gs

dim(g)

model <- gs ~ year+field+status+(1|offense)+(1|defense)+(1|game_id)

fit <- glmer(model,
	     data=g,
	     family=poisson,
	     verbose=TRUE,
	     weights=week,
	     nAGQ=0,
	     control=glmerControl(optimizer = "nloptwrap"))
fit
summary(fit)

# List of data frames

# Fixed factors

f <- fixef(fit)
fn <- names(f)

# Random factors

r <- ranef(fit)
rn <- names(r) 

results <- list()

for (n in fn) {

  df <- f[[n]]

  factor <- n
  level <- n
  type <- "fixed"
  estimate <- df

  results <- c(results,list(data.frame(factor,type,level,estimate)))

 }

for (n in rn) {

  df <- r[[n]]

  factor <- rep(n,nrow(df))
  type <- rep("random",nrow(df))
  level <- row.names(df)
  estimate <- df[,1]

  results <- c(results,list(data.frame(factor,type,level,estimate)))

 }

combined <- as.data.frame(do.call("rbind",results))

dbWriteTable(con,c("href","_basic_factors"),as.data.frame(combined),row.names=TRUE)

quit("no")
