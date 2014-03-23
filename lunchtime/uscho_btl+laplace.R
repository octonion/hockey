library("BradleyTerry2")

games <- read.csv("uscho_games.csv",stringsAsFactors=FALSE)
dim(games)

g <- subset(games,year==2013 & team_div=="I" & opponent_div=="I")
dim(g)

teams <- unique(append(g$team,g$opponent))
n <- length(teams)

dummy_games_won <- data.frame(year=rep("2013",n),game_date=rep("",n),team=rep("Dummy",n),team_div=rep("I",n),opponent=teams,opponent_div=rep("I",n),site=rep("",n),team_score=rep(1,n),opponent_score=rep(0,n),outcome=rep(1.0,n))

dummy_games_lost <- data.frame(year=rep("2013",n),game_date=rep("",n),team=teams,team_div=rep("I",n),opponent=rep("Dummy",n),opponent_div=rep("I",n),site=rep("",n),team_score=rep(1,n),opponent_score=rep(0,n),outcome=rep(1.0,n))

g <- rbind(g,dummy_games_won)
g <- rbind(g,dummy_games_lost)
dim(g)

fit <- BTm(outcome,team,opponent,data=g)

fit

krach <- as.data.frame(BTabilities(fit))
krach <- krach[with(krach, order(-ability)), ]

krach <- subset(krach,TRUE,select=c(ability))
krach$ability <- exp(krach$ability)
krach

quit("no")
