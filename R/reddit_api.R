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
thread_details <- get_thread_content(info$url) # to try to get upvotes...

rstats_tbl2 <- tibble(
  post = info$title,
  # upvotes = thread_details$data$children$data$ups,
  comments = info$comments
)


# Visualization
## Display an appropriate tidyverse visualization of the relationship between upvotes and comments
  
  
# Analysis
## calculate and display the correlation between upvotes and comments, as well as the p-value associate diwth that relationship
cor()
cor.test()


# Publication



# use the following if there is no API to use
rstats_page <- read_html("https://www.reddit.com/r/rstats/.json")
rstats_elements <- html_elements(reddit_page, ".newsList a") # figure out how to get good xpath ... also, for no API
rstats_links <- html_attr(reddit_elements, "href") # for no API
rstats_text <- html_text(reddit_elements) # for no API