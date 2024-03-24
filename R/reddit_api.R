# Script Settings and Resources
library(tidyverse)
library(RedditExtractoR)
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# Data Import and Cleaning
data <- find_thread_urls("rstats", period = "month")
urls <- data$url
thread_details <- get_thread_content(urls) # expect a long processing time
# This gives access to upvotes, which wasn't directly provided in 'data'.

rstats_tbl <- tibble(
  post = data$title,
  upvotes = thread_details$threads$upvotes,
  comments = data$comments
)

# Visualization
rstats_tbl %>%
  ggplot(aes(x=upvotes, y = comments)) +
  geom_point() +
  geom_smooth(method = "lm", color = "maroon", fill = "gold") +
  labs(title = "Relationship Between Upvotes and Comments",
       x = "Number of Upvotes",
       y = "Number of Comments") 
  # I considered adding 'coord_cartesian(xlim = c(0, 50), ylim = c(0, 50))'
  # to better see the values less than 15, but I liked seeing and showing 
  # the outliers for this as well. You still get a good idea of what that 
  # data would look like zoomed in from this level. Also, the coord_cartesian()
  # function would ensure the regression line was not affected by narrowing 
  # the range of the x and y axis.
  
# Analysis
analysis <- cor.test(rstats_tbl$upvotes, rstats_tbl$comments)
correlation <- str_remove(formatC(analysis$estimate, digits=2), "^0")  
# This gets rid of leading 0 and keeps only 2 digits, but
# also turns it into a character object instead of numeric.
p_value <- str_remove(prettyNum(analysis$p.value, digits=2), "^0") 
significance <- if(p_value>0.05){"was not"}else{"was"}
df <- analysis$parameter # degrees of freedom has no digits after the decimal

# Publication
# The correlation between upvotes and comments was r(136) = .57, p = 2.1e-13. This test was statistically significant.

cat(sprintf("The correlation between upvotes and comments was r(%d) = %s, p = %s. This test %s statistically significant.", df, correlation, p_value, significance))