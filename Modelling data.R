# Modelling describes and tries to generalize datasets by use of mathematical models.
# Using the car df, we can use a linear model to approximate the relationship between fuel efficiency and horsepower
model <- ml_linear_regression(car, mpg ~ hp)
?ml_linear_regression
model
# Handling data 
###################################
# data is read from existing data sourcs in variety of formats ; like, plain text,CSV, JSON, JDBC and many more. 
# For instance we can export the car dataset as a csv file, by typing
spark_write_csv(car, "car.csv")
# In practice we would read an existing dataset from a distributed storage system like HDFS, but we can also read back from the local file system
# like
car <- spark_read_csv(Sc, "car.csv")
####################################################################################################
# Usinf a sample document for modelling as example. her we are using files from "okcupid" dating site the data is zipped
download.file("https://github.com/r-spark/okcupid/raw/master/profiles.csv.zip", "okcupid.zip")
# Now we will unzip it
unzip("okcupid.zip", exdir = "okcupidData")
# deleting the zip file we run the unlink function
unlink("okcupid.zip")
head("okcupidData")
str("okcupidData")
# working on the profiles
profiles <- read.csv("okcupidData/profiles.csv")
profiles
write.csv(dplyr:: sample_n(profiles, 10^3),"okcupidData/profiles.csv", row.names = FALSE)
# to follow along we need to install the following packages
install.packages("ggmosaic")
install.packages("forcats")
install.packages("FactoMineR")
######################################################################################################################
# EXPLORATORY DATA ANALYSIS
# Exploratory data analysis (EDA), in the context of predictive modeling, is the exercise of looking at excerpts and summaries of the data. 
# The specific goals of the EDA stage are informed by the business problem, but here are some common objectives:

# 1) Check for data quality; confirm meaning and prevalence of missing values and reconcile statistics against existing controls.
# 2) Understand univariate relationships between variables.
# 3) Perform an initial assessment on what variables to include and what transformations need to be done on them.
# To begin, we connect to Spark, load libraries, and read in the data:
library(sparklyr)
library(ggplot2)
library(dbplot)
library(dplyr)
# now we start our spark connection
sc <- spark_connect(master = "local")
# next we will read the okcupid file into spark
okc <- spark_read_csv(
  sc, 
  "okcupidData/profiles.csv", 
  escape = "\"", 
  memory = FALSE,
  options = list(multiline = TRUE)
) %>%
  mutate(
    height = as.numeric(height),
    income = ifelse(income == "-1", NA, as.numeric(income))
  ) %>%
  mutate(sex = ifelse(is.na(sex), "missing", sex)) %>%
  mutate(drinks = ifelse(is.na(drinks), "missing", drinks)) %>%
  mutate(drugs = ifelse(is.na(drugs), "missing", drugs)) %>%
  mutate(job = ifelse(is.na(job), "missing", job))
# to view the data we use the glimpse function
glimpse(okc)
# Now we add our respnse variable as a column in the dataset and look at it's distribution
okc <- okc %>%
  mutate(
    not_working = ifelse(job %in% c("student","unemployed","retired"), 1,0)
  ) okc %>% group_by(not_working) %>% tally()
# the code just above isn't working
rlang::last_error()
# We could split the data by using the sdf_random_split() function
data_splits <- sdf_random_split(okc, training = 0.8, testing = 0.2, seed = 42)
