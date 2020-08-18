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
