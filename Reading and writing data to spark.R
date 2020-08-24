# We create a dataframe of letters (Alphabets and their corresponding number) 
letters <- data.frame(x = letters, y = 1:length(letters))
letters
# then create a directory called data.csv
dir.create("data-csv")
# writing the contents of letters into the created directory and creating new csv files
write.csv(letters[1:3, ], "data-csv/letters1.csv", row.names = FALSE)
write.csv(letters[1:3, ], "data-csv/letters2.csv", row.names = FALSE)
# combining both csv files
do.call("rbind", lapply(dir("data-csv", full.names = TRUE), read.csv))
library(sparklyr)
sc <- spark_connect(master = "local")

spark_read_csv(sc, "data-csv/")