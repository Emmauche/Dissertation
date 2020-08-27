# Before analyzing a dataset, we would want to take a look at it to give prior understanding
essay_cols <- paste0("essay",0:9)
essays <-okc %>% select(!!essay_cols) 
glimpse(essays)

essay_cols <- paste0("essay", 0:9)
essays <- okc %>%
  select(!!essay_cols)
essays %>% 
  glimpse()
# To do some transformations like replacing 'missing' with empty strings we type
essays <- essays %>%
  # Replace `missing` with empty string.
  mutate_all(list(~ ifelse(. == "missing", "", .))) %>%
  # Concatenate the columns.
  mutate(essay = paste(!!!syms(essay_cols))) %>%
  # Remove miscellaneous characters and HTML tags
  mutate(words = regexp_replace(essay, "\\n|&nbsp;|<[^>]*>|[^A-Za-z|']", " "))
glimpse(essays)
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
library(janeaustenr)
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
