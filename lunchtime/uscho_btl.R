library("BradleyTerry2")

games <- read.csv("uscho_games.csv",stringsAsFactors=FALSE)
dim(games)

g <- subset(games,year==2013 & team_div=="I" & opponent_div=="I")
dim(g)

fit <- BTm(outcome,team,opponent,data=g)

fit

krach <- as.data.frame(BTabilities(fit))
krach[with(krach, order(-ability)), ]

quit("no")
