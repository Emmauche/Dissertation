# Log is an important tool, which appends informtion relevant to the execution of tasks in the cluster.
# For local clusters, we can retrieve all the recent logs by running the spark_log() function
spark_log(Sc)
# or we can retrieve specific log entries containning any project. Example for sparklyr, we can type
spark_log(Sc, filter = "sparklyr")
# This logs are only required when troubleshooting
