# To extract live tweets for 120s window we can run the
?stream_tweets
install.packages("twitteR")
library(twitteR)
tweets120s <-stream_tweets(" ", time = 120)
# Extracting twitter data
# Onnce a twittwer developer account is created, enable pop-up on your mobile browser install rtweet() and httpuv() packages
install.packages("rtweet")
library(rtweet)
install.packages("httpuv")
library(httpuv)
# the function search_tweets() is a querry to connect with twitter returning the twitter data matching a search query for tweets from the past 7 days only
# and maximun of 18,000 tweets returned per request for e.g
library(rtweet)
tweets_covid <-search_tweets("#COVID-19", n=1000, include_rts = TRUE, lang = "en")
# now we shall examine the data extracted We use the head() function
head(tweets_covid)
# To return tweets by specific user, you can use get_timeline() function. for e.x
#extracting tweets from trump we execute
get_trump <- get_timeline("@Trump", n =3200)
head(get_trump)
# working on some further examples
# To view output of 5 columns and 10 rows, we can type
head(get_trump[,1:5], 10)
get_chris <- get_timeline("@christiano", n= 3200)
head(get_chris)
# Components of twitter data.
# This deals with working with Twitter JSON. These JSON components helps in deriving insights
# A tweet may have over 150 metadata component
#JSON has attributes and Values
#The rtweet() function converts it into column names and values
# Now We will view components of tweets by extracting tweets on #COVID-19 using search-tweets()
tweets_co <- search_tweets("#COVID")
#To view the column, type
names(tweets_co)
# next we aim at exploring components
# screen_name is to understand user interest
# followers_count is to compare social media influence
# retweet_count and text is to identify popular tweets
# Now we will create table of users and tweet counts for the topic
sc_name <- table(tweets_co$screen_name)
head(sc_name)
sc_covid <- table(tweets_covid$created_at)
head(sc_covid)
# Now we want to sort the table in descending order or tweet counts
sc_name_sort <- sort(sc_name, decreasing = TRUE)
head(sc_name_sort)
# Follower count can help to measure popularity of a user as it measures influence on social media
# You can compare followers count of shows or events or persons by using the lookup_users() function
