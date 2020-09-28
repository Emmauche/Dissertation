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
tweets_cure  <-search_tweets("#cure", n= 2000, include_rts = TRUE, lang = "en")
tweets_lockdown  <-search_tweets("#lockdown", n= 2000, include_rts = TRUE, lang = "en")
# We aim at analyzing immediate tweets and be able to identify mis informing ones
# now we shall examine the data extracted We use the head() function
head(tweets_covid)
names(tweets_covid)
head(tweets_cov)
head(tweets_corona)
head(tweets_2020)
#############################################################################
# Components of twitter data.
# This deals with working with Twitter JSON. These JSON components helps in deriving insights
# A tweet may have over 150 metadata component
#JSON has attributes and Values
#The rtweet() function converts it into column names and values
# Now We will view components of tweets by extracting tweets on #COVID-19 using search-tweets()
#To view the components,we typed
names(tweets_cov)

# next we aim at exploring components
# screen_name is to understand user interest
# followers_count is to compare social media influence
# retweet_count and text is to identify popular tweets
# Now we will create table of users and tweet counts for the topic
sc_covid <- table(tweets_covid$created_at)
head(sc_covid)

# Follower count can help to measure popularity of a user as it measures influence on social media
# You can compare followers count of shows or events or persons by using the lookup_users() function
# Exploring components
# screen_name is to understand user interest
# followers_count is to compare social media influence
# retweet_count and text is to identify popular tweets
# We can compare followers count. example
#next we create a dataframe for the screen name and followers count
#to view the dataframe

## To find trend we can use the below as guide
#######################################################################
# creating dataframe for covid tweets by users and number of followers they have and the text they shared
us_cov10_df <- tweets_covid[,c("screen_name","followers_count","text")]
us_cov11_df <- tweets_cov[,c("screen_name","followers_count","text")]
us_cov12_df <- tweets_corona[,c("screen_name","followers_count","text")]
us_cov13_df <- tweets_2020[,c("screen_name","followers_count","text")]
us_cov14_df <- tweets_2020[,c("screen_name","followers_count","text")]
us_cov15_df <- tweets_2020[,c("screen_name","followers_count","text")]
# viewing the df
us_cov10_df
us_cov2_df
us_cov3_df
us_cov4_df

# retweet is a tweet re-shared by another user
# We use retweet_count to store number of retweets
# it helps to identify trends and popularity of a topic
# Sorting dataframe based on followers count in descending order
library(dplyr)

rtwt_sort10 <- arrange(us_cov10_df, desc(us_cov10_df$followers_count))
rtwt_sort11 <- arrange(us_cov11_df, desc(us_cov11_df$followers_count))
rtwt_sort12 <- arrange(us_cov12_df, desc(us_cov12_df$followers_count))
rtwt_sort13 <- arrange(us_cov13_df, desc(us_cov13_df$followers_count))
rtwt_sort14 <- arrange(us_cov14_df, desc(us_cov14_df$followers_count))
rtwt_sort15 <- arrange(us_cov15_df, desc(us_cov15_df$followers_count))
rtwt_sort
# dealing with duplicate tweets
# We use unique functions to tackle duplication of tweets. example
rtwt_unique <- unique(rtwt_sort10, by ="text")
rtwt_unique2 <- unique(rtwt_sort11, by ="text")
rtwt_unique3 <- unique(rtwt_sort12, by ="text")
rtwt_unique4 <- unique(rtwt_sort13, by ="text")
rtwt_unique5 <- unique(rtwt_sort14, by ="text")
rtwt_unique6 <- unique(rtwt_sort15, by ="text")
rtwt_unique
head(rtwt_unique)
head(rtwt_unique2)
head(rtwt_unique3)
head(rtwt_unique4)
# In summary the tweet count is to derive insights, identify twitter users who are interested in a topic
# And look at users who tweet often about a topic and can be used for target advertising of actions
# to create the table of users and tweet count for a topic. we can have the  code
User_name_table <- table(us_cov10_df$screen_name)
User_name_table2 <- table(us_cov11_df$screen_name)
User_name_table3 <- table(us_cov12_df$screen_name)
User_name_table4 <- table(us_cov13_df$screen_name)
User_name_table5 <- table(us_cov14_df$screen_name)
User_name_table6 <- table(us_cov15_df$screen_name)

