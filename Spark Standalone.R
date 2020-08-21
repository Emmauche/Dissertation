#####################################################
# Spark standalone uses itself as its own cluster manager, which allows use of spark without installing additional software in your cluster
# to start the workers nodes on a single machine, first retrieve the spark_home directory by running spark_home_dir() function and then start the master node and workers node as follows
library(sparklyr)
spark_home <- spark_home_dir()
# build paths and classes
spark_path <- file.path(spark_home, "bin", "spark-class")
# start cluster manager master node
system2 (spark_path, "org.apache.spark.deploy.master.Master", wait = FALSE)
# After performing computations in this cluster, you will need to stop the master and worker nodes. 
# you can use the jps command to identify the process number to terminate
# Toterminate a process, youcan use system("Taskkill /PID #### /F") in windows or
# system("kill -9 ######" )in macOS and Linux
system("jps")
system("kill -9 2751")
system("jps")

