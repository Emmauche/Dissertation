# Working on my R studio. To use the following notes
# •	Social media analysis: To get the social media data
# Extracting twitter data
# Onnce a twittwer developer account is created, enable pop-up on your mobile browser install rtweet() and httpuv() packages
install.packages("rtweet")
library(rtweet)
install.packages("httpuv")
library(httpuv)
# the function search_tweets() is a querry to connect with twitter returning the twitter data matching a search query for tweets from the past 7 days only
# and maximun of 18,000 tweets returned per request for e.g
library(rtweet)
tweets_covid <-search_tweets("#COVID-19", n= 2000, include_rts = TRUE, lang = "en")
tweets_corona <-search_tweets("#CORONA", n= 2000, include_rts = TRUE, lang = "en")
tweets_cov <-search_tweets("#COVID", n= 2000, include_rts = TRUE, lang = "en")
tweets_2020 <-search_tweets("#2020", n= 2000, include_rts = TRUE, lang = "en")
# We aim at analyzing immediate tweets and be able to identify mis informing ones
# now we shall examine the data extracted We use the head() function
head(tweets_covid)
names(tweets_covid)
head(tweets_cov)
head(tweets_corona)
head(tweets_2020)


#############################################################################
get_trump <- get_timeline("@Trump", n =3200) ############
head(get_trump)   #######################################
# working on some further examples#######################
# To view output of 5 columns and 10 rows, we can type###
head(get_trump[,1:5], 10) ###############################

# Components of twitter data.
# This deals with working with Twitter JSON. These JSON components helps in deriving insights
# A tweet may have over 150 metadata component
#JSON has attributes and Values
#The rtweet() function converts it into column names and values
# Now We will view components of tweets by extracting tweets on #COVID-19 using search-tweets()
tweets_cov19 <- search_tweets("#COVID")
head(tweets_cov19)
#To view the column, type
names(tweets_cov19)


# next we aim at exploring components
# screen_name is to understand user interest
# followers_count is to compare social media influence
# retweet_count and text is to identify popular tweets
# Now we will create table of users and tweet counts for the topic
screen_name <- table(tweets_cov19$screen_name)
name_cov19 <- table(tweets_cov19$text, tweets_cov$text,tweets_2020$text,tweets_corona$text)
head(screen_name)
sc_covid <- table(tweets_covid$created_at)
head(sc_covid)


# Follower count can help to measure popularity of a user as it measures influence on social media
# You can compare followers count of shows or events or persons by using the lookup_users() function
# Exploring components
# screen_name is to understand user interest
# followers_count is to compare social media influence
# retweet_count and text is to identify popular tweets
# We can compare followers count. example
<<<<<<< HEAD
covid_trend<- lookup_statuses(c("COVID","COVID-19","corona virus"))
covid_trend
covid1_trend <- lookup_tweets("covid")
covid1_trend
covid_df <- covid1_trend[c("followers_count","text")]
tw_follower <- lookup_users(c("trump","Christiano","adele"))
tw_trends <- lookup_users(c("COVID","COVID-19","corona virus"))
trend_df <- tw_trends[,c("screen_name","followers_count")]
trend_df
#next we create a dataframe for the screen name and followers count
user_df <- tw_follower[,c("screen_name", "followers_count")]
#to view the dataframe
=======

## To find trend we can use the below as guide
#######################################################################
tw_follower <- lookup_users(c("trump","Christiano","adele"))###########
tw_trends <- lookup_users(c("COVID","COVID-19","corona virus"))########
trend_df <- tw_trends[,c("screen_name","followers_count")]#############
trend_df###############################################################

# creating dataframe for covid tweets by users and number of followers they have and the text they shared
us_cov_df <- tweets_covid[,c("screen_name","followers_count","text")]
us_cov2_df <- tweets_cov[,c("screen_name","followers_count","text")]
us_cov3_df <- tweets_corona[,c("screen_name","followers_count","text")]
us_cov4_df <- tweets_2020[,c("screen_name","followers_count","text")]

