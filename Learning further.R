install.packages("tidyverse")
install.packages("ggmap")
library(tidyverse)
library(ggmap)
# getting college data using read_csv function
college <- read_csv('http://672258.youcanlearnit.net/college.csv')
# to take a look we use summary function
summary(college)
# The items are read in character class variable
# to convert some variables to factors class variable for ease of use 
college <- college %>%
  mutate(state=as.factor(state),region=as.factor(region),
         highest_degree=as.factor(highest_degree),control= as.factor(control),
         gender=as.factor(gender))
# to view all the unique default rate
unique(college$loan_default_rate)
# to take care of the null value we can run and convert it to NAs
college <- college %>%
  mutate(loan_default_rate= as.numeric(loan_default_rate))
# plotting using ggplot
ggplot(data = college)+
  geom_point(mapping = aes(x = tuition, y= sat_avg, color= control,
                           size =undergrads), alpha=1/2)
# using lines and smothers
# geom_lines connect the points in a dataset, geom_smooth fits a line to a point
