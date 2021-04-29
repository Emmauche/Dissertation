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

summary(college)
# to view all the unique default rate
unique(college$loan_default_rate)
# to take care of the null value we can run and convert it to NAs
college <- college %>%
  mutate(loan_default_rate= as.numeric(loan_default_rate))
# plotting using ggplot
ggplot(data = college)+
  geom_line(mapping = aes(x = tuition, y= sat_avg, color= control))+
  geom_point(mapping = aes(x = tuition, y= sat_avg, color= control))
# using lines and smothers

# Another way to plot the above graph in ggplot level
ggplot(data = college, mapping = aes(x=tuition, y= sat_avg, color = control))+
  geom_line()+
  geom_point()
  
# To smothen and not use line
ggplot(data = college, mapping = aes(x=tuition, y= sat_avg, color = control))+
  geom_smooth(se = FALSE)+ # to hid the shadow set se to false
  geom_point(alpha = 1/25)
# geom_lines connect the points in a dataset, geom_smooth fits a line to a point
# Bars and coloumn
ggplot(data = college)+
  geom_bar(mapping = aes(x=region))

# To seperate the private and public schools using the fill as control
ggplot(data = college)+
  geom_bar(mapping = aes(x=region, fill = control))
# To check average tuition using dplyr
college %>%
  group_by(region) %>%
  summarise(average_tuition = mean(tuition))

#Working with the data above
college %>%
  group_by(region) %>%
  summarise(average_tuition = mean(tuition)) %>%
  ggplot()+
  geom_col(mapping = aes(x=region, y=  average_tuition))
# Histograms
ggplot(data = college)+
  geom_bar(mapping = aes(x=undergrads))

