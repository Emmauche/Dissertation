# We want to install sparklyr, first confirm the R studio is of latest version
# On the right side, click on update and update all
# install packages. to be able to use sparklyr we need to install the following packages
# httpuv
#sparklyr
install.packages("httpuv")

library(sparklyr)
spark_install(version = "2.4.0")
# now install devtools and include its library
install.packages("devtools")
library(devtools)
devtools::install_github("rstudio/sparklyr")
# now restart R, through the session bar
# now include the sparklyr library
library(sparklyr)
# now we need to connect to a local version of spark type
Sc<- spark_connect(master = "local")
# next, open the spark UI, connections tab. spark UI opens browser
spark_web(Sc)
# load data into spark cluster
library(dplyr)
UCsat<-copy_to(Sc,UCS_Satellite_Database, "spark_ucs")# This will not connect because the database is not available here
src_tbls(Sc)
