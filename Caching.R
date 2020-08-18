library(dplyr)
cached_car <- car %>% mutate (cyl =paste0("cyl_", cyl)) %>% compute("cached_cars")
cached_car %>% ml_linear_regression(mpg ~ .) %>% summary()
##################################################################################
# using the r markdown for producing readable reports containing codes.For example
?MLlib