head(User_name_table)
head(user_df)

# •	Reading and writing data into spark: This to save the twitter data into a data-frame
# aim is go get more value from data presented
# For record purposes. twitter data was saved starting from 15-09-2020
# then create a directory called data.csv
dir.create("tweetcsv")
# writing the contents of letters into the created directory and creating new csv files
write.csv(us_cov_df, "tweetcsv/l1.csv", row.names = FALSE)
write.csv(us_cov1_df, "tweetcsv/l1.csv", row.names = FALSE)
write.csv(us_cov2_df, "tweetcsv/l2.csv", row.names = FALSE)
write.csv(us_cov3_df, "tweetcsv/l3.csv", row.names = FALSE)
write.csv(us_cov4_df, "tweetcsv/l4.csv", row.names = FALSE)
write.csv(us_cov5_df, "tweetcsv/l5.csv", row.names = FALSE)


# combining all csv files
do.call("rbind", lapply(dir("tweetcsv", full.names = TRUE), read.csv))
??do.call
library(sparklyr)
sc <- spark_connect(master = "local")

spark_read_csv(sc, "tweetcsv/")


# •	Streaming R: To create a continuous flow of data
# Then We define a stream that processes incoming data from the input folder, performs a custom transformation in R and pushes the output into an output folder
# first we created a directory for the input we will get, then create a csv file
# then create a stream with the attributes we need
names(tweets_co)
??stream
stream <- stream_read_csv(sc, "tweetcsv/")%>% select(screen_name,followers_count,text) %>% stream_write_csv("tweetout/")
# In here the processing occurs, before outputing results
############################################################################
# to delete a file use the command below ###################################
if(file.exists("Dissertation method-copy.R")) unlink("Dissertation method-copy.R", TRUE)########
############################################################################


dir("tweetout", pattern = ".csv")
# We can keep adding files to the input location, and the spark will parallelize and process data automatically. Let's add one more file and validate that its automatically processed
# write.csv(mtcars, "input/cars_2.csv", row.names = F)
# now check and validate that the data is processed by the spark stream


# to stop the stream use the streamstop() function
stream_stop(stream)
spark_disconnect(sc)
# sample of words to search on twitter 
# Unreliable, COnspiracy Clickbait, political/biased
#some keywords
#covid19, covid-19, coronavirus, corona virus, 2019nCov, CoronavirusOutbreak, coronapocalyse
###############################################################################################

# Before analyzing a dataset, we would want to take a look at it to give prior understanding
################################################################################################
# To do some transformations like replacing 'missing' with empty strings we type
install.packages("dplyr")
library(dplyr)
install.packages("ggplot2")
library(ggplot2)
??regexp
rlang::last_error()
rlang::last_trace()
us_cov_df <- us_cov_df %>% 
  # Replace `missing` with empty string.
  mutate_all(list(~ ifelse(. == "missing", "", .))) %>%
  # Remove miscellaneous characters and HTML tags
  mutate(words = regexp_replace(text, "\\n|&nbsp;|<[^>]*>|[^A-Za-z|']", " ")) 

 

glimpse(us_cov_df)


us_cov_df <- us_cov_df %>%
  mutate(text = covid(wo_stop_words)) %>%
  select(text, screen_name) %>%
  filter(nchar(text) > 2)

word_count <- us_cov_df %>%
  group_by(text, ) %>%
  tally() %>%
  arrange(desc(n)) 

# Data transformation
# The objective is to end up with a tidy table inside Spark with one row per word used. The steps will be:
  
