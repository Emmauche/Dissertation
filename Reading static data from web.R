# Today We will be working with web data in R. We shall download files using specialized packages to get data from web
# packages as httr to query API using GET() and POST()
# To download and read files from the internet you can use csv_url or tsv_url for example
csv_url <- "http://s3.amazonaws.com/assets.datacamp.com/production/course_1561/datasets/chickwts.csv"
tsv_url <- "http://s3.amazonaws.com/assets.datacamp.com/production/course_3026/datasets/tsv_data.tsv"
# Now We will read a file from  internet using the objects csv_url and tsv_url
csv_data <- read.csv(csv_url) 
tsv_data <-read.delim(tsv_url)
# to inspect the files We can use function head(). i.e
head(csv_data)
head(tsv_data)
# Now we can access the file, we need to download it foe ease access on our local computer
# We shall be using the download.file() function. which takes two arguments; url (source) and destfile(storage location)
download.file(url = csv_url,destfile = "feed_data.csv")
# to read our downloaded file we can use read.csv()
Ncsv_data <- read.csv("feed_data.csv")
# To view our data we can type
Ncsv_data
# dealing with formats weather downloading data using download.file() or read.csv, there will be need to modify data and preserve format
# We could use write.table() functon but will worry about accidentally writing out data in a format r cannot read back
# To avoid this risk you can use saveRDS() and  readRDS() functions which save R objects in R specific file formats
?readRDS()
?write.table
?saveRDS
# Example, we are introducing a new column called squaredweight. which is the square of existing weight as contained in the weight colum 
csv_data$sqare_weight <- csv_data$weight^2
# now that the new column has been adde, We need to save it to disk using saveRDS()
saveRDS(object = csv_data, file = "modified_feed_data.RDS")
# To read it back we use readRDS()
modifield_feed_data <- readRDS(file = "modified_feed_data.RDS")
# to examine our new data run
str(modifield_feed_data)
