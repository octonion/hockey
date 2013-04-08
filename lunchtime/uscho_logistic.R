
games <- read.csv("uscho_games.csv",stringsAsFactors=FALSE)
dim(games)

t <- subset(games, year==2013 & team_div=="I" & opponent_div=="I", select=c(outcome,team,opponent))

t$team <- as.factor(t$team)
t$opponent <- as.factor(t$opponent)

o <- data.frame(outcome=1-t$outcome,team=t$opponent,opponent=t$team)

g <- rbind(t,o)

d <- nlevels(t$team)

fit <- glm(outcome ~ -1+team+opponent,data=g,family=binomial(link="logit"))

fit

logistic <- as.data.frame(summary(fit)$coefficients[1:d,])
logistic <- logistic[with(logistic, order(-Estimate)), ]

logistic <- subset(logistic,TRUE,select=c(Estimate))
logistic$Estimate <- exp(logistic$Estimate)
logistic

quit("no")
