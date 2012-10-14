
r <- getOption("repos")
r["CRAN"] <- "http://ftp.osuosl.org/pub/cran"
options(repos=r)

package <- commandArgs(TRUE)[1]

install.packages(package,dependencies=TRUE)

q("no")
