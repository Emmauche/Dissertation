install.packages("tidytext")
library(janeaustenr)
library(dplyr)
library(stringr)
orig_books <- austen_books() %>% group_by(book) %>% mutate(linenumber = row_number(), chapter = cumsum(str_detect(text, regex("chapter [\\divxlc]", ignore_case = TRUE)))) %>% ungroup()
orig_books
austen_books()
library(tidytext)
# Tidying the dataset
tidy_book <- orig_books %>% unnest_tokens(word, text)
tidy_book
# Introducing stop words we can have
data("stop_words")
tidy_book <-tidy_book %>% anti_join(stop_words)
stop_words
# To find the most common word in all the book as a whole we can run
tidy_book %>% count(word, sort = TRUE)
# because we've been using tidy tools, our word count are stored in a tidy dataframe.
# This allows us to pipe directly to the ggplot2 package to create the visualization of the most common words
library(ggplot2)
tidy_book %>% count(word, sort = TRUE) %>%
  filter(n>600) %>%
  mutate(word= reorder(word,n)) %>%
  ggplot(aes(word,n)) +
  geom_col()+xlab(NULL)+
  coord_flip()
############################################################
# checking words frequencies
# using gutenbergr library(book)
install.packages("gutenbergr")
library(gutenbergr)
# Now we download these novels
hgwells <- gutenberg_download(c(35,36,5230,159))
tidy_hgwells <- hgwells %>% unnest_tokens(word,text) %>% anti_join(stop_words)
# checking the most common words in the novel H.G Wells
tidy_hgwells %>% count(word,sort = TRUE)
# getting some more works
bronte <-gutenberg_download(c(1260,768,969,9182,767))
# checking the most common words in this new downloads
tidy_bronte <- bronte %>% unnest_tokens(word,text) %>% anti_join(stop_words)
tidy_bronte %>% count(word,sort = TRUE)
# Now We want to calculate the frequency for each word in the downloaded books .
# We can use spread and gather from tidyr to reshape our dataframe so that, it's just what we need for ploting and comparing te three sets of novels
library(tidyr)
frequency_word <- bind_rows(mutate(tidy_bronte,author = "Bronte Sisters"),
                            mutate(tidy_hgwells, author = "H.G Wells"),
                            mutate(tidy_book, author = "Jane Austen")) %>%
  mutate(word = str_extract(word, "[a-z] +")) %>%
  count(author,word) %>% 
  group_by(author) %>%
  mutate(proportion = n/sum(n)) %>%
  select(-n) %>%
  spread(author, proportion) %>%
  gather(author,proportion,'Bronte Sisters':'H.G Wells')
frequency_word
# Now we shall plot this in graph
library(scales)
ggplot(frequency_word, aes(x = proportion, y = `Jane Austen`,
                      color = abs(`Jane Austen` - proportion))) +
  geom_abline(color = "gray40", lty = 2) +
  geom_jitter(alpha = 0.1, size = 2.5, width = 0.3, height = 0.3) +
  geom_text(aes(label = word), check_overlap = TRUE, vjust = 1.5) +
  scale_x_log10(labels = percent_format()) +
  scale_y_log10(labels = percent_format()) +
  scale_color_gradient(limits = c(0, 0.001),
                       low = "darkslategray4", high = "gray75") +
  facet_wrap(~author, ncol = 2) +
  theme(legend.position="none") +
  labs ( y  =  "Jane Austen", x = NULL)
rlang::last_error()
rlang::last_trace()
#Quantifying how similar and different sets of word frequencies are using a correlation test
cor.test(data = frequency[frequency_word$author == "H.G Wells",],
         ~proportion + 'Jane Austen')

