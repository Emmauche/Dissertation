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



