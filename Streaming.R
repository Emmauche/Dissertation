# To try out streaming, We first create a folder,here we will call it input
dir.create("input")
write.csv(mtcars, "input/cars_1.csv", row.names = F)
# Then We define a strean that processes incoming data from the input folder, performs a custom transformation in R and pushes the output into an output folder
stream <- stream_read_csv(Sc, "input/")%>% select(mpg,cyl,disp) %>% stream_write_csv("output/")
dir("output", pattern = ".csv")
# We can keep adding files to the input location, and the spark will parallelize and process data automatically. Let's add one more file and validate that its automatically processed
write.csv(mtcars, "input/cars_2.csv", row.names = F)
# now check and validate that the data is processed by the spark stream
dir("output", pattern = ".csv")
# to stop the stream use the streamstop() function
stream_stop(stream)
head(mtcars$mpg)
names(mtcars)
