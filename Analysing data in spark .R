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