# viewing the df
us_cov_df
us_cov2_df
us_cov3_df
us_cov4_df

>>>>>>> c4b78943a9077d8f2337ed1e243e62003c063c99
# retweet is a tweet re-shared by another user
# We use retweet_count to store number of retweets
# it helps to identify trends and popularity of a topic
# We will create


# creating dataframe of tweet text and retweet counts
rtwt <- tw_follower[,c("text","retweet_count")]
rtwt
# Sorting dataframe based on followers count in descending order
library(dplyr)
rtwt_sort <- arrange(us_cov_df, desc(us_cov_df$followers_count))
rtwt_sort2 <- arrange(us_cov2_df, desc(us_cov2_df$followers_count))
rtwt_sort3 <- arrange(us_cov3_df, desc(us_cov3_df$followers_count))
rtwt_sort4 <- arrange(us_cov4_df, desc(us_cov4_df$followers_count))
rtwt_sort
# dealing with duplicate tweets
# We use unique functions to tackle duplication of tweets. example
rtwt_unique <- unique(rtwt_sort, by ="text")
rtwt_unique2 <- unique(rtwt_sort2, by ="text")
rtwt_unique3 <- unique(rtwt_sort3, by ="text")
rtwt_unique4 <- unique(rtwt_sort4, by ="text")
rtwt_unique
head(rtwt_unique)
head(rtwt_unique2)
head(rtwt_unique3)
head(rtwt_unique4)
# In summary the tweet count is to derive insights, identify twitter users who are interested in atopic
# And look at users who tweet often about a topic and can be used for target advertising of actions
# to create the table of users and tweet count for a topic. we can have the  code
User_name_table <- table(us_cov_df$screen_name)
User_name_table2 <- table(us_cov2_df$screen_name)
User_name_table3 <- table(us_cov3_df$screen_name)
User_name_table4 <- table(us_cov4_df$screen_name)
head(User_name_table)
head(user_df)

# •	Reading and writing data into spark: This to save the twitter data into a data-frame
# aim is go get more value from data presented
# For record purposes. twitter data was saved starting from 15-09-2020
# then create a directory called data.csv
dir.create("tweetcsv")
# writing the contents of letters into the created directory and creating new csv files
write.csv(us_cov_df, "tweetcsv/l1.csv", row.names = FALSE)
write.csv(us_cov2_df, "tweetcsv/l2.csv", row.names = FALSE)
write.csv(us_cov3_df, "tweetcsv/l3.csv", row.names = FALSE)
write.csv(us_cov4_df, "tweetcsv/l4.csv", row.names = FALSE)

# combining all csv files
do.call("rbind", lapply(dir("tweetcsv", full.names = TRUE), read.csv))

library(sparklyr)
sc <- spark_connect(master = "local")

spark_read_csv(sc, "tweetcsv/")

# •	Streaming R: To create a continuous flow of data
# Then We define a stream that processes incoming data from the input folder, performs a custom transformation in R and pushes the output into an output folder
# first we created a directory for the input we will get, then create a csv file
# then create a stream with the attributes we need
names(tweets_co)
??stream
stream <- stream_read_csv(Sc, "dissertationcsv/")%>% select(, ,) %>% stream_write_csv("output/")
dir("output", pattern = ".csv")
# We can keep adding files to the input location, and the spark will parallelize and process data automatically. Let's add one more file and validate that its automatically processed
write.csv(mtcars, "input/cars_2.csv", row.names = F)
# now check and validate that the data is processed by the spark stream
dir("output", pattern = ".csv")
# to stop the stream use the streamstop() function
stream_stop(stream)
# sample of words to search on twitter 
# Unreliable, COnspiracy Clickbait, political/biased
#some keywords
#covid19, covid-19, coronavirus, corona virus, 2019nCov, CoronavirusOutbreak, coronapocalyse
??textmining
??broom
??pipeline
??analyze
??ggplot

# •	Basic text mining
# •	Text mining with R
# •	Tidying text
# •	Pipeline
# •	Modelling/Topic modelling
# •	 Analyzing data in r
# 	 