# The needed data transformations apply to the data from both authors. The data sets will be appended to one another
# Punctuation will be removed
# The words inside each line will be separated, or tokenized
# For a cleaner analysis, stop words will be removed
# To tidy the data, each word in a line will become its own row
# The results will be saved to Spark memory

#################################################################################
# Topic Modelling
#  LDA is a type of topic model for identifying abstract “topics” in a set of documents. 
# It is an unsupervised algorithm in that we do not provide any labels, or topics, for the input documents. 
# LDA posits that each document is a mixture of topics, and each topic is a mixture of words.
# During training, it attempts to estimate both of these simultaneously. 
# A typical use case for topic models involves categorizing many documents,
# for which the large number of documents renders manual approaches infeasible.
# The application domains range from GitHub issues to legal documents.
# For example we have:
stop_words <- ml_default_stop_words(sc) %>%
  c(
    "like", "love", "good", "music", "friends", "people", "life",
    "time", "things", "food", "really", "also", "movies"
  )

lda_model <-  ml_lda(essays, ~ words, k = 6, max_iter = 1, min_token_length = 4, 
                     stop_words = stop_words, min_df = 5)
betas <- tidy(lda_model)
betas
?ml_default_stop_words
?ml_lda
betas %>%
  group_by(topic) %>%
  top_n(10, beta) %>%
  ungroup() %>%
  arrange(topic, -beta) %>%
  mutate(term = reorder(term, beta)) %>%
  ggplot(aes(term, beta, fill = factor(topic))) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~ topic, scales = "free") +
  coord_flip()
# ################################################################
# Term Frequency in Jane Austen’s Novels
# Checking the frequency of a term in documents
# We include the below libraries
library(dplyr)

library(tidytext)
# We then create an object
book_words <- austen_books() %>%
  unnest_tokens(word, text) %>%
  count(book, word, sort = TRUE) %>%
  ungroup()
# to get the total words
total_words <- book_words %>%
  group_by(book) %>%
  summarize(total = sum(n))

# Now we will join the number of all books and book words
# There is one row in this book_words data frame for each word-book combination; 
# n is the number of times that word is used in that book, 
# and total is the total number of words in that book. 

book_words <- left_join(book_words, total_words)
book_words
# let’s look at the distribution of n/total for each novel: 
# the number of times a word appears in a novel divided by the total number of terms (words) in that novel. 
# This is exactly what term frequency is.

library(ggplot2)

ggplot(book_words, aes(n/total, fill = book)) +
  geom_histogram(show.legend = FALSE) +
  xlim(NA, 0.0009) +
  facet_wrap(~book, ncol = 2, scales = "free_y")
# Checking the rank of words

freq_by_rank
freq_by_rank %>%
  ggplot(aes(rank, `term frequency`, color = book)) +
  geom_line(size = 1.1, alpha = 0.8, show.legend = FALSE) +
  scale_x_log10() +
  scale_y_log10()

rank_subset <- freq_by_rank %>%
  filter(rank < 500,
         rank > 10)

lm(log10(`term frequency`) ~ log10(rank), data = rank_subset)


freq_by_rank %>%
  ggplot(aes(rank, `term frequency`, color = book)) +
  geom_abline(intercept = -0.62, slope = -1.1, color = "gray50", linetype = 2) +
  geom_line(size = 1.1, alpha = 0.8, show.legend = FALSE) +
  scale_x_log10() +
  scale_y_log10()

book_words <- book_words %>%
  bind_tf_idf(word, book, n)

book_words

book_words %>%
  select(-total) %>%
  arrange(desc(tf_idf))

###################################################################################
# Working on another set od data available
library(gutenbergr)
physics <- gutenberg_download(c(37729, 14725, 13476, 5001),
                              meta_fields = "author")

# Now that we have the texts, 
# let’s use unnest_tokens() and count() to find out how many times each word is used in each text.
physics_words <- physics %>%
  unnest_tokens(word, text) %>%
  count(author, word, sort = TRUE) %>%
  ungroup()

physics_words


