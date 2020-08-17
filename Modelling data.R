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
