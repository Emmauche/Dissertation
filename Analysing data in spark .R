# When using Spark from R to analyze data, you can use SQL (Structured Query Language) or dplyr (a grammar of data manipulation). 
# You can use SQL through the DBI package; 
#for instance, to count how many records are available in our dataset, we can run the following:
library("DBI")
# here we can use sql querry referencing the connection as below
dbGetQuery(Sc, "SELECT count(*) FROM mtcars")
# When using dplyr, you write less code, and it’s often much easier to write than SQL. 
# This is precisely why we won’t make use of SQL
# however, if you are proficient in SQL, this is a viable option for you.
# For instance, counting records in dplyr is more compact and easier to understand:
library(dplyr)
# In general, analyses in spark with dplyr starts with count, followed by sampling rows and selecting a subset of the available columns, the 
# next step is to collect data from spark to perform further data processing, like visualisation 
# to perform count simply use function count as below
count(car)
# performing visualisation
select(car, hp, mpg) %>% sample_n(100) %>% collect() %>% plot()
# code above is ploting mpg on y axis against hp on x axis of the car dataframe 
#############################################################################################################################
############################################################################################################################
# DATA ANALYSIS
# The main goal of data analysis is to understand what the data is trying to tell us, hoping that it provides an answer to a specific question
# A common step often employed is
# 1) Data Import
# 2) Data Understanding; includes; data wrangling, Data visualisation and modelling
# 3) Communication of outcome ( interpretation)
# To practise, we will install the following packages
install.packages("ggplot2")
install.packages("corrr")
install.packages("dbplot")
install.packages("rmarkdown")
# Now we will load the sparklyr and dplyr libraries
library(sparklyr)
library(dplyr)
##################################################################################
# Importing data
####################################
# Instead of importing all data into spark, spark can be requested to to access the data source without importing it.
# Correlation
##################################################################################
# To be able to calculate and visualize correlations, we can use the corr package in spark
library("corrr")
ml_corr(car)
warning()
