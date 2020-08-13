# in tyding text, it is important to know that 
# each variable is a column
# each observation is a row
# each type of observation unit is a table

# Contrasting tidy text with other data structure
#String : They are text stored as characters or vectors and is often read into memory in the form of text data
# Corpus : They are objects that typically contain raw strings annotated with additional metadata and details
# Document-term Matrix : it is a sparse matrix describing a collection(i.e a corpus) of documents
# with one row for each document and one column for each term. 
# The value in the matrix is typically word count or tf-idf
#####################################################################################
#The unnest_token function
#######################################
# now we will work with some data from twitter
# To extract live tweets for 120s window we can run the
?stream_tweets
install.packages("twitteR")
library(twitteR)
tweets120s <-stream_tweets(" ", time = 120)
tweets120s
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
tweets_covid
str(tweets_covid)
# now we will create data frame for the covid tweets
covid_df <- tweets_covid[,c("screen_name", "followers_count","text","retweet_count")]
covid_df
str(covid_df)
# Sorting data frame based on descending order
library(dplyr)
arr_sort <- arrange(covid_df, desc(retweet_count))
arr_sort
covid_unique <- unique(arr_sort, by ="text")
covid_unique
# to pick out particular text we can have
install.packages("dplyr")
library(dplyr)
library(tidytext)
covid_unique %>% unnest_tokens (word, text)
??stringr
tweets_covid
write.csv(covid_df,"C\\Users\\Public\\Downloads\\twitter1.csv", row.names = TRUE )