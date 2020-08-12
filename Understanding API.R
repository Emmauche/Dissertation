# Basically, An API (ApPlication Interface) are server components to make it easy for your code to interact with a service and get data fron it.
# R features many clients. to check for a particular client and check what has been done on any just google search "CRAN client" e.g cran twitter
# For this example, we shall use pageviews (API for wikipedia) 
??article_pageviews()
install.packages("pageviews")
devtools::install_github("ironholds/pageviews")
library(pageviews)
hadley_pageview <- article_pageviews(project = "en.wikipedia", "Hadley Wickham")
str(hadley_pageview)
# Now We will work with access token
# Access tokens are basically for authentication and authorisation
# Example using wordnik site, which uses API birdnik. first we load package httr
library("httr")
?httr
library("birdnik")
install.packages("httr")
library(httr)
word_frequency(api_key, "vector")
