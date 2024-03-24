# Script Settings and Resources
library(tidyverse)
library(httr)
library(jsonlite)
library(RedditExtractoR)
library(rvest)
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# Data Import and Cleaning

# Method 1
# this does not give me one months worth of data
data <- fromJSON("https://www.reddit.com/r/rstats/.json")
post_titles <- data$data$children$data$title
number_upvotes <- data$data$children$data$ups
number_comments <- data$data$children$data$num_comment

rstats_tbl1 <- tibble(
  post = post_titles,
  upvotes = number_upvotes,
  comments = number_comments
)

# Method 2
# this gives me a months worth of data but is hard to get upvotes info
info <- find_thread_urls("rstats", period = "month")
urls <- info$url
thread_details <- get_thread_content(urls) 
# done to get access to upvote numbers, which weren't provided in 'info'

rstats_tbl2 <- tibble(
  post = info$title,
  upvotes = thread_details$threads$upvotes,
  comments = info$comments
)

# Visualization
rstats_tbl2 %>%
  ggplot(aes(x=upvotes, y = comments)) +
  geom_point() +
  geom_smooth(method = "lm", color = "maroon", fill = "gold") +
  labs(title = "Relationship Between Upvotes and Comments",
       x = "Number of Upvotes",
       y = "Number of Comments") 
  # coord_cartesian(xlim = c(0, 50), ylim = c(0, 50))
  # I considered adding the above line to better see the values less than 15,
  # but I liked seeing and showing the outliers for this as well. You still
  # get a good idea of what that data would look like zoomed in from this
  # level. Also, the coord_cartesian() function would ensure the regression 
  # line was not affected by narrowing the range of the x and y axis.
  
# Analysis
analysis <- cor.test(rstats_tbl2$upvotes, rstats_tbl2$comments)
(correlation <- analysis$estimate)  # correlation value
(p_value <- analysis$p.value) # p-value
(significance <- if(p.value>0.05){"was not"}else{"was"})
(df <- analysis$parameter)

# Publication
cat(sprintf("The correlation between upvotes and comments was r(%d) = %.2f, p = %.2f. This test %s statistically significant.", df, correlation, p_value, significance))
# still need to remove the leading 0 in correlation and p-value!