plot_physics <- physics_words %>%
  bind_tf_idf(word, author, n) %>%
  arrange(desc(tf_idf)) %>%
  mutate(word = factor(word, levels = rev(unique(word)))) %>%
  mutate(author = factor(author, levels = c("Galilei, Galileo",
                                            "Huygens, Christiaan",
                                            "Tesla, Nikola",
                                            "Einstein, Albert")))


plot_physics %>%
  group_by(author) %>%
  top_n(15, tf_idf) %>%
  ungroup() %>%
  mutate(word = reorder(word, tf_idf)) %>%
  ggplot(aes(word, tf_idf, fill = author)) +
  geom_col(show.legend = FALSE) +
  labs(x = NULL, y = "tf-idf") +
  facet_wrap(~author, ncol = 2, scales = "free") +
  coord_flip()

library(stringr)
physics %>%
  filter(str_detect(text, "eq\\.")) %>%
  select(text)

physics %>%
  filter(str_detect(text, "K1")) %>%
  select(text)

physics %>%
  filter(str_detect(text, "AK")) %>%
  select(text)

# Let’s remove some of these less meaningful words to make a better, 
# more meaningful plot. Notice that we make a custom list of stop words and use anti_join() to remove them;
#########################
# creating stop words
mystopwords <- data_frame(word = c("eq", "co", "rc", "ac", "ak", "bn",
                                   "fig", "file", "cg", "cb", "cm"))
physics_words <- anti_join(physics_words, mystopwords, by = "word")

plot_physics <- physics_words %>%
  bind_tf_idf(word, author, n) %>%
  arrange(desc(tf_idf)) %>%
  mutate(word = factor(word, levels = rev(unique(word)))) %>%
  group_by(author) %>%
  top_n(15, tf_idf) %>%
  ungroup %>%
  mutate(author = factor(author, levels = c("Galilei, Galileo",
                                            "Huygens, Christiaan",
                                            "Tesla, Nikola",
                                            "Einstein, Albert")))
ggplot(plot_physics, aes(word, tf_idf, fill = author)) +
  geom_col(show.legend = FALSE) +
  labs(x = NULL, y = "tf-idf") +
  facet_wrap(~author, ncol = 2, scales = "free") +
  coord_flip()

# Chapter 4. Relationships Between Words: N-grams and Correlations
# So far we’ve considered words as individual units, and considered their relationships to sentiments or to documents. However, many interesting text analyses are based on the relationships between words, whether examining which words tend to follow others immediately, or words that tend to co-occur within the same documents.

# In this chapter, we’ll explore some of the methods tidytext offers for calculating and visualizing relationships between words in your text dataset. This includes the token = "ngrams" argument, which tokenizes by pairs of adjacent words rather than by individual ones. We’ll also introduce two new packages: ggraph, by Thomas Pedersen, which extends ggplot2 to construct network plots, and widyr, which calculates pairwise correlations and distances within a tidy data frame. Together these expand our toolbox for exploring text within the tidy data framework.

# Tokenizing by N-gram

library(dplyr)
library(tidytext)
library(janeaustenr)

austen_bigrams <- austen_books() %>%
  unnest_tokens(bigram, text, token = "ngrams", n = 2)
austen_bigrams


??textmining
??broom
??pipeline
??analyze
??ggplot
citation()
citation("broom")
# spark streaming
# A good way of looking at the way how Spark streams update is as a three stage operation:
# Input - Spark reads the data inside a given folder. The folder is expected to contain multiple data files, with new files being created containing the most current stream data.
# Processing - Spark applies the desired operations on top of the data. These operations could be data manipulations (dplyr, SQL), data transformations (sdf operations, PipelineModel predictions), or native R manipulations (spark_apply()).
# Output - The results of processing the input files are saved in a different folder.
# •	Basic text mining
# •	Text mining with R
# •	Tidying text
# •	Pipeline
# •	Modelling/Topic modelling
# •	 Analyzing data in r
# 	 
