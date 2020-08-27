#  Topic modeling is a method for unsupervised classification of such documents, 
# similar to clustering on numeric data, which finds natural groups of items even 
# when we’re not sure what we’re looking for.
# Latent Dirichlet allocation (LDA) is a particularly popular method for fitting a topic model. 
# It treats each document as a mixture of topics, and each topic as a mixture of words. 
# This allows documents to “overlap” each other in terms of content, 
# rather than being separated into discrete groups, in a way that mirrors typical use of natural language.
##########################################################################################################
# using LDA for topic modelling
install.packages("topicmodels")
library(topicmodels)

data("AssociatedPress")
AssociatedPress

#################################################
install.packages("lubridate")
library(lubridate)
library(ggplot2)
library(dplyr)
library(readr)
tweets_julia <- read_csv("data/tweets_julia.csv")
