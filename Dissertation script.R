# Spark is an improvement of Hadoop
# sparklyr is a project to combine spark and r fo better performance
# Common packages used are  
# Dplyr ### to manipulate data
# cluster ### to analyze clusters
# ggplot ### to visualize data
# We want to install sparklyr, first confirm the R studio is of latest version
# On the right side, click on update and update all
# install packages. to be able to use sparklyr we need to install the following packages
# httpuv
#sparklyr
install.packages("httpuv")
install.packages("sparklyr")
library(sparklyr)
# we can check the available versions of spark by running
spark_available_versions()
spark_install(version = "3.0")
# to check the installed version, run
spark_installed_versions()
# To uninstall a specific version of spark you cn run
spark_uninstall(version = "2.4.0", hadoop = "2.7")
# now install devtools and include its library
install.packages("devtools")
library(devtools)
devtools::install_github("rstudio/sparklyr")
# now restart R, through the session bar
# now include the sparklyr library
library(sparklyr)
# checking the version of sparklyr installed run
packageVersion("sparklyr")
####################################################################
#### Connecting to spark locally#############
# So fr we have installed the local spark cluster
# now we need to connect to a local version of spark type 
Sc<- spark_connect(master = "local")
# you can alos connect by typing  Sc<- spark_connect(master = "local", version = "3.0")
# to disconnect run
spark_disconnect(Sc)
# if multiple spark connections are active or if the connection instance is no longer available you can diconnect all by typing
spark_disconnect_all()
######################################################################
# Using spark. let's use cars dataset 
cars
# next copy the mtcars data into spark using the established connection
car <- copy_to(Sc,mtcars)
car
# next, open the spark UI, connections tab. spark UI opens browser
# Most of the Spark commands are executed from the R console; however, 
#monitoring and analyzing execution is done through Spark’s web interface.
# This interface is a web application provided by Spark that you can access by running:
spark_web(Sc)
# load data into spark cluster
library(dplyr)
UCsat<-copy_to(Sc,UCS_Satellite_Database, "spark_ucs")# This will not connect because the database is not available here
src_tbls(Sc